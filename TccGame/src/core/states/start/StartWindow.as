package core.states.start
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import core.utils.ScreenUtils;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public final class StartWindow extends Sprite
	{
		/**
		 * Background da tela de start.
		 */
		private var _background:Image;
		
		/**
		 * Botao que leva pra seleção do mundo.
		 */
		private var _playButton:Button;
		
		/**
		 * Botão que abre a janela de opções.
		 */
		private var _settingsButton:Button;
		
		/**
		 * Botão que abre a página do jogo no facebook.
		 */
		private var _fbButton:Button;
		
		/**
		 * Botão que abre a página da Apple Store para dar o jogo de presente para alguém.
		 */
		private var _giftButton:Button;
		
		/**
		 * Janela de opçÕes
		 */
		private var _settingsWindow:SettingsWindow;
		private var screenBlocker:Image;
		
		public var onPlay:Signal = new Signal();
		
		public function StartWindow()
		{
			super();
			
			_settingsWindow = new SettingsWindow();
			_settingsWindow.x = ScreenUtils.SCREEN_REAL_WIDTH *.5 - _settingsWindow.width * .5;
			_settingsWindow.y = ScreenUtils.SCREEN_REAL_HEIGHT *.5 - _settingsWindow.height * .5;
			
			screenBlocker = new Image(Texture.fromColor(2048,1536,0xC0000000));
			
			//Adiciona background
			//TODO> Carregar backgroun	d
			_background = new Image(Texture.fromColor(2048,1536,0xFF000000));
			this.addChild(_background);
			
			//Adiciona botão play
			_playButton = new Button(Texture.fromColor(250,250,0xFFFF0000),"PLAY");
			_playButton.x = this.width * .5;//_background.width/2 - _playButton.width/2;
			_playButton.y = this.height * .1;
			_playButton.addEventListener(Event.TRIGGERED, onPlayPressed);
			this.addChild(_playButton);
			
			//Adiciona botão opções
			_settingsButton = new Button(Texture.fromColor(250,250,0xFF00FF00),"SETTINGS");
			_settingsButton.x = this.width * .5;//_settingsButton.width * 1.5;
			_settingsButton.y = this.height * .3;
			_settingsButton.addEventListener(Event.TRIGGERED, onSettingsPressed);
			this.addChild(_settingsButton);
			
			
			//Adiciona botão do facebook
			_fbButton = new Button(Texture.fromColor(250,250,0xFF00FF00),"FACEBOOK");
			_fbButton.x = this.width * .5;//_background.width - _fbButton.width * 1.5;
			_fbButton.y = this.height * .5;
			_fbButton.addEventListener(Event.TRIGGERED, onFacebookPressed);
			this.addChild(_fbButton);
			
			
			//Adiciona botão de gift
			_giftButton = new Button(Texture.fromColor(250,250,0xFF00FF00),"GIFT");
			_giftButton.x = this.width * .5;//_background.width - (_giftButton.width * 1.5);
			_giftButton.y = this.height * .7;
			_giftButton.addEventListener(Event.TRIGGERED, onGiftPressed);
			this.addChild(_giftButton);
		}
		
		private function onPlayPressed(event:Event):void
		{
			//Abre a tela de selecao de mundos
			_playButton.removeEventListener(Event.TRIGGERED, onPlayPressed);
			onPlay.dispatch();
		}
		
		private function onSettingsPressed(event:Event):void
		{
			_settingsWindow.onClose.addOnce(onCloseSettingsWindow);
			openSettingsWindow();
		}
		
		private function openSettingsWindow():void
		{
			addScreenBlocker();
			this.addChild(_settingsWindow);
		}
		
		private function onCloseSettingsWindow():void
		{
			this.removeChild(_settingsWindow);
			removeScreenBlocker();
		}
		
		private function onFacebookPressed(event:Event):void
		{
			//TODO> Abre a pagina do jogo no facebook
			navigateToURL(new URLRequest("http://fb.com/robobobo"));
		}
		
		private function onGiftPressed(event:Event):void
		{
			//TODO > Abre apple store pra mandar gift
			navigateToURL(new URLRequest("http://applestore/robobobo/sendasgift"));
		}
		
		private function addScreenBlocker():void
		{
			this.addChild(screenBlocker);
		}
		
		private function removeScreenBlocker():void
		{
			this.removeChild(screenBlocker);
		}
		
		public function destroy():void
		{
			_settingsButton.removeEventListener(Event.TRIGGERED, onSettingsPressed);
			_playButton.removeEventListener(Event.TRIGGERED, onPlayPressed);
			_fbButton.removeEventListener(Event.TRIGGERED, onFacebookPressed);
			_giftButton.removeEventListener(Event.TRIGGERED, onGiftPressed);
			
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			
			_background = null;
			_playButton = null;
			_settingsButton = null;
			_fbButton = null;
			_giftButton = null;
			_settingsWindow = null;
			
		}
	}
}









