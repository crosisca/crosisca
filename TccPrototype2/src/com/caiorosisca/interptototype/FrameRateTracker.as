package com.caiorosisca.interptototype
{
	
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class FrameRateTracker extends Sprite
	{
		
		// vars
		private var time:int;
		private var prevTime:int = 0;
		private var fps:int;
		private var fps_txt:TextField;
		
		// constructor
		public function FrameRateTracker()
		{
			
			//
			fps_txt = new TextField();
			addChild(fps_txt);
			
			//
			addEventListener(Event.ENTER_FRAME, getFps);
			
		}
		
		// methods
		private function getFps(e:Event):void
		{
			
			//
			time = getTimer();
			fps = 1000 / (time - prevTime);
			
			//
			fps_txt.text = "fps: " + fps;
			
			//
			prevTime = getTimer();
			
			
			
		}
		
		
		
	} // end class
	
}