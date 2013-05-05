package customobjects
{
	import flash.utils.getDefinitionByName;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DShapeMaker;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	public class Spike extends Box2DPhysicsObject
	{
		protected var _enemyClass:* = Hero;
		protected var sensorShape:b2PolygonShape;
		protected var _sensorFixtureDef:b2FixtureDef;
		protected var sensorFixture:b2Fixture;
		
		
		public function Spike(name:String, params:Object=null)
		{
			updateCallEnabled = true;
			_beginContactCallEnabled = true;
			super(name, params);
		}
		
		[Inspectable(defaultValue="citrus.objects.platformer.box2d.Hero",type="String")]
		public function set enemyClass(value:*):void
		{
			if (value is String)
				_enemyClass = getDefinitionByName(value) as Class;
			else if (value is Class)
				_enemyClass = value;
		}
		
		override protected function defineBody():void
		{
			_bodyDef = new b2BodyDef();
			_bodyDef.type = b2Body.b2_staticBody;
			_bodyDef.position = new b2Vec2(_x, _y);
			_bodyDef.angle = _rotation;
		}
		
		override protected function createBody():void
		{
			super.createBody();
			_body.SetFixedRotation(true);
		}
		
		override public function handleBeginContact(contact:b2Contact):void {
			
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			//if (collider is _enemyClass)
				//hurt();
		}
		
		override protected function createShape():void
		{
			_shape = Box2DShapeMaker.BeveledRect(_width, _height, 0.2);
			
			var sensorWidth:Number = _width / _box2D.scale;
			var sensorHeight:Number = _width / _box2D.scale;
			var sensorOffset:b2Vec2 = new b2Vec2();
			
			sensorShape = new b2PolygonShape();
			sensorShape.SetAsOrientedBox(sensorWidth, sensorHeight, sensorOffset);
			
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = 0.8;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("BadGuys");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAllExcept("Items");
			
			_sensorFixtureDef = new b2FixtureDef();
			_sensorFixtureDef.shape = sensorShape;
			_sensorFixtureDef.isSensor = true;
			_sensorFixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("BadGuys");
			_sensorFixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAllExcept("Items");
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			
			sensorFixture = body.CreateFixture(_sensorFixtureDef);
		}
	}
}