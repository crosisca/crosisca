package com.caiorosisca
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	
	[SWF(frameRate="30",height="600",width="800")]
	public class RoundGameTest2 extends Sprite
	{
		private var world:b2World = new b2World(new b2Vec2(0,10),false);
		private var worldScale:Number = 30;
		private var rolyCenter:b2Vec2 = new b2Vec2(320, 320); // meio do circulo
		private var rolyRadius:Number = 230; // raio do ciculo
		private var rolyPieces:Number = 32; // quantidade de retangulos pra criar o circulo da borda
		private var tileSize:Number = 32; // tamanho dos tiles..medidas em pixels
		
		private var rolyLevel:b2Body;
		
		private var level:Array = [];
		private var startAngle:Number;
		private var startRolyAngle:Number;
		
		//private var mouseJoint:b2MouseJoint;
		private var rolyJoint:b2RevoluteJoint;
		private var rotateSpeed:Number = 0;
		
		private var playerSprite:Sprite = new Player();
		private var bgSprite:Sprite = new Background();
		
		private var player:b2Body;
		
		private var portal:b2Body;
		private var rotateRight:Boolean;
		private var rotateLeft:Boolean;
		private var tilesArray:Object;
		
		private var tilesContainer:MovieClip = new MovieClip();
		
		private var square:MovieClip  = new FundoRoda();
		private var ready:Boolean;
		
		public function RoundGameTest2()
		{
			stage.addChild(bgSprite);
			playerSprite.scaleX = .1;
			playerSprite.scaleY = .1;
			stage.addChild(playerSprite);
			
			
			square.x = rolyCenter.x;
			square.y = rolyCenter.y;
			
			//stage.addChild(tilesContainer);
			// 0 = vazio
			// 1 = parede
			// 2 = player
			/////////Cria o Level//////////
			level[0] =  [0,0,0,0,0,0,1,0,0,0,0,0,0,0,0];
			level[1] =  [0,0,0,0,0,0,1,0,0,0,0,0,0,0,0];
			level[2] =  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			level[3] =  [0,0,0,0,0,0,0,0,0,0,0,0,,0,0];
			level[4] =  [0,0,0,0,0,1,1,1,0,0,1,0,0,0,0];
			level[5] =  [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0];
			level[6] =  [0,1,1,0,0,0,0,0,0,0,1,3,0,0,0];
			level[7] =  [0,0,0,0,0,0,0,0,1,0,1,1,1,1,0];
			level[8] =  [0,0,0,0,1,1,0,0,0,0,0,0,0,0,0];
			level[9] =  [0,0,0,0,1,0,0,0,0,0,0,0,0,0,0];
			level[10] = [0,1,1,0,1,0,0,0,0,0,0,1,0,0,0];
			level[11] = [0,0,0,0,1,0,0,2,0,0,0,0,0,0,0];
			level[12] = [0,0,0,0,0,0,0,1,0,0,0,0,0,0,0];
			level[13] = [0,0,0,0,0,0,0,1,0,0,0,0,0,0,0];
			level[14] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			
			////////////////////////////////
			var centerAngle:Number = 2*Math.PI/rolyPieces; // circulo dividido pelo numero de fatias(representa o angulo de cada fatia)
			var rolySide:Number = rolyRadius*Math.tan(centerAngle/2)/worldScale;//tamanho de kd fatia
			rolyCenter.Multiply(1/worldScale); // converte de px pra metro
			
			debugDraw();
			
			var bodyDef:b2BodyDef= new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position = rolyCenter;
			
			rolyLevel = world.CreateBody(bodyDef);
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0;
			fixtureDef.friction  = 1;
			fixtureDef.userData = tileSprite;
			
			for(var i:int=0; i<rolyPieces; i++)
			{
				var angle:Number = 2*Math.PI/rolyPieces*i;
				polygonShape.SetAsOrientedBox(0.1,rolySide, new b2Vec2(rolyRadius/worldScale*Math.cos(angle),
					rolyRadius/worldScale*Math.sin(angle)),
					angle);
				rolyLevel.CreateFixture(fixtureDef);
			}
			
			var numberOfTiles:Number = Math.ceil(rolyRadius*2/tileSize);//determina a qtd de tiles dentro do circulo
			
			if(numberOfTiles%2 == 0) numberOfTiles++;//aumenta o numero pra impar..assim sempre tem 1 tile no meio
			
			var tileSizePX:Number = tileSize/worldScale;//tileSize convertido em metros
			
			for (var u:int=0; u<numberOfTiles; u++)
			{
				for (var j:int=0; j< numberOfTiles; j++)
				{
					switch (level[numberOfTiles-1-j][numberOfTiles-1-u])
					{
						case 1:
							polygonShape.SetAsOrientedBox(tileSizePX/2,tileSizePX/2, new b2Vec2(tileSizePX*(numberOfTiles/2-u)-tileSizePX/2,
								tileSizePX*(numberOfTiles/2-j)-tileSizePX/2),
								0);
							
							var tileSprite:Tile = new Tile();
							fixtureDef.userData = tileSprite;
							
							rolyLevel.CreateFixture(fixtureDef);
							break;
						case 2:
							createSphere(rolyCenter.x+(tileSizePX*(numberOfTiles/2-u)-tileSizePX/2),
								rolyCenter.y+(tileSizePX*(numberOfTiles/2-j)-tileSizePX/2));
							break;
						case 3:
							/*var portalBodyDef:b2BodyDef = new b2BodyDef();
							portalBodyDef.position.Set(rolyCenter.x+(tileSizePX*(numberOfTiles/2-u)-tileSizePX/2),
							rolyCenter.y+(tileSizePX*(numberOfTiles/2-j)-tileSizePX/2));
							portalBodyDef.type = b2Body.b2_dynamicBody;*/
							
							var circleShape:b2CircleShape = new b2CircleShape(10/worldScale);
							
							circleShape.SetLocalPosition(new b2Vec2(tileSizePX*(numberOfTiles/2-u)-tileSizePX/2,
								tileSizePX*(numberOfTiles/2-j)-tileSizePX/2));
							
							var portalFixtureDef:b2FixtureDef = new b2FixtureDef();
							portalFixtureDef.shape = circleShape;
							portalFixtureDef.density = 1;
							portalFixtureDef.restitution = 0.5;
							portalFixtureDef.friction = 1;
							
							var portalSprite:Goal= new Goal();
							fixtureDef.userData = portalSprite;
							
							rolyLevel.CreateFixture(portalFixtureDef);
							
							break;
					}
					
				}
			}
			
			var containerJoint:b2RevoluteJointDef = new b2RevoluteJointDef();
			var anchorA:b2Vec2 = new b2Vec2(0,0);
			var anchorB:b2Vec2 = rolyCenter;
			containerJoint.localAnchorA = anchorA;
			containerJoint.localAnchorB = anchorB;
			containerJoint.bodyA = rolyLevel;
			containerJoint.bodyB = world.GetGroundBody();
			//containerJoint.Initialize(rolyLevel,world.GetGroundBody(),rolyCenter);
			containerJoint.enableMotor = true;
			containerJoint.maxMotorTorque = 500000;
			containerJoint.motorSpeed = 0;
			//world.CreateJoint(containerJoint);
			
			
			
			rolyJoint=world.CreateJoint(containerJoint) as b2RevoluteJoint;
			
			addEventListener(Event.ENTER_FRAME, updateWorld);
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, startRotation);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(event.keyCode == Keyboard.RIGHT)
				rotateRight = true;
			if(event.keyCode == Keyboard.LEFT)
				rotateLeft = true;
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(event.keyCode == Keyboard.RIGHT)
				rotateRight = false;
			if(event.keyCode == Keyboard.LEFT)
				rotateLeft = false;
		}
		
		protected function startRotation(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var jointDef:b2MouseJointDef= new b2MouseJointDef();
			jointDef.bodyA = world.GetGroundBody();
			jointDef.bodyB = rolyLevel;
			jointDef.target.Set(mouseX/worldScale, mouseY/worldScale);
			jointDef.maxForce = 1000*rolyLevel.GetMass();
			//mouseJoint = new b2MouseJoint(jointDef) as b2MouseJoint;
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, startRotation);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, rotate);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopRotation);
		}
		
		protected function rotate(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			//mouseJoint.SetTarget(new b2Vec2(mouseX/worldScale, mouseY/worldScale));
		}
		
		protected function stopRotation(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			//world.DestroyJoint(mouseJoint);
			//mouseJoint = null;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, startRotation);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, rotate);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopRotation);
		}
		
		private function createSphere(pX:Number,pY:Number):void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(pX,pY);
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.bullet = true;
			bodyDef.userData = playerSprite;
			
			var circleShape:b2CircleShape = new b2CircleShape(10/worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = circleShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.5;
			fixtureDef.friction = 1;
			
			
			
			player = world.CreateBody(bodyDef);
			player.CreateFixture(fixtureDef);
			
			
			
		}
		
		private function debugDraw():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
		
		private function rotateCalc():void
		{
			if(rotateLeft)
				rotateSpeed +=.05;
			if(rotateRight)
				rotateSpeed-=.05;
			
			if(rotateSpeed >= 1)
				rotateSpeed = 1;
			
			if(rotateSpeed <= -1)
				rotateSpeed = -1;
			
			
			if(!rotateLeft && !rotateRight)
				if(rotateSpeed > 0)
					rotateSpeed -= 0.05;
				else if(rotateSpeed < 0)
					rotateSpeed += 0.05;
		}
		
		private function updateWorld(event:Event):void
		{
			rotateCalc();
			rolyJoint.SetMotorSpeed(rotateSpeed);
			//rolyJoint.SetMotorSpeed((mouseX-rolyCenter.x*worldScale)/100)
			world.Step(1/30,10,10);
			world.ClearForces();
			world.DrawDebugData();
			draw();
			stage.setChildIndex(bgSprite, 0);
		}
		
		
		private function draw():void
		{
			var i:int = 0;
			for (var f:b2Fixture = rolyLevel.GetFixtureList(); f; f = f.GetNext()) 
			{
				i++;
				var shapeType:b2Shape = f.GetShape();
				
				var fixSprite:Sprite = f.GetUserData() as Sprite;
					
				if(shapeType is b2CircleShape){
					
					
				}else{
					if(fixSprite)
					{
						var b:b2PolygonShape = f.GetShape() as b2PolygonShape;
						var vector:Vector.<b2Vec2> = b.GetVertices();
						
						var b2Vec:b2Vec2 = rolyLevel.GetWorldPoint(vector[3]);

						
						
						if(!ready){
							tilesContainer.addChild(fixSprite);
							fixSprite.x = b2Vec.x * worldScale;
							fixSprite.y = b2Vec.y * worldScale;
						}
					
					}
					
				}
				
			}
			
			ready = true;
			stage.addChild(square);
			square.addChild(tilesContainer);
			
			//trace(tilesContainer.x,tilesContainer.width/2);
			/*tilesContainer.graphics.beginFill(0X330044, 0.1);
			tilesContainer.graphics.drawRect(0, 0, tilesContainer.width, tilesContainer.height);
			tilesContainer.graphics.endFill();*/
			square.rotation = radiansToDegrees(rolyLevel.GetAngle());// radiansToDegrees(Math.atan2((b2Vec.y - rolyCenter.y) * worldScale, (b2Vec.x - rolyCenter.y)*worldScale));
			
			
			tilesContainer.x = -tilesContainer.width/2 -47 - 47;
			tilesContainer.y = -tilesContainer.height/2 -64;
			
			/*for (var currentBody:b2Body=world.GetBodyList(); currentBody; currentBody=currentBody.GetNext())
			{
			(currentBody.GetUserData() as Sprite).x = currentBody.GetPosition().x * worldScale;
			(currentBody.GetUserData() as Sprite).y = currentBody.GetPosition().y * worldScale;
			(currentBody.GetUserData() as Sprite).rotation = radiansToDegrees(currentBody.GetAngle());
			}*/
		}
		
		private function radiansToDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
	}
}