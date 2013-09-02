package core.buttons
{
	import core.utils.Debug;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public final class MusicButton extends Sprite
	{
		private var musicOnImg:Image;
		private var musicOffImg:Image;
		
		public function MusicButton()
		{
			super();
			
			musicOnImg = new Image(Texture.fromColor(50,50,0xFF00FF00));
			this.addChild(musicOnImg);

			musicOffImg = new Image(Texture.fromColor(50,50,0xFFFF0000));
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