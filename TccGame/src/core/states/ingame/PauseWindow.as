package core.states.ingame
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import core.buttons.FxButton;
	import core.buttons.MusicButton;
	import core.utils.Languages;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public final class PauseWindow extends Sprite
	{
		private var _background:Image;
		private var _resumeBtn:Button;
		private var _musicBtn:MusicButton;
		private var _fxBtn:FxButton;
		private var _restartBtn:Button;
		private var _quitBtn:Button;
		
		public var onResume:Signal;
		public var onMuteMusic:Signal;
		public var onMuteFx:Signal;
		public var onRestart:Signal;
		public var onQuit:Signal;
		
		private var helperPoint:Point = new Point();
		
		public function PauseWindow()
		{
			super();
			
			_background = new Image(Texture.fromColor(1024,768,0xFF7F7F7F));
			this.addChild(_background);
			
			_resumeBtn = new Button(Texture.fromColor(50,50,0xFFFF0000),"RESUME");
			_resumeBtn.pivotX = _resumeBtn.width * .5;
			_resumeBtn.pivotY = _resumeBtn.height * .5;
			_resumeBtn.x = _background.x + _background.width * .5;
			_resumeBtn.y = _background.y + _background.height * .1;
			this.addChild(_resumeBtn);
			//_resumeBtn.addEventListener(Event.TRIGGERED, onTouchResume);
			
			_musicBtn = new MusicButton();
			_musicBtn.pivotX = _musicBtn.width * .5;
			_musicBtn.pivotY = _musicBtn.height * .5;
			_musicBtn.x = _background.x + _background.width * .5;
			_musicBtn.y = _background.y + _background.height * .3;
			this.addChild(_musicBtn);
			//_musicBtn.addEventListener(Event.TRIGGERED, onTouchMusic);
			
			_fxBtn = new FxButton();
			_fxBtn.pivotX = _fxBtn.width * .5;
			_fxBtn.pivotY = _fxBtn.height * .5;
			_fxBtn.x = _background.x + _background.width * .5;
			_fxBtn.y = _background.y + _background.height * .5;
			this.addChild(_fxBtn);
			//_fxBtn.addEventListener(Event.TRIGGERED, onTouchFx);
			
			_restartBtn = new Button(Texture.fromColor(50,50,0xFFFF0000),"RESTART");
			_restartBtn.pivotX = _restartBtn.width * .5;
			_restartBtn.pivotY = _restartBtn.height * .5;
			_restartBtn.x = _background.x + _background.width * .5;
			_restartBtn.y = _background.y + _background.height * .7;
			this.addChild(_restartBtn);
			//_restartBtn.addEventListener(Event.TRIGGERED, onTouchRestart);
			
			_quitBtn = new Button(Texture.fromColor(50,50,0xFFFF0000),"QUIT");
			_quitBtn.pivotX = _quitBtn.width * .5;
			_quitBtn.pivotY = _quitBtn.height * .5;
			_quitBtn.x =_background.x + _background.width * .5;
			_quitBtn.y = _background.y + _background.height * .9;
			this.addChild(_quitBtn);
			//_quitBtn.addEventListener(Event.TRIGGERED, onTouchQuit);
			
			onResume = new Signal();
			onMuteMusic = new Signal();
			onMuteFx = new Signal();
			onRestart = new Signal();
			onQuit = new Signal();
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				helperPoint.x = touch.globalX;
				helperPoint.y = touch.globalY;
				var hitObject:DisplayObject = this.stage.hitTest(helperPoint, true);
				
				//Touched Resume Button
				if(_resumeBtn.contains(hitObject))
					onResume.dispatch();
				
				//Touched Music Button
				if(_musicBtn.contains(hitObject))
					onMuteMusic.dispatch();
				
				//Touched FX Button
				if(_fxBtn.contains(hitObject))
					onMuteFx.dispatch();
				
				//Touched Restart Button
				if(_restartBtn.contains(hitObject))
					onRestart.dispatch();
				
				//Touched Quit Button
				if(_quitBtn.contains(hitObject))
					onQuit.dispatch();
			}
			
			//Fist try
			/*if(touch)
			{
				//Touched Resume Button
				if(touch.isTouching(_resumeBtn))
					onResume.dispatch();
				
				//Touched Music Button
				if(touch.isTouching(_musicBtn))
					onMuteMusic.dispatch();
				
				//Touched FX Button
				if(touch.isTouching(_fxBtn))
					onMuteFx.dispatch();
				
				//Touched Restart Button
				if(touch.isTouching(_restartBtn))
					onRestart.dispatch();
				
				//Touched Quit Button
				if(touch.isTouching(_quitBtn))
					onQuit.dispatch();
			}*/
		}
	}
}