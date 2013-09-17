package core.levels
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	
	import citrus.core.CitrusObject;
	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.awayphysics.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMakerStarling;
	import citrus.view.starlingview.StarlingCamera;
	
	import core.TccGame;
	import core.art.AssetsManager;
	import core.controllers.TouchController;
	import core.data.GameData;
	import core.data.GameSettings;
	import core.objects.SpawnPoint;
	import core.states.WorldSelectionState;
	import core.states.ingame.PauseWindow;
	import core.states.ingame.VictoryWindow;
	import core.utils.Debug;
	import core.utils.ScreenBlocker;
	import core.utils.ScreenUtils;
	import core.utils.WorldUtils;
	
	import customobjects.Spike;
	
	import org.osflash.signals.Signal;
	
	import remake.AccelerometerHandler;
	import remake.MyNewHero;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class AbstractLevel extends StarlingState
	{
		[Deprecated(message="LevelManager needs this, isn't been used.")]
		public var lvlEnded:Signal;
		[Deprecated(message="LevelManager needs this, isn't been used.")]
		public var restartLevel:Signal;
		protected var _level:XML;
		
		//private var assetsLoaded:Boolean = false;
		//private var viewsLoaded:Boolean = false;
		private var gameData:GameData = GameData.getInstance();
		
		private var victoryWindow:VictoryWindow = new VictoryWindow();
		
		//Setup
		private var touchController:TouchController;
		private var box2d:Box2D;
		private var _camera:StarlingCamera;
		private var accelerometerHandler:AccelerometerHandler;

		//HUD
		private var pauseBtn:Button;
		private var restartBtn:Button;
		private var pauseWindow:PauseWindow;
		
		private var screenBlocker:ScreenBlocker;
		
		/**
		 * AssetManager
		 */
		private var _assets:AssetsManager = AssetsManager.getInstance();
		
		/**
		 * Boolean flag so init() is only called once;
		 */
		private var isInitiated:Boolean = false;
		
		//teste
		private var hero:MyNewHero;
		[Embed(source="../../../assetsNopack/images/robotHero.png")]
		private var HeroPng:Class;
		private var spawnPoint:SpawnPoint;
		
		//Teste.. TODO> tirar daqui
		private var gravityForce:int = 10;
		private var heroBodyTransform:b2Transform;
		
		public function AbstractLevel(level:XML)
		{
			super();
			
			_level = level;
			
			lvlEnded = new Signal();
			restartLevel = new Signal();
			
			// Useful for not forgetting to import object from the Level Editor
			var objectsUsed:Array = [MyNewHero, Platform, Spike];
		}
		
		override public function initialize():void {
			super.initialize();
			
			//Level Setup
			
			//Create Controller
			touchController = new TouchController("touchController");
			_ce.input.addController(touchController);
			
			//Create physics engine
			box2d = new Box2D("box2d");
			box2d.gravity.Set(0,GameSettings.gravityForce);
			box2d.visible = false;
			add(box2d);
			
			//Initialize world with default rotation;
			WorldUtils.setWorldRotation(0);
			
			//Create rotation handler
			accelerometerHandler = new AccelerometerHandler("accelerometerHandler");
			accelerometerHandler.triggerActions=true;
			_ce.input.addController(accelerometerHandler);
			
			//Create screen blocker
			screenBlocker = new ScreenBlocker();
			
			//Load the Tileset
			_assets = AssetsManager.getInstance();
			_assets.enqueue("../assets/levels/world"+gameData.activeWorld+"/TilesetWorld"+gameData.activeWorld+".png"/*.toString()*//*,"TilesetWorld"+gameData.activeWorld/*+"Img"*/);
			_assets.enqueue("../assets/levels/world"+gameData.activeWorld+"/TilesetWorld"+gameData.activeWorld+".xml"/*.toString()*//*,"TilesetWorld"+gameData.activeWorld+"Xml"*/);
		//	_assets.enqueueWithName("../assets/levels/world"+gameData.activeWorld+"/level"+gameData.activeLevelNumber+"/world"+gameData.activeWorld+"level"+gameData.activeLevelNumber+".xml".toString(),"TilesetWorld"+gameData.activeWorld+"Xml");
			_assets.loadQueue(onAssetsManagerLoadProgress);
			
			//Tells me when all views are finished loading
			//view.loadManager.onLoadComplete.addOnce(handleLoadComplete);
			
			// create objects from our level made with Flash Pro
			//ObjectMakerStarling.FromTiledMap(_level,assets.getSelectedWorldAtlas());
			
			//Pause the State until everything is loaded and player touchs the screen to start playing
			//_ce.playing = false;
		}
		
		private function onAssetsManagerLoadProgress(ratio:Number):void
		{
			Debug.log("AssetsManager Loading Progress:",ratio);
			
			// a progress bar should always show the 100% for a while,
			// so we show the main menu only after a short delay. 
			if (ratio == 1)
			{
				Debug.log("Assets/Atlas carregados");
				//var tilesetImg:Texture = _assets.getTexture("TilesetWorld"+gameData.activeWorld/*+"Img"*/);
				//var tilesetXml:XML = _assets.getXml("TilesetWorld"+gameData.activeWorld+"Xml");
				
				//_assets.addTextureAtlas("AtlasWorld"+gameData.activeWorld, new TextureAtlas(tilesetImg, tilesetXml));
				
				//Descobrir pq magica "TilesetWorld"+gamedata.active world ja existe..o assetmanager fez isso sozinho sei la pq
				ObjectMakerStarling.FromTiledMap(_level, _assets.getTextureAtlas("TilesetWorld"+gameData.activeWorld));
				
				//Initiation of the level
				init();
				
				//Starling.juggler.delayCall(remove loading info, 0.15);
			}
		}
		
		/**
		 * Called when the views are done loading.
		 */
		/*private function handleLoadComplete():void
		{
			Debug.log("All views are loaded");
			viewsLoaded = true;
		}*/
		
		/**
		 * Called every frame
		 */
		override public function update(timeDelta:Number):void {
			super.update(timeDelta);
			if(_ce.input.isDoing(AccelerometerHandler.GravityChange))
				Debug.log("I'm doing gravity change------");
			if(_ce.input.justDid(AccelerometerHandler.GravityChange))
			{
				Debug.log("A gravity change just happened!!!!!");
				handleWorldRotation();
				accelerometerHandler.triggerGravityChangeOff();
			}
			//Trace views load progress
			/*var percent:uint = view.loadManager.bytesLoaded / view.loadManager.bytesTotal * 100;
			if (percent < 99)
			{
				//Debug.log("Views Loading Progress:",percent.toString() + "%");
			}*/
			
			/*if(/*viewsLoaded && assetsLoaded && !isInitiated)
			{
				isInitiated = true;
				
				//Remove the loading screen
				Starling.current.nativeOverlay.removeChild(TccGame.loadImage);
				
				//init
			}*/
		}
		
		private function handleWorldRotation():void
		{
			Debug.log("Handling World Rotation!");
			if(_ce.input.isDoing(AccelerometerHandler.GravityDown))
			{
				WorldUtils.setWorldRotation(0);
				box2d.gravity.Set(0, gravityForce);
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityLeft))
			{
				WorldUtils.setWorldRotation(90);
				box2d.gravity.Set(-gravityForce,0);
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityRight))
			{
				WorldUtils.setWorldRotation(270);
				box2d.gravity.Set(gravityForce,0);
			}
			if(_ce.input.isDoing(AccelerometerHandler.GravityUp))
			{
				WorldUtils.setWorldRotation(180);
				box2d.gravity.Set(0, -gravityForce);
			}
			
			if(hero)
			{
				heroBodyTransform = new b2Transform(hero.body.GetPosition(), b2Mat22.FromAngle(WorldUtils.getWorldRotation()));
				hero.body.SetTransform(heroBodyTransform);
				
				hero.recalculateGroundCollisionAngle();
			}
		}
		
		/**
		 * Build the level from Tmx config and TextureAtlas
		 */
		private function init():void
		{
			Debug.log("Ready to play - Init()");
			Debug.log("Touch screen to unpause and start playing");
			
			//Hero's Spawn Point
			spawnPoint = this.getFirstObjectByType(SpawnPoint) as SpawnPoint;
			
			//hero = _ce.state.getObjectByName("Hero");
			var heroBitmap:Bitmap = new HeroPng();
			var heroTexture:Texture = Texture.fromBitmap(heroBitmap);
			var heroImg:Image = new Image(heroTexture);
			heroImg.scaleX = heroImg.scaleY = .5;
			addChild(heroImg);
			hero = new MyNewHero("hero",{view:heroImg,x: spawnPoint.x, y: spawnPoint.y, width: 62, height:64});
			add(hero);
			
			//TODO> FIX CAMERA
			_camera = view.camera as StarlingCamera;
			var width:int = _level.@width * _level.@tilewidth;
			var height:int = _level.@height * _level.@tileheight;
			var cameraBounds:Rectangle = new Rectangle(0,0,width,height);//tamanho do level..
			//var cameraBounds:Rectangle = new Rectangle(0,0,3840,2816);//tamanho do level..
			_camera.setUp(hero,new Point(ScreenUtils.SCREEN_REAL_WIDTH /2,ScreenUtils.SCREEN_REAL_HEIGHT / 2),cameraBounds,new Point(.5,.5));
			_camera.allowZoom = true;
			_camera.baseZoom = _camera.zoomFit(2048, 1536);
			_camera.setZoom(1);
			_camera.reset();
			
			//Remove the loading screen
			Starling.current.nativeOverlay.removeChild(TccGame.loadImage);
			
			createHud();
			
			addScreenBlocker();		
		}
		
		private function addScreenBlocker():void
		{
			_ce.playing = false;
			this.addChild(screenBlocker);
			screenBlocker.addEventListener(TouchEvent.TOUCH, onTouchScreenBlocker);
		}
		
		private function onTouchScreenBlocker(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(screenBlocker, TouchPhase.ENDED);
			
			if(touch)
			{
				removeScreenBlocker();
			}
		}
		
		private function removeScreenBlocker():void
		{
			_ce.playing = true;
			this.removeChild(screenBlocker);
			screenBlocker.removeEventListener(TouchEvent.TOUCH, onTouchScreenBlocker);
		}
		
		private function createHud():void
		{
			pauseBtn = new Button(Texture.fromColor(50,50,0xFFFF0000),"PAUSE");
			pauseBtn.pivotX = pauseBtn.width * .5;
			pauseBtn.pivotY = pauseBtn.height * .5;
			pauseBtn.x = ScreenUtils.SCREEN_REAL_WIDTH - pauseBtn.width * 1.5 - 500;
			pauseBtn.y = pauseBtn.height * 1.5;
			pauseBtn.touchable = true;
			addChild(pauseBtn);
			pauseBtn.addEventListener(Event.TRIGGERED, onTouchPause);
			
			restartBtn = new Button(Texture.fromColor(50,50,0xFF0000FF),"RESTART");
			restartBtn.pivotX = pauseBtn.width * .5;
			restartBtn.pivotY = pauseBtn.height * .5;
			restartBtn.x = pauseBtn.width * 1.5;
			restartBtn.y = pauseBtn.height * 1.5;
			restartBtn.touchable = true;
			addChild(restartBtn);
			restartBtn.addEventListener(Event.TRIGGERED, onTouchRestart);
			
			//TODO> Janela de pause é recriada todo level..poderia ficar salva em algum lugar
			pauseWindow = new PauseWindow();
		}
		
		private function onTouchRestart(event:Event):void
		{
			Debug.log("Touched restart!");
			//this.removeChild(pauseWindow);
			restart();
		}
		
		private function onTouchPause(event:Event):void
		{
			this.addChild(pauseWindow);
			pauseWindow.onResume.addOnce(resume);
			pauseWindow.onMuteMusic.addOnce(muteMusic);
			pauseWindow.onMuteFx.addOnce(muteFx);
			pauseWindow.onRestart.addOnce(restart);
			pauseWindow.onQuit.addOnce(quit);
			_ce.playing = false;
		}
		
		private function resume():void
		{
			this.removeChild(pauseWindow);
			_ce.playing = true;
		}
		
		private function muteMusic():void
		{
			//TODO> Mute/Unmute MUSIC
			Debug.log("Music muted/unmuted!");
		}
		
		private function muteFx():void
		{
			//TODO> Mute/Unmute Fx
			Debug.log("FX muted/unmuted!");
		}
		
		private function restart():void
		{
			//TODO> restart the whole level..if level doesn't have any destroyable objects or moving ones. just set the hero back to original position
			//Otherwise build the whole level again using ObjectMaker..or even reload the whole state using _ce.state = this
			//also block screen
			Debug.log("Restarting the level");
			
			//TODO> Send Hero to initial position
			//Need to work around to instantly set the hero position..its only been set once playing is true..
			hero.x = spawnPoint.x;
			hero.y = spawnPoint.y;
			//Send objects to initial position, rebuild them it breakable
			
			if(this.contains(pauseWindow))
				this.removeChild(pauseWindow);
			
			addScreenBlocker();
		}
		
		private function quit():void
		{
			//TODO> Voltar para selecao de fases // dar um jeito de resolver isso aqui..nao da pra importar worldselection state aqui dentro
			Debug.log("Quiting level. Going back to level selection screen");
			_ce.state = new WorldSelectionState();
		}
		
		/**
		 * Destroys all elements from a level. MAKE SURE IT DOES!
		 */
		override public function destroy():void
		{
			super.destroy();

			this.removeChild(pauseBtn);
			pauseBtn.removeEventListener(Event.TRIGGERED, onTouchPause);
			
			this.removeChild(restartBtn);
			restartBtn.removeEventListener(Event.TRIGGERED, onTouchRestart);
			
			if(this.contains(pauseWindow))
				this.removeChild(pauseWindow);
			pauseWindow = null;
			
			if(this.contains(screenBlocker))
				this.removeChild(screenBlocker);
			screenBlocker = null;
			
			/*lvlEnded.removeAll();
			lvlEnded = null;
			restartLevel.removeAll();//signal
			restartLevel = null;*/
			_level = null;
			gameData = null;
			victoryWindow.dispose();
			victoryWindow = null;
			touchController = null;
			box2d = null;
			_camera = null;
			accelerometerHandler = null;
			_assets = null;
			//assetsLoaded = false;
			isInitiated = false;
			_ce.playing = true;
		}
	}
}