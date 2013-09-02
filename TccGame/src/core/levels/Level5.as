package core.levels
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	
	import citrus.physics.box2d.Box2D;
	import citrus.utils.Mobile;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.view.starlingview.StarlingCamera;
	
	import core.controllers.TouchController;
	import core.utils.ScreenUtils;
	import core.utils.WorldUtils;
	
	import customobjects.Spike;
	
	import remake.AccelerometerHandler;
	import remake.AssetsManagerLixo;
	import remake.MyNewHero;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Level5 extends AbstractLevel
	{
		//private var levelSwf:MovieClip;
		private var box2d:Box2D;
		private var gravityForce:int = 15;
		private var hero:MyNewHero;
		private var _camera:StarlingCamera;
		private var accelerometerHandler:AccelerometerHandler;
		private var touchController:TouchController;
		
		[Embed(source="../../../assetsNopack/images/robotHero.png")]
		private var HeroPng:Class;
		private var heroBodyTransform:b2Transform;
		
		[Embed(source="../../../assetsNopack/images/consoleImg.jpg")]
		private var ConsoleJpg:Class;
		
		//Used for deathByFall
		public var delayer:Vector.<Function> = new Vector.<Function>();
		
		private var objectsUsedToBuildLevel:Array = [Spike];
		
		public function Level5()
		{
			super();
			if(Mobile.isIOS())
			{
				if(Mobile.isIpad())
				{
					if(Mobile.isRetina())
					{
						ScreenUtils.SCREEN_REAL_WIDTH = Mobile.iPAD_RETINA_WIDTH;
						ScreenUtils.SCREEN_REAL_HEIGHT = Mobile.iPAD_RETINA_HEIGHT;	
					}
					else
					{
						ScreenUtils.SCREEN_REAL_WIDTH = Mobile.iPAD_WIDTH;
						ScreenUtils.SCREEN_REAL_HEIGHT = Mobile.iPAD_HEIGHT;
					}
				}
				else
				{
					if(Mobile.isRetina())
					{
						ScreenUtils.SCREEN_REAL_WIDTH = Mobile.iPHONE_RETINA_WIDTH;
						ScreenUtils.SCREEN_REAL_HEIGHT = Mobile.iPHONE_RETINA_HEIGHT;
					}
				}
			}
			if(Mobile.isLandscapeMode())
			{
				var landscapeWidth:uint = ScreenUtils.SCREEN_REAL_HEIGHT;
				var landscapeHeight:uint = ScreenUtils.SCREEN_REAL_WIDTH;
				
				ScreenUtils.SCREEN_REAL_HEIGHT = landscapeHeight;
				ScreenUtils.SCREEN_REAL_WIDTH = landscapeWidth;
			}
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			//Create Controller
			touchController = new TouchController("touchController");
			_ce.input.addController(touchController);
			
			//Create physics engine
			box2d = new Box2D("box2d");
			box2d.gravity.Set(0,gravityForce);
			box2d.visible = false;
			add(box2d);
			
			//Initialize world with default rotation;
			WorldUtils.setWorldRotation(0);
			
			//Create level from MC
			//ObjectMakerStarling.FromTiledMap(AssetsManagerLixo.getLevel5Map(),AssetsManagerLixo.getLevel5View1());
			ObjectMaker2D.FromTiledMap(AssetsManagerLixo.getLevel5Map(),[AssetsManagerLixo.getLevel5View1()]);
			//Add Hero
			var heroBitmap:Bitmap = new HeroPng();
			var heroTexture:Texture = Texture.fromBitmap(heroBitmap);
			var heroImg:Image = new Image(heroTexture);
			heroImg.scaleX = heroImg.scaleY = 1;
			addChild(heroImg);
			hero = new MyNewHero("hero",{view:heroImg,x: 640, y: 480, width: 128, height:128});
			add(hero);
			
			
			//_camera.setUp(hero, new MathVector(ScreenUtils.SCREEN_REAL_WIDTH / 2, ScreenUtils.SCREEN_REAL_HEIGHT / 2), cameraBounds, new MathVector(0.5, 0.5));
			_camera = view.camera as StarlingCamera;
			var cameraBounds:Rectangle = new Rectangle(0,0,3840,2816);//tamanho do level..
			_camera.setUp(hero,new Point(ScreenUtils.SCREEN_REAL_WIDTH / 2, ScreenUtils.SCREEN_REAL_HEIGHT / 2),cameraBounds,new Point(.5,.5));
			//_camera.parallaxMode = ACitrusCamera.PARALLAX_MODE_DEPTH;
			_camera.allowZoom = true;
			_camera.baseZoom = _camera.zoomFit(3500, 2000)
			_camera.setZoom(1);
			_camera.reset();
			
			//Create rotation handler
			accelerometerHandler = new AccelerometerHandler("accelerometerHandler",{});
			accelerometerHandler.triggerActions=true;
			_ce.input.addController(accelerometerHandler);
		}
		
		override public function update(timeDelta:Number):void
		{
			if(_ce.input.justDid(AccelerometerHandler.GravityChange))
			{
				handleWorldRotation();
				accelerometerHandler.triggerGravityChangeOff();
			}
			super.update(timeDelta);
			
			if(delayer.length > 0)
			{
				var delayf:Function;
				while(delayf = delayer.pop())
				{
					delayf();
				}
			}
		}
		
		private function handleWorldRotation():void
		{
			if(_ce.input.isDoing(AccelerometerHandler.GravityDown))
			{
				WorldUtils.setWorldRotation(0);
				box2d.gravity.Set(0, gravityForce);
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityLeft))
			{
				WorldUtils.setWorldRotation(90);
				box2d.gravity.Set(-gravityForce,0);
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityRight))
			{
				WorldUtils.setWorldRotation(270);
				box2d.gravity.Set(gravityForce,0);
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityUp))
			{
				WorldUtils.setWorldRotation(180);
				box2d.gravity.Set(0, -gravityForce);
			}
			
			heroBodyTransform = new b2Transform(hero.body.GetPosition(), b2Mat22.FromAngle(WorldUtils.getWorldRotation()));
			hero.body.SetTransform(heroBodyTransform);
			
			hero.recalculateGroundCollisionAngle();
		}
	}
}