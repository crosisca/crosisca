package core.states.start
{
	
	import core.buttons.FxButton;
	import core.buttons.LanguageButton;
	import core.buttons.MusicButton;
	import core.utils.Debug;
	import core.utils.Languages;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public final class SettingsWindow extends Sprite
	{
		private var _background:Image;
		private var _closeBtn:Button;
		private var _musicBtn:MusicButton;
		private var _fxBtn:FxButton;
		private var _resetDataBtn:Button;
		private var _portugueseButton:LanguageButton;
		private var _englishButton:LanguageButton;
		private var _creditsButton:Button;
		
		public var onClose:Signal = new Signal(); 
		
		////TESTES DELETAR TODO>
		
		private var musicMuted:Boolean;
		private var fxMuted:Boolean;

		public function SettingsWindow()
		{
			super();
			
			_background = new Image(Texture.fromColor(1024,768,0xFF7F7F7F));
			this.addChild(_background);
			
			_closeBtn = new Button(Texture.fromColor(50,50,0xFFFF0000),"X");
			_closeBtn.pivotX = _closeBtn.width * .5;
			_closeBtn.pivotY = _closeBtn.height * .5;
			_closeBtn.x = (_background.x + _background.width) - _closeBtn.width * 1.5;
			_closeBtn.y = _background.y + _background.height * .1;
			this.addChild(_closeBtn);
			
			_musicBtn = new MusicButton();
			_musicBtn.pivotX = _musicBtn.width * .5;
			_musicBtn.pivotY = _musicBtn.height * .5;
			_musicBtn.x = _background.x + _background.width * .5;
			_musicBtn.y = _background.y + _background.height * .1;
			this.addChild(_musicBtn);
			
			_fxBtn = new FxButton();
			_fxBtn.pivotX = _fxBtn.width * .5;
			_fxBtn.pivotY = _fxBtn.height * .5;
			_fxBtn.x = _background.x + _background.width * .5;
			_fxBtn.y = _background.y + _background.height * .2;
			this.addChild(_fxBtn);
			
			_resetDataBtn = new Button(Texture.fromColor(50,50,0xFFFF0000),"RESET DATA");
			_resetDataBtn.pivotX = _resetDataBtn.width * .5;
			_resetDataBtn.pivotY = _resetDataBtn.height * .5;
			_resetDataBtn.x = _background.x + _background.width * .5;
			_resetDataBtn.y = _background.y + _background.height * .3;
			this.addChild(_resetDataBtn);
			
			_englishButton = new LanguageButton(Languages.ENGLISH);
			_englishButton.pivotX = _englishButton.width * .5;
			_englishButton.pivotY = _englishButton.height * .5;
			_englishButton.x = _background.x + _background.width * .5;
			_englishButton.y = _background.y + _background.height * .4;
			this.addChild(_englishButton);
			
			_portugueseButton = new LanguageButton(Languages.PORTUGUESE);
			_portugueseButton.pivotX = _portugueseButton.width * .5;
			_portugueseButton.pivotY = _portugueseButton.height * .5;
			_portugueseButton.x = _background.x + _background.width * .5 + (_englishButton.width * 2);
			_portugueseButton.y = _background.y + _background.height * .4;
			this.addChild(_portugueseButton);
			
			_creditsButton = new Button(Texture.fromColor(50,50,0xFFFF0000),"CREDITS");
			_creditsButton.pivotX = _creditsButton.width * .5;
			_creditsButton.pivotY = _creditsButton.height * .5;
			_creditsButton.x = _background.x + _background.width * .5;
			_creditsButton.y = _background.y + _background.height * .5;
			this.addChild(_creditsButton);
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				//Touched Close Button
				if(touch.isTouching(_closeBtn))
				{
					onClosePressed();
				}
				
				//Touched Music Button
				if(touch.isTouching(_musicBtn))
				{
					onMusicPressed();
				}
				
				//Touched FX Button
				if(touch.isTouching(_fxBtn))
				{
					onFxPressed();
				}
				
				//Touched ResetData Button
				if(touch.isTouching(_resetDataBtn))
				{
					onResetDataPressed();
				}
				
				//Touched English Button
				if(touch.isTouching(_englishButton))
				{
					onChooseLanguage(Languages.ENGLISH);
				}
				
				//Touched Portuguese Button
				if(touch.isTouching(_portugueseButton))
				{
					onChooseLanguage(Languages.PORTUGUESE);
				}

				//Touched Credits Button
				if(touch.isTouching(_creditsButton))
				{
					onCreditsPressed();
				}
			}
		}
		
		private function onClosePressed():void
		{
			onClose.dispatch();
		}
		
		private function onMusicPressed():void
		{
			//TODO> Checkar e setar o mute e unmute da sound manager 
			if(musicMuted)
			{
				//Unmute music sound manager
				_musicBtn.unMute();
				musicMuted = false;
			}
			else
			{
				//Mute music sound manager
				_musicBtn.mute();
				musicMuted = true;
			}
		}
		
		private function onFxPressed():void
		{
			//TODO> Checkar e setar o mute e unmute da sound manager 
			if(fxMuted)
			{
				//Unmute fx sound manager
				_fxBtn.unMute();
				fxMuted = false;
			}
			else
			{
				//Mute fx sound manager
				_fxBtn.mute();
				fxMuted = true;
			}
		}
		
		private function onResetDataPressed():void
		{
			//TODO> Resetar os saves do jogador - vai ter que ter uma tela de confirmação COM CTZ!!!
			Debug.log("Reset Saved Data.");
		}
		
		private function onChooseLanguage(language:int):void
		{
			//TODO> Setar lingua escolhida pro jogo
			if(language == Languages.PORTUGUESE)
			{
				Debug.log("Language Selected : Portuguese");
				_portugueseButton.choose();
				_englishButton.unChoose();
			}
			else if(language == Languages.ENGLISH)
			{
				Debug.log("Language Selected : English");
				_englishButton.choose();
				_portugueseButton.unChoose();
				
			}
		}
		
		private function onCreditsPressed():void
		{
			//TODO> Show credits - nao faço ideia de como vao ser os creditos
			Debug.log("Show Credits.");
		}
		
		private function destroy():void
		{
			this.removeEventListener(TouchEvent.TOUCH, onTouch);
			
			onClose.removeAll();
			
			while(this.numChildren > 0)
				this.removeChildAt(0);
			
			_closeBtn = null;
			_musicBtn = null;
			_fxBtn = null;
			_resetDataBtn = null;
			_portugueseButton = null;
			_englishButton = null;
			_background = null;
			onClose = null;
			
		}
	}
}