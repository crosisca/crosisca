package utils
{
	import com.gamua.flox.Entity;
	import com.gamua.flox.Flox;
	import com.gamua.flox.Player;
	import com.gamua.flox.Score;
	import com.gamua.flox.TimeScope;
	import com.gamua.flox.utils.HttpStatus;

	public class FloxConsoleUtils
	{
		public function FloxConsoleUtils()
		{
		}
		
		public static function saveGame():void
		{
			Player.current.save(function onComplete(_player:Player): void {
				//The savegame has been saved successfully.
				Flox.logInfo("Player info saved sucessfully.");
			},
				function onError(error:String):void {
					//An error occured while saving the entity: The device may be offline.
					Flox.logError(error, "Nao salvou player info. Device deve estar offline.");
				}
			);
		}
		
		public static function loadPlayer():void
		{
			Entity.load(Player, Player.current.id, 
				function onComplete(_player:Player):void {
					//Everything worked just fine and an entity has been retrieved from the server.
					//This savegame is never null.
					Flox.logInfo("Player sucessfilly loaded! /n #Player createdAt: "+_player.createdAt+" and updatedAt: "+_player.updatedAt);
				},
				function onError(error:String, httpStatus:HttpStatus):void {
					if(httpStatus == HttpStatus.NOT_FOUND) {
						//There's no entity on the server that matches the given type and ID.
						Flox.logError(error, "Não existe ume Entity com o tipo e id especificado no server.");
					} else {
						//Something went wrong during the load operation: The player's device may be offline.
						Flox.logError(error, "Algum erro ocorreu durante carregamento dos dados do Player. Device deve estar offline.");
					}
				}
			);
		}
		
		public static function saveScore(points:int, name:String):void
		{
			Flox.postScore("topranking", points, name);
		}
		
		public static function loadLeaderboard():void
		{
			Flox.loadScores("topranking", TimeScope.ALL_TIME, 
				function onComplete(scores:Array):void {
					trace("Retrieved " + scores.length + " scores");
					for (var i:int = 0; i < scores.length; i++) 
					{
						trace((scores[i] as Score).playerName +": "+(scores[i] as Score).value);
					}
					
				},
				function onError(error:String):void {
					trace("Error loading leaderboard 'topranking': " + error);
				}
			);
		}
	}
}