package
{
	import flash.display.MovieClip;
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	
	import citrus.core.State;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.utils.objectmakers.ObjectMakerStarling;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.gestures.SwipeGestureDirection;
	
	public class GameState extends State
	{
		
		private var gravityForce:int = 25;
		
		private var swipe:SwipeGesture;
		private var accelerometer:Accelerometer = new Accelerometer();
		private var hero:MyNewHero;
		
		private const myConst:Number = Math.sin(Math.PI/4);
		private var box2d:Box2D;
		private static var _worldRotation:Number;
		private var heroBodyTransform:b2Transform;
		private var levelSwf:MovieClip;
		
		
		public function GameState(level:MovieClip)
		{
			super();
			levelSwf = level;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			trace("Height: "+stage.fullScreenHeight);
			trace("Width: "+stage.fullScreenWidth);
			
			//Create physics engine
			box2d = new Box2D("box2d");
			box2d.gravity.Set(0,gravityForce);
			box2d.visible  =true;
			add(box2d);
			
			//Seteup accelerometer
			accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdate);
			
			//Setup swipe
			/*swipe = new SwipeGesture(stage);
			swipe.direction = SwipeGestureDirection.UP;
			swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onGesture);*/
			
			//Create level from MC
			ObjectMaker2D.FromMovieClip(levelSwf);
			//Create objects
			addObjects();
		}
		
		protected function onGesture(event:GestureEvent):void
		{
			if(event.target == swipe)
			{
				hero.swipeJump();
			}
		}
		
		private function test():void{
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
			hero.body.SetFixedRotation(true);
			add(hero);
		}
		
		//Gravity
		private function onAccelerometerUpdate(e:AccelerometerEvent):void{
			if(e.accelerationX > 0 && e.accelerationY > -myConst && e.accelerationY < myConst){//Left
				box2d.gravity.Set(-gravityForce,0);
				swipe.direction = SwipeGestureDirection.RIGHT;
				
				setWorldRotation(90);
				/*hero.body.SetFixedRotation(false);
				hero.rotation = 90;
				hero.body.SetFixedRotation(true);*/
				
			}else if( e.accelerationY >= myConst){//Default
				box2d.gravity.Set(0, gravityForce);
				swipe.direction = SwipeGestureDirection.UP;
				
				setWorldRotation(0);
				/*hero.body.SetFixedRotation(false);
				hero.rotation = 0;
				hero.body.SetFixedRotation(true);*/
			}else if(e.accelerationX < 0 && e.accelerationY > -myConst && e.accelerationY < myConst){//Right
				box2d.gravity.Set(gravityForce,0);
				swipe.direction = SwipeGestureDirection.LEFT;
				
				setWorldRotation(270);
				/*hero.body.SetFixedRotation(false);
				hero.rotation = 270;
				hero.body.SetFixedRotation(true);*/				
			}else if(e.accelerationY <= myConst){//Upside down
				box2d.gravity.Set(0, -gravityForce);
				swipe.direction = SwipeGestureDirection.DOWN;
				setWorldRotation(180);
				/*hero.body.SetFixedRotation(false);
				hero.rotation = 180;
				hero.body.SetFixedRotation(true);*/
			}
				heroBodyTransform = new b2Transform(hero.body.GetPosition(), b2Mat22.FromAngle(getWorldRotation()));
				hero.body.SetTransform(heroBodyTransform);
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