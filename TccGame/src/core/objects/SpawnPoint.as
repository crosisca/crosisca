	package core.objects
{
	import citrus.core.CitrusObject;
	
	public final class SpawnPoint extends CitrusObject
	{
		public var x:int;
		public var y:int;
		
		public function SpawnPoint(name:String, params:Object=null)
		{
			super(name, params);
		}
	}
}