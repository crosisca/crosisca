package core.levels.world1
{
	import core.levels.AbstractLevel;
	
	public final class World1Level1 extends AbstractLevel
	{
		public function World1Level1(level:XML = null)
		{
			super(level);
			trace("world1level1 constructor");
		}
		
		override public function initialize():void
		{
			super.initialize();
			trace("initialized world1level1");
		}
	}
}