package citrus.objects.complex.box2dstarling
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.CitrusSprite;
	
	import citrus.physics.PhysicsCollisionCategories;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import starling.utils.rad2deg;
	
	/**
	 * ...
	 * @author Alex using
	 * http://www.emanueleferonato.com/2011/09/18/creation-of-a-box2d-car-with-10-customizable-parameters/
	 */
	public class Car extends Box2DPhysicsObject
	{
		
		private const degreesToRadians:Number = 0.0174532925;
		
		public var inputChannel:uint = 0;
		public const ws:Number = 30;
		
		protected var bodies:Vector.<b2Body>;
		
		private var worldScale:int=30;
        protected var car:b2Body;
        private var leftWheelRevoluteJoint:b2RevoluteJoint;
        private var rightWheelRevoluteJoint:b2RevoluteJoint;
        private var motorSpeed:Number=0;
        private var leftAxlePrismaticJoint:b2PrismaticJoint;
        private var rightAxlePrismaticJoint:b2PrismaticJoint;
		
		private var carPosX:Number = 0;
		private var carPosY:Number = 0;
		private var carWidth:Number = 103/2;
		protected var carHeight:Number = 10;
		private var axleContainerDistance:Number = 40;
		private var axleContainerWidth:Number = 4;
		private var axleContainerHeight:Number = 20;
		private var axleContainerDepth:Number = 10;
		private var axleAngle:Number = 20;
		private var wheelRadius:Number = 45/2;
		
		private var wheelFriction:Number = 1;
		private var axleDensity:Number = 4;
		private var axleFriction:Number = 1;
		
		protected var controlsEnabled:Boolean = false;
		
		private var motorIncrement:Number = 0.5;
		private var maxSpeed:Number = 11;
		private var maxMotorTorque:Number = 10;
		
		private var carArt:CitrusSprite;
		private var leftWheelArt:CitrusSprite;
		private var rightWheelArt:CitrusSprite;
		private var leftAxleArt:CitrusSprite;
		private var rightAxleArt:CitrusSprite;
		
		private var leftWheel:b2Body;
		private var rightWheel:b2Body;
		private var leftAxle:b2Body;
		private var rightAxle:b2Body;
		
		private var carFlippedTimeoutID:uint;
		private var isFlipping:Boolean = false;

		public function Car(name:String, params:Object = null)
		{
			updateCallEnabled = true;
			//_preContactCallEnabled = true;
			//_beginContactCallEnabled = true;
			//_endContactCallEnabled = true;
			super(name, params);
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (controlsEnabled) {
				if (_ce.input.isDoing("right", inputChannel)) motorSpeed -= motorIncrement;
				if (_ce.input.isDoing("left", inputChannel)) motorSpeed += motorIncrement;
				
				if (_ce.input.justDid("jump", inputChannel)) {
					var v:b2Vec2 = car.GetLinearVelocity();
					var force:b2Vec2 = new b2Vec2(0, 5).rotate( car.GetAngle());
					v.Subtract(force);
				}

				motorSpeed *= 0.99;
				if (motorSpeed > maxSpeed) motorSpeed = maxSpeed;
				else if (motorSpeed < -maxSpeed) motorSpeed = -maxSpeed;
				
				leftWheelRevoluteJoint.SetMotorSpeed(motorSpeed);
				rightWheelRevoluteJoint.SetMotorSpeed(motorSpeed);
				
			} else {
				motorSpeed = 0;
				leftWheelRevoluteJoint.SetMotorSpeed(motorSpeed);
				rightWheelRevoluteJoint.SetMotorSpeed(motorSpeed);
			}
			
			var carAngle:Number = rad2deg(car.GetAngle());
			if (!isFlipping) 
			{
				if (carAngle > 90 || carAngle < -90) {
					isFlipping = true;
					clearTimeout(carFlippedTimeoutID);
					carFlippedTimeoutID = setTimeout(endCarFlippedState, 1000);
				}
			}
			updateArt();
		}
		
		private function endCarFlippedState():void
		{
			clearTimeout(carFlippedTimeoutID);
			isFlipping = false;
			car.SetAngle(0);
		}
		
		override public function initialize(poolObjectParams:Object = null):void
		{
			super.initialize(poolObjectParams);
			createCar();
			addArt();
		}
		
		private function addArt():void 
		{
			carArt = new CitrusSprite("carArt", { group:2, width:carWidth * 2, height:carHeight * 2,
			view:"art/car.png", registration:"center"});
			
			leftAxleArt = new CitrusSprite("axleArt1", { group:2, width:axleContainerWidth *2, height:axleContainerHeight*2,
			view:"art/axleContainer.png", registration:"center" } );
			
			rightAxleArt = new CitrusSprite("axleArt2", { group:2, width:axleContainerWidth *2, height:axleContainerHeight*2,
			view:"art/axleContainer.png", registration:"center" } );
			
			leftWheelArt = new CitrusSprite("wheelArt1", { group:2, width:wheelRadius*2, height:wheelRadius * 2,
			view:"art/wheel.png", registration:"center" } );
			
			rightWheelArt = new CitrusSprite("wheelArt2", { group:2, width:wheelRadius*2, height:wheelRadius * 2,
			view:"art/wheel.png", registration:"center" } );
			
			_ce.state.add(leftAxleArt);
			_ce.state.add(rightAxleArt);
			_ce.state.add(leftWheelArt);
			_ce.state.add(rightWheelArt);
			_ce.state.add(carArt);
		}
		
		public function updateArt():void {
			carArt.x = car.GetPosition().x * ws;
			carArt.y = car.GetPosition().y * ws;
			carArt.rotation = rad2deg(car.GetAngle());
			
			leftAxleArt.x = leftAxle.GetPosition().x * ws;
			leftAxleArt.y = leftAxle.GetPosition().y * ws;
			leftAxleArt.rotation = rad2deg(leftAxle.GetAngle()) + axleAngle;
			
			rightAxleArt.x = rightAxle.GetPosition().x * ws;
			rightAxleArt.y = rightAxle.GetPosition().y * ws;
			rightAxleArt.rotation = rad2deg(rightAxle.GetAngle()) - axleAngle;
			
			leftWheelArt.x = leftWheel.GetPosition().x * ws;
			leftWheelArt.y = leftWheel.GetPosition().y * ws;
			leftWheelArt.rotation = rad2deg(leftWheel.GetAngle());
			
			rightWheelArt.x = rightWheel.GetPosition().x * ws;
			rightWheelArt.y = rightWheel.GetPosition().y * ws;
			rightWheelArt.rotation = rad2deg(rightWheel.GetAngle());
		}
		
		protected function createCar():void {
			bodies = new Vector.<b2Body>();
			makeCar();
		}
		
		private function makeCar():void {
			carPosX = this.x;
			carPosY = this.y;
			var carShape:b2PolygonShape = new b2PolygonShape();
			carShape.SetAsBox(carWidth / worldScale, carHeight / worldScale);
			var carFixture:b2FixtureDef = new b2FixtureDef();
			carFixture.density = 0.5;
			carFixture.friction = 3;
			carFixture.restitution = 0.1;
			carFixture.filter.groupIndex = -1;
			carFixture.filter.categoryBits = PhysicsCollisionCategories.Get("Level");
			carFixture.filter.maskBits = PhysicsCollisionCategories.GetAll();
			carFixture.shape = carShape;
			var carBodyDef:b2BodyDef = new b2BodyDef();
			carBodyDef.position.Set(carPosX / worldScale, carPosY / worldScale);
			carBodyDef.type = b2Body.b2_dynamicBody;
			// ************************ LEFT AXLE CONTAINER ************************ //
			var leftAxleContainerShape:b2PolygonShape = new b2PolygonShape();
			leftAxleContainerShape.SetAsOrientedBox(axleContainerWidth / worldScale, axleContainerHeight / worldScale, new b2Vec2(-axleContainerDistance / worldScale, axleContainerDepth / worldScale), axleAngle * degreesToRadians);
			var leftAxleContainerFixture:b2FixtureDef = new b2FixtureDef();
			leftAxleContainerFixture.density = 3;
			leftAxleContainerFixture.friction = 3;
			leftAxleContainerFixture.restitution = 0.3;
			leftAxleContainerFixture.filter.groupIndex = -1;
			leftAxleContainerFixture.shape = leftAxleContainerShape;
			// ************************ RIGHT AXLE CONTAINER ************************ //
			var rightAxleContainerShape:b2PolygonShape = new b2PolygonShape();
			rightAxleContainerShape.SetAsOrientedBox(axleContainerWidth / worldScale, axleContainerHeight / worldScale, new b2Vec2(axleContainerDistance / worldScale, axleContainerDepth / worldScale), -axleAngle * degreesToRadians);
			var rightAxleContainerFixture:b2FixtureDef = new b2FixtureDef();
			rightAxleContainerFixture.density = 3;
			rightAxleContainerFixture.friction = 3;
			rightAxleContainerFixture.restitution = 0.3;
			rightAxleContainerFixture.filter.groupIndex = -1;
			rightAxleContainerFixture.shape = rightAxleContainerShape;
			// ************************ MERGING ALL TOGETHER ************************ //
			car = _box2D.world.CreateBody(carBodyDef);
			car.CreateFixture(carFixture);
			car.CreateFixture(leftAxleContainerFixture);
			car.CreateFixture(rightAxleContainerFixture);
			addBody(car); // AS IMPORTANT :) SO THERE IS A _BODY to destroy
			// ************************ THE AXLES ************************ //
			var leftAxleShape:b2PolygonShape = new b2PolygonShape();
			leftAxleShape.SetAsOrientedBox(axleContainerWidth / worldScale / 2, axleContainerHeight / worldScale, new b2Vec2(0, 0), axleAngle * degreesToRadians);
			var leftAxleFixture:b2FixtureDef = new b2FixtureDef();
			leftAxleFixture.density = axleDensity;
			leftAxleFixture.friction = axleFriction;
			leftAxleFixture.restitution = 0;
			leftAxleFixture.shape = leftAxleShape;
			leftAxleFixture.filter.groupIndex = -1;
			var leftAxleBodyDef:b2BodyDef = new b2BodyDef();
			leftAxleBodyDef.type = b2Body.b2_dynamicBody;
			leftAxle = _box2D.world.CreateBody(leftAxleBodyDef);
			addBody(leftAxle);
			leftAxle.CreateFixture(leftAxleFixture);
			leftAxle.SetPosition(new b2Vec2(carPosX / worldScale - axleContainerDistance / worldScale - axleContainerHeight / worldScale * Math.cos((90 - axleAngle) * degreesToRadians), carPosY / worldScale + axleContainerDepth / worldScale + axleContainerHeight / worldScale * Math.sin((90 - axleAngle) * degreesToRadians)));
			var rightAxleShape:b2PolygonShape = new b2PolygonShape();
			rightAxleShape.SetAsOrientedBox(axleContainerWidth / worldScale / 2, axleContainerHeight / worldScale, new b2Vec2(0, 0), -axleAngle * degreesToRadians);
			var rightAxleFixture:b2FixtureDef = new b2FixtureDef();
			rightAxleFixture.density = axleDensity;
			rightAxleFixture.friction = axleFriction;
			rightAxleFixture.restitution = 0;
			rightAxleFixture.shape = rightAxleShape;
			rightAxleFixture.filter.groupIndex = -1;
			var rightAxleBodyDef:b2BodyDef = new b2BodyDef();
			rightAxleBodyDef.type = b2Body.b2_dynamicBody;
			rightAxle = _box2D.world.CreateBody(rightAxleBodyDef);
			addBody(rightAxle);
			rightAxle.CreateFixture(rightAxleFixture);
			rightAxle.SetPosition(new b2Vec2(carPosX / worldScale + axleContainerDistance / worldScale + axleContainerHeight / worldScale * Math.cos((90 - axleAngle) * degreesToRadians), carPosY / worldScale + axleContainerDepth / worldScale + axleContainerHeight / worldScale * Math.sin((90 - axleAngle) * degreesToRadians)));
			// ************************ THE WHEELS ************************ //;
			var wheelShape:b2CircleShape = new b2CircleShape(wheelRadius / worldScale);
			var wheelFixture:b2FixtureDef = new b2FixtureDef();
			wheelFixture.density = 1;
			wheelFixture.friction = wheelFriction;
			wheelFixture.restitution = 0.1;
			wheelFixture.filter.groupIndex = -1;
			wheelFixture.shape = wheelShape;
			var wheelBodyDef:b2BodyDef = new b2BodyDef();
			wheelBodyDef.type = b2Body.b2_dynamicBody;
			wheelBodyDef.position.Set(carPosX / worldScale - axleContainerDistance / worldScale - 2 * axleContainerHeight / worldScale * Math.cos((90 - axleAngle) * degreesToRadians), carPosY / worldScale + axleContainerDepth / worldScale + 2 * axleContainerHeight / worldScale * Math.sin((90 - axleAngle) * degreesToRadians));
			leftWheel = _box2D.world.CreateBody(wheelBodyDef);
			addBody(leftWheel);
			leftWheel.CreateFixture(wheelFixture);
			wheelBodyDef.position.Set(carPosX / worldScale + axleContainerDistance / worldScale + 2 * axleContainerHeight / worldScale * Math.cos((90 - axleAngle) * degreesToRadians), carPosY / worldScale + axleContainerDepth / worldScale + 2 * axleContainerHeight / worldScale * Math.sin((90 - axleAngle) * degreesToRadians));
			rightWheel = _box2D.world.CreateBody(wheelBodyDef);
			addBody(rightWheel);
			rightWheel.CreateFixture(wheelFixture);
			// ************************ REVOLUTE JOINTS ************************ //
			var leftWheelRevoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			leftWheelRevoluteJointDef.Initialize(leftWheel, leftAxle, leftWheel.GetWorldCenter());
			leftWheelRevoluteJointDef.enableMotor = true;
			leftWheelRevoluteJoint = _box2D.world.CreateJoint(leftWheelRevoluteJointDef) as b2RevoluteJoint;
			leftWheelRevoluteJoint.SetMaxMotorTorque(maxMotorTorque);
			var rightWheelRevoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			rightWheelRevoluteJointDef.Initialize(rightWheel, rightAxle, rightWheel.GetWorldCenter());
			rightWheelRevoluteJointDef.enableMotor = true;
			rightWheelRevoluteJoint = _box2D.world.CreateJoint(rightWheelRevoluteJointDef) as b2RevoluteJoint;
			rightWheelRevoluteJoint.SetMaxMotorTorque(maxMotorTorque);
			// ************************ PRISMATIC JOINTS ************************ //
			var leftAxlePrismaticJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			leftAxlePrismaticJointDef.lowerTranslation = 0;
			leftAxlePrismaticJointDef.upperTranslation = axleContainerDepth / worldScale;
			leftAxlePrismaticJointDef.enableLimit = true;
			leftAxlePrismaticJointDef.enableMotor = true;
			leftAxlePrismaticJointDef.Initialize(car, leftAxle, leftAxle.GetWorldCenter(), new b2Vec2(-Math.cos((90 - axleAngle) * degreesToRadians), Math.sin((90 - axleAngle) * degreesToRadians)));
			leftAxlePrismaticJoint = _box2D.world.CreateJoint(leftAxlePrismaticJointDef) as b2PrismaticJoint;
			leftAxlePrismaticJoint.SetMaxMotorForce(10);
			leftAxlePrismaticJoint.SetMotorSpeed(10);
			var rightAxlePrismaticJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			rightAxlePrismaticJointDef.lowerTranslation = 0;
			rightAxlePrismaticJointDef.upperTranslation = axleContainerDepth / worldScale;
			rightAxlePrismaticJointDef.enableLimit = true;
			rightAxlePrismaticJointDef.enableMotor = true;
			rightAxlePrismaticJointDef.Initialize(car, rightAxle, rightAxle.GetWorldCenter(), new b2Vec2(Math.cos((90 - axleAngle) * degreesToRadians), Math.sin((90 - axleAngle) * degreesToRadians)));
			rightAxlePrismaticJoint = _box2D.world.CreateJoint(rightAxlePrismaticJointDef) as b2PrismaticJoint;
			rightAxlePrismaticJoint.SetMaxMotorForce(10);
			rightAxlePrismaticJoint.SetMotorSpeed(10);
		}
		
		private function addBody(b:b2Body):void {
			bodies.push(b);
			_body = b;
			b.SetUserData(this);
		}
		
		override protected function defineBody():void { }
		override protected function createBody():void { }
		override protected function createShape():void { }
		override protected function defineFixture():void { }
		override protected function createFixture():void { }
	}
}