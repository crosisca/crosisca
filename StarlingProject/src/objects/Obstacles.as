package objects
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Obstacles extends Sprite
	{
		private var _type:int;
		private var _speed:int;
		private var _distance:int;
		private var _watchOut:Boolean;
		private var _alreadyHit:Boolean;
		private var _position:String;
		private var obstacleImage:Image;
		private var obstacleCrashImage:Image;
		private var obstacleAnimation:MovieClip;
		private var watchOutAnimation:MovieClip;
		
		public function Obstacles(type:int,distance:int,watchOut:Boolean = true,speed:int = 0)
		{
			super();
			
			_type = type;
			_distance = distance;
			_watchOut = watchOut;
			_speed = speed;

			_alreadyHit = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}

		public function get distance():int
		{
			return _distance;
		}

		public function set distance(value:int):void
		{
			_distance = value;
		}

		public function get position():String
		{
			return _position;
		}

		public function set position(value:String):void
		{
			_position = value;
		}

		public function get alreadyHit():Boolean
		{
			return _alreadyHit;
		}

		public function set alreadyHit(value:Boolean):void
		{
			_alreadyHit = value;
			
			if(value)
			{
				obstacleCrashImage.visible = true;
				
				if(_type == 4)
					obstacleAnimation.visible = false;
				else
					obstacleImage.visible = false;
				
			}
		}

		public function get watchOut():Boolean
		{
			return _watchOut;
		}

		public function set watchOut(value:Boolean):void
		{
			_watchOut = value;
			
			if(watchOutAnimation)
			{
				if(value)
				{
					watchOutAnimation.visible = true;
				}
				else
				{
					watchOutAnimation.visible = false;
				}
			}
		}

		private function onAddedToStage(event:Event):void
		{
			// TODO Auto Generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			createObstacleArt();
			createObstacleCrashArt();
			createWatchOutAnimation();
		}
		
		private function createWatchOutAnimation():void
		{
			// TODO Auto Generated method stub
			watchOutAnimation = new MovieClip(Assets.getAtlas().getTextures("watchOut_"),10);
			Starling.juggler.add(watchOutAnimation);
			
			if(_type == 4)
			{
				watchOutAnimation.x = -watchOutAnimation.texture.width;
				watchOutAnimation.y = obstacleAnimation.y + (obstacleAnimation.texture.height * .5) -(watchOutAnimation.texture.height * 0.5);
			}
			else
			{
				watchOutAnimation.x = -watchOutAnimation.texture.width;
				watchOutAnimation.y = obstacleImage.y + (obstacleImage.texture.height * 0.5) - (watchOutAnimation.texture.height * .5);
			}
			
			this.addChild(watchOutAnimation);
		}
		
		private function createObstacleCrashArt():void
		{
			// TODO Auto Generated method stub
			obstacleCrashImage = new Image(Assets.getAtlas().getTexture("obstacle"+_type+"_crash"));
			obstacleCrashImage.visible = false;
			this.addChild(obstacleCrashImage);
		}
		
		private function createObstacleArt():void
		{
			
			if(_type == 4)
			{
				obstacleAnimation = new MovieClip(Assets.getAtlas().getTextures("obstacle"+_type + "_0"),10);
				Starling.juggler.add(obstacleAnimation);
				obstacleAnimation.x = 0;
				obstacleAnimation.y = 0;
				this.addChild(obstacleAnimation);
			}
			else
			{
				obstacleImage = new Image(Assets.getAtlas().getTexture("obstacle"+_type));
				obstacleImage.x = 0;
				obstacleImage.y = 0;
				this.addChild(obstacleImage);
			}
			
		}
	}
}