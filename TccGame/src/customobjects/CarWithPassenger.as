package citrus.objects.complex.box2dstarling {
	/**
	 * ...
	 * @author Alex
	 * An extension of the car which binds the Hero as a passenger
	 * allowing (dis)embarkation at will. 
	 * 
	 */
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import citrus.objects.platformer.box2d.Hero;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2FilterData;
	
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.math.MathVector;
	
	
	public class CarWithPassenger extends Car {
		
		protected var hasPassenger:Boolean = false;
		private var disembarkTimeoutID:uint;
		private var isDisembarking:Boolean = false;
		
		private var bindHeroJoint:b2DistanceJoint;
		private var heroOriginalFilterData:b2FilterData;
		
		private var hero:Hero;
		
		public function CarWithPassenger(name:String, params:Object=null) {
			updateCallEnabled = true;
			//_preContactCallEnabled = true;
			_beginContactCallEnabled = true;
			//_endContactCallEnabled = true;
			super(name, params);
			
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (!hero) hero = Hero.getInstance();
			
			if (controlsEnabled) {
				
				if (hasPassenger && !isDisembarking && ((_ce.input.justDid("up", inputChannel) || (_ce.input.justDid("down", inputChannel))))) {
					isDisembarking = true;
					controlsEnabled = false;
					hasPassenger = false;
					hero.controlsEnabled = true;
					hero.visible = true;
					_box2D.world.DestroyJoint(bindHeroJoint);
					
					var heroVelocity:b2Vec2 = hero.body.GetLinearVelocity();
					var disembarkForce:b2Vec2 = new b2Vec2(0, 8).rotate( hero.body.GetAngle());
					heroVelocity.Subtract(disembarkForce);
					
					clearTimeout(disembarkTimeoutID);
					disembarkTimeoutID = setTimeout(endDisembarkState, 250);
				}
			}
			
		}
		
		override public function handleBeginContact(contact:b2Contact):void 
		{
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			var colliderBody:b2Body = collider.body;
			
			if (!hasPassenger && !isDisembarking && collider is Hero) 
			{				
				var normalVec:MathVector = new MathVector(contact.GetManifold().m_localPoint.x, contact.GetManifold().m_localPoint.y);
				var collisionAngle:Number = normalVec.angle * 180 / Math.PI;
				var letsBoard:Boolean = false;
				if (hero.x < this.x && collisionAngle == 0) letsBoard = true;
				else if (hero.x > this.x && collisionAngle == 180) letsBoard = true;
				
				if (letsBoard) 
				{
					hasPassenger = true;
					controlsEnabled = true;
					hero.controlsEnabled = false;
					hero.visible = false;
					
					var bindHeroJointDef:b2DistanceJointDef = new b2DistanceJointDef();
					bindHeroJointDef.bodyA = car;
					bindHeroJointDef.bodyB = colliderBody;
					bindHeroJointDef.localAnchorB.Set(0, (carHeight / 30));
					bindHeroJoint = _box2D.world.CreateJoint(bindHeroJointDef) as b2DistanceJoint;

					heroOriginalFilterData = hero.fixture.GetFilterData();
					var filterData:b2FilterData = new b2FilterData();
					filterData.groupIndex = -1;
					hero.fixture.SetFilterData(filterData);
				}
			}
			
		}
		
		private function endDisembarkState():void 
		{
			clearTimeout(disembarkTimeoutID);
			isDisembarking = false;
			hero.fixture.SetFilterData(heroOriginalFilterData);
		}
	}

}