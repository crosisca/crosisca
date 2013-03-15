package screens
{
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import objects.GameBackground;
	import objects.Hero;
	import objects.Item;
	import objects.Obstacles;
	import objects.Particle;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.utils.deg2rad;
	
	public class InGame extends Sprite
	{
		private var hero:Hero;
		private var bg:GameBackground;
		
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		
		private var startButton:Button;
		
		private var gameState:String;
		
		private var playerSpeed:Number;
		private var hitObstacle:Number = 0;
		private const MIN_SPEED:Number = 650;
		
		private var scoreDistance:int;
		private var obstacleGapCount:int;
		
		private var gameArea:Rectangle;

		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		
		private var obstaclesToAnimate:Vector.<Obstacles>;
		private var itemsToAnimate:Vector.<Item>;
		private var eatParticlesToAnimate:Vector.<Particle>;
		
		private var scoreText:TextField;
		
		private var particle:PDParticleSystem;		
		
		
		public function InGame()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			// TODO Auto Generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawGame();
			
			scoreText = new TextField(300,200, "Score: 0", Assets.getFont().name, 24, 0xffffff);
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			scoreText.x = 20;
			scoreText.y = 20;
			scoreText.border = true;
			scoreText.height = scoreText.textBounds.height + 10;
			this.addChild(scoreText);
		}
		
		private function drawGame():void
		{
			bg = new GameBackground();
			this.addChild(bg);
			
			particle = new PDParticleSystem(XML(new AssetsParticles.ParticleXml()), Texture.fromBitmap(new AssetsParticles.ParticleTexture()));
			Starling.juggler.add(particle);
			particle.x = -100;
			particle.y = -100;
			particle.scaleX = 1.2;
			particle.scaleY = 1.2;
			this.addChild(particle);
			
			
			hero = new Hero();
			hero.x = stage.stageWidth/2;
			hero.y = stage.stageHeight/2;
			this.addChild(hero);
			
			startButton = new Button(Assets.getAtlas().getTexture("startButton"));
			startButton.x = stage.stageWidth * .5 -  startButton.width * .5;
			startButton.y = stage.stageHeight * .5 - startButton.height * .5;
			this.addChild(startButton);
			
			gameArea = new Rectangle(0, 100, stage.stageWidth, stage.stageHeight - 250);
		}
		
		private function onStartButtonClick(event:Event):void
		{
			startButton.visible = false;
			startButton.removeEventListener(Event.TRIGGERED, onStartButtonClick);
			
			launchHero();
		}
		
		private function launchHero():void
		{
			particle.start();
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(stage);
			
			touchX = touch.globalX;
			touchY = touch.globalY;
		}
		
		private function onGameTick(event:Event):void
		{
			particle.x = hero.x + 60;
			particle.y = hero.y;
			
			switch(gameState)
			{
				case "idle":
					//Take off
					if(hero.x < stage.stageWidth * .5 * .5)
					{
						hero.x += ((stage.stageWidth * .5 * .5 + 10) + hero.x) * 0.05;
						hero.y = stage.stageHeight * .5;
						playerSpeed += (MIN_SPEED - playerSpeed) * 0.05;
						bg.speed = playerSpeed * elapsed;
					}
					else
					{
						gameState = "flying";
					}
					break;
				
				case "flying":
					
					if(hitObstacle <= 0)
					{
						hero.y -= (hero.y - touchY) * 0.1;
						
						if(-(hero.y - touchY) < 150 && -(hero.y - touchY) > -150)
						{
							hero.rotation = deg2rad(-(hero.y - touchY) * .2);//max 30 graus(150 *.2);
						}
						
						//bot limit
						if(hero.y > gameArea.bottom - hero.height *.5)
						{
							hero.y = gameArea.bottom - hero.height*.5;
							hero.rotation = deg2rad(0);
						}
						
						
						//top limit
						if(hero.y < gameArea.top + hero.height*.5)
						{
							hero.y = gameArea.top + hero.height*.5;
							hero.rotation = deg2rad(0);
						}
					}
					else
					{
						hitObstacle--;
						cameraShake();
					}
					
					playerSpeed -= (playerSpeed - MIN_SPEED) * .01;
					bg.speed = playerSpeed * elapsed;
					
					scoreDistance += playerSpeed * elapsed * .1;
					
					scoreText.text = "Score: "+ scoreDistance;
					
					initObstacle();
					animateObstacles();
					
					createFoodItems();
					animateItems();
					animateEatParticles();
					
					break;
				
				case "over":
					break;
				default:
					break;
			}
		}
		
		private function animateEatParticles():void
		{
			for (var i:uint = 0; i < eatParticlesToAnimate.length; i++) 
			{
				var eatParticleToTrack:Particle = eatParticlesToAnimate[i];
				
				if(eatParticleToTrack)
				{
					eatParticleToTrack.scaleX -= 0.3;
					eatParticleToTrack.scaleY = eatParticleToTrack.scaleX;
					
					eatParticleToTrack.y -= eatParticleToTrack.speedY;
					eatParticleToTrack.speedY -= eatParticleToTrack.speedY * .2;
					
					eatParticleToTrack.x += eatParticleToTrack.speedX;
					eatParticleToTrack.speedX--;
					
					eatParticleToTrack.rotation += deg2rad(eatParticleToTrack.spin);
					eatParticleToTrack.spin *= 1.1;
					
					if(eatParticleToTrack.scaleY <= 0.02)
					{
						eatParticlesToAnimate.splice(i,1);
						this.removeChild(eatParticleToTrack);
						eatParticleToTrack = null;
					}
				}
			}
			
		}
		
		private function animateItems():void
		{
			var itemToTrack:Item;
			
			for (var i:int = 0; i < itemsToAnimate.length; i++) 
			{
				itemToTrack = itemsToAnimate[i];
				
				itemToTrack.x -= playerSpeed * elapsed;
				
				if(itemToTrack.bounds.intersects(hero.bounds))
				{
					createEatParticles(itemToTrack);//or itemtotack.x and y
					
					itemsToAnimate.splice(i,1);
					this.removeChild(itemToTrack);
				}
				
				if(itemToTrack.x < - 50)
				{
					itemsToAnimate.splice(i,1);
					this.removeChild(itemToTrack);
				}
			}
			
		}
		
		private function createEatParticles(itemToTrack:Item):void
		{
			var count:int = 5;
			
			while(count > 0)
			{
				count--;
				
				var eatParticle:Particle = new Particle();
				this.addChild(eatParticle);
				
				eatParticle.x = itemToTrack.x + Math.random() * 40 - 20;
				eatParticle.y = itemToTrack.y - Math.random() * 40;
				
				eatParticle.speedX = Math.random() * 2 + 1;
				eatParticle.speedY = Math.random() * 5;
				eatParticle.spin = Math.random() * 15;
				
				eatParticle.scaleX = eatParticle.scaleY = (Math.random() * .3) + .3;
				
				eatParticlesToAnimate.push(eatParticle);
			}
			
		}
		
		private function createFoodItems():void
		{
			if(Math.random() > .95)
			{
				var itemToTrack:Item = new Item(Math.ceil(Math.random() * 5));
				itemToTrack.x = stage.stageWidth + 50;
				itemToTrack.y = int(Math.random() *  (gameArea.bottom - gameArea.top)) + gameArea.top;
				this.addChild(itemToTrack);
				
				itemsToAnimate.push(itemToTrack);
			}
		}
		
		private function cameraShake():void
		{
			if(hitObstacle > 0)
			{
				this.x = Math.random()*hitObstacle;
				this.y = Math.random()*hitObstacle;
			}
			else if(x!= 0)
			{
				this.x = 0;
				this.y = 0;
			}
		}
		
		private function animateObstacles():void
		{
			// TODO Auto Generated method stub
			var obstacleToTrack:Obstacles;
			
			for (var i:uint = 0; i < obstaclesToAnimate.length; i++) 
			{
				obstacleToTrack = obstaclesToAnimate[i];
				
				if(obstacleToTrack.alreadyHit == false && obstacleToTrack.bounds.intersects(hero.bounds))
				{
					obstacleToTrack.alreadyHit = true;
					obstacleToTrack.rotation = deg2rad(70);
					hitObstacle = 30;
					playerSpeed *= .5;
				}
				
				
				if(obstacleToTrack.distance > 0)
				{
					obstacleToTrack.distance -= playerSpeed * elapsed;
				}
				else
				{
					if(obstacleToTrack.watchOut)
					{
						obstacleToTrack.watchOut = false;
					}
					obstacleToTrack.x -= (playerSpeed + obstacleToTrack.speed) * elapsed;
				}
				
				if(obstacleToTrack.x < -obstacleToTrack.width || gameState == "over")
				{
					obstaclesToAnimate.splice(i,1);
					this.removeChild(obstacleToTrack);
				}
			}
		}
		
		private function initObstacle():void
		{
			if(obstacleGapCount < 1200)
			{
				obstacleGapCount += playerSpeed * elapsed;
			}
			else if(obstacleGapCount != 0)
			{
				obstacleGapCount = 0;
				createObstacle(Math.ceil(Math.random() * 4), Math.random() * 1000 + 1000);
			}
		}
		
		private function createObstacle(type:Number, distance:Number):void
		{
			var obstacle:Obstacles = new Obstacles(type, distance, true, 300);
			obstacle.x = stage.stageWidth;
			this.addChild(obstacle);
			
			if(type <= 3)//not helicopter
			{
				if(Math.random() > .5)
				{
					obstacle.y = gameArea.top;
					obstacle.position = "top";
				}
				else
				{
					obstacle.y = gameArea.bottom - obstacle.height;
					obstacle.position = "bottom";
				}
			}
			else//is helicopter
			{//////////////////////////////////////////              350>>>>>>>> 100 - 450
				obstacle.y = int(Math.random() * ( gameArea.bottom - obstacle.height - gameArea.top)) + gameArea.top;
				obstacle.position = "middle";
			}
			
			obstaclesToAnimate.push(obstacle);
			
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
			
			this.addEventListener(Event.ENTER_FRAME, checkElapsed);
			
			hero.x = -hero.width;// Nao pode ser menor q isso q buga..n sei pq
			hero.y = stage.stageHeight * .5;
			
			gameState = "idle";
			
			playerSpeed = 0;
			hitObstacle = 0;
			
			bg.speed = 0;
			scoreDistance = 0;
			obstacleGapCount = 0;
			
			obstaclesToAnimate = new Vector.<Obstacles>();
			itemsToAnimate = new Vector.<Item>();
			eatParticlesToAnimate = new Vector.<Particle>();
			
			startButton.addEventListener(Event.TRIGGERED, onStartButtonClick);
		}
		
		private function checkElapsed(event:Event):void
		{
			timePrevious = timeCurrent;
			timeCurrent = getTimer();
			elapsed = (timeCurrent - timePrevious) * 0.001;
		}
	}
}