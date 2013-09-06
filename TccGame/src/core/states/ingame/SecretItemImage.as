package core.states.ingame
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public final class SecretItemImage extends Sprite
	{
		private var itemFound:Image;
		private var itemNotFound:Image;
		
		public function SecretItemImage()
		{
			super();		
			
			itemFound = new Image(Texture.fromColor(60,60,0xFF0000FF));
			itemFound.pivotX = itemFound.width * .5;
			itemFound.pivotY = itemFound.height * .5;
			itemFound.visible = false;
			this.addChild(itemFound);
			
			itemNotFound = new Image(Texture.fromColor(60,60,0xFF00FF00));
			itemNotFound.pivotX = itemNotFound.width * .5;
			itemNotFound.pivotY = itemNotFound.height * .5;
			this.addChild(itemFound);
		}
		
		public function setAsFound():void
		{
			itemFound.visible = true;
			itemNotFound.visible = false;
		}

		public function setAsNotFound():void
		{
			itemFound.visible = false;
			itemNotFound.visible = true;
		}
	}
}