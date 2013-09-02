package core.utils
{
	public final class Debug
	{
		private static var debug:Boolean = true;
		
		public function Debug()
		{
		}
		
		public static function log(msg:String):void
		{
			if(debug)
			{
				trace("[DEBUG]",msg);
			}
		}
	}
}