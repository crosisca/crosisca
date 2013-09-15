package core.utils
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public final class ScreenBlocker extends Sprite
	{
		private var _background:Image = new Image(Texture.fromColor(2048,1536,0xB4000000));
		public function ScreenBlocker()
		{
			super();
			this.addChild(_background);
		}
	}
}