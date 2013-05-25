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
	
	import controllers.AccelerometerHandler;
	import controllers.Controls;
	
	import utils.WorldUtils;
	
	public class MyNewHero extends Hero
	{
		private var _worldRotation:int;
		private var isDoingRight:Boolean;
		private var isDoingLeft:Boolean;
		//private var maxVerticalVelocity:Number;
		
		public function MyNewHero(name:String, params:Object=null)
		{
			super(name, params);
			jumpHeight = 15;
			maxVelocity = 5;
			
			//Define o quanto o Hero desliza
			friction = 150;
		}
		
		override public function update(timeDelta:Number):void
		{
			// we get a reference to the actual velocity vector
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			if(controlsEnabled)
			{
				var moveKeyPressed:Boolean = false;
				
				//Indo pra direita
				if (_ce.input.isDoing(Controls.RIGHT, inputChannel))
				{
					velocity.Add(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),WorldUtils.getWorldRotation()));
					moveKeyPressed = true;
				}
				
				//Indo pra esquerda
				if (_ce.input.isDoing(Controls.LEFT, inputChannel))
				{
					velocity.Subtract(Box2DUtils.Rotateb2Vec2(getSlopeBasedMoveAngle(),WorldUtils.getWorldRotation()));
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
				
				//Acabei de pular
				if (_onGround && _ce.input.justDid(Controls.JUMP, inputChannel))
				{
					//velocity.y = -jumpHeight;
					var jumpVec:b2Vec2 = Box2DUtils.Rotateb2Vec2(new b2Vec2(0,jumpHeight),WorldUtils.getWorldRotation());
					velocity.Subtract(jumpVec);
					onJump.dispatch();
				}
				
				//Feedback colisao com inimigo..arrumar dps
				/*if (_springOffEnemy != -1)
				{
					if (_ce.input.isDoing("jump", inputChannel))
						velocity.y = -enemySpringJumpHeight;
					else
						velocity.y = -enemySpringHeight;
					_springOffEnemy = -1;
				}*/
				
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
			}//End if(controlsEnabled)
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
					//caio TODO> nao esta ajustado pra levar em consideracao rotacao do device
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
			//Adjusted for any device rotation
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
					//trace("begin.groundContacts lenght:",_groundContacts.length);
					_onGround = true;
					(_ce.input.getControllerByName("accelerometerHandler") as AccelerometerHandler).setIsRotationAllowed(true);
					updateCombinedGroundAngle();
					//trace("handleBegin -> onGround");
				}
			}
		}
		
		public function recalculateGroundCollisionAngle():void
		{
			var collider:IBox2DPhysicsObject;
			
			if(this.body.GetContactList())
			{
				for (var contact: b2Contact = this.body.GetContactList().contact ; contact ; contact = contact.GetNext())
				{ 
					collider = Box2DUtils.CollisionGetOther(this, contact);
					if (contact.GetManifold().m_localPoint && !(collider is Sensor))
					{
						var collisionAngle:Number = (((new MathVector(contact.normal.x, contact.normal.y).angle) * 180 / Math.PI) + 360) % 360;// 0º <-> 360º
						
						var adjustedMinCollisionAngle:int;
						var adjustedMaxCollisionAngle:int;
						switch(WorldUtils.getWorldRotationDeg())//Defined by myself when I rotate the iPad
						{
							case 0://Collision Angle perpendicular to floor = 90
								adjustedMinCollisionAngle = 45;
								adjustedMaxCollisionAngle = 135;
								break;
							case 180://Collision Angle perpendicular to floor = 270
								adjustedMinCollisionAngle = 225;
								adjustedMaxCollisionAngle = 315;
								break;
							case 270://Collision Angle perpendicular to floor = 0
								adjustedMinCollisionAngle = -45;
								adjustedMaxCollisionAngle = 45;
								break;
							case 90://Collision Angle perpendicular to floor = 180
								adjustedMinCollisionAngle = 135;
								adjustedMaxCollisionAngle = 225;
								break;
						}
						if ((collisionAngle > adjustedMinCollisionAngle && collisionAngle < adjustedMaxCollisionAngle))
						{
							/**TODO> caio > Quando adiciono o novo chao aqui(que é o certo), a parede lateral ainda continua na lista de chao
							Não sei se isso é bom, talvez deveria limpar a lista _groundContacts, pq updateCombinedGroundAngle() pode
							estar sendo afetado*/
							_groundContacts.push(collider.body.GetFixtureList());
							_onGround = true;
							(_ce.input.getControllerByName("accelerometerHandler") as AccelerometerHandler).setIsRotationAllowed(true);
							updateCombinedGroundAngle();
						}//End if collision Angle> adjustedMin && > AdjustedMax
					}//End if(contact.GetManifold())
				}//End for contact
			}
		}
	}
}