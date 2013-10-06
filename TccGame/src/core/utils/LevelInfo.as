package core.utils
{
	public final class LevelInfo
	{
		private var _gotSecretItem:Boolean = false;
		public var worldNumber:int;
		public var levelNumber:int;
		public var locked:Boolean = true;
		
		public function LevelInfo()
		{
		}

		public function get gotSecretItem():Boolean
		{
			return _gotSecretItem;
		}

		public function set gotSecretItem(value:Boolean):void
		{
			if(!_gotSecretItem)
				_gotSecretItem = value;
		}

	}
}