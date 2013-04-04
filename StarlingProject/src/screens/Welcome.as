package screens
{
	import com.greensock.TweenLite;
	
	import events.NavigationEvent;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Welcome extends Sprite
	{
		private var bg:Image;
		private var title:Image;
		private var hero:Image;
		
		private var hero_tween:Tween;

		private var playBtn:Button;
		private var aboutBtn:Button;
		private var backBtn:Button;
		
		private var screenMode:String;
		
		private var aboutText:TextField;
		
		public function Welcome()
		{
			super();
			this.visible = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawScreen();
		}
		
		private function drawScreen():void
		{
			bg = new Image(Assets.getTexture("BgWelcome"));
			bg.blendMode = BlendMode.NONE;
			this.addChild(bg);
			
			title = new Image(Assets.getAtlas().getTexture("welcome_title"));
			title.x = 500;
			title.y = 50;
			this.addChild(title);
			
			hero = new Image(Assets.getAtlas().getTexture("welcome_hero"));
			hero.x = -hero.width;
			hero.y = 120;
			this.addChild(hero);

			playBtn = new Button(Assets.getAtlas().getTexture("welcome_playButton"));
			playBtn.x = 600;
			playBtn.y = 350;
			playBtn.addEventListener(Event.TRIGGERED, onButtonClick);
			this.addChild(playBtn);
			
			aboutBtn = new Button(Assets.getAtlas().getTexture("welcome_aboutButton"));
			aboutBtn.x = 450;
			aboutBtn.y = 450;
			aboutBtn.addEventListener(Event.TRIGGERED, onButtonClick);
			this.addChild(aboutBtn);
			
			backBtn = new Button(Assets.getAtlas().getTexture("about_backButton"));
			backBtn.x = 660;
			backBtn.y = 350;
			backBtn.addEventListener(Event.TRIGGERED, onButtonClick);
			this.addChild(backBtn);
			
			//Campo de texto com info sobre o jogo
			aboutText = new TextField(480, 600, "", Assets.getFont().name, 20, 0xffffff);
			aboutText.text = "Remake do jogo Hungry Hero (http://www.hungryherogame.com).\n\n" +
				" Jogo produzido utilizando Starling Framework, com intuito de testes." +
				" O objetivo do jogo é simples, você deve alimentar o super herói que está com fome." +
				" Você ganha pontos quando come.\n\n Existem 3 obstáculos que voam com um aviso \"Watch out!\"" +
				" antes deles aparecerem. Evite-os a todo custo. Você tem apenas 5 vidas. Tente fazer o máximo de pontos" +
				" e também voar o mais longe possível.";
			aboutText.x = 80;
			aboutText.y = 280;
			aboutText.hAlign = HAlign.CENTER;
			aboutText.vAlign = VAlign.TOP;
			aboutText.height = aboutText.textBounds.height + 30;
			this.addChild(aboutText);
			
		}
		
		private function onButtonClick(event:Event):void
		{
			var buttonClicked:Button = event.target as Button;
			switch(buttonClicked)
			{
				case playBtn:
					onPlayBtnClick();
					break;
					
				case aboutBtn:
					onAboutBtnClick();
					break;
					
				case backBtn:
					onBackBtnClick();
					break;
					
				
			}
		}
		
		private function onPlayBtnClick():void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "play"},true));
			//se n tiver muted toca o som do café
		}
		
		private function onAboutBtnClick():void
		{
			//se n tiver mutado toca o som do cogumelo
			showAbout();
		}
		
		public function showAbout():void
		{
			hero.visible = false;
			playBtn.visible = false;
			aboutBtn.visible = false;
			
			aboutText.visible = true;
			backBtn.visible = true;
		}
		
		private function onBackBtnClick():void
		{
			//se n tiver mutado toca o som do café
			
			initialize();
		}
		
		
		/**Funcao chamada pela Game assim que inicia o jogo*/
		public function initialize():void
		{
			//Limpa screen
			disposeTemporarily();
			
			this.visible = true;
			
			//Se nao tiver vindo da tela de about, restart a musica de background
			
			screenMode = NavigationEvent.WELCOME;
			
			
			hero.visible = true;
			playBtn.visible = true;
			aboutBtn.visible = true;
			
			//Esconder texto do about e botao de voltar
			aboutText.visible = false;
			backBtn.visible = false;
			
			
			//Posiciona o hero fora da tela
			hero.x = -hero.width;
			hero.y = 100;
			
			//Faz a animacao de entrada do hero
			hero_tween = new Tween(hero, 4, Transitions.EASE_OUT);
			hero_tween.animate("x",80);
			Starling.juggler.add(hero_tween);
			
			
			//Adiciona listener pros botoes ficarem flutuando
			this.addEventListener(Event.ENTER_FRAME, floatAnimations);
		}
		
		private function floatAnimations(event:Event):void
		{
			var currentDate:Date = new Date();
			hero.y = 130 + (Math.cos(currentDate.getTime() * 0.002) * 25);//0.002 = speed, 125-175(posY)
			playBtn.y = 260 + (Math.cos(currentDate.getTime() * 0.002) * 10);//0.002 = speed, 125-175(posY)
			aboutBtn.y = 400 + (Math.cos(currentDate.getTime() * 0.002) * 10);//0.002 = speed, 125-175(posY)
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, floatAnimations);
			
			//se nao vier do about..parar todos os sons
		}
	}
}