package core.states.ingame
{
	import core.buttons.FxButton;
	import core.buttons.MusicButton;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public final class PauseWindow extends Sprite
	{
		private var _background:Image;
		private var _resumeBtn:Button;
		private var _musicBtn:MusicButton;
		private var _fxBtn:FxButton;
		private var _restartBtn:Button;
		private var _quitBtn:Button;
		
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
			
			_musicBtn = new MusicButton();
			_musicBtn.pivotX = _musicBtn.width * .5;
			_musicBtn.pivotY = _musicBtn.height * .5;
			_musicBtn.x = _background.x + _background.width * .5;
			_musicBtn.y = _background.y + _background.height * .3;
			this.addChild(_musicBtn);
			
			_fxBtn = new FxButton();
			_fxBtn.pivotX = _fxBtn.width * .5;
			_fxBtn.pivotY = _fxBtn.height * .5;
			_fxBtn.x = _background.x + _background.width * .5;
			_fxBtn.y = _background.y + _background.height * .5;
			this.addChild(_fxBtn);
			
			_restartBtn = new Button(Texture.fromColor(50,50,0xFFFF0000),"RESTART");
			_restartBtn.pivotX = _restartBtn.width * .5;
			_restartBtn.pivotY = _restartBtn.height * .5;
			_restartBtn.x = _background.x + _background.width * .5;
			_restartBtn.y = _background.y + _background.height * .7;
			this.addChild(_restartBtn);
			
			_quitBtn = new Button(Texture.fromColor(50,50,0xFFFF0000),"QUIT");
			_quitBtn.pivotX = _quitBtn.width * .5;
			_quitBtn.pivotY = _quitBtn.height * .5;
			_quitBtn.x =_background.x + _background.width * .5;
			_quitBtn.y = _background.y + _background.height * .9;
			this.addChild(_quitBtn);
			
		}
	}
}