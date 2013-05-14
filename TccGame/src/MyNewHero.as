/**
 * Final Hero Class, needa alot of updates on movement/jump and input controller
 * */

package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.math.MathVector;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Missile;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	import utils.WorldUtils;
	
	public class MyNewHero extends Hero
	{
		private var shouldJump:Boolean;
		private var _worldRotation:int;
		private var isDoingRight:Boolean;
		private var isDoingLeft:Boolean;
		//private var maxVerticalVelocity:Number;
		
		
		public function MyNewHero(name:String, params:Object=null)
		{
			super(name, params);
			jumpHeight = 15;
			maxVelocity = 5;
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
				trace("isDoingRight");
				isDoingRight = true;
				isDoingLeft = false;
			}
			else if(dir == "left")
			{
				trace("isDoingLeft");
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
			// we get a reference to the actual velocity vector
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			//Makes the hero always on ground for testing purposes only
			//_onGround = true;
			//trace("OnGround =",_onGround);
			
			if (controlsEnabled)
			{
				var moveKeyPressed:Boolean = false;
				
				if (isDoingRight && _onGround)
				{
					switch(WorldUtils.getWorldRotationDeg())
					{
						case 0://Normal
							velocity.Add(getSlopeBasedMoveAngle());
							break;
						case 180:
							velocity.Subtract(getSlopeBasedMoveAngle());
							break;
						case 270://right
							velocity.Add(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),WorldUtils.getWorldRotation()));
							break;
						case 90://left
							velocity.Add(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),WorldUtils.getWorldRotation()));
							break;
					}
					moveKeyPressed = true;
				}
				
				if (isDoingLeft && _onGround)
				{
					switch(WorldUtils.getWorldRotationDeg())
					{
						case 0://Normal
							velocity.Subtract(getSlopeBasedMoveAngle());
							break;
						case 180:
							velocity.Add(getSlopeBasedMoveAngle());
							break;
						case 270://right
							velocity.Subtract(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),WorldUtils.getWorldRotation()));
							break;
						case 90://left
							velocity.Subtract(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),WorldUtils.getWorldRotation()));
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
					var jumpVec:b2Vec2 = Box2DUtils.Rotateb2Vec2(new b2Vec2(0,jumpHeight),WorldUtils.getWorldRotation());
					//trace("JumpVec = (X:",jumpVec.x,",","Y:",jumpVec.y,")");
					velocity.Subtract(jumpVec);
					onJump.dispatch();
					shouldJump = false;
				}
				
				//Cap velocities
				if(WorldUtils.getWorldRotationDeg() == 0 || WorldUtils.getWorldRotationDeg() == 180)
				{
					//horizontal
					if (velocity.x > (maxVelocity))
						velocity.x = maxVelocity;
					else if (velocity.x < (-maxVelocity))
						velocity.x = -maxVelocity;
					
					//vertical
					/*if (velocity.y > (maxVerticalVelocity))
						velocity.y = maxVerticalVelocity;
					else if (velocity.y < (-maxVerticalVelocity))
						velocity.y = -maxVerticalVelocity;*/
				}
				else if(WorldUtils.getWorldRotationDeg() == 90 || WorldUtils.getWorldRotationDeg() == 270)
				{
					//horizontal
					if (velocity.y > (maxVelocity))
						velocity.y = maxVelocity;
					else if (velocity.y < (-maxVelocity))
						velocity.y = -maxVelocity;
					
					//vertical
					/*if (velocity.x > (maxVerticalVelocity))
						velocity.x = maxVerticalVelocity;
					else if (velocity.x < (-maxVerticalVelocity))
						velocity.x = -maxVerticalVelocity;*/
				}
			}
			
			updateAnimation();
		}
		
		override public function handleBeginContact(contact:b2Contact):void {
			
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			if (_enemyClass && collider is _enemyClass || collider is Missile)
			{
				if (_body.GetLinearVelocity().y < killVelocity && !_hurt)
				{
					hurt();
					
					//fling the hero
					var hurtVelocity:b2Vec2 = _body.GetLinearVelocity();
					hurtVelocity.y = -hurtVelocityY;
					hurtVelocity.x = hurtVelocityX;
					if (collider.x > x)
						hurtVelocity.x = -hurtVelocityX;
					_body.SetLinearVelocity(hurtVelocity);
				}
				else
				{
					_springOffEnemy = collider.y - height;
					onGiveDamage.dispatch();
				}
			}
			
			//Collision angle if we don't touch a Sensor.
			if (contact.GetManifold().m_localPoint && !(collider is Sensor)) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{				
				var collisionAngle:Number = (((new MathVector(contact.normal.x, contact.normal.y).angle) * 180 / Math.PI) + 360) % 360;// 0º <-> 360º
				
				var adjustedMinCollisionAngle:int;
				var adjustedMaxCollisionAngle:int;
				switch(WorldUtils.getWorldRotationDeg())
				{
					case 0://Collision Angle do chao = 90
						adjustedMinCollisionAngle = 45;
						adjustedMaxCollisionAngle = 135;
						break;
					case 180://Collision Angle do chao = 270
						adjustedMinCollisionAngle = 225;
						adjustedMaxCollisionAngle = 315;
						break;
					case 270://Collision Angle do chao = 0
						adjustedMinCollisionAngle = -45;
						adjustedMaxCollisionAngle = 45;
						break;
					case 90://Collision Angle do chao = 180
						adjustedMinCollisionAngle = 135;
						adjustedMaxCollisionAngle = 225;
						break;
				}
				if ((collisionAngle > adjustedMinCollisionAngle && collisionAngle < adjustedMaxCollisionAngle))
				{
					_groundContacts.push(collider.body.GetFixtureList());
					_onGround = true;
					updateCombinedGroundAngle();
				}
			}
		}
	}
}