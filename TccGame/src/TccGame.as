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
	
	[SWF(frameRate="60")]
	public class TccGame extends StarlingCitrusEngine
	{
		public var debugSpriteRectangle:Sprite = new Sprite();

		public function TccGame()
		{
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			stage.quality = StageQuality.LOW;
			/*stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;*/
			stage.showDefaultContextMenu = true;
			
			//Minimap
			addChild(debugSpriteRectangle);
			
			setUpStarling(true);
			
			/*var fps:Stats = new Stats();
			addChild(fps);*/
			
			//state = new GameState();
			
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain,null);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.load(new URLRequest("Level2.swf"),loaderContext);
		}
		protected function handleLoadComplete(event:Event):void
		{
			var levelSwf:MovieClip = event.target.loader.content as MovieClip;
			state = new GameState(levelSwf,debugSpriteRectangle);
		}
	}
}