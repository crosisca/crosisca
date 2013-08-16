package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import citrus.core.starling.StarlingCitrusEngine;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60")]
	public class TccGame extends StarlingCitrusEngine
	{
		/**
		 * Used to display the minimap of a level, for debug purposes.*/
		public var debugSpriteRectangle:Sprite = new Sprite();

		public function TccGame()
		{
			//Set stage properties
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			stage.quality = StageQuality.LOW;
			stage.showDefaultContextMenu = true;
			
			//Minimap
			addChild(debugSpriteRectangle);
			
			//Setup Starling
			Starling.multitouchEnabled = true;
			setUpStarling(true);
			
			//loadeLevel1();
		}
		
		private function loadeLevel1():void
		{
			//Load Level1.swf to build the level
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain,null);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.load(new URLRequest("Level1.swf"),loaderContext);
		}
		
		//Start the a game state
		protected function handleLoadComplete(event:Event):void
		{
			var levelSwf:MovieClip = event.target.loader.content as MovieClip;
			//state = new GameState(levelSwf,debugSpriteRectangle);
			//state = new ThresholdTestState(levelSwf);//FLUID LEVEL
			state = new NewGameControlsState(debugSpriteRectangle,levelSwf);
		}
	}
}