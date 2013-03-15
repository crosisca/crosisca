package
{
	import events.NavigationEvent;
	
	import screens.InGame;
	import screens.Welcome;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var screenWelcome:Welcome;
		private var screenInGame:InGame;
		
		public function Game()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);

			screenInGame = new InGame();
			screenInGame.addEventListener(NavigationEvent.CHANGE_SCREEN, onInGameNavigation);
			this.addChild(screenInGame);
			
			
			//Cria a tela inicial
			screenWelcome = new Welcome();
			this.addChild(screenWelcome);

			//Inicializar botao de som/mute e adicionar listener
			
			
			//Inicia a tela inicial
			screenWelcome.initialize();
		}
		
		//Recebe botao clicado na tela inGame
		private function onInGameNavigation(event:NavigationEvent):void
		{
			switch(event.params.id)
			{
				case NavigationEvent.MAIN_MENU:
					screenWelcome.initialize();
					break;
				
				case NavigationEvent.ABOUT:
					screenWelcome.initialize();
					screenWelcome.showAbout();
					break;
			}
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch(event.params.id)
			{
				case "play":
					screenWelcome.disposeTemporarily();
					screenInGame.initialize();
					break;
			}
		}
	}
}