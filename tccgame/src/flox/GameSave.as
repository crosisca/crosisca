package flox
{
	import com.gamua.flox.Entity;
	
	public final class GameSave extends Entity
	{
		private var _playerX:Number;
		private var _playerY:Number;
		private var _playerAngle:Number;
		
		public function GameSave()
		{
			super();
		}

		public function get playerAngle():Number
		{
			return _playerAngle;
		}

		public function set playerAngle(value:Number):void
		{
			_playerAngle = value;
		}

		public function get playerY():Number
		{
			return _playerY;
		}

		public function set playerY(value:Number):void
		{
			_playerY = value;
		}

		public function get playerX():Number
		{
			return _playerX;
		}

		public function set playerX(value:Number):void
		{
			_playerX = value;
		}

	}
}