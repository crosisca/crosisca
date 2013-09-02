package core.art
{
	import starling.utils.AssetManager;
	
	public final class AssetsManager extends AssetManager
	{
		private static var _instance:AssetsManager;
		
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
	}
}