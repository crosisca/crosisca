package levels {
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.physics.box2d.Box2DUtils;
	
	import org.osflash.signals.Signal;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.extensions.filters.ThresholdFilter;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	public class ThresholdTestState extends StarlingState 
	{
		private var renderSprite:CitrusSprite;
		private var renderImage:Image;
		private var renderTexture:RenderTexture;
		private var thresholdFilter:starling.extensions.filters.ThresholdFilter;
		private var balls:Vector.<Box2DPhysicsObject>;
		
		private var m: Matrix = new Matrix();
		
		private var texture:Texture;
		
		private var sensor:Sensor;
		
		protected var _level:MovieClip;
		
		private var ballRadius:uint = 7;
		private var circleShape:Shape;
		
		private var impX:Number = 0;
		
		public var lvlEnded:Signal;
		public var restartLevel:Signal;
		
		protected var box2D:Box2D;
		private var numOfBalls:uint = 30;
		
		public function ThresholdTestState(level:MovieClip = null) 
		{
			super();
			
			_ce = CitrusEngine.getInstance();
			
			_level = level;
			
			lvlEnded = new Signal();
			restartLevel = new Signal();
		}
		override public function initialize():void {
			
			super.initialize();
			
			box2D = new Box2D("box2D");
			box2D.visible = false;
			box2D.gravity.y = 10;
			add(box2D);
			
			createObjects();
		}
		
		private function createObjects():void
		{
			var platform:Platform = new Platform("pf", {x:2048/2, y:1536-10, width:2048, height:20});
			add(platform);
			
			balls = new Vector.<Box2DPhysicsObject>();
			
			thresholdFilter = new ThresholdFilter(0.3);
			renderTexture = new RenderTexture(2048, 1536, false);
			renderImage = new Image(renderTexture);
			renderImage.filter = thresholdFilter;
			renderImage.blendMode = BlendMode.NORMAL;
			
			// or just addChild the image to Starling
			renderSprite = new CitrusSprite("render", {view:renderImage, x:2048/2, y:1536/2, group:7, width:2048, height:1536, registration:"center"});
			add(renderSprite);
			
			//create texture dynamically, switch to an predefined texture if you like
			var blur:int = 20;
			circleShape = new Shape();
			circleShape.graphics.beginFill(0x0000ff, 0.6);
			circleShape.graphics.drawCircle(ballRadius*2, ballRadius*2, ballRadius*2);
			circleShape.graphics.endFill();
			circleShape.filters = [new BlurFilter(blur, blur)];
			m = new Matrix();
			m.translate(blur, blur);
			
			var circleData:BitmapData = new BitmapData(ballRadius*4+2*blur, ballRadius*4+2*blur, true, 0x00000000);
			circleData.draw(circleShape, m);
			texture = Texture.fromBitmapData(circleData, true, true, 1);
			circleData.dispose();
			sensor = new Sensor("sensor", {x:100, y:1350, width:30, height:150});
			add(sensor);
			
			sensor.onBeginContact.add(onSensor);
		}
		
		private function onSensor(c:b2Contact):void
		{
			(Box2DUtils.CollisionGetOther(sensor, c) as Box2DPhysicsObject).body.ApplyImpulse(
				new b2Vec2(1+impX, 0/*-1.6*/), c.GetFixtureB().GetBody().GetWorldCenter());
		}
		
		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
			
			if (renderTexture)
			{
				impX = Math.random() * 0.5;
				if (balls.length > numOfBalls) {
					remove(balls[0]);
					balls.splice(0,1);
				}
				
				renderTexture.drawBundled(function():void
				{
					for (var i:int = 0; i < balls.length; i++)
					{
						balls[i].view.x = balls[i].x;
						balls[i].view.y = balls[i].y;
						m.identity();
						m.translate(balls[i].view.x - (renderSprite.x - renderTexture.width/2 + texture.width/2), 
							balls[i].view.y - (renderSprite.y - renderTexture.height/2 + texture.height/2));
						renderTexture.draw(balls[i].view, m);
					}
				});
				var img:Image = new Image(texture);
				var ball:Box2DPhysicsObject = new Box2DPhysicsObject("ball",{radius:ballRadius, x:100, y: 1400, view:img, group:0});
				ball.visible = false;
				add(ball);
				ball.body.GetFixtureList().SetFriction(0);
				ball.body.GetFixtureList().SetDensity(1.4);
				ball.body.GetFixtureList().GetBody().ResetMassData();
				ball.body.GetFixtureList().SetRestitution(0.5);
				balls.push(ball);
			}
		}
	}
}