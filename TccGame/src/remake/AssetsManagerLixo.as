package remake
{
	import flash.display.Bitmap;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public final class AssetsManagerLixo
	{
		[Embed(source="../assets/menu/World1.png")]
		private static var World1Png:Class;
		
		[Embed(source="../assets/menu/World2.png")]
		private static var World2Png:Class;
		
		[Embed(source="../assets/menu/World3.png")]
		private static var World3Png:Class;
		
		[Embed(source="../assets/menu/World4.png")]
		private static var World4Png:Class;
		
		public static function World1Texture():Texture
		{
			return Texture.fromBitmap(new World1Png());
		}
		
		public static function World2Texture():Texture
		{
			return Texture.fromBitmap(new World2Png());
		}
		
		public static function World3Texture():Texture
		{
			return Texture.fromBitmap(new World3Png());
		}
		
		public static function World4Texture():Texture
		{
			return Texture.fromBitmap(new World4Png());
		}
		
		/*[Embed(source="../assets/levels/world1/Fase5.tmx", mimeType="application/octet-stream")]
		private static var Level5Map:Class;
		[Embed(source="../assets/levels/world1/TilesetWorldDebug.png")]
		private static var Level5View1:Class;
		
		//TESTE 64 VS 32
		
		[Embed(source="../assets/levels/Level1_32.tmx", mimeType="application/octet-stream")]
		private static var Level1TMX32:Class;
		[Embed(source="../assets/levels/Tileset32.png")]
		private static var Tileset32PNG:Class;
		[Embed(source="../assets/levels/Tileset32.xml", mimeType="application/octet-stream")]
		private static var Tileset32XML:Class;
		
		
		[Embed(source="../assets/levels/Level1_64.tmx", mimeType="application/octet-stream")]
		private static var Level1TMX64:Class;
		[Embed(source="../assets/levels/Tileset64.png")]
		private static var Tileset64PNG:Class;
		[Embed(source="../assets/levels/Tileset64.xml", mimeType="application/octet-stream")]
		private static var Tileset64XML:Class;*/
		
		//32
		/*public static function getLevel1Map32():XML
		{
			var xml:XML = XML(new Level1TMX32());
			return xml;
		}
		
		public static function getLevel1Atlas32():TextureAtlas
		{
			var tilesetImg:Texture = Texture.fromBitmap(new Tileset32PNG());
			var tilesetXml:XML = XML(new Tileset32XML());
			
			var atlas:TextureAtlas = new TextureAtlas(tilesetImg, tilesetXml);
			return atlas;
		}*/
		
		
		//64
		/*public static function getLevel1Map64():XML
		{
			var xml:XML = XML(new Level1TMX64());
			return xml;
		}
		
		public static function getLevel1Atlas64():TextureAtlas
		{
			var tilesetImg:Texture = Texture.fromBitmap(new Tileset64PNG());
			var tilesetXml:XML = XML(new Tileset64XML());
			
			var atlas:TextureAtlas = new TextureAtlas(tilesetImg, tilesetXml);
			return atlas;
		}*/
		
		
		
		//FIM TESTE 64 VS 32
		
		/*public static function getLevel5View1():Bitmap
		{
			var bitmapView:Bitmap = new Level5View1();     
			bitmapView.name = "TilesetWorldDebug.png"; 
			return bitmapView;
		}
		
		public static function getLevel5Map():XML
		{
			var xml:XML = XML(new Level5Map());
			return xml;
		}*/
	/*	private static var _menuAtlas:TextureAtlas;
		
		public static function getMenuAtlas():TextureAtlas
		{
			if(!_menuAtlas)
				_menuAtlas = new TextureAtlas(Texture.fromBitmap(new MenuAtlasImg()), XML(new MenuAtlasXml()));
			return _menuAtlas;
		}
		
		public static function dispose():void
		{
			_menuAtlas.dispose();
			_menuAtlas = null;
		}
		
		public static function getAtlas(selectedLevel:String):TextureAtlas
		{
			var levelAtlas:TextureAtlas = new TextureAtlas(getDefinitionByName(selectedLevel+".png")as Texture,getDefinitionByName(selectedLevel+".xml")as XML);
			return levelAtlas;
		}*/
	}
}