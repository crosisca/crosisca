package
{
	import flash.display.Sprite;
	import starling.core.Starling;
	
	[SWF(frameRate="60",width="1024",height="768",backgroundColor="0x000000")]
	public class StarlingProject extends Sprite
	{
		
		//private var stats:Stats;
		private var myStarling:Starling;
		
		public function StarlingProject()
		{
			myStarling = new Starling(Game, stage);
			myStarling.antiAliasing = 1;
			
			myStarling.showStats = true;
			myStarling.showStatsAt("left", "bottom");
			
			myStarling.start();
		}
	}
}