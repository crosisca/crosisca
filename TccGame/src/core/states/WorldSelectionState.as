package core.states
{
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	
	import core.TccGame;
	import core.data.GameData;
	import core.states.worldselection.WorldSelectionWindow;
	
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	
	public final class WorldSelectionState extends StarlingState
	{
		private var worldSelectionWindow:WorldSelectionWindow;
		public var onLevelSelected:Signal = new Signal();
		
		public function WorldSelectionState()
		{
			super();
			worldSelectionWindow = new WorldSelectionWindow();
			worldSelectionWindow.onLevelSelected.addOnce(onLevelChosen);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var mainSprite:CitrusSprite = new CitrusSprite("WorldSelectionWindow", { x:0, y:0 , view: worldSelectionWindow, touchable:true } );
			add(mainSprite);
			
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
	}
}