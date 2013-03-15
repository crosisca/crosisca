package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		[Embed(source="../media/graphics/bgWelcome.jpg")]
		public static const BgWelcome:Class;
		
		[Embed(source="../media/graphics/bgLayer1.jpg")]
		public static const BgLayer1:Class;
		
		
		/*
		[Embed(source="../media/graphics/welcome_hero.png")]
		public static const WelcomeHero:Class;
		
		[Embed(source="../media/graphics/welcome_title.png")]
		public static const WelcomeTitle:Class;
		
		[Embed(source="../media/graphics/welcome_playButton.png")]
		public static const WelcomePlayBtn:Class;
		
		[Embed(source="../media/graphics/welcome_aboutButton.png")]
		public static const WelcomeAboutBtn:Class;
		*/
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source="../media/graphics/mySpritesheet.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source="../media/graphics/mySpritesheet.xml",mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
				
		[Embed(source="../media/fonts/bitmap/badaboomImg.png")]
		public static const FontTexture:Class;
		
		[Embed(source="../media/fonts/bitmap/badaboom.fnt",mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		public static var myFont:BitmapFont;
		
		public static function getFont():BitmapFont
		{
			var fontTexture:Texture = Texture.fromBitmap(new FontTexture());
			var fontXML:XML = XML(new FontXml());
			
			var font:BitmapFont = new BitmapFont(fontTexture, fontXML);
			TextField.registerBitmapFont(font);
			
			return font;
		}
		
		public static function getAtlas():TextureAtlas
		{
			if(gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		
		public static function getTexture(name:String):Texture
		{
			if(gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}
}