package core.data
{
	import core.levels.world1.World1Level1;
	import core.levels.world1.World1Level2;

	import core.levels.world2.World2Level1;
	import core.levels.world2.World2Level2;

	public final class GameData
	{
		private static var _instance:GameData;
		private var _activeWorld:int
		private var _activeLevelNumber:int;
		private var _allLevels:Array = [[World1Level1, "../../assets/levels/world1/world1level1.tmx"],
										[World1Level2, "../../assets/levels/world1/world1level2.tmx"],
										[World1Level1, "../../assets/world1/world1level3.xml"],
										[World1Level1, "../../assets/world1/world1level4.xml"],
										[World1Level1, "../../assets/world1/world1level5.xml"],
										[World1Level1, "../../assets/world1/world1level6.xml"],
										[World1Level1, "../../assets/world1/world1level7.xml"],
										[World1Level1, "../../assets/world1/world1level8.xml"],
										[World1Level1, "../../assets/world1/world1level9.xml"],
										[World1Level1, "../../assets/world1/world1level10.xml"],
										
										[World2Level1, "../../assets/levels/world2/world2level1.tmx"],
										[World2Level2, "../../assets/levels/world2/world2level2.tmx"]/*,
										[World2Level3, "../../assets/world2/world2level3.xml"],
										[World2Level4, "../../assets/world2/world2level4.xml"],
										[World2Level5, "../../assets/world2/world2level5.xml"],
										[World2Level6, "../../assets/world2/world2level6.xml"],
										[World2Level7, "../../assets/world2/world2level7.xml"],
										[World2Level8, "../../assets/world2/world2level8.xml"],
										[World2Level9, "../../assets/world2/world2level9.xml"],
										[World2Level10, "../../assets/world2/world2level10.xml"],
										
										[World3Level1, "../../assets/world3/world3level1.xml"],
										[World3Level2, "../../assets/world3/world3level2.xml"],
										[World3Level3, "../../assets/world3/world3level3.xml"],
										[World3Level4, "../../assets/world3/world3level4.xml"],
										[World3Level5, "../../assets/world3/world3level5.xml"],
										[World3Level6, "../../assets/world3/world3level6.xml"],
										[World3Level7, "../../assets/world3/world3level7.xml"],
										[World3Level8, "../../assets/world3/world3level8.xml"],
										[World3Level9, "../../assets/world3/world3level9.xml"],
										[World3Level10, "../../assets/world3/world3level10.xml"],
										
										[World4Level1, "../../assets/World4/world4level1.xml"],
										[World4Level2, "../../assets/World4/world4level2.xml"],
										[World4Level3, "../../assets/World4/world4level3.xml"],
										[World4Level4, "../../assets/World4/world4level4.xml"],
										[World4Level5, "../../assets/World4/world4level5.xml"],
										[World4Level6, "../../assets/World4/world4level6.xml"],
										[World4Level7, "../../assets/World4/world4level7.xml"],
										[World4Level8, "../../assets/World4/world4level8.xml"],
										[World4Level9, "../../assets/World4/world4level9.xml"],
										[World4Level10, "../../assets/World4/world4level10.xml"]*/];
		
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