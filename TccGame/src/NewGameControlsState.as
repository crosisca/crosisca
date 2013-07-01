package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	
	import citrus.core.starling.StarlingState;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSprite;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.Mobile;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.view.ACitrusCamera;
	import citrus.view.starlingview.StarlingCamera;
	
	import controllers.AccelerometerHandler;
	import controllers.TouchController;
	
	import customobjects.Spike;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import utils.ScreenUtils;
	import utils.WorldUtils;
	
	public class NewGameControlsState extends StarlingState
	{
		private var _debugSprite:flash.display.Sprite;
		//private var levelSwf:MovieClip;
		private var box2d:Box2D;
		private var gravityForce:int = 15;
		private var hero:MyNewHero;
		private var _camera:StarlingCamera;
		private var accelerometerHandler:AccelerometerHandler;
		private var touchController:TouchController;
		
		[Embed(source="/assets/images/robotHero.png")]
		private var HeroPng:Class;
		private var heroBodyTransform:b2Transform;
		
		[Embed(source="/assets/images/consoleImg.jpg")]
		private var ConsoleJpg:Class;
		
		[Embed(source="/assets/images/PlataformasFase1.png")]
		private var EmbeddedPlataformasFase1:Class;
		
		/*[Embed(source="/assets/images/EspinhosFase1.png")]
		private var EmbeddedEspinhosFase1:Class;*/
		
		[Embed(source="/assets/images/BackgroundFase1.jpg")]
		private var EmbeddedBackgroundFase1:Class;
		
		
		private var levelSwf:MovieClip;
		
		//Used for deathByFall
		public var delayer:Vector.<Function> = new Vector.<Function>();
		
		private var objectsUsedToBuildLevel:Array = [Spike];
		
		public function NewGameControlsState(debugSprt:flash.display.Sprite,level:MovieClip)
		{
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
			
			_debugSprite = debugSprt;
			super();
			levelSwf = level;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
		/*	_ce.sound.addSound("jump","/assets/sounds/Pulo.mp3");
			_ce.sound.addSound("bg","/assets/sounds/BackgroundMusic.mp3");
			_ce.sound.addSound("morte","/assets/sounds/Morte.mp3");
			_ce.sound.addSound("queda","/assets/sounds/Queda.mp3");
			_ce.sound.playSound("bg");*/
			
			//Adiciona arte do background
			var backgroundArtBitmap:Bitmap = new EmbeddedBackgroundFase1();
			var backgroundArtTexture:Texture = Texture.fromBitmap(backgroundArtBitmap);
			var backgroundArtImg:Image = new Image(backgroundArtTexture);
			var backgroundArtSprite:CitrusSprite = new CitrusSprite("backgroundFase1Sprite",{view:backgroundArtImg,x:ScreenUtils.SCREEN_REAL_WIDTH/2,y:ScreenUtils.SCREEN_REAL_HEIGHT/2,parallaxX:0.4,parallaxY:0.2});
			backgroundArtSprite.registration = "center";
			add(backgroundArtSprite);
			
			
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
			ObjectMaker2D.FromMovieClip(levelSwf);
			
			//Adiciona arte das plataformas
			var plataformasArtBitmap:Bitmap = new EmbeddedPlataformasFase1();
			var plataformasArtTexture:Texture = Texture.fromBitmap(plataformasArtBitmap);
			var plataformasArtImg:Image = new Image(plataformasArtTexture);
			var plataformasArtSprite:CitrusSprite = new CitrusSprite("plataformasFase1Sprite",{view:plataformasArtImg,x:ScreenUtils.SCREEN_REAL_WIDTH/2,y:ScreenUtils.SCREEN_REAL_HEIGHT/2});
			plataformasArtSprite.registration = "center";
			add(plataformasArtSprite);
			
			//Add Hero
			var heroBitmap:Bitmap = new HeroPng();
			var heroTexture:Texture = Texture.fromBitmap(heroBitmap);
			var heroImg:Image = new Image(heroTexture);
			heroImg.scaleX = heroImg.scaleY = .5;
			addChild(heroImg);
			hero = new MyNewHero("hero",{view:heroImg,x: 290, y: 1200, width: 50, height:50});
			add(hero);
			
			//Adiciona arte dos espinhos
		/*	var espinhosArtBitmap:Bitmap = new EmbeddedEspinhosFase1();
			var espinhosArtTexture:Texture = Texture.fromBitmap(espinhosArtBitmap);
			var espinhosArtImg:Image = new Image(espinhosArtTexture);
			var espinhosArtSprite:CitrusSprite = new CitrusSprite("espinhosFase1Sprite",{view:espinhosArtImg});
			add(espinhosArtSprite);*/
			
			//_camera.setUp(hero, new MathVector(ScreenUtils.SCREEN_REAL_WIDTH / 2, ScreenUtils.SCREEN_REAL_HEIGHT / 2), cameraBounds, new MathVector(0.5, 0.5));
			_camera = view.camera as StarlingCamera;
			var cameraBounds:Rectangle = new Rectangle(0,0,levelSwf.width,levelSwf.height);//tamanho do level..
			_camera.setUp(hero,new Point(ScreenUtils.SCREEN_REAL_WIDTH / 2, ScreenUtils.SCREEN_REAL_HEIGHT / 2),cameraBounds,new Point(.5,.5));
			//_camera.parallaxMode = ACitrusCamera.PARALLAX_MODE_DEPTH;
			_camera.allowZoom = true;
			_camera.baseZoom = _camera.zoomFit(960,640);
			_camera.setZoom(_camera.zoomFit(960,640));
			_camera.zoom(_camera.zoomFit(960,640));
			//_camera.zoomFit(960,640);
			
			//Create rotation handler
			accelerometerHandler = new AccelerometerHandler("accelerometerHandler",{});
			accelerometerHandler.triggerActions=true;
			_ce.input.addController(accelerometerHandler);
			
			createConsoleInput();
		}
		
		/*private function addWalls():void
		{
			var floor:Platform = new Platform("floor",
				{x: ScreenUtils.SCREEN_REAL_WIDTH * .5, y: ScreenUtils.SCREEN_REAL_HEIGHT/2, width: ScreenUtils.SCREEN_REAL_WIDTH,height: 20});
			add(floor);
			
			var ceiling:Platform = new Platform("ceiling",
				{x: ScreenUtils.SCREEN_REAL_WIDTH * .5, y: 0, width: ScreenUtils.SCREEN_REAL_WIDTH,height: 20});
			add(ceiling);
			
			var leftWall:Platform = new Platform("leftWall",
				{x: 0, y:ScreenUtils.SCREEN_REAL_HEIGHT *.5, width: 20,height: ScreenUtils.SCREEN_REAL_HEIGHT});
			add(leftWall);
			
			var rightWall:Platform = new Platform("rightWall",
				{x: ScreenUtils.SCREEN_REAL_WIDTH/2, y:ScreenUtils.SCREEN_REAL_HEIGHT*.5, width: 20,height: ScreenUtils.SCREEN_REAL_HEIGHT});
			add(rightWall);
			
		}*/
		
		private function createConsoleInput():void
		{
			var consoleBtmp:Bitmap = new ConsoleJpg();
			var consoleBtn:Button = new Button(Texture.fromBitmap(consoleBtmp));
			consoleBtn.scaleX = consoleBtn.scaleY = 0.3;
			consoleBtn.x = ScreenUtils.SCREEN_REAL_WIDTH-consoleBtn.width;
			consoleBtn.touchable = true;
			addChild(consoleBtn);
			consoleBtn.addEventListener(Event.TRIGGERED, onTouchConsole);
		}
		
		private function onTouchConsole(e:Event):void
		{
			box2d.visible = !box2d.visible;
		}
		
		override public function update(timeDelta:Number):void
		{
			drawMinimap();
			
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
		
		private function drawMinimap():void
		{
			/*_camera.renderDebug(_debugSprite);
			_debugSprite.scaleX = 0.2 * 0.6;
			_debugSprite.scaleY = 0.2 * 0.6;
			_debugSprite.x = ScreenUtils.SCREEN_REAL_WIDTH-_debugSprite.width;
			_debugSprite.y = ScreenUtils.SCREEN_REAL_HEIGHT-_debugSprite.height;
			
			_debugSprite.graphics.lineStyle();
			_debugSprite.graphics.beginFill(0x000000, 0.2);
			
			var platforms:Vector.<CitrusObject> = getObjectsByType(Platform);
			var platfrm:CitrusObject;
			for each (platfrm in platforms)
			{
				_debugSprite.graphics.drawRect((platfrm as Platform).x - (platfrm as Platform).width / 2, (platfrm as Platform).y - (platfrm as Platform).height / 2, (platfrm as Platform).width, (platfrm as Platform).height);
			}*/
		}
	}
}