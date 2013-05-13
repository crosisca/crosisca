package
{
	import com.gamua.flox.Entity;
	import com.gamua.flox.Flox;
	import com.gamua.flox.utils.HttpStatus;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.core.CitrusObject;
	import citrus.core.starling.StarlingState;
	import citrus.input.controllers.Keyboard;
	import citrus.math.MathVector;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.CitrusSprite;
	import citrus.objects.complex.box2dstarling.Rope;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Treadmill;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.Mobile;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.view.starlingview.StarlingCamera;
	
	import customobjects.EnemyVertical;
	import customobjects.Esteira;
	import customobjects.Spike;
	import customobjects.VerticalCannon;
	
	import flox.GameSave;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.gestures.SwipeGestureDirection;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import utils.WorldUtils;
	
	public class GameState extends StarlingState
	{
		
		private var gravityForce:int = 15;
		
		private var swipe:SwipeGesture;
		private var hero:MyNewHero;
		
		private var box2d:Box2D;
		private static var _worldRotation:Number;
		private var heroBodyTransform:b2Transform;
		private var levelSwf:MovieClip;
		public var touchMoveId:int;
		private var accelerometerHandler:AccelerometerHandler;
		private var myTextField:TextField;
		private var myConsoleTextField:TextField;
		private var _camera:StarlingCamera;
		private var _debugSprite:Sprite;
		private var ScreenRealWidth:uint;
		private var ScreenRealHeight:uint;
		
		[Embed(source="/assets/images/Level1.jpg")]
		private var Level1Jpg:Class;
		
		[Embed(source="/assets/images/BackgroundForest.jpg")]
		private var BgForestJpg:Class;
		
		[Embed(source="/assets/images/ForegroundForest.png")]
		private var FgForestPng:Class;
		
		[Embed(source="/assets/images/robotHero.png")]
		private var HeroPng:Class;
		
		[Embed(source="/assets/images/consoleImg.jpg")]
		private var ConsoleJpg:Class;
		
		
		private var ceiling:Platform;
		private var isHangingRope1:Boolean;
		private var isHangingRope2:Boolean;
		private var enemy:Enemy;
		
		
		private var objectsUsedToBuildLevel:Array = [Platform,Treadmill,Spike,Enemy,VerticalCannon,Esteira];
		private var rope1:Rope;
		private var rope2:Rope;
		private var rankScreen:RankingScreen;
		private var gameSave:GameSave;
		
		public function GameState(level:MovieClip,debugSprt:Sprite)
		{
			if(Mobile.isIOS())
			{
				if(Mobile.isIpad())
				{
					if(Mobile.isRetina())
					{
						ScreenRealWidth = Mobile.iPAD_RETINA_WIDTH;
						ScreenRealHeight = Mobile.iPAD_RETINA_HEIGHT;	
					}
					else
					{
						ScreenRealWidth = Mobile.iPAD_WIDTH;
						ScreenRealHeight = Mobile.iPAD_HEIGHT;
					}
				}
				else
				{
					if(Mobile.isRetina())
					{
						ScreenRealWidth = Mobile.iPHONE_RETINA_WIDTH;
						ScreenRealHeight = Mobile.iPHONE_RETINA_HEIGHT;
					}
				}
			}
			if(Mobile.isLandscapeMode())
			{
				var landscapeWidth:uint = ScreenRealHeight;
				var landscapeHeight:uint = ScreenRealWidth;
				
				ScreenRealHeight = landscapeHeight;
				ScreenRealWidth = landscapeWidth;
			}
			
			_debugSprite = debugSprt;
			super();
			levelSwf = level;
		}
		
		
		override public function initialize():void
		{
			super.initialize();
			Flox.logInfo("Level Initialized");
			
			rankScreen = new RankingScreen();
			
			var bgBitmap:Bitmap = new Level1Jpg();
			var bgTexture:Texture = Texture.fromBitmap(bgBitmap);
			var bgImg:Image = new Image(bgTexture);
			var backgroundSprite:CitrusSprite = new CitrusSprite("bgSprite",{view:bgImg});
			add(backgroundSprite);
			
			//Create physics engine
			box2d = new Box2D("box2d");
			box2d.gravity.Set(0,gravityForce);
			box2d.visible = false;
			add(box2d);
			
			//Setup swipe
			swipe = new SwipeGesture(Starling.current.nativeStage);
			swipe.direction = SwipeGestureDirection.UP;
			swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipe);
			
			//Initialize world with default rotation;
			WorldUtils.setWorldRotation(0);

			//Create level from MC
			ObjectMaker2D.FromMovieClip(levelSwf);
			
			
			//Add Hero
			var heroBitmap:Bitmap = new HeroPng();
			var heroTexture:Texture = Texture.fromBitmap(heroBitmap);
			var heroImg:Image = new Image(heroTexture);
			heroImg.scaleX = heroImg.scaleY = .5;
			addChild(heroImg);
			hero = new MyNewHero("hero",{view:heroImg,x: 150, y: 200, width: 50, height:50});
			add(hero);
			
			
			//Create the ropes
			//createAndFixRopes();
			
			//Create enemys
			//createEnemys();
			
			//Setup Camera
			_camera = view.camera as StarlingCamera;
			var _bounds:Rectangle = new Rectangle(0,0,2048,1536);
			_camera.setUp(hero, new MathVector(ScreenRealWidth / 2, ScreenRealHeight / 2), _bounds, new MathVector(0.5, 0.5));
			_camera.restrictZoom = true;
			_camera.allowZoom = true;
			_camera.zoomFit(960,640);
			
			//Add move listeners
			Starling.current.nativeStage.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN, onTouchBegin);
			Starling.current.nativeStage.addEventListener(flash.events.TouchEvent.TOUCH_MOVE, onTouchBegin);
			Starling.current.nativeStage.addEventListener(flash.events.TouchEvent.TOUCH_END, onTouchEnd);
			
			//Create rotation handler
			accelerometerHandler = new AccelerometerHandler("accelerometerHandler",{});
			accelerometerHandler.triggerActions=true;
			_ce.input.addController(accelerometerHandler);
			
			//Console input
			createConsoleInput();
			
			//Create Flow stuff for saving player
			gameSave = new GameSave();
			gameSave.id = "mysave";
			_ce.console.addCommand("saveHero", saveHero);
			_ce.console.addCommand("loadHero", loadHero);
			
			//RankingBtn
			createRankingButton();
		}
		
		private function saveHero():void
		{
			gameSave.playerX = (hero.getBody() as b2Body).GetPosition().x;
			gameSave.playerY = (hero.getBody() as b2Body).GetPosition().y;
			gameSave.playerAngle = hero.rotation;
			gameSave.save(function onComplete(_gameSave:GameSave): void {
				Flox.logInfo("Hero saved sucessfully.");
			},
				function onError(error:String):void {
					Flox.logError(error, "Nao salvou Hero info. Device deve estar offline.");
				}
			);
		}
		private function loadHero():void
		{
			Entity.load(GameSave, gameSave.id, 
				function onComplete(_gameSave:GameSave):void {
					hero.body.SetPositionAndAngle(new b2Vec2(_gameSave.playerX,_gameSave.playerY),_gameSave.playerAngle);
				},
				function onError(error:String, httpStatus:HttpStatus):void {
					if(httpStatus == HttpStatus.NOT_FOUND) {
						Flox.logError(error, "Não existe ume Entity com o tipo e id especificado no server.");
					} else {
						Flox.logError(error, "Algum erro ocorreu durante carregamento dos dados do Player. Device deve estar offline.");
					}
				}
			);
		}
		
		private function createEnemys():void
		{
			var enemy1:Enemy = new Enemy("enemy",{x:600,y:950,
				height:50,width:50, view:Texture.fromColor(50,50,0xFF0000FF),
			rightBound:27000,leftBound:15000});
			add(enemy1);

			var enemy2:EnemyVertical = new EnemyVertical("enemy",{x:1125,y:950,
				height:50,width:50, view:Texture.fromColor(50,50,0xFF0000FF),
			topBound:26100,bottomBound:30900});
			add(enemy2);
		}
		
		private function createAndFixRopes():void
		{
			var rope1anchor: Platform = new Platform("rope1anchor",
				{x: 460, y: 750, width: 5,height: 5});
			add(rope1anchor);
			var rope2anchor: Platform = new Platform("rope2anchor",
				{x: 1450, y: 1330, width: 5,height: 5});
			add(rope2anchor);
			
			//Rope
			rope1 = new Rope("rope1", {anchor:rope1anchor,useTexture:true,
				segmentTexture:Texture.fromColor(20,2,0xFFFF0000),
				ropeLength: 80,numSegments:5,widthSegment:10});
			rope1.onHang.add(onRopeHang1);
			rope1.onHangEnd.add(onRopeStopHang1);
			add(rope1);
			
			//Rope
			rope2 = new Rope("rope2", {anchor:rope2anchor,useTexture:true,
				upsideDownCreation:true, segmentTexture:Texture.fromColor(20,2,0xFFFF0000),
				ropeLength: 80,numSegments:5,widthSegment:10});
			rope2.onHang.add(onRopeHang2);
			rope2.onHangEnd.add(onRopeStopHang2);
			add(rope2);
		}
		
		private function onSpawnEnemy(cEvt:b2Contact):void {
			//If contact body is my hero
			/*var enemyNum:Number = Math.random()*100;
			if (cEvt.GetFixtureA().GetBody().GetUserData() is MyNewHero) {
				var enemy2:Enemy = new Enemy(String("enemy"+enemyNum),{x:ScreenRealWidth/2,y:ScreenRealHeight-150,
					height:100,width:100, view:Texture.fromColor(100,100,0xFF0000FF)});
				add(enemy2);
			}*/
		}
		
		private function _cannonHurt(contact:Box2DPhysicsObject):void {
			if (contact is MyNewHero) {
				hero.hurt();
			}
		}
		
		private function _teleport(cEvt:b2Contact):void {
			//If contact body is my hero
			if (cEvt.GetFixtureA().GetBody().GetUserData() is MyNewHero) {
				//Set hero as object to be teleported on Teleporter.as
				cEvt.GetFixtureB().GetBody().GetUserData().object = cEvt.GetFixtureA().GetBody().GetUserData();
				//Set  teleport flag to true
				cEvt.GetFixtureB().GetBody().GetUserData().teleport = true;
			}
		}
		
		private function createConsoleInput():void
		{
			var consoleBtmp:Bitmap = new ConsoleJpg();
			var consoleBtn:Button = new Button(Texture.fromBitmap(consoleBtmp));
			consoleBtn.x = ScreenRealWidth-consoleBtn.width;
			consoleBtn.touchable = true;
			addChild(consoleBtn);
			consoleBtn.addEventListener(Event.TRIGGERED, onTouchConsole);
		}
		
		private function createRankingButton():void
		{
			var rankBtn:Button = new Button(Texture.fromColor(50,50,0xFF00FFFF));
			rankBtn.x = ScreenRealWidth-rankBtn.width;
			rankBtn.y = ScreenRealHeight-rankBtn.height;
			rankBtn.touchable = true;
			addChild(rankBtn);
			rankBtn.addEventListener(Event.TRIGGERED, onTouchRankBtn);
		}
		
		private function onTouchRankBtn(e:Event):void
		{
			rankScreen.showRanking();
			this.addChild(rankScreen);
		}
		
		private function onTouchConsole(e:Event):void
		{
			Starling.current.nativeStage.dispatchEvent(new flash.events.KeyboardEvent
				(starling.events.KeyboardEvent.KEY_UP, 
					true, false, "	".charCodeAt(0), Keyboard.TAB));
		}
		
		override public function update(timeDelta:Number):void
		{
			drawMinimap();
			
			//Track rotation(debbuging only)
			/*myTextField.text = (accelerometerHandler.rotZtest.toFixed(1).toString()+" "+
				accelerometerHandler.gravDirection);*/
			
			//Handle gravity direction
			if(_ce.input.justDid(AccelerometerHandler.GravityChange))
			{
				handleWorldRotation();
				accelerometerHandler.triggerGravityChangeOff();
			}
			super.update(timeDelta);
		}
		
		private function handleWorldRotation():void
		{
			if(_ce.input.isDoing(AccelerometerHandler.GravityDown))
			{
				Flox.logEvent("Device Rotated", {Gravity : "Down"});
				WorldUtils.setWorldRotation(0);
				box2d.gravity.Set(0, gravityForce);
				swipe.direction = SwipeGestureDirection.UP;
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityLeft))
			{
				Flox.logEvent("Device Rotated", {Gravity : "Left"});
				WorldUtils.setWorldRotation(90);
				box2d.gravity.Set(-gravityForce,0);
				swipe.direction = SwipeGestureDirection.RIGHT;
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityRight))
			{
				Flox.logEvent("Device Rotated", {Gravity : "Right"});
				WorldUtils.setWorldRotation(270);
				box2d.gravity.Set(gravityForce,0);
				swipe.direction = SwipeGestureDirection.LEFT;
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityUp))
			{
				Flox.logEvent("Device Rotated", {Gravity : "Up"});
				WorldUtils.setWorldRotation(180);
				box2d.gravity.Set(0, -gravityForce);
				swipe.direction = SwipeGestureDirection.DOWN;
			}
			heroBodyTransform = new b2Transform(hero.body.GetPosition(), b2Mat22.FromAngle(WorldUtils.getWorldRotation()));
			hero.body.SetTransform(heroBodyTransform);
		}
		
		protected function onTouchBegin(event:flash.events.TouchEvent):void
		{
			if(!touchMoveId)
			{
				touchMoveId = event.touchPointID;
				
				switch(WorldUtils.getWorldRotationDeg())
				{
					case 0://Normal
						if(event.stageX > ScreenRealWidth>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
					
					case 90://Left
						if(event.stageY > ScreenRealHeight>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
					
					case 180:
						if(event.stageX < ScreenRealWidth>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
					
					case 270:
						if(event.stageY < ScreenRealHeight>>1)
							hero.moveDir("right");
						else
							hero.moveDir("left");
						break;
				}
			}
		}
		
		private function onTouchEnd(event:flash.events.TouchEvent):void
		{
			if(event.touchPointID == touchMoveId)
			{
				touchMoveId = 0;
				hero.stopMoving();
			}
		}
		
		protected function onSwipe(event:GestureEvent):void
		{
			if(event.target == swipe)
			{
				if(isHangingRope1)
					rope1.removeJoint();
				else if(isHangingRope2)
					rope2.removeJoint();	
				
				hero.swipeJump();
			}
		}
		
		private function onRopeHang1():void{
			isHangingRope1 = true;
		}
		private function onRopeStopHang1():void{
			isHangingRope1 = false;
		}
		private function onRopeHang2():void{
			isHangingRope2 = true;
		}
		private function onRopeStopHang2():void{
			isHangingRope2 = false;
		}
		
		private function drawMinimap():void
		{
			_camera.renderDebug(_debugSprite);
			_debugSprite.scaleX = 0.2 * 0.6;
			_debugSprite.scaleY = 0.2 * 0.6;
			_debugSprite.x = ScreenRealWidth-_debugSprite.width;
			_debugSprite.y = ScreenRealHeight-_debugSprite.height;
			
			_debugSprite.graphics.lineStyle();
			_debugSprite.graphics.beginFill(0x000000, 0.2);
			
			var platforms:Vector.<CitrusObject> = getObjectsByType(Platform);
			var platfrm:CitrusObject;
			for each (platfrm in platforms)
			{
				_debugSprite.graphics.drawRect((platfrm as Platform).x - (platfrm as Platform).width / 2, (platfrm as Platform).y - (platfrm as Platform).height / 2, (platfrm as Platform).width, (platfrm as Platform).height);
			}
		}
	}
}