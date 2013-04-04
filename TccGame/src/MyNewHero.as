package
{
	import Box2D.Common.Math.b2Vec2;
	
	import citrus.math.MathVector;
	import citrus.objects.platformer.box2d.Hero;
	
	public class MyNewHero extends Hero
	{
		private var shouldJump:Boolean;
		private var _worldRotation:int;
		private var verticalVelocity:Number;
		
		
		public function MyNewHero(name:String, params:Object=null)
		{
			super(name, params);
			jumpHeight = 15;
			jumpAcceleration= 0.5;
		}
		
		public function swipeJump():void
		{
			/*if (_onGround && _ce.input.justDid("jump", inputChannel) && !_ducking)
			{
				velocity.y = -jumpHeight;
				onJump.dispatch();
			}*/
			if(_onGround)
				shouldJump = true;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			// we get a reference to the actual velocity vector
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			if (controlsEnabled)
			{
				var moveKeyPressed:Boolean = false;
				
				_ducking = (_ce.input.isDoing("duck", inputChannel) && _onGround && canDuck);
				
				if (_ce.input.isDoing("right", inputChannel) && !_ducking)
				{
					velocity.Add(getSlopeBasedMoveAngle());
					moveKeyPressed = true;
				}
				
				if (_ce.input.isDoing("left", inputChannel) && !_ducking)
				{
					velocity.Subtract(getSlopeBasedMoveAngle());
					moveKeyPressed = true;
				}
				
				//If player just started moving the hero this tick.
				if (moveKeyPressed && !_playerMovingHero)
				{
					_playerMovingHero = true;
					_fixture.SetFriction(0); //Take away friction so he can accelerate.
				}
					//Player just stopped moving the hero this tick.
				else if (!moveKeyPressed && _playerMovingHero)
				{
					_playerMovingHero = false;
					_fixture.SetFriction(_friction); //Add friction so that he stops running
				}
				
				if (/*_onGround &&*/ shouldJump/*_ce.input.justDid("jump", inputChannel)*/ && !_ducking)
				{
					switch(GameState.getWorldRotationDeg())
					{
						case 0:
							velocity.y = -jumpHeight;
							verticalVelocity = velocity.y;
							break;
						case 180:
							velocity.y = +jumpHeight;
							verticalVelocity = velocity.y*=-1;
							break;
						case 270://certo
							velocity.x = -jumpHeight;
							verticalVelocity = velocity.x;
							break;
						case 90:
							velocity.x = +jumpHeight;
							verticalVelocity = velocity.x*=-1;
							break;
					}
					
					onJump.dispatch();
					shouldJump = false;
					_onGround = false;
				}
				
				if (/*_ce.input.isDoing("jump", inputChannel) && */!_onGround && verticalVelocity < 0)
				{
					switch(GameState.getWorldRotationDeg())
					{
						case 0:
							velocity.y += jumpAcceleration;
							verticalVelocity = velocity.y;
							break;
						case 180:
							velocity.y -= jumpAcceleration;
							verticalVelocity = velocity.y;y 
							//verticalVelocity*=-1;
							break;
						case 270://certo
							velocity.x += jumpAcceleration;
							verticalVelocity = velocity.x;
							break;
						case 90:
							velocity.x += jumpAcceleration;
							verticalVelocity = velocity.x;
							break;
					}
				}
				
				if (_springOffEnemy != -1)
				{
					if (_ce.input.isDoing("jump", inputChannel))
						velocity.y = -enemySpringJumpHeight;
					else
						velocity.y = -enemySpringHeight;
					_springOffEnemy = -1;
				}
				
				//Cap velocities
				if (velocity.x > (maxVelocity))
					velocity.x = maxVelocity;
				else if (velocity.x < (-maxVelocity))
					velocity.x = -maxVelocity;
			}
			
			updateAnimation();
		}
	}
}