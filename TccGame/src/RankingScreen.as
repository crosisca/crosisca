package
{
	import com.gamua.flox.Flox;
	import com.gamua.flox.Score;
	import com.gamua.flox.TimeScope;
	
	import feathers.system.DeviceCapabilities;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class RankingScreen extends Sprite
	{
		private var txtFields:Array = [];
		
		public function RankingScreen()
		{
			super();
			
			this.addChild(new Image(Texture.fromColor(960,640,0xFFFFFF00)));
			
			for (var i:int = 0; i < 10; i++) 
			{
				var tf:TextField = new TextField(500,30,"");
				tf.x = 500-tf.width*.5;
				tf.y = 50+(tf.height*i);
				this.addChild(tf);
				txtFields.push(tf);
			}
			createExitButton();
		}
		
		private function createExitButton():void
		{
			var exitBtn:Button = new Button(Texture.fromColor(50,50,0xFFFF0000));
			exitBtn.touchable = true;
			addChild(exitBtn);
			exitBtn.addEventListener(Event.TRIGGERED, onTouchExitBtn);
		}
		
		private function onTouchExitBtn(e:Event):void
		{
			removeFromParent();
		}
		
		public function showRanking():void
		{
			Flox.loadScores("topranking", TimeScope.ALL_TIME, 
				function onComplete(scores:Array):void {
					for (var i:int = 0; i < 10; i++) 
					{
						TextField(txtFields[i]).text = Score(scores[i]).playerName+": "
						+Score(scores[i]).value;
					}
					
				},
				function onError(error:String):void {
					trace("Error loading leaderboard 'topranking': " + error);
				}
			);
			
		}
	}
}