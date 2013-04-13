package backup
{
	import Box2D.Common.Math.b2Vec2;
	
	import citrus.math.MathVector;
	import citrus.objects.platformer.box2d.Hero;
	
	public class MyHero extends Hero
	{
		private var shouldJump:Boolean;
		private var _worldRotation:int;
		
		
		public function MyHero(name:String, params:Object=null)
		{
			super(name, params);
			jumpHeight = 15;
			jumpAcceleration= 0.5;
		}
		
		public function swipeJump():void
		{
			if (_onGround && _ce.input.justDid("jump", inputChannel) && !_ducking)
			{
				velocity.y = -jumpHeight;
				onJump.dispatch();
			}
			if(_onGround)
				shouldJump = true;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			// we get a reference to the actual velocity vector
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			
			var rotatedVelocity:MathVector = new MathVector(velocity.x, velocity.y);
			rotatedVelocity.rotate(GameState.getWorldRotation());
			var rotatedJumpVector:b2Vec2 = new b2Vec2(rotatedVelocity.x, rotatedVelocity.y);
			
			
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
				
				if (_onGround && shouldJump/*_ce.input.justDid("jump", inputChannel)*/ && !_ducking)
				{
					trace("just jumped");
					trace("Velocity: ",velocity.x,velocity.y);
					trace("RotatedVelocity: ",rotatedVelocity.x,rotatedVelocity.y);
					trace("RotatedJumpVector: ",rotatedJumpVector.x,rotatedJumpVector.y);
					velocity.Subtract(rotatedJumpVector);
					trace("Velocity: ",velocity.x,velocity.y);
					//velocity.y = -jumpHeight;
					onJump.dispatch();
					shouldJump = false;
				}
				
				if (_ce.input.isDoing("jump", inputChannel) && !_onGround && velocity.y < 0)
				{
					trace("jumping");
					velocity.Subtract(rotatedJumpVector);
					//velocity.y -= jumpAcceleration;
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
			
			this.velocity = [velocity.x,velocity.y];
		}
	}
}