package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	
	import citrus.core.CitrusObject;
	import citrus.core.Console;
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.Mobile;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.view.starlingview.StarlingCamera;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.gestures.SwipeGestureDirection;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class GameState extends StarlingState
	{
		
		private var gravityForce:int = 15;
		
		private var swipe:SwipeGesture;
		private var hero:MyNewHero;
		
		private var box2d:Box2D;
		private static var _worldRotation:Number;
		private var heroBodyTransform:b2Transform;
		private var levelSwf:MovieClip;
		public static var touchMoveId:int;
		private var accelerometerHandler:AccelerometerHandler;
		private var myTextField:TextField;
		private var myConsoleTextField:TextField;
		private var _camera:StarlingCamera;
		private var _debugSprite:Sprite;
		private var ScreenRealWidth:uint;
		private var ScreenRealHeight:uint;
		
		[Embed(source="/assets/images/BackgroundForest.jpg")]
		private var BgForestJpg:Class;
		
		[Embed(source="/assets/images/ForegroundForest.png")]
		private var FgForestPng:Class;
		
		[Embed(source="/assets/images/robotHero.png")]
		private var HeroPng:Class;
		
		[Embed(source="/assets/images/consoleImg.jpg")]
		private var ConsoleJpg:Class;
		
		[Deprecated(message="For debbuging AccelerometerController only.")]
		private function createTxtField():void
		{
			myTextField = new TextField(900,600,"rotZ","Verdana",70);  
			
			myTextField.autoScale = TextFieldAutoSize.CENTER;  

			myTextField.x = ScreenRealWidth/2 -(myTextField.width/2);  
			myTextField.y = ScreenRealHeight/2 - (myTextField.height/2);  
			
			addChild(myTextField);
		}
		
		
		public function GameState(level:MovieClip,debugSprt:Sprite)
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
			levelSwf = level;
		}
		
		
		override public function initialize():void
		{
			super.initialize();
			
			var bgBitmap:Bitmap = new BgForestJpg();
			var bgTexture:Texture = Texture.fromBitmap(bgBitmap);
			var bgImg:Image = new Image(bgTexture);
			var backgroundSprite:CitrusSprite = new CitrusSprite("bgSprite",{view:bgImg,parallaxX:0.5,parallaxY:0.5});
			add(backgroundSprite);
			
			
			var fgBitmap:Bitmap = new FgForestPng();
			var fgTexture:Texture = Texture.fromBitmap(fgBitmap);
			var fgImg:Image = new Image(fgTexture);
			var foregroundSprite:CitrusSprite = new CitrusSprite("fgSprite" ,{view:fgImg});
			add(foregroundSprite);
			
			//Create physics engine
			box2d = new Box2D("box2d");
			box2d.gravity.Set(0,gravityForce);
			box2d.visible = false;
			add(box2d);
			
			//Setup swipe
			swipe = new SwipeGesture(Starling.current.nativeStage);
			swipe.direction = SwipeGestureDirection.UP;
			swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipe);
			
			//Initialize world with default rotation;
			setWorldRotation(0);

			//Create Borders
			addBorders();
			//Create level from MC
			ObjectMaker2D.FromMovieClip(levelSwf);
			
			//Add Hero
			var heroBitmap:Bitmap = new HeroPng();
			var heroTexture:Texture = Texture.fromBitmap(heroBitmap);
			var heroImg:Image = new Image(heroTexture);
			addChild(heroImg);
			hero = new MyNewHero("hero",{view:heroImg,x: ScreenRealWidth*.5, y: ScreenRealHeight*.5, width: 100, height:100});
			add(hero);
			
			//Setup Camera
			_camera = view.camera as StarlingCamera;
			//var _bounds:Rectangle = new Rectangle(0,0,ScreenRealWidth,ScreenRealHeight);
			var _bounds:Rectangle = new Rectangle(0,0,2048,1536);
			_camera.setUp(hero, new MathVector(ScreenRealWidth / 2, ScreenRealHeight / 2), _bounds, new MathVector(0.5, 0.5));
			_camera.restrictZoom = true;
			_camera.allowZoom = true;
			
			if(Mobile.isIpad() && Mobile.isRetina())
			{
				_camera.setZoom(2);
				foregroundSprite.width *= _camera.getZoom();
				foregroundSprite.height *= _camera.getZoom();
			}
			
			//Add move listeners
			Starling.current.nativeStage
			Starling.current.nativeStage.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN, onTouchBegin);
			Starling.current.nativeStage.addEventListener(flash.events.TouchEvent.TOUCH_MOVE, onTouchBegin);
			Starling.current.nativeStage.addEventListener(flash.events.TouchEvent.TOUCH_END, onTouchEnd);
			
			//Create rotation handler
			accelerometerHandler = new AccelerometerHandler("accelerometerHandler",{})
			_ce.input.addController(accelerometerHandler);
			
			//Create Debug TF
			//createTxtField();
			
			//Console input
			createConsoleInput();
		}
		
		private function createConsoleInput():void
		{
			var consoleBtmp:Bitmap = new ConsoleJpg();
			var consoleBtn:Button = new Button(Texture.fromBitmap(consoleBtmp));
			consoleBtn.x = ScreenRealWidth-consoleBtn.width;
			consoleBtn.touchable = true;
			addChild(consoleBtn);
			consoleBtn.addEventListener(Event.TRIGGERED, onTouchConsole);
			/*if ( stage )
			{
				
				myTextField = new TextField(500,300,"rotZ","Verdana",70);  
				
				myTextField.autoScale = TextFieldAutoSize.CENTER;  
				
				myTextField.x = ScreenRealWidth/2 -(myTextField.width/2);  
				myTextField.y = ScreenRealHeight/2 - (myTextField.height/2);  
				
				addChild(myTextField);
				myTextField.border = true;
				myTextField.autoScale = TextFieldAutoSize.CENTER;

				myTextField.addEventListener(starling.events.TouchEvent.TOUCH, onTouchConsole);
				myTextField.touchable = true;
				_ce.console.enabled = true;
			}*/
		}
		
		private function onTouchConsole(e:Event):void
		{
			Starling.current.nativeStage.dispatchEvent(new flash.events.KeyboardEvent
				(starling.events.KeyboardEvent.KEY_UP, 
					true, false, "	".charCodeAt(0), Keyboard.TAB));
		}
		
		override public function update(timeDelta:Number):void
		{
			drawMinimap();
			//Track rotation(debbuging only)
			/*myTextField.text = (accelerometerHandler.rotZtest.toFixed(1).toString()+" "+
				accelerometerHandler.gravDirection);*/
			
			//Handle gravity direction
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
				setWorldRotation(0);
				box2d.gravity.Set(0, gravityForce);
				swipe.direction = SwipeGestureDirection.UP;
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityLeft))
			{
				setWorldRotation(90);
				box2d.gravity.Set(-gravityForce,0);
				swipe.direction = SwipeGestureDirection.RIGHT;
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityRight))
			{
				setWorldRotation(270);
				box2d.gravity.Set(gravityForce,0);
				swipe.direction = SwipeGestureDirection.LEFT;
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityUp))
			{
				setWorldRotation(180);
				box2d.gravity.Set(0, -gravityForce);
				swipe.direction = SwipeGestureDirection.DOWN;
			}
			heroBodyTransform = new b2Transform(hero.body.GetPosition(), b2Mat22.FromAngle(getWorldRotation()));
			hero.body.SetTransform(heroBodyTransform);
		}
		
		protected function onTouchBegin(event:flash.events.TouchEvent):void
		{
			if(!touchMoveId)
			{
				touchMoveId = event.touchPointID;
				
				switch(getWorldRotationDeg())
				{
					case 0://Normal
						if(event.stageX > ScreenRealWidth>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
					
					case 90://Left
						if(event.stageY > ScreenRealHeight>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
					
					case 180:
						if(event.stageX < ScreenRealWidth>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
					
					case 270:
						if(event.stageY < ScreenRealHeight>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
				}
			}
		}
		
		private function onTouchEnd(event:flash.events.TouchEvent):void
		{
			if(event.touchPointID == touchMoveId)
			{
				touchMoveId = 0;
				hero.stopMoving();
			}
		}
		
		protected function onSwipe(event:GestureEvent):void
		{
			if(event.target == swipe)
			{
				hero.swipeJump();
			}
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
		
		private function addBorders():void
		{
			var levelDoTamanhoDaTela:Boolean = false;
			if(!levelDoTamanhoDaTela)
			{
				var floor:Platform = new Platform("floor",
					{x: 2048 * .5, y: 1536, width: 2048,height: 20});
				add(floor);
				
				var ceiling:Platform = new Platform("ceiling",
					{x: 2048 * .5, y: 0, width: 2048,height: 20});
				add(ceiling);
				
				var leftWall:Platform = new Platform("leftWall",
					{x: 0, y:1536 *.5, width: 20,height: 1536});
				add(leftWall);
				
				var rightWall:Platform = new Platform("rightWall",
					{x: 2048, y:1536*.5, width: 20,height: 1536});
				add(rightWall);
			}
		/*	else
			{
				var floor:Platform = new Platform("floor",
					{x: ScreenRealWidth * .5, y: ScreenRealHeight, width: ScreenRealWidth,height: 20});
				add(floor);
				
				var ceiling:Platform = new Platform("ceiling",
					{x: ScreenRealWidth * .5, y: 0, width: ScreenRealWidth,height: 20});
				add(ceiling);
				
				var leftWall:Platform = new Platform("leftWall",
					{x: 0, y:ScreenRealHeight *.5, width: 20,height: ScreenRealHeight});
				add(leftWall);
				
				var rightWall:Platform = new Platform("rightWall",
					{x: ScreenRealWidth, y:ScreenRealHeight*.5, width: 20,height: ScreenRealHeight});
				add(rightWall);
			}*/
		}
		
		
		public static function deg2rad(degree:Number):Number {
			return degree * (Math.PI / 180);
		}
		public static function rad2deg(rad:Number):Number
		{
			return rad * (180 / Math.PI);
		}
		
		public function setWorldRotation(worldRotation:int):void
		{
			_worldRotation = deg2rad(worldRotation);
		}
		
		public static function getWorldRotation():Number
		{
			return _worldRotation;
		}
		public static function getWorldRotationDeg():Number
		{
			return rad2deg(_worldRotation);
		}
	}
}