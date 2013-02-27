package sfs2x.games.cannoncombat.managers
{
	
	/*******************************************************************************************
	 * 
	 * TITLE: 		SFS2X Cannon Combat
	 * VERSION:		1.0
	 * RELEASE:		2012-03-14
	 * COPYRIGHT:	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * DEVELOPER:	A51 Integrated - http://a51integrated.com
	 * 
	 * This file is part of Cannon Combat.
	 * 
	 * Contributers: Wayne Helman, Fabricio Medeiros,
	 * 				 Steve Schoger, Andy Rohan
	 * 
	 * Cannon Combat is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	 * included license for more details.
	 *
	 * You are not allowed to rent, lend, lease, license or distribute SFS2X Cannon Combat or a
	 * modified version of Cannon Combat to any other person or organization in any way.
	 * 
	 * For commercial licensing information, please contact gotoAndPlay().
	 * 
	 *******************************************************************************************/
	
	/**
	 * InstanceManager
	 * 
	 * Manager to store and return instances of a class. Similar to a Singleton, it returns a specific instance
	 * based on a unique identifier enabling AIR applications to run multiple instances of a game for debugging.
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0
	 */
	
	import sfs2x.games.cannoncombat.SFSWrapper;
	import sfs2x.games.cannoncombat.config.Assets;
	import sfs2x.games.cannoncombat.config.Settings;

	public class InstanceManager
	{
		private static var
			_SFSContainer				:Object 	= new Object(),
			_soundContainer				:Object 	= new Object(),
			_assetsContainer			:Object 	= new Object();

			
		
		/**
		 * Returns an instance of SFSWrapper
		 *
		 * @param $win :String - Window ID
		 * 
		 * @return SFSWrapper
		 */
		public static function getSFSInstance($win:String):SFSWrapper
		{
			if (_SFSContainer != null)
			{
				if (_SFSContainer[$win] == null)
				{
					_SFSContainer[$win] = new SFSWrapper($win, Settings.SFS_DEBUG);
				}
				return _SFSContainer[$win];
			}
			else
			{
				return null;
			}
		}
		
		
		
		/**
		 * Returns an instance of SoundManager
		 *
		 * @param $win :String - Window ID
		 * 
		 * @return SoundManager
		 */
		public static function getSoundManagerInstance($win:String):SoundManager
		{
			if (_soundContainer != null)
			{
				if (_soundContainer[$win] == null)
				{
					_soundContainer[$win] = new SoundManager();
				}
				return _soundContainer[$win];
			}
			else
			{
				return null;
			}
		}
		
		
		
		/**
		 * Returns an instance of Assets
		 *
		 * @param $win :String - Window ID
		 * 
		 * @return Assets
		 */
		public static function getAssetsInstance($win:String):Assets
		{
			if (_assetsContainer != null)
			{
				if (_assetsContainer[$win] == null)
				{
					_assetsContainer[$win] = new Assets();
				}
				return _assetsContainer[$win];
			}
			else
			{
				return null;
			}
		}
		
		
		
		/**
		 * Removes elements from memory
		 * 
		 * @param $win :String - Window ID
		 */
		public static function destroy($win:String):void
		{
			if (_soundContainer[$win] != null)
			{
				delete _soundContainer[$win];
				_soundContainer[$win] = null;
			}
			delete _soundContainer[$win];
			
			if (_SFSContainer[$win] != null)
			{
				delete _SFSContainer[$win];
				_SFSContainer[$win] = null;
			}
			delete _SFSContainer[$win];
			
			if (_assetsContainer[$win] != null)
			{
				if('destroy' in _assetsContainer[$win])
					_assetsContainer[$win].destroy();
				
				delete _assetsContainer[$win];
				_assetsContainer[$win] = null;
			}
			delete _assetsContainer[$win];
		}
		
	}
}