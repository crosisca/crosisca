package core.buttons
{
	import core.utils.Languages;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public final class LanguageButton extends Sprite
	{
		private var portugueseOnImg:Image;
		private var portugueseOffImg:Image;
		
		private var englishOnImg:Image;
		private var englishOffImg:Image;
		
		private var selectedImg:Image;
		private var unselectedImg:Image;
		
		public function LanguageButton(language:int)
		{
			super();
			switch(language)
			{
				case Languages.ENGLISH:
					englishOnImg = new Image(Texture.fromColor(60,60,0xFF0000FF));
					this.addChild(englishOnImg);
					englishOffImg = new Image(Texture.fromColor(50,50,0x7F0000FF));
					this.addChild(englishOffImg);
					selectedImg = englishOnImg;
					unselectedImg = englishOffImg;
					selectedImg.visible = true;
					unselectedImg.visible = false;
					break;
				
				case Languages.PORTUGUESE:
					portugueseOnImg = new Image(Texture.fromColor(60,60,0xFF00FF00));
					this.addChild(portugueseOnImg);
					portugueseOffImg = new Image(Texture.fromColor(50,50,0x7F00FF00));
					this.addChild(portugueseOffImg);
					selectedImg = portugueseOnImg;
					unselectedImg = portugueseOffImg;
					selectedImg.visible = false;
					unselectedImg.visible = true;
					break;
				
				default:
					englishOnImg = new Image(Texture.fromColor(60,60,0xFF0000FF));
					this.addChild(englishOnImg);
					englishOffImg = new Image(Texture.fromColor(50,50,0x7F0000FF));
					this.addChild(englishOffImg);
					selectedImg = englishOnImg;
					unselectedImg = englishOffImg;
					selectedImg.visible = true;
					unselectedImg.visible = false;
					break;
			}
		}
		
		public function choose():void
		{
			selectedImg.visible = true;
			unselectedImg.visible = false;
		}
		
		public function unChoose():void
		{
			selectedImg.visible = false;
			unselectedImg.visible = true;
		}
	}
}