package core.art
{
	import flash.display.Bitmap;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public final class AssetsManager extends AssetManager
	{
		private static var _instance:AssetsManager;
		
		/**
		 * Flix Art
		 */
		[Embed(source="/../../assets/character/FlixAtlas.xml", mimeType="application/octet-stream")]
		private var _flixXml:Class;
		
		[Embed(source="/../../assets/character/FlixAtlas.png")]
		private var _flixPng:Class;
		
		private var _flixAtlas:TextureAtlas;
		/**
		 * End Flix Art
		 */
		
		[Embed(source="/../../assets/menu/MenuAtlas.xml", mimeType="application/octet-stream")]
		private var _hudXml:Class;
		
		[Embed(source="/../../assets/menu/MenuAtlas.png")]
		private var _hudPng:Class;
		
		private var _hudAtlas:TextureAtlas;
		
		public function AssetsManager(scaleFactor:Number=-1, useMipmaps:Boolean=false)
		{
			super(scaleFactor, useMipmaps);
			if(_instance)
			{
				throw new Error("AssetsManager is a Singleton - Use getInstance()");
			}
			_instance = this;
		}
		
		public static function getInstance():AssetsManager
		{
			if(!_instance){
				new AssetsManager();
			} 
			return _instance;
		}
		
		public function getFlixAltas():TextureAtlas
		{
			if(_flixAtlas)
				return _flixAtlas;
			
			var bitmap:Bitmap = new _flixPng();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new _flixXml());
			var flixTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			return flixTextureAtlas;
		}
		
		public function getHudAltas():TextureAtlas
		{
			if(_hudAtlas)
				return _hudAtlas;
			
			var bitmap:Bitmap = new _hudPng();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new _hudXml());
			var hudTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			return hudTextureAtlas;
		}
	}
}