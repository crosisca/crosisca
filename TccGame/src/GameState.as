package
{
	import flash.display.MovieClip;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	
	import citrus.core.State;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMaker2D;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.gestures.SwipeGestureDirection;
	
	public class GameState extends State
	{
		
		private var gravityForce:int = 25;
		
		private var swipe:SwipeGesture;
		private var hero:MyNewHero;
		
		private var box2d:Box2D;
		private static var _worldRotation:Number;
		private var heroBodyTransform:b2Transform;
		private var levelSwf:MovieClip;
		public static var touchMoveId:int;
		private var accelerometerHandler:AccelerometerHandler;
		private var myTextField:TextField;
		
		private function createTxtField():void
		{
			//Creating the textfield object and naming it "myTextField"  
			myTextField = new TextField();  
			
			//Here we define some properties for our text field, starting with giving it some text to contain.  
			//A width, x and y coordinates.  
			myTextField.text = "RotationZ";  
			myTextField.width = 200;  
			myTextField.height = 100;  
			
			//Here are some great properties to define, first one is to make sure the text is not selectable, then adding a border.  
			myTextField.selectable = false;  
			myTextField.border = true;  
			
			//This last property for our textfield is to make it autosize with the text, aligning to the left.  
			myTextField.autoSize = TextFieldAutoSize.CENTER;  

			
			myTextField.scaleX = myTextField.scaleY = 15;
			
			myTextField.x = stage.fullScreenWidth/2 -(myTextField.width/2);  
			myTextField.y = stage.fullScreenHeight/2 - (myTextField.height/2);  
			
			addChild(myTextField);
		}
		
		
		public function GameState(level:MovieClip)
		{
			super();
			levelSwf = level;
		}
		
		
		override public function initialize():void
		{
			super.initialize();

			//Create physics engine
			box2d = new Box2D("box2d");
			box2d.gravity.Set(0,gravityForce);
			box2d.visible  =true;
			add(box2d);
			
			//Setup swipe
			swipe = new SwipeGesture(stage);
			swipe.direction = SwipeGestureDirection.UP;
			swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipe);
			
			setWorldRotation(0);

			//Create Borders and Hero
			addObjects();
			//Create level from MC
			ObjectMaker2D.FromMovieClip(levelSwf);
			
			//Add move listeners
			this.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			this.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchBegin);
			this.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			
			//Create rotation handler
			accelerometerHandler = new AccelerometerHandler("accelerometerHandler",{})
			_ce.input.addController(accelerometerHandler);
			
			//Create Debug TF
			createTxtField();
		}
		
		override public function update(timeDelta:Number):void
		{
			//Track rotation
			myTextField.text = (accelerometerHandler.rotZtest.toFixed(1).toString()+" "+
				accelerometerHandler.gravDirection);
			
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
		
		protected function onTouchBegin(event:TouchEvent):void
		{
			if(!touchMoveId)
			{
				touchMoveId = event.touchPointID;
				
				switch(getWorldRotationDeg())
				{
					case 0://Normal
						if(event.stageX > stage.fullScreenWidth>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
					
					case 90://Left
						if(event.stageY > stage.fullScreenHeight>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
					
					case 180:
						if(event.stageX < stage.fullScreenWidth>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
					
					case 270:
						if(event.stageY < stage.fullScreenHeight>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
				}
			}
		}
		
		private function onTouchEnd(event:TouchEvent):void
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
		
		private function addObjects():void
		{
			var floor:Platform = new Platform("floor",
				{x: stage.fullScreenWidth * .5, y: stage.fullScreenHeight, width: stage.fullScreenWidth,height: 20});
			add(floor);
			
			var ceiling:Platform = new Platform("ceiling",
				{x: stage.fullScreenWidth * .5, y: 0, width: stage.fullScreenWidth,height: 20});
			add(ceiling);
			
			var leftWall:Platform = new Platform("leftWall",
				{x: 0, y:stage.fullScreenHeight *.5, width: 20,height: stage.fullScreenHeight});
			add(leftWall);
			
			var rightWall:Platform = new Platform("rightWall",
				{x: stage.fullScreenWidth, y:stage.fullScreenHeight*.5, width: 20,height: stage.fullScreenHeight});
			add(rightWall);
			
			hero = new MyNewHero("hero",{x: stage.fullScreenWidth*.5, y: stage.fullScreenHeight*.5, width: 25, height:50});
			add(hero);
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