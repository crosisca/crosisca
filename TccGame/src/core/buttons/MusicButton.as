package core.buttons
{
	import core.art.AssetsManager;
	import core.utils.Debug;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public final class MusicButton extends Sprite
	{
		private var musicOnImg:Image;
		private var musicOffImg:Image;
		
		public function MusicButton()
		{
			super();
			
			musicOnImg = new Image(AssetsManager.getInstance().getHudAltas().getTexture("soundButtonOn"));
			this.addChild(musicOnImg);

			musicOffImg = new Image(AssetsManager.getInstance().getHudAltas().getTexture("soundButtonOff"));
			musicOffImg.visible = false;
			this.addChild(musicOffImg);
		}
		
		public function mute():void
		{
			Debug.log("Music Muted.");
			musicOnImg.visible = false;
			musicOffImg.visible = true;
		}

		public function unMute():void
		{
			Debug.log("Music Unmuted.");
			musicOnImg.visible = true;
			musicOffImg.visible = false;
		}
	}
}