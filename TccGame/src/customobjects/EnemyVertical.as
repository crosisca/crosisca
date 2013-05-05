package customobjects
{
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.math.MathVector;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DShapeMaker;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	public class EnemyVertical extends Box2DPhysicsObject
	{
		[Inspectable(defaultValue="1.3")]
		public var speed:Number = 1.3;
		
		[Inspectable(defaultValue="3")]
		public var enemyKillVelocity:Number = 3;
		
		[Inspectable(defaultValue="up",enumeration="up,down")]
		public var startingDirection:String = "up";
		
		[Inspectable(defaultValue="400")]
		public var hurtDuration:Number = 400;
		
		[Inspectable(defaultValue="-100000")]
		public var topBound:Number = -100000;
		
		[Inspectable(defaultValue="100000")]
		public var bottomBound:Number = 100000;
		
		[Inspectable(defaultValue="10")]
		public var wallSensorOffset:Number = 10;
		
		[Inspectable(defaultValue="2")]
		public var wallSensorWidth:Number = 2;
		
		[Inspectable(defaultValue="2")]
		public var wallSensorHeight:Number = 2;
		
		protected var _hurtTimeoutID:uint = 0;
		protected var _hurt:Boolean = false;
		protected var _enemyClass:* = Hero;
		
		protected var _bottomSensorShape:b2PolygonShape;
		protected var _topSensorShape:b2PolygonShape;
		protected var _bottomSensorFixture:b2Fixture;
		protected var _topSensorFixture:b2Fixture;
		protected var _sensorFixtureDef:b2FixtureDef;
		
		public function EnemyVertical(name:String, params:Object=null)
		{
			updateCallEnabled = true;
			_beginContactCallEnabled = true;
			
			super(name, params);
			
			if(startingDirection == "up")
				_inverted = true;
		}
		
		override public function destroy():void
		{
			clearTimeout(_hurtTimeoutID);
			
			super.destroy();
		}
		
		public function get enemyClass():*
		{
			return _enemyClass;
		}
		
		[Inspectable(defaultValue="citrus.objects.platformer.box2d.Hero",type="String")]
		public function set enemyClass(value:*):void
		{
			if (value is String)
				_enemyClass = getDefinitionByName(value) as Class;
			else if (value is Class)
				_enemyClass = value;
		}
		
		//TODO ARRUMAR PRA MOVIMENTACAO VERTICAL
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			var position:b2Vec2 = _body.GetPosition();
			
			//Turn around when they pass their top/bottom bounds
			if ((_inverted && position.y * _box2D.scale < topBound) || (!_inverted && position.x * _box2D.scale > bottomBound))
				turnAround();
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			if (!_hurt)
				velocity.y = _inverted ? -speed-body.GetWorld().GetGravity().y/2 : speed-body.GetWorld().GetGravity().y/2;
			else
				velocity.y = 0;
			
			updateAnimation();
		}
		
		override protected function defineBody():void
		{
			_bodyDef = new b2BodyDef();
			_bodyDef.type = b2Body.b2_kinematicBody;
			_bodyDef.position = new b2Vec2(_x, _y);
			_bodyDef.angle = _rotation;
		}
		
		/**
		 * The enemy is hurt, start the time out with <code>hurtDuration</code> value. Then it called <code>endHurtState</code>'s function.
		 */
		public function hurt():void
		{
			_hurt = true;
			_hurtTimeoutID = setTimeout(endHurtState, hurtDuration);
		}
		
		public function turnAround():void
		{
			_inverted = !_inverted;
		}
		
		override protected function createBody():void
		{
			super.createBody();
			_body.SetFixedRotation(true);
		}
		
		override protected function createShape():void
		{
			_shape = Box2DShapeMaker.BeveledRect(_width, _height, 0.2);
			
			var sensorWidth:Number = wallSensorWidth / _box2D.scale;
			var sensorHeight:Number = wallSensorHeight / _box2D.scale;
			var sensorOffset:b2Vec2 = new b2Vec2( -_width / 2 - (sensorWidth / 2), _height / 2 - (wallSensorOffset / _box2D.scale));
			
			_topSensorShape = new b2PolygonShape();
			_topSensorShape.SetAsOrientedBox(sensorWidth, sensorHeight, sensorOffset);
			
			sensorOffset.x = -sensorOffset.x;
			_bottomSensorShape = new b2PolygonShape();
			_bottomSensorShape.SetAsOrientedBox(sensorWidth, sensorHeight, sensorOffset);
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = 0;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("BadGuys");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAllExcept("Items");
			
			_sensorFixtureDef = new b2FixtureDef();
			_sensorFixtureDef.shape = _topSensorShape;
			_sensorFixtureDef.isSensor = true;
			_sensorFixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("BadGuys");
			_sensorFixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAllExcept("Items");
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			
			_topSensorFixture = body.CreateFixture(_sensorFixtureDef);
			
			_sensorFixtureDef.shape = _bottomSensorShape;
			_bottomSensorFixture = body.CreateFixture(_sensorFixtureDef);
		}
		
		override public function handleBeginContact(contact:b2Contact):void {
			
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			if (collider is _enemyClass && collider.body.GetLinearVelocity().y > enemyKillVelocity)
				hurt();
			
			if (_body.GetLinearVelocity().y < 0 && (contact.GetFixtureA() == _bottomSensorFixture || contact.GetFixtureB() == _bottomSensorFixture))
				return;
			
			if (_body.GetLinearVelocity().y > 0 && (contact.GetFixtureA() == _topSensorFixture || contact.GetFixtureB() == _topSensorFixture))
				return;
			
			if (contact.GetManifold().m_localPoint) {
				
				var normalPoint:Point = new Point(contact.GetManifold().m_localPoint.x, contact.GetManifold().m_localPoint.y);
				var collisionAngle:Number = new MathVector(normalPoint.x, normalPoint.y).angle * 180 / Math.PI;
				
				//Angulo pode estar errado
				if ((collider is Platform && collisionAngle != 0) || collider is Enemy)
					turnAround();
			}
			
		}
		
		protected function updateAnimation():void
		{
			_animation = _hurt ? "die" : "walk";	
		}
		
		/**
		 * The enemy is no more hurt, but it is killed. Override this function to prevent enemy's death.
		 */
		protected function endHurtState():void
		{
			_hurt = false;
			kill = true;
		}
		
		
		
		
	}
}