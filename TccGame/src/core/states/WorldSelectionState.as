package core.states
{
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	
	import core.levels.AbstractLevel;
	import core.states.worldselection.WorldSelectionWindow;
	
	public final class WorldSelectionState extends StarlingState
	{
		private var worldSelectionWindow:WorldSelectionWindow;
		
		public function WorldSelectionState()
		{
			super();
			worldSelectionWindow = new WorldSelectionWindow();
			worldSelectionWindow.testSignal.addOnce(playLevelTest);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var mainSprite:CitrusSprite = new CitrusSprite("WorldSelectionWindow", { x:0, y:0 , view: worldSelectionWindow, touchable:true } );
			add(mainSprite);
			
		}
		
		private function playLevelTest(level:AbstractLevel):void
		{
			_ce.state = level;
		}
		
		
	}
}