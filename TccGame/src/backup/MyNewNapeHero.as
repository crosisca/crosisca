package
{
	import Box2D.Common.Math.b2Vec2;
	
	import citrus.objects.platformer.nape.Hero;
	import citrus.physics.box2d.Box2DUtils;
	
	import nape.geom.Vec2;
	
	public class MyNewNapeHero extends Hero
	{
		private var shouldJump:Boolean;
		private var _worldRotation:int;
		private var isDoingRight:Boolean;
		private var isDoingLeft:Boolean;
		private var maxVerticalVelocity:Number;
		
		public function MyNewNapeHero(name:String, params:Object=null)
		{
			super(name, params);
			jumpHeight = 15;
		}
		
		public function swipeJump():void
		{
			if(_onGround)
				shouldJump = true;
		}
		
		public function moveDir(dir:String):void
		{
			if(dir == "right")
			{
				isDoingRight = true;
				isDoingLeft = false;
			}else if(dir == "left")
			{
				isDoingLeft = true;
				isDoingRight = false;
			}
		}
		
		public function stopMoving():void{
			isDoingLeft = false;
			isDoingRight = false;
		}
		
		override public function update(timeDelta:Number):void
		{
			//super.update(timeDelta);
			
			// we get a reference to the actual velocity vector
			var velocity:Vec2 = _body.velocity;
			
			//Makes the hero always on ground for testing purposes only
			_onGround = true;
			
			if (controlsEnabled)
			{
				var moveKeyPressed:Boolean = false;
				
				if (isDoingRight && _onGround)
				{
					switch(GameState.getWorldRotationDeg())
					{
						case 0://Normal
							break;
						case 180:
							velocity.Subtract(getSlopeBasedMoveAngle());
							break;
						case 270://right
							velocity.Add(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),GameState.getWorldRotation()));
							break;
						case 90://left
							velocity.Add(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),GameState.getWorldRotation()));
							//velocity.Subtract(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),GameState.getWorldRotation()));//Retorna o valor contrario(eskerda vira direita)
							break;
					}
					moveKeyPressed = true;
				}
				
				if (isDoingLeft && _onGround)
				{
					switch(GameState.getWorldRotationDeg())
					{
						case 0://Normal
							velocity.Subtract(getSlopeBasedMoveAngle());
							break;
						case 180:
							velocity.Add(getSlopeBasedMoveAngle());
							break;
						case 270://right
							velocity.Subtract(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),GameState.getWorldRotation()));
							break;
						case 90://left
							velocity.Subtract(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),GameState.getWorldRotation()));
							//velocity.Add(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),GameState.getWorldRotation()));
							break;
					}
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
				
				if (shouldJump)
				{
					switch(GameState.getWorldRotationDeg())
					{
						case 0://Normal
							velocity.Subtract(new b2Vec2(0,jumpHeight));
							//velocity.y = -jumpHeight;
							break;
						case 180:
							velocity.Add(new b2Vec2(0,jumpHeight));
							//velocity.y = +jumpHeight;
							break;
						case 270://certo
							//velocity.Subtract(new b2Vec2(jumpHeight,0));
							velocity.Subtract(Box2DUtils.Rotateb2Vec2(new b2Vec2(0,jumpHeight),GameState.getWorldRotation()));
							//velocity.x = -jumpHeight;
							break;
						case 90://left
							//velocity.Add(new b2Vec2(jumpHeight,0));
							velocity.Subtract(Box2DUtils.Rotateb2Vec2(new b2Vec2(0,jumpHeight),GameState.getWorldRotation()));
							//velocity.x = +jumpHeight;
							break;
					}
					
					//onJump.dispatch();
					shouldJump = false;
				}
				
				//Cap velocities
				
				maxVerticalVelocity = maxVelocity<<1;
				
				if(GameState.getWorldRotationDeg() == 0 || GameState.getWorldRotationDeg() == 180)
				{
					//horizontal
					if (velocity.x > (maxVelocity))
						velocity.x = maxVelocity;
					else if (velocity.x < (-maxVelocity))
						velocity.x = -maxVelocity;
					
					//vertical
					if (velocity.y > (maxVerticalVelocity))
						velocity.y = maxVerticalVelocity;
					else if (velocity.y < (-maxVerticalVelocity))
						velocity.y = -maxVerticalVelocity;
				}
				else if(GameState.getWorldRotationDeg() == 90 || GameState.getWorldRotationDeg() == 270)
				{
					//horizontal
					if (velocity.y > (maxVelocity))
						velocity.y = maxVelocity;
					else if (velocity.y < (-maxVelocity))
						velocity.y = -maxVelocity;
					
					//vertical
					if (velocity.x > (maxVerticalVelocity))
						velocity.x = maxVerticalVelocity;
					else if (velocity.x < (-maxVerticalVelocity))
						velocity.x = -maxVerticalVelocity;
				}
			}
			
			updateAnimation();
		}
	}
}