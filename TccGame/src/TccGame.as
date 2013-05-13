package
{
	import com.gamua.flox.Flox;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import citrus.core.starling.StarlingCitrusEngine;
	
	import starling.core.Starling;
	
	[SWF(frameRate="30")]
	public class TccGame extends StarlingCitrusEngine
	{
		public var debugSpriteRectangle:Sprite = new Sprite();

		public function TccGame()
		{
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			stage.quality = StageQuality.LOW;
			stage.showDefaultContextMenu = true;
			
			//Minimap
			addChild(debugSpriteRectangle);
			
			Starling.multitouchEnabled = true;
			setUpStarling(true);
			
			//Flox.init("caiorosisca-tccgame", "ue4aNbO8zlES1tbp","1.0");
			
			loaderInfo.uncaughtErrorEvents.addEventListener(  UncaughtErrorEvent.UNCAUGHT_ERROR, 
				function(event:UncaughtErrorEvent):void 
				{
					Flox.logError(event.error, "Uncaught Error: " + event.error.message);
				}
			);
			
			var email:String = "caio.rosisca@hotmail.com";
			
			/*Player.loginWithEmail(email,
				function onLoginComplete(player:Player):void {
					Flox.logInfo("Player sucessfully logged in!"+player);
				},
				function onLoginFailed(error:String, confirmationEmailSent:Boolean):void {
					if(confirmationEmailSent) {
						Flox.logWarning("Tell the player to confirm his e-mail then come back to the game!");
					} else {
						Flox.logError(error, "Error when loggin in via e-mail!"); 
					}
				}
			);*/
			//state = new GameState();
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain,null);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
			loader.load(new URLRequest("Level1.swf"),loaderContext);
			
			console.addCommand("save", FloxConsoleUtils.saveGame);
			console.addCommand("load", FloxConsoleUtils.loadPlayer);
			console.addCommand("savescore", FloxConsoleUtils.saveScore);
			console.addCommand("loadscores", FloxConsoleUtils.loadLeaderboard);
		}
		
		protected function handleLoadComplete(event:Event):void
		{
			var levelSwf:MovieClip = event.target.loader.content as MovieClip;
			//state = new GameState(levelSwf,debugSpriteRectangle);
			//state = new ThresholdTestState(levelSwf);//FLUID LEVEL
			state = new NewGameControlsState(debugSpriteRectangle);
		}
		
		private function handleLoadError(event:IOErrorEvent):void
		{
			Flox.logError(event.errorID, "Nao carregou a primeira fase!");
		}
	}
}