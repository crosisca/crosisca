package core.data
{
	import core.levels.world1.World1Level1;
	import core.levels.world1.World1Level2;
	import core.levels.world1.World1Level3;
	import core.levels.world1.World1Level4;
	import core.levels.world1.World1Level5;
	import core.levels.world1.World1Level6;
	import core.levels.world1.World1Level7;
	import core.levels.world1.World1Level8;
	import core.levels.world1.World1Level9;
	import core.levels.world1.World1Level10;

	import core.levels.world2.World2Level1;
	import core.levels.world2.World2Level2;
	import core.levels.world2.World2Level3;
	import core.levels.world2.World2Level4;
	import core.levels.world2.World2Level5;
	import core.levels.world2.World2Level6;
	import core.levels.world2.World2Level7;
	import core.levels.world2.World2Level8;
	import core.levels.world2.World2Level9;
	import core.levels.world2.World2Level10;

	import core.levels.world3.World3Level1;
	import core.levels.world3.World3Level2;
	import core.levels.world3.World3Level3;
	import core.levels.world3.World3Level4;
	import core.levels.world3.World3Level5;
	import core.levels.world3.World3Level6;
	import core.levels.world3.World3Level7;
	import core.levels.world3.World3Level8;
	import core.levels.world3.World3Level9;
	import core.levels.world3.World3Level10;

	import core.levels.world4.World4Level1;
	import core.levels.world4.World4Level2;
	import core.levels.world4.World4Level3;
	import core.levels.world4.World4Level4;
	import core.levels.world4.World4Level5;
	import core.levels.world4.World4Level6;
	import core.levels.world4.World4Level7;
	import core.levels.world4.World4Level8;
	import core.levels.world4.World4Level9;
	import core.levels.world4.World4Level10;

	public final class GameData
	{
		private static var _instance:GameData;
		private var _activeWorld:int
		private var _activeLevelNumber:int;
		private var _allLevels:Array = [[World1Level1, "../../assets/levels/world1/world1level1.tmx"],
										[World1Level2, "../../assets/levels/world1/world1level2.tmx"],
										[World1Level3, "../../assets/levels/world1/world1level3.tmx"],
										[World1Level4, "../../assets/levels/world1/world1level4.tmx"],
										[World1Level5, "../../assets/levels/world1/world1level5.tmx"],
										[World1Level6, "../../assets/levels/world1/world1level6.tmx"],
										[World1Level7, "../../assets/levels/world1/world1level7.tmx"],
										[World1Level8, "../../assets/levels/world1/world1level8.tmx"],
										[World1Level9, "../../assets/levels/world1/world1level9.tmx"],
										[World1Level10,"../../assets/levels/world1/world1level10.tmx"],
										
										[World2Level1, "../../assets/levels/world2/world2level1.tmx"],
										[World2Level2, "../../assets/levels/world2/world2level2.tmx"],
										[World2Level3, "../../assets/levels/world2/world2level3.tmx"],
										[World2Level4, "../../assets/levels/world2/world2level4.tmx"],
										[World2Level5, "../../assets/levels/world2/world2level5.tmx"],
										[World2Level6, "../../assets/levels/world2/world2level6.tmx"],
										[World2Level7, "../../assets/levels/world2/world2level7.tmx"],
										[World2Level8, "../../assets/levels/world2/world2level8.tmx"],
										[World2Level9, "../../assets/levels/world2/world2level9.tmx"],
										[World2Level10,"../../assets/levels/world2/world2level10.tmx"],
										
										[World3Level1, "../../assets/levels/world3/world3level1.tmx"],
										[World3Level2, "../../assets/levels/world3/world3level2.tmx"],
										[World3Level3, "../../assets/levels/world3/world3level3.tmx"],
										[World3Level4, "../../assets/levels/world3/world3level4.tmx"],
										[World3Level5, "../../assets/levels/world3/world3level5.tmx"],
										[World3Level6, "../../assets/levels/world3/world3level6.tmx"],
										[World3Level7, "../../assets/levels/world3/world3level7.tmx"],
										[World3Level8, "../../assets/levels/world3/world3level8.tmx"],
										[World3Level9, "../../assets/levels/world3/world3level9.tmx"],
										[World3Level10,"../../assets/levels/world3/world3level10.tmx"],
										
										[World4Level1, "../../assets/levels/world4/world4level1.tmx"],
										[World4Level2, "../../assets/levels/world4/world4level2.tmx"],
										[World4Level3, "../../assets/levels/world4/world4level3.tmx"],
										[World4Level4, "../../assets/levels/world4/world4level4.tmx"],
										[World4Level5, "../../assets/levels/world4/world4level5.tmx"],
										[World4Level6, "../../assets/levels/world4/world4level6.tmx"],
										[World4Level7, "../../assets/levels/world4/world4level7.tmx"],
										[World4Level8, "../../assets/levels/world4/world4level8.tmx"],
										[World4Level9, "../../assets/levels/world4/world4level9.tmx"],
										[World4Level10,"../../assets/levels/world4/world4level10.tmx"]];
		
		public const LevelsQuantityByWorld:int = 10;
		
		public function GameData()
		{
			if(_instance)
			{
				throw new Error("GameData is a Singleton - Use getInstance()");
			}
			_instance = this;
		}
		
		public static function getInstance():GameData
		{
			if(!_instance){
				new GameData();
			} 
			return _instance;
		}

		public function get activeWorld():int
		{
			return _activeWorld;
		}

		public function set activeWorld(value:int):void
		{
			_activeWorld = value;
		}

		public function get allLevels():Array
		{
			return _allLevels;
		}

		public function get activeLevelNumber():int
		{
			return _activeLevelNumber;
		}

		public function set activeLevelNumber(value:int):void
		{
			_activeLevelNumber = value;
		}


	}
}