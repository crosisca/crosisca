package customobjects
{
	import Box2D.Dynamics.b2Body;
	
	import citrus.objects.platformer.box2d.MovingPlatform;
	
	public final class Esteira extends MovingPlatform
	{
		/**
		 * A velocidade da esteira.
		 */
		[Inspectable(defaultValue="3")]
		public var speedTread:Number = 3;
		
		/**
		 * A direcao da esteira
		 */
		[Inspectable(defaultValue="right",enumeration="right,left,up,down")]
		public var startingDirection:String = "right";
		
		/**
		 * Activate it or not.
		 */
		[Inspectable(defaultValue="true")]
		public var enableTreadmill:Boolean = true;
		
		
		public function Esteira(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
			if (enableTreadmill) 
			{
				for each (var passengers:b2Body in _passengers) 
				{
					switch(startingDirection)
					{
						case "right":
							passengers.GetUserData().x += speedTread;
							break;
						case "left":
							passengers.GetUserData().x -= speedTread;
							break;
						case "up":
							passengers.GetUserData().y -= speedTread;
							break;
						case "down":
							passengers.GetUserData().y += speedTread;
							break;
					}
				}
			}
			/*if (enableTreadmill) 
			{
				for each (var passengers:b2Body in _passengers) 
				{
					switch(GameState.getWorldRotationDeg())
					{
						case 0:
							switch(startingDirection)
							{
								case "right":
									passengers.GetUserData().x += speedTread;
									break;
								case "left":
									passengers.GetUserData().x -= speedTread;
									break;
								case "up":
									passengers.GetUserData().y -= speedTread;
									break;
								case "down":
									passengers.GetUserData().y += speedTread;
									break;
							}
							break;
						case 90:
							switch(startingDirection)
							{
								case "right":
									passengers.GetUserData().y -= speedTread;
									break;
								case "left":
									passengers.GetUserData().y += speedTread;
									break;
								case "up":
									passengers.GetUserData().x -= speedTread;
									break;
								case "down":
									passengers.GetUserData().x += speedTread;
									break;
							}
							break;
						case 180:
							switch(startingDirection)
							{
								case "right":
									passengers.GetUserData().x -= speedTread;
									break;
								case "left":
									passengers.GetUserData().x += speedTread;
									break;
								case "up":
									passengers.GetUserData().y += speedTread;
									break;
								case "down":
									passengers.GetUserData().y -= speedTread;
									break;
							}
							break;
						case 270:
							switch(startingDirection)
							{
								case "right":
									passengers.GetUserData().y += speedTread;
									break;
								case "left":
									passengers.GetUserData().y -= speedTread;
									break;
								case "up":
									passengers.GetUserData().x += speedTread;
									break;
								case "down":
									passengers.GetUserData().x -= speedTread;
									break;
							}
							break;
					}
				}
			}*/
		}
	}
}