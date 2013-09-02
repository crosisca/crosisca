package core.buttons
{
	import core.utils.Debug;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public final class FxButton extends Sprite
	{
		private var fxOnImg:Image;
		private var fxOffImg:Image;
		
		public function FxButton()
		{
			super();
			
			fxOnImg = new Image(Texture.fromColor(50,50,0xFF0000FF));
			this.addChild(fxOnImg);
			
			fxOffImg = new Image(Texture.fromColor(50,50,0xFFFF0000));
			fxOffImg.visible = false;
			this.addChild(fxOffImg);
		}
		
		public function mute():void
		{
			Debug.log("FX Muted.");
			fxOnImg.visible = false;
			fxOffImg.visible = true;
		}
		
		public function unMute():void
		{
			Debug.log("FX Unmuted.");
			fxOnImg.visible = true;
			fxOffImg.visible = false;
		}
	}
}