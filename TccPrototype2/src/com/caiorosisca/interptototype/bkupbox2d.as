package com.caiorosisca.interptototype
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	[SWF(frameRate="60")]
	public class TccPrototype2 extends Sprite
	{
		public var world:b2World;
		private var stepTimer:Timer;
		private var wheelArray:Array;
		
		public function TccPrototype2()
		{
			var fps:FrameRateTracker = new FrameRateTracker();
			addChild(fps);
			getStarted();
		}
		
		private function getStarted():void
		{
			var gravity:b2Vec2 = new b2Vec2(0, 10);
			world = new b2World(gravity, true);
			
			wheelArray = new Array();
			
			for (var i:int = 0; i < 20; i++) 
			{
				createWheel(Math.random()*10, //radius
					Math.random()*(stage.stageWidth - 20) + 10,// X
					Math.random()*(stage.stageHeight - 20) + 10,// Y
					(Math.random()* 100) - 50,// velX
					0);// velY
			}
			
			
			
			/*
			createWheel(5, 10, 10, 50, 0);
			createWheel(5, 100, 200, -25, 0);
			*/
			createBoundaries();
			
			stepTimer = new Timer(0.025 * 1000);
			stepTimer.addEventListener(TimerEvent.TIMER, onTick);
			graphics.lineStyle(3, 0xff0000);
			stepTimer.start();
		}
		
		private function onTick(a_event:TimerEvent):void
		{
			/*graphics.moveTo(wheelBody.GetPosition().x, wheelBody.GetPosition().y);
			world.Step(0.025, 10, 10);
			graphics.lineTo(wheelBody.GetPosition().x, wheelBody.GetPosition().y);*/
			
			graphics.clear();
			graphics.lineStyle(3, 0xff0000);
			world.Step(0.025,10,10);
			
			for each (var wheelBody:b2Body in wheelArray) 
			{
				graphics.drawCircle(wheelBody.GetPosition().x,
					wheelBody.GetPosition().y,
					(wheelBody.GetFixtureList().GetShape() as b2CircleShape).GetRadius());
			}
		}
		
		private function createWheel(radius:Number, startX:Number, startY:Number,velX:Number, velY:Number):void
		{
			var wheelBodyDef:b2BodyDef = new b2BodyDef();
			wheelBodyDef.type = b2Body.b2_dynamicBody;
			wheelBodyDef.position.Set(startX, startY);
			var wheelBody:b2Body = world.CreateBody(wheelBodyDef);
			var circleShape:b2CircleShape = new b2CircleShape(radius);
			var wheelFixtureDef:b2FixtureDef = new b2FixtureDef();
			wheelFixtureDef.shape = circleShape;
			wheelFixtureDef.restitution = (Math.random()* 0.5)+0.5;
			var wheelFixture:b2Fixture = wheelBody.CreateFixture(wheelFixtureDef);
			
			var startingVelocity:b2Vec2 = new b2Vec2(velX, velY);
			wheelBody.SetLinearVelocity(startingVelocity);
			
			wheelArray.push(wheelBody);
		}
		
		private function createBoundaries():void	
		{
			/**Ground*/
			var groundBodyDef:b2BodyDef = new b2BodyDef();
			groundBodyDef.position.Set(0, stage.stageHeight);
			var groundBody:b2Body = world.CreateBody(groundBodyDef);
			var groundShape:b2PolygonShape = new b2PolygonShape();
			groundShape.SetAsBox(stage.stageWidth, 1);
			var groundFixtureDef:b2FixtureDef = new b2FixtureDef();
			groundFixtureDef.shape = groundShape;
			var groundFixture:b2Fixture = groundBody.CreateFixture(groundFixtureDef);
			
			/**Ceiling*/
			var ceilingBodyDef:b2BodyDef = new b2BodyDef();
			ceilingBodyDef.position.Set(0, 0);
			var ceilingBody:b2Body = world.CreateBody(ceilingBodyDef);
			var ceilingShape:b2PolygonShape = new b2PolygonShape();
			ceilingShape.SetAsBox(stage.stageWidth, 1);
			var ceilingFixtureDef:b2FixtureDef = new b2FixtureDef();
			ceilingFixtureDef.shape = ceilingShape;
			var ceilingFixture:b2Fixture = ceilingBody.CreateFixture(ceilingFixtureDef);
			
			/**Right Wall*/
			var rightWallBodyDef:b2BodyDef = new b2BodyDef();
			rightWallBodyDef.position.Set(stage.stageWidth, 0);
			var rightWallBody:b2Body = world.CreateBody(rightWallBodyDef);
			var rightWallShape:b2PolygonShape = new b2PolygonShape();
			rightWallShape.SetAsBox(1, stage.stageHeight);
			var rightWallFixtureDef:b2FixtureDef = new b2FixtureDef();
			rightWallFixtureDef.shape = rightWallShape;
			var rightWallFixture:b2Fixture = rightWallBody.CreateFixture(rightWallFixtureDef);
			
			/**Left Wall*/
			var leftWallBodyDef:b2BodyDef = new b2BodyDef();
			leftWallBodyDef.position.Set(0, 0);
			var leftWallBody:b2Body = world.CreateBody(leftWallBodyDef);
			var leftWallShape:b2PolygonShape = new b2PolygonShape();
			leftWallShape.SetAsBox(1, stage.stageHeight);
			var leftWallFixtureDef:b2FixtureDef = new b2FixtureDef();
			leftWallFixtureDef.shape = leftWallShape;
			var leftWallFixture:b2Fixture = leftWallBody.CreateFixture(leftWallFixtureDef);
		}
	}
}
import com.caiorosisca.interptototype;

