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
	 * SFSWrapper
	 * 
	 * A singleton that controls SmartFox events, listeners and handlers
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.requests.LoginRequest;
	
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.ui.windows.WinError;

	public class SFSWrapper extends SmartFox
	{
		private var
			_windowID			:String = '',
			_username			:String,
			_zone				:String = Settings.SFS2X_ZONE,
			_ip					:String = Settings.SFS2X_IP,
			_tcpPort			:int	= Settings.SFS2X_PORT,
			_udpPort			:int	= Settings.SFS2X_UDP_PORT;
		
			

		/**
		 * Constructor - Instantiates our SFSWrapper
		 *
		 * @param $win 		:String		- The window ID
		 * @param $debug 	:Boolean	- Specifies whether or not debug mode is enabled
		 */
		public function SFSWrapper($win:String, $debug:Boolean = false):void
		{
			_windowID = $win;
			
			super($debug);
			
			registerEvents();
		}
		

		
		/**
		 * Returns an instance of SmartFoxServer2X client
		 * to calling class after getInstance() is called.
		 * 
		 * @return this :SFSWrapper
		 */
		public function sfs():SFSWrapper { return this; }
		
		
		
		/**
		 * Remove events
		 */
		public function removeEvents():void
		{
			removeEventListener(SFSEvent.CONNECTION, onConnection);
			removeEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
		}
		
		
		
		/**
		 * Establishes a connection to the SmartFoxServer2X
		 */
		public function connectToServer():void
		{
			/*
			We're not loading an XML file through
			_sfs.loadConfig() since AIR is compiled.
			Direct insertion of host and port
			*/
			connect(_ip, _tcpPort);
		}
		

		
		/**
		 * Register event listeners
		 */
		private function registerEvents():void
		{
			addEventListener(SFSEvent.CONNECTION, onConnection, false, 0, true);
			addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost, false, 0, true);
		}
		
		
		
		/**
		 * Attempt to log on to the SFS zone 
		 */
		private function login():void
		{
			var request:LoginRequest = new LoginRequest(_username, '', _zone);
			send(request);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Handles a successfull connection to the 
		 * SmartFoxServer2X 
		 * 
		 * @param $e :SFSEvent - SFSEvent.CONNECTION
		 */
		private function onConnection($e:SFSEvent):void
		{
			if ($e.params.success)
			{
				login();
			}
			else
			{
				var msgObject		:Object = (Settings.DEBUG) ? Settings.MSG_ERR_CONN : Settings.MSG_ERR_CONN,
					errorWin		:WinError = new WinError(msgObject),
					cc				:CannonCombat;
				
				cc = Settings.getGlobal('CannonCombat', _windowID);
				cc.lobbyInitOnce = false;
				cc.addChild(errorWin);
			}
		}
		
		
		
		/**
		 * Handles a lost connection to the 
		 * SmartFoxServer2X 
		 * 
		 * @param $e :SFSEvent - SFSEvent.CONNECTION_LOST
		 */
		private function onConnectionLost($e:SFSEvent):void
		{
			var msgObject		:Object = (Settings.DEBUG) ? Settings.MSG_CONN_LOST : Settings.MSG_CONN_LOST,
				errorWin		:WinError = new WinError(msgObject);
			
			var cc:CannonCombat = Settings.getGlobal('CannonCombat', _windowID);
			
			if (cc != null)
			{
				if (cc._lobby != null)
				{
					cc._lobby.destroy();	
					cc.removeChild(cc._lobby);
					cc._lobby = null;
				}
				if (cc._game  != null) 
				{ 
					cc._game.destroy();  
					cc.removeChild(cc._game);
					cc._game = null;
				}
				cc.lobbyInitOnce = false;
				
				cc.createLogin();
				cc.addChild(errorWin);
			}
		}

		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get windowID():String { return _windowID; }
		
		public function  set setUserName($value:String):void { _username = $value; }
		
		public function  set setIP($value:String):void { _ip = $value; }
		public function  get getIP():String { return _ip; }
		
		public function  set setZone($value:String):void { _zone = $value; }
		
		public function  set setTCPPort($value:int):void { _tcpPort = $value; }
		
		public function  set setUDPPort($value:int):void { _udpPort = $value; }
		public function  get getUDPPort():int { return _udpPort; }
		
	}
}