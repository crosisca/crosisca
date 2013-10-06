package core.levels.world1
{
	import core.levels.AbstractLevel;
	
	public final class World1Level1 extends AbstractLevel
	{
		public function World1Level1(level:XML)
		{
			super(level);
		}
		
		override public function initialize():void
		{
			super.initialize();
			_ce.sound.playSound("World1Music");
		}
	}
}