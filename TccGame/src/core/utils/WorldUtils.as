package core.utils
{
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;

	public final class WorldUtils
	{
		private static var _worldRotation:Number;
		
		public static function setWorldRotation(worldRotation:int):void
		{
			_worldRotation = deg2rad(worldRotation);
		}
		
		public static function getWorldRotation():Number
		{
			return _worldRotation;
		}
		
		public static function getWorldInvertedRotation():Number
		{
			return _worldRotation-Math.PI;
		}
		
		public static function getWorldRotationDeg():Number
		{
			return rad2deg(_worldRotation);
		}
	}
}