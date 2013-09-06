package core.states.ingame
{
	import core.buttons.LanguageButton;
	import core.utils.Languages;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public final class VictoryWindow extends Sprite
	{
		private var _background:Image;
		private var _nextLvlBtn:Button;
		private var _restartBtn:Button;
		private var _quitBtn:Button;
		private var _secretItem:SecretItemImage;
		private var _levelTime:TextField;
		
		public function VictoryWindow()
		{
			super();
			
			_background = new Image(Texture.fromColor(1024,768,0xFF7F7F7F));
			this.addChild(_background);
			
			_nextLvlBtn = new Button(Texture.fromColor(50,50,0xFFFF0000),"NEXT LEVEL");
			_nextLvlBtn.pivotX = _nextLvlBtn.width * .5;
			_nextLvlBtn.pivotY = _nextLvlBtn.height * .5;
			_nextLvlBtn.x = _background.x + _background.width * .5;
			_nextLvlBtn.y = _background.y + _background.height * .1;
			this.addChild(_nextLvlBtn);
			
			_secretItem =  new SecretItemImage();
			_secretItem.pivotX = _secretItem.width * .5;
			_secretItem.pivotY = _secretItem.height * .5;
			_secretItem.x = _background.x + _background.width * .5;
			_secretItem.y = _background.y + _background.height * .3;
			this.addChild(_secretItem);
			
			_levelTime = new TextField(200,50, "10:00","Verdana",40,0x0,true);
			_levelTime.pivotX = _levelTime.width * .5;
			_levelTime.pivotY = _levelTime.height * .5;
			_levelTime.x = _background.x + _background.width * .5;
			_levelTime.y = _background.y + _background.height * .5;
			this.addChild(_levelTime);
			
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