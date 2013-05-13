package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	
	import citrus.core.CitrusObject;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.math.MathVector;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.utils.Mobile;
	import citrus.view.starlingview.StarlingCamera;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import utils.WorldUtils;
	
	public class NewGameControlsState extends StarlingState
	{
		private var _debugSprite:flash.display.Sprite;
		private var ScreenRealWidth:uint;
		private var ScreenRealHeight:uint;
		//private var levelSwf:MovieClip;
		private var box2d:Box2D;
		private var gravityForce:int = 15;
		private var hero:MyNewHero;
		private var _camera:StarlingCamera;
		private var accelerometerHandler:AccelerometerHandler;
		
		[Embed(source="/assets/images/robotHero.png")]
		private var HeroPng:Class;
		private var heroBodyTransform:b2Transform;
		
		[Embed(source="/assets/images/consoleImg.jpg")]
		private var ConsoleJpg:Class;
		private var swipeLenghtToJump:int = 100;
		
		public function NewGameControlsState(debugSprt:flash.display.Sprite)
		{
			if(Mobile.isIOS())
			{
				if(Mobile.isIpad())
				{
					if(Mobile.isRetina())
					{
						ScreenRealWidth = Mobile.iPAD_RETINA_WIDTH;
						ScreenRealHeight = Mobile.iPAD_RETINA_HEIGHT;	
					}
					else
					{
						ScreenRealWidth = Mobile.iPAD_WIDTH;
						ScreenRealHeight = Mobile.iPAD_HEIGHT;
					}
				}
				else
				{
					if(Mobile.isRetina())
					{
						ScreenRealWidth = Mobile.iPHONE_RETINA_WIDTH;
						ScreenRealHeight = Mobile.iPHONE_RETINA_HEIGHT;
					}
				}
			}
			if(Mobile.isLandscapeMode())
			{
				var landscapeWidth:uint = ScreenRealHeight;
				var landscapeHeight:uint = ScreenRealWidth;
				
				ScreenRealHeight = landscapeHeight;
				ScreenRealWidth = landscapeWidth;
			}
			
			_debugSprite = debugSprt;
			super();
			//levelSwf = level;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			//Create physics engine
			box2d = new Box2D("box2d");
			box2d.gravity.Set(0,gravityForce);
			box2d.visible = false;
			add(box2d);
			
			//Initialize world with default rotation;
			WorldUtils.setWorldRotation(0);
			
			addWalls();
			
			//Add Hero
			var heroBitmap:Bitmap = new HeroPng();
			var heroTexture:Texture = Texture.fromBitmap(heroBitmap);
			var heroImg:Image = new Image(heroTexture);
			heroImg.scaleX = heroImg.scaleY = .5;
			addChild(heroImg);
			hero = new MyNewHero("hero",{view:heroImg,x: 150, y: 200, width: 50, height:50});
			add(hero);
			
			_camera = view.camera as StarlingCamera;
			var _bounds:Rectangle = new Rectangle(0,0,2048,1536);
			_camera.setUp(hero, new MathVector(ScreenRealWidth / 2, ScreenRealHeight / 2), _bounds, new MathVector(0.5, 0.5));
			_camera.restrictZoom = true;
			_camera.allowZoom = true;
			_camera.zoomFit(960,640);
			
			//Add move listeners
			//Where should I add the TouchEvent listener? Keep stuff on starling.stage for now
			//stage.addEventListener(TouchEvent.TOUCH, onTouch3);
			(_ce as StarlingCitrusEngine).starling.stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			//Create rotation handler
			accelerometerHandler = new AccelerometerHandler("accelerometerHandler",{});
			accelerometerHandler.triggerActions=true;
			_ce.input.addController(accelerometerHandler);
			createConsoleInput();
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(stage, TouchPhase.MOVED);
			
			for (var i:int = 0; i < touches.length; i++) 
			{
				var touch:Touch = touches[i];
				var touchMovement:Point = touch.getMovement(stage);
				
				var movementVector:b2Vec2 = new b2Vec2(touchMovement.x, touchMovement.y);
				var adjustedMoveVector:b2Vec2 = Box2DUtils.Rotateb2Vec2(movementVector, WorldUtils.getWorldRotation());
				var adjustedMoveVector2:b2Vec2 = Box2DUtils.Rotateb2Vec2(movementVector, WorldUtils.getWorldRotation()+180);
				
				trace("Move vector: (X="+movementVector.x,",","Y="+movementVector.y,")");
				trace("Rotated vector: (X="+adjustedMoveVector.x,",","Y="+adjustedMoveVector.y,")");
				trace("Rotated vector2: (X="+adjustedMoveVector2.x,",","Y="+adjustedMoveVector2.y,")");
				//caio TODO> Vetor de movimento roda pro sentid contrario ao desejado..arrumar isso se nao
				//adjustedMoveVector.y terá que ser positivo quando o device estiver em portrait.
				if(adjustedMoveVector.y < -swipeLenghtToJump)
				{
					hero.swipeJump();
				}
			}
		}		
		
		private function addWalls():void
		{
			var floor:Platform = new Platform("floor",
				{x: ScreenRealWidth * .5, y: ScreenRealHeight/2, width: ScreenRealWidth,height: 20});
			add(floor);
			
			var ceiling:Platform = new Platform("ceiling",
				{x: ScreenRealWidth * .5, y: 0, width: ScreenRealWidth,height: 20});
			add(ceiling);
			
			var leftWall:Platform = new Platform("leftWall",
				{x: 0, y:ScreenRealHeight *.5, width: 20,height: ScreenRealHeight});
			add(leftWall);
			
			var rightWall:Platform = new Platform("rightWall",
				{x: ScreenRealWidth/2, y:ScreenRealHeight*.5, width: 20,height: ScreenRealHeight});
			add(rightWall);
			
		}
		
		private function createConsoleInput():void
		{
			var consoleBtmp:Bitmap = new ConsoleJpg();
			var consoleBtn:Button = new Button(Texture.fromBitmap(consoleBtmp));
			consoleBtn.x = ScreenRealWidth-consoleBtn.width;
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
		}
		
		private function drawMinimap():void
		{
			_camera.renderDebug(_debugSprite);
			_debugSprite.scaleX = 0.2 * 0.6;
			_debugSprite.scaleY = 0.2 * 0.6;
			_debugSprite.x = ScreenRealWidth-_debugSprite.width;
			_debugSprite.y = ScreenRealHeight-_debugSprite.height;
			
			_debugSprite.graphics.lineStyle();
			_debugSprite.graphics.beginFill(0x000000, 0.2);
			
			var platforms:Vector.<CitrusObject> = getObjectsByType(Platform);
			var platfrm:CitrusObject;
			for each (platfrm in platforms)
			{
				_debugSprite.graphics.drawRect((platfrm as Platform).x - (platfrm as Platform).width / 2, (platfrm as Platform).y - (platfrm as Platform).height / 2, (platfrm as Platform).width, (platfrm as Platform).height);
			}
		}
	}
}