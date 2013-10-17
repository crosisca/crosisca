package core.states
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.view.starlingview.StarlingCamera;
	
	import core.TccGame;
	import core.art.AssetsManager;
	import core.data.GameData;
	import core.states.worldselection.WorldSelectionWindow;
	import core.utils.Debug;
	
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	
	public final class WorldSelectionState extends StarlingState
	{
		private var worldSelectionWindow:WorldSelectionWindow;
		public var onLevelSelected:Signal = new Signal();
		private var _assets:AssetsManager;
		private var _camera:StarlingCamera;
		
		public function WorldSelectionState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_assets = AssetsManager.getInstance();
			_assets.enqueue("../assets/menu/MenuAtlas.png");
			_assets.enqueue("../assets/menu/MenuAtlas.xml");
			_assets.loadQueue(onAssetsManagerLoadProgress);
			
			if(Starling.current.nativeOverlay.contains(TccGame.loadImage))
				Starling.current.nativeOverlay.removeChild(TccGame.loadImage);
			
			_camera = view.camera.setUp(null,null,new Rectangle(0,0,1024,768),null/*,new Point(1024,768)*/) as StarlingCamera;
			_camera.allowZoom = true;
			_camera.zoomFit(1024, 768);
		}
		
		private function onAssetsManagerLoadProgress(ratio:Number):void
		{
			Debug.log("Menu assets loading progress:",ratio);
			
			// a progress bar should always show the 100% for a while,
			// so we show the main menu only after a short delay. 
			if (ratio == 1)
			{
				Debug.log("Menu Atlas loaded");
				
				worldSelectionWindow = new WorldSelectionWindow();
				worldSelectionWindow.onLevelSelected.addOnce(onLevelChosen);
				
				var mainSprite:CitrusSprite = new CitrusSprite("WorldSelectionWindow", { x:0, y:0 , view: worldSelectionWindow, touchable:true } );
				add(mainSprite);
				
			}
		}
		
		private function onLevelChosen(worldNumber:int,levelNumber:int):void
		{
			//Go to the level
			//_ce.levelManager.gotoLevel(level.lvlIndex);
			//TODO> level errado
			var lvlIndex:int = ((worldNumber-1) * GameData.getInstance().LevelsQuantityByWorld) +levelNumber;
			_ce.levelManager.gotoLevel(lvlIndex); 
			//onLevelSelected.dispatch(level);
			
			//Adds loading screen
			Starling.current.nativeOverlay.addChild(TccGame.loadImage);
		}
		
		override public function destroy():void
		{
			//TODO > Tirar itens usados no jogo do atlas do menu e sumir com ele aqui
			
			//_assets.removeTextureAtlas("MenuAtlas");
			super.destroy();
		}
	}
}