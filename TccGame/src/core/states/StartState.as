package core.states
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.sounds.CitrusSoundGroup;
	import citrus.view.starlingview.StarlingCamera;
	
	import core.TccGame;
	import core.art.AssetsManager;
	import core.controllers.TouchController;
	import core.levels.Level5;
	import core.states.start.StartWindow;
	import core.utils.ScreenUtils;
	
	import org.osflash.signals.Signal;
	
	import remake.AccelerometerHandler;
	import remake.NewGameControlsState;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public final class StartState extends StarlingState
	{
		private var backgroundImg:Image;
		
		private var _camera:StarlingCamera;
		
		private var _startWindow:StartWindow;
		public var onStateChange:Signal = new Signal();
		
		private var touchController:TouchController;
		private var accelerometerHandler:AccelerometerHandler;
		
		public function StartState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			_startWindow = new StartWindow();
			_startWindow.onPlay.addOnce(onPlayPressed);
			var mainSprite:CitrusSprite = new CitrusSprite("StartWindow", { x:0, y:0 , view:_startWindow, touchable:true } );
			add(mainSprite);
			
			_camera = view.camera.setUp(null,null,new Rectangle(0,0,2048,1536)) as StarlingCamera;//new Point(ScreenUtils.SCREEN_REAL_WIDTH/2, ScreenUtils.SCREEN_REAL_HEIGHT/2)) as StarlingCamera;
			_camera.allowZoom = true;
			_camera.zoomFit(2048, 1536);
			
			Starling.current.nativeOverlay.removeChild(Starling.current.nativeOverlay.getChildByName("loadImage"));

			//var assets:AssetsManager = AssetsManager.getInstance();
			//assets.loadQueue(onLoadProgress);
			
			
			//Prepare Game Stuff used later
			
			//Create Controller
			touchController = new TouchController("touchController");
			_ce.input.addController(touchController);
			
			//Create rotation handler
			accelerometerHandler = new AccelerometerHandler("accelerometerHandler");
			accelerometerHandler.triggerActions=true;
			_ce.input.addController(accelerometerHandler);
			
			
			//Iniciar soms principais
			_ce.sound.addSound("World1Music", { sound:"../../../assets/audio/World1Music.mp3", timesToPlay:-1, group:CitrusSoundGroup.BGM } );
			_ce.sound.addSound("World2Music", { sound:"../../../assets/audio/World2Music.mp3", timesToPlay:-1, group:CitrusSoundGroup.BGM } );
			_ce.sound.addSound("MenuMusic", { sound:"../../../assets/audio/MenuMusic.mp3", timesToPlay:-1, group:CitrusSoundGroup.BGM } );
			
			_ce.sound.playSound("MenuMusic");
		}
		
		private function onPlayPressed():void
		{
			Starling.current.nativeOverlay.addChild(TccGame.loadImage);
			_ce.state = new WorldSelectionState();
		}
		
		override public function destroy():void
		{
			super.destroy();
			backgroundImg = null;
		}
	}
}

















