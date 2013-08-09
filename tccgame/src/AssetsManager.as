package
{
	import flash.utils.getDefinitionByName;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public final class AssetsManager
	{
		
		[Embed(source="assets/MenuAtlas.png")]
		private static var MenuAtlasImg:Class;
		[Embed(source="assets/MenuAtlas.xml", mimeType="application/octet-stream")]
		private static var MenuAtlasXml:Class;
		
		private static var _menuAtlas:TextureAtlas;
		
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
			var levelAtlas:TextureAtlas = new TextureAtlas(getDefinitionByName(selectedLevel+"png")as Texture,getDefinitionByName(selectedLevel+"xml")as XML);
			return levelAtlas;
		}
	}
}