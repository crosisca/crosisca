package core.buttons
{
	import core.art.AssetsManager;
	import core.utils.Debug;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public final class FxButton extends Sprite
	{
		private var fxOnImg:Image;
		private var fxOffImg:Image;
		
		public function FxButton()
		{
			super();
			
			fxOnImg = new Image(AssetsManager.getInstance().getHudAltas().getTexture("fxButtonOn"));
			this.addChild(fxOnImg);
			
			fxOffImg = new Image(AssetsManager.getInstance().getHudAltas().getTexture("fxButtonOff"));
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