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
	import citrus.view.starlingview.StarlingCamera;
	
	import core.art.AssetsManager;
	import core.levels.Level5;
	import core.states.start.StartWindow;
	import core.utils.ScreenUtils;
	
	import org.osflash.signals.Signal;
	
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
		private var worldSelectionContainer:Sprite = new Sprite();
		private var levelSelectionContainer:Sprite = new Sprite();
		private var currentlySelectedWorld:String = "0";
		private var levelButtonsVector:Vector.<Button> = new Vector.<Button>;
		private var btExitLevelSelector:Button;
		
		private var _camera:StarlingCamera;
		
		private var _startWindow:StartWindow;
		public var onStateChange:Signal = new Signal();
		
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
		}
		
		private function onPlayPressed():void
		{
			_ce.state = new WorldSelectionState();
			//DELETAR TODO CAIO TESTE
			//_ce.state = new Level5();
			
		}
		
		/**
		 * 
		 * 
		 * DAQUI PRA BAIXO NAO TEM NADA SENDO UTILIZADO
		 * 
		 * 
		 */

		private function onLoadProgress(ratio:Number):void
		{
			trace("Loading Progress:",ratio);
			
			// a progress bar should always show the 100% for a while,
			// so we show the main menu only after a short delay. 
			if (ratio == 1)
			{
				Starling.juggler.delayCall(init, 0.15);
			}
		}
		
		private function init():void
		{
			//Remove Load Image
			Starling.current.nativeOverlay.removeChild(Starling.current.nativeOverlay.getChildByName("loadImage"));
			
			//Create assets for menu
			backgroundImg = new Image(AssetsManager.getInstance().getTexture("MenuWorldBg"));
			backgroundImg.width = ScreenUtils.SCREEN_REAL_WIDTH;
			backgroundImg.height = ScreenUtils.SCREEN_REAL_HEIGHT;
			addChild(backgroundImg);
			
			var offset:int = backgroundImg.width*.1;
			
			var worldButton:Button;
			for (var k:int = 0; k < 5; k++) 
			{
				worldButton = new Button(AssetsManager.getInstance().getTexture("World"+(k+1)));
				worldButton.name = "world"+(k+1);
				worldButton.scaleX = worldButton.scaleY = 2;
				worldButton.y = (ScreenUtils.SCREEN_REAL_HEIGHT - worldButton.height) / 2 ;
				worldButton.x = ( ( ScreenUtils.SCREEN_REAL_WIDTH - ( worldButton.width*5 ) ) / 6) * ( k + 1 ) + ( worldButton.width * k );
				worldSelectionContainer.addChild(worldButton);
				worldButton.addEventListener(starling.events.Event.TRIGGERED, handleWorldSelection);
			}
			addChild(worldSelectionContainer);
			
			
			//Prepara container de load dos levels
			var fundoLevelSelectionContainer:Image = new Image(Texture.fromColor(1024,768,0xFF0000FF));
			levelSelectionContainer.addChild(fundoLevelSelectionContainer);
			levelSelectionContainer.x = (ScreenUtils.SCREEN_REAL_WIDTH - levelSelectionContainer.width)/2;
			levelSelectionContainer.y = (ScreenUtils.SCREEN_REAL_HEIGHT - levelSelectionContainer.height)/2;
			
			btExitLevelSelector = new Button(Texture.fromColor(50,50,0xFFFF0000),"X");
			btExitLevelSelector.addEventListener(starling.events.Event.TRIGGERED, onCloseLevelSelector);
			btExitLevelSelector.x = levelSelectionContainer.width - ( btExitLevelSelector.width * 1.5 );
			btExitLevelSelector.y = btExitLevelSelector.height * 1.5;
			levelSelectionContainer.addChild(btExitLevelSelector);
			
			//Cria todos os botoes dos levels
			var levelNumber:int = 0;
			for (var i:int = 0; i < 5; i++) 
			{
				for (var j:int = 0; j < 4; j++) 
				{
					levelNumber++;
					var levelButton:Button = new Button(Texture.fromColor(64,64,0xFFFF00FF),levelNumber.toString());
					levelButton.x = ( ( levelSelectionContainer.width - ( levelButton.width*5 ) ) / 6) * ( i + 1 ) + ( levelButton.width * i );
					levelButton.y = ( ( levelSelectionContainer.height - ( levelButton.height*4 ) ) / 5) * ( j + 1 ) + ( levelButton.height * j );
					levelSelectionContainer.addChild(levelButton);
					levelButton.addEventListener(starling.events.Event.TRIGGERED, onLevelSelected);
					levelButtonsVector.push(levelButton);
				}
			}
		}
		
		private function onCloseLevelSelector(event:starling.events.Event):void
		{
			this.removeChild(levelSelectionContainer);
			this.addChild(worldSelectionContainer);
		}
		
		private function handleWorldSelection(event:starling.events.Event):void
		{
			//Substring "worldButton" from the button name
			var worldName:String = Button(event.currentTarget).name;
			//var worldChosen:String = worldName.substring(11);
			//trace("World chosen:",worldChosen);
			trace("World chosen:",worldName);
			//gotoLevelSelection(parseInt(worldChosen));
			gotoLevelSelection(worldName);
		}
		
		private function gotoLevelSelection(worldNumber:String):void
		{
			currentlySelectedWorld = worldNumber;
			this.removeChild(worldSelectionContainer);
			this.addChild(levelSelectionContainer);
		}
		
		private function onLevelSelected(event:starling.events.Event):void
		{
			var selectedLevelNumber:int;
			for (var i:int = 0; i < levelButtonsVector.length; i++) 
			{
				if(event.currentTarget == levelButtonsVector[i])
				{
					selectedLevelNumber = i+1;
				}
			}
			var selectedLevel:String = currentlySelectedWorld+"/level"+selectedLevelNumber;
			trace("Selected Level:",selectedLevel);
			
			//load currently selected level atlas
			//AssetsManager.getAtlas(selectedLevel);
			//init new level state
			
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain,null);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, handleLoadComplete);
			var levelUrl:String = "../assets/levels/"+selectedLevel+"/level.swf";
			trace("URL Do Level:",levelUrl);
			loader.load(new URLRequest(levelUrl),loaderContext);
		}
		
		//Start the a game state
		private function handleLoadComplete(event:flash.events.Event):void
		{
			var levelSwf:MovieClip = event.target.loader.content as MovieClip;
			//state = new GameState(levelSwf,debugSpriteRectangle);
			//state = new ThresholdTestState(levelSwf);//FLUID LEVEL
			//state = new NewGameControlsState(debugSpriteRectangle,levelSwf);
			_ce.state = new NewGameControlsState(null,levelSwf);
		}
		
		override public function destroy():void
		{
			super.destroy();
			backgroundImg = null;
			worldSelectionContainer = null;
			levelSelectionContainer = null;
			currentlySelectedWorld = null;
			levelButtonsVector = null;
			btExitLevelSelector = null;
		}
	}
}

















