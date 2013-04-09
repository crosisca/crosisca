package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.net.URLRequest;
	
	import citrus.core.CitrusEngine;
	
	public class TccGame extends CitrusEngine
	{
		public function TccGame()
		{
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			stage.quality = StageQuality.LOW;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.showDefaultContextMenu = true;
			
			//state = new GameState();
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.load(new URLRequest("Level1.swf"));
			
			
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, onOrientationChange); 
			
		}
		
		
		private function onOrientationChange(event:StageOrientationEvent):void 
		{ 
			event.preventDefault();
			//event.stopImmediatePropagation();
		}
		
		protected function handleLoadComplete(event:Event):void
		{
			var levelSwf:MovieClip = event.target.loader.content as MovieClip;
			state = new GameState(levelSwf);
		}
	}
}