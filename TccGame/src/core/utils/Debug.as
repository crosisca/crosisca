package core.utils
{
	public final class Debug
	{
		private static var debug:Boolean = true;
		
		private static var date:Date = new Date();
		
		public static function log(...msg):void
		{
			if(debug)
			{
				trace("[DEBUG]",date,msg);
			}
		}
	}
}