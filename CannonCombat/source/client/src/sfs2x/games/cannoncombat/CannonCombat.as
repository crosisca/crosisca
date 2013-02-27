package sfs2x.games.cannoncombat
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
	 * CannonCombat
	 * 
	 * Main game class
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import com.greensock.TweenMax;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.variables.ReservedRoomVariables;
	import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
	import com.smartfoxserver.v2.requests.JoinRoomRequest;
	import com.smartfoxserver.v2.requests.SetUserVariablesRequest;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import sfs2x.games.cannoncombat.config.Assets;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.gameplay.Arena01;
	import sfs2x.games.cannoncombat.gameplay.BasicArena;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.managers.SoundManager;
	import sfs2x.games.cannoncombat.ui.windows.WinError;
	import sfs2x.games.cannoncombat.ui.windows.WinLogin;
	import sfs2x.games.cannoncombat.ui.windows.WinStart;
	import sfs2x.games.cannoncombat.utils.PositionUtils;

	public class CannonCombat extends Sprite
	{
		public var	
			_game				:GameController,
			_lobby				:LobbyController;
		 
		private var
			_assets				:Assets,
			_sfs				:SFSWrapper,
			_bg					:Bitmap,
			_winLogin			:WinLogin,
			_winStart			:WinStart,
			_myVars				:SFSUserVariable,
			
			_selectedArena		:BasicArena,
			
			_p1					:User,
			_p2					:User,
			
			_roomLayer			:int = 0,
			_arenaID			:int,		
			_windowID			:String = '',
			_soundManager		:SoundManager,
			_destroyed			:Boolean = false,
			_lobbyInitOnce		:Boolean = false;
			
		
		
	   /**
		* Constructor
		*/
		public function CannonCombat()
		{
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		
		
		/**
		 * Initialize graphical elements and sounds
		 * 
		 * @param $e :Event - Event.ADDED_TO_STAGE
		 */
		private function init($e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//Sounds
			_soundManager = InstanceManager.getSoundManagerInstance(_windowID);
			
			_soundManager.addLibrarySound(background,'background');
			_soundManager.addLibrarySound(boing,'boing');
			_soundManager.addLibrarySound(cannon,'cannon');
			_soundManager.addLibrarySound(notice,'notice');
			_soundManager.addLibrarySound(smash,'smash');
			_soundManager.addLibrarySound(pop,'pop');
			_soundManager.addLibrarySound(wahwah,'wahwah');
			
			_assets = InstanceManager.getAssetsInstance(_windowID);
			
			//Keep this updated with all arenas you create
			var arena01		:Arena01 	= new Arena01(),
				arrArena	:Array 		= [arena01];
			
			Settings.setGlobal('arenas', arrArena, _windowID);
			
			//BG
			_bg = _assets.bg;
			_bg.width = Settings.APPLICATION_WIDTH;
			_bg.height = Settings.APPLICATION_HEIGHT;
			addChild(_bg);
			
			//Server instance
			_sfs = InstanceManager.getSFSInstance(_windowID).sfs();
			
			//Bring login window up
			createLogin();
		}
		

		
		/**
		 * Sets my user variables
		 * 
		 * @param $status :String - User status
		 */
		public function setMyVars($status:String = Settings.STATUS_IN_LIMBO):void
		{
			var userVars:Array 	= [];
			_myVars = new SFSUserVariable( Settings.GAME_STATUS, $status );
			userVars.push( _myVars );
			
			_sfs.send(new SetUserVariablesRequest(userVars));
		}
		
		
		
		/**
		 * Show login window and set SmartFoxServer 2X listeners
		 */
		public function createLogin():void
		{
			if (_windowID != null)
			{
				_sfs.addEventListener(SFSEvent.LOGIN, onLogin, false, 0, true);
				_sfs.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError, false, 0, true);
				
				if(_winStart != null)
				{
					removeChild(_winStart);
					_winStart.destroy();
					_winStart = null;
				}
				
				_winLogin = new WinLogin();
				_winLogin.bgAlpha = 0;
				addChild(_winLogin);
				PositionUtils.center(_winLogin, null, true);
				
				_winLogin.tweenIn();
			}
		}

		
		
		/**
		 * Initialize lobby join request
		 */
		public function initLobby():void
		{
			if(_winStart != null)
			{
				_winStart = null;
			}
			
			if (_game != null)
			{
				_game.destroy();
				removeChild(_game);
				_game = null;
			}
			
			_sfs.addEventListener(SFSEvent.ROOM_JOIN, onJoinRoom, false, 0, true);
			_sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onJoinRoomError, false, 0, true);
			_sfs.addEventListener(SFSEvent.ROOM_VARIABLES_UPDATE, onRoomVarUpdate, false, 0, true);
			
			if(_myVars.getStringValue() == Settings.STATUS_IN_LIMBO)
			{
				//User joins the Lobby for the first time or just creates the screens (in case it is returning to the lobby from a game)
				(_lobbyInitOnce) ? createLobby() : _sfs.send(new JoinRoomRequest(Settings.SFS2X_LOBBY));
			}
		}
		
		
		
		/**
		 * Creates the Lobby class and necessary windows
		 */
		private function createLobby():void
		{
			_lobbyInitOnce = true;
			
			setMyVars(Settings.STATUS_IN_LOBBY);
			
			if(_winLogin) 
			{
				_winLogin.destroy();
				_winLogin = null;
			}
			
			if (_game != null)
			{
				_game.destroy();
				removeChild(_game);
				_game = null;
			}
			
			if (_lobby != null)
			{
				_lobby.destroy();
				removeChild(_lobby);
				_lobby = null;
			}

			_lobby = new LobbyController(_windowID);
			addChild(_lobby);
		}
		
		
		
		/**
		 * Destroy lobby class
		 */
		public function destroyLobby():void
		{
			if (_lobby != null)
			{
				_lobby.destroy();
				removeChild(_lobby);
				_lobby = null;
			}
			
			setMyVars(Settings.STATUS_IN_LIMBO);
			
			initStart();
			
			_sfs.removeEventListener(SFSEvent.ROOM_JOIN, onJoinRoom);
			_sfs.removeEventListener(SFSEvent.ROOM_JOIN_ERROR, onJoinRoomError);
		}
		

		
		/**
		 * Initialize start screen
		 */
		private function initStart():void
		{
			if (_game != null)
			{
				_game.destroy();
				removeChild(_game);
				_game = null;
			}
			
			if(_winLogin != null) 
			{
				_winLogin.destroy();
				_winLogin = null;
			}
			
			if (_winStart == null)
			{
				_winStart = new WinStart();
				_winStart.bgAlpha = 0;
				_winStart.windowID = _windowID;
				addChild(_winStart);
			}
		}
		
		
		
		/**
		 * Save arena selected on arena panel before entering a game
		 * 
		 * @param $arena :int - Index of arena in the global arenas array
		 */
		public function onArenaSelected($arena:int):void
		{
			var arenaList	:Array = Settings.getGlobal('arenas', _windowID),
				len			:int = arenaList.length;

			_arenaID = $arena;
			
			for(var i:int = 0; i < len; i++)
			{
				if(i == _arenaID)	_selectedArena = arenaList[i];
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Logs the user in upon receipt of a 'LOGIN' event from SmartFoxServer
		 * 
		 * @param $e :SFSEvent - SFSEvent.LOGIN
		 */
		private function onLogin($e:SFSEvent):void
		{
			_sfs.removeEventListener(SFSEvent.LOGIN, onLogin);
			_sfs.removeEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
			
			Settings.setGlobal('CannonCombat', this, _windowID);
			
			setMyVars();
			
			initStart();
		}
		
		
		
		/**
		 * Handles receipt of a 'LOGIN_ERROR' event from SmartFoxServer
		 * 
		 * @param $e :SFSEvent - SFSEvent.LOGIN_ERROR
		 */
		private function onLoginError($e:SFSEvent):void
		{
			var msgObject	:Object = Settings.MSG_ERR_LOGIN,
				errorWin	:WinError = new WinError(msgObject);
			
			_sfs.disconnect();
			
			errorWin.addEventListener(Event.REMOVED_FROM_STAGE, destroyErrorWindow, false, 0, true);
			addChild(errorWin);
		}
		
		
		
		/**
		 * Handles receipt of a 'ROOM_JOIN' event from SmartFoxServer
		 * 
		 * @param $e :SFSEvent - SFSEvent.ROOM_JOIN
		 */
		private function onJoinRoom($e:SFSEvent):void
		{
			var room:Room = $e.params.room;

			if(room.name == Settings.SFS2X_LOBBY)
			{
				createLobby();
			}
			else if(room.isGame)
			{
				_lobby.destroy();
				removeChild(_lobby);
				_lobby = null;
				
				if (_game != null)
				{
					_game.destroy();
					removeChild(_game);
					_game = null;
				}
				
				if(room.userCount <= room.maxUsers)
				{
					var playerList:Array;

					//We have to guarantee p1 is the inviter
					//For the invitee there is only one user in the room, himself
					if(room.playerList.length == 1) 
					{
						playerList = [_p1, _p2] ;
					}
					else
					{
						//For the inviter we check if the user order in the room matches our logic
						(room.getUserByName(_sfs.mySelf.name).name == room.playerList[0].name)
						?
							playerList = [ room.playerList[1], room.playerList[0] ]
						:
							playerList = [ room.playerList[0], room.playerList[1] ];
					}
					
					_game = new GameController(_windowID, _selectedArena, playerList, false);
					addChildAt(_game,_roomLayer);
				}
				else
				{
					//Spectator
					_game = new GameController(_windowID, _selectedArena, room.playerList, true);
					addChildAt(_game,_roomLayer);
				}
			}
		}
				
		
		
		/**
		 * Handles receipt of a 'ROOM_JOIN_ERROR' event from SmartFoxServer
		 * 
		 * @param $e :SFSEvent - SFSEvent.ROOM_JOIN_ERROR
		 */
		private function onJoinRoomError($e:SFSEvent):void
		{
			var msgObject	:Object = Settings.MSG_ERR_ROOMJOIN,
				errorWin	:WinError = new WinError(msgObject);
			
			errorWin.addEventListener(Event.REMOVED_FROM_STAGE, destroyErrorWindow, false, 0, true);
			addChild(errorWin);
		}
		
		
		
		/**
		 * This handler is triggered when a room variable change event is fired by the server
		 * 
		 * @param $e :SFSEvent - SFSEvent.ROOM_VARIABLES_UPDATE
		 */
		private function onRoomVarUpdate($e:SFSEvent):void
		{
			var room	:Room 			= $e.params.room,
				vars	:Array 			= $e.params.changedVars,
				slot	:String			= vars[0],
				obj		:ISFSObject,
				count	:int			= vars.length;
			
			if( vars.indexOf(Settings.RV_ARENA) != -1 )
			{
				if(room.getVariable(slot) != null)
				{
					obj	= room.getVariable(slot).getSFSObjectValue();
					_arenaID = obj.getInt('arena');
				}
			}
			else if( vars.indexOf(ReservedRoomVariables.RV_GAME_STARTED) != -1 )
			{
				if(room.getVariable(ReservedRoomVariables.RV_GAME_STARTED).getBoolValue() == true)
				{
					if(_lobby != null)	_lobby.roomList.removeItem('name', room.name);
					if(_game != null)
						_game.setUpArena();
				}
			}
		}
		
		
		
		/**
		 * Removes the error window from the stage and memory
		 * 
		 * @param $e :Event - Event.REMOVED_FROM_STAGE from WinError
		 */
		private function destroyErrorWindow($e:Event):void
		{
			var child:DisplayObject = $e.currentTarget as DisplayObject;
			if(child.hasEventListener(Event.REMOVED_FROM_STAGE))
			{
				child.removeEventListener(Event.REMOVED_FROM_STAGE, destroyErrorWindow);
			}
			child = null;
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public function destroy():void
		{
			_destroyed = true;
			InstanceManager.getSFSInstance(_windowID).removeEvents();
			
			TweenMax.killAll(true, true, true);
			
			_sfs.removeEventListener(SFSEvent.LOGIN, onLogin);
			_sfs.removeEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
			_sfs.removeEventListener(SFSEvent.ROOM_JOIN, onJoinRoom);
			_sfs.removeEventListener(SFSEvent.ROOM_JOIN_ERROR, onJoinRoomError);
			_sfs.removeEventListener(SFSEvent.ROOM_VARIABLES_UPDATE, onRoomVarUpdate);
			
			_soundManager.fadeAllSounds();
			_soundManager = null;
			
			if(_lobby)
			{
				_lobby.destroy();
				_lobby = null;
			}
			
			if (_game != null)
			{
				_game.destroy();
				removeChild(_game);
				_game = null;
			}
			
			while (numChildren)
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
			
			_sfs.disconnect();
			
			_assets				= null;
			_sfs				= null;
			_winLogin			= null;
			_lobby				= null;
			_roomLayer			= undefined;
			_windowID			= null;
			_myVars				= null;
			_selectedArena		= null;
			_p1					= null;
			_p2					= null;
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get windowID():String { return _windowID; };
		public function set windowID($value:String):void { _windowID = $value; }
		
		public function get bg():Bitmap { return _bg; };
		public function set bg($value:Bitmap):void { _bg = $value; }
		
		public function get arenaID():int { return _arenaID; };
		public function set arenaID($value:int):void { _arenaID = $value; }
		
		public function get p1():User { return _p1; };
		public function set p1($value:User):void { _p1 = $value; }
		
		public function get p2():User { return _p2; };
		public function set p2($value:User):void { _p2 = $value; }
		
		public function get lobby():LobbyController	{ return _lobby; }
		public function set lobby($value:LobbyController):void { _lobby = $value; }

		public function get lobbyInitOnce():Boolean	{ return _lobbyInitOnce; }
		public function set lobbyInitOnce($value:Boolean):void { _lobbyInitOnce = $value; }
		
		public function get destroyed():Boolean { return _destroyed; }
	}
}