package core.levels
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
	import core.states.ingame.VictoryWindow;
	import core.utils.Debug;
	import core.utils.ScreenUtils;
	import core.utils.WorldUtils;
	
	import customobjects.Spike;
	
	import org.osflash.signals.Signal;
	
	import remake.AccelerometerHandler;
	import remake.MyNewHero;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class AbstractLevel extends StarlingState
	{
		public var lvlEnded:Signal;
		public var restartLevel:Signal;
		protected var _level:XML;
		
		
		private var assetsLoaded:Boolean = false;
		//private var viewsLoaded:Boolean = false;
		private var gameData:GameData = GameData.getInstance();
		
		private var victoryWindow:VictoryWindow = new VictoryWindow();
		
		//Setup
		private var touchController:TouchController;
		private var box2d:Box2D;
		private var _camera:StarlingCamera;
		private var accelerometerHandler:AccelerometerHandler;
		
		
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
		
		public function AbstractLevel(level:XML = null)
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
			
			
			//TODO> FIX CAMERA
			_camera = view.camera as StarlingCamera;
			var cameraBounds:Rectangle = new Rectangle(0,0,3840,2816);//tamanho do level..
			_camera.setUp(hero,new Point(ScreenUtils.SCREEN_REAL_WIDTH / 2, ScreenUtils.SCREEN_REAL_HEIGHT / 2),cameraBounds,new Point(.5,.5));
			_camera.allowZoom = true;
			_camera.baseZoom = _camera.zoomFit(2048, 1536);
			_camera.setZoom(1);
			_camera.reset();
			
			
			//Create rotation handler
			accelerometerHandler = new AccelerometerHandler("accelerometerHandler",{});
			accelerometerHandler.triggerActions=true;
			_ce.input.addController(accelerometerHandler);
			
			
			
			/**
			 * teste
			 */
			
			//ObjectMakerStarling.FromTiledMap(AssetsManagerLixo.getLevel1Map32(),AssetsManagerLixo.getLevel1Atlas32());
			//ObjectMakerStarling.FromTiledMap(AssetsManagerLixo.getLevel1Map64(),AssetsManagerLixo.getLevel1Atlas64());
			
			var heroBitmap:Bitmap = new HeroPng();
			var heroTexture:Texture = Texture.fromBitmap(heroBitmap);
			var heroImg:Image = new Image(heroTexture);
			heroImg.scaleX = heroImg.scaleY = .5;
			addChild(heroImg);
			hero = new MyNewHero("hero",{view:heroImg,x: 384*2, y: 320*2, width: 62, height:64});
			add(hero);
			
			/**
			 * fim teste
			 */
			//Load the Tileset
			_assets= AssetsManager.getInstance();
			_assets.enqueueWithName("../assets/levels/world"+gameData.activeWorld+"/TilesetWorld"+gameData.activeWorld+".png".toString(),"TilesetWorld"+gameData.activeWorld+"Img");
			_assets.enqueueWithName("../assets/levels/world"+gameData.activeWorld+"/level"+gameData.activeLevelNumber+"/world"+gameData.activeWorld+"level"+gameData.activeLevelNumber+".xml".toString(),"TilesetWorld"+gameData.activeWorld+"Xml");
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
				var tilesetImg:Texture = _assets.getTexture("TilesetWorld"+gameData.activeWorld+"Img");
				var tilesetXml:XML = _assets.getXml("TilesetWorld"+gameData.activeWorld+"Xml");
				
				//TODO> TA BUGADO > CAIO > tilesetImg e tilesetXml sao nulos
				
				_assets.addTextureAtlas("AtlasWorld"+gameData.activeWorld, new TextureAtlas(tilesetImg, tilesetXml));
				
				assetsLoaded = true;
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
			
			//Trace views load progress
			/*var percent:uint = view.loadManager.bytesLoaded / view.loadManager.bytesTotal * 100;
			if (percent < 99)
			{
				//Debug.log("Views Loading Progress:",percent.toString() + "%");
			}*/
			
			if(/*viewsLoaded &&*/ assetsLoaded && !isInitiated)
			{
				isInitiated = true;
				
				//Remove the loading screen
				Starling.current.nativeOverlay.removeChild(TccGame.loadImage);
				
				//Initiation of the level
				init();
			}
		}
		
		/**
		 * Build the level from Tmx config and TextureAtlas
		 */
		private function init():void
		{
			ObjectMakerStarling.FromTiledMap(_level, _assets.getTextureAtlas("AtlasWorld"+gameData.activeWorld));
			Debug.log("Ready to play - Init()");
			Debug.log("Touch screen to unpause and start playing");
		}
		
		override public function destroy():void
		{
			super.destroy();

			lvlEnded.removeAll();
			lvlEnded = null;
			restartLevel.removeAll();
			restartLevel = null;
			_level = null;
			gameData = null;
			victoryWindow.dispose();
			victoryWindow = null;
			touchController = null;
			box2d = null;
			_camera = null;
			accelerometerHandler = null;
			_assets = null;
		}
	}
}