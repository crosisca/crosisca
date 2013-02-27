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
	 * GameController - Controls the gameplay - All the events occurring on-screen during a game
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import com.greensock.TweenLite;
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.ObjectMessageRequest;
	import com.smartfoxserver.v2.requests.SetRoomVariablesRequest;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	
	import sfs2x.games.cannoncombat.config.Assets;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.events.CustomEvent;
	import sfs2x.games.cannoncombat.gameplay.BasicArena;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.managers.SoundManager;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.ui.windows.WinGameOver;
	import sfs2x.games.cannoncombat.utils.Clock;
	import sfs2x.games.cannoncombat.utils.PositionUtils;
	import sfs2x.games.cannoncombat.utils.Score;
	import sfs2x.games.cannoncombat.utils.TextUtils;
	
	public class GameController extends Sprite
	{
		private var
			_assets				:Assets,																// Our imported assets TBD
			_windowID			:String,																// The ID of this NativeWindow
			_cc					:CannonCombat,															// Reference to CannonCombat class instance
			_soundManager		:SoundManager,
			
			_sfs				:SmartFox,					
			_gameRoom			:Room,																	// The current room// SmartFoxServer2X
			_updateObj			:SFSObject 					= new SFSObject(),							// Contains update data from SFS
			_myName				:String,																// My SFS name	
			
			_winGameOver		:WinGameOver,
			_world				:BasicArena,															//Physics world
			_shootingClock		:Clock,
			
			_p1Score			:Score,
			_p2Score			:Score,
			_p1TurnIndicator	:TurnIndicator,
			_p2TurnIndicator	:TurnIndicator,
			_msg				:TextField,
			_buttonAudioOn		:BasicButton,
			_buttonAudioOff		:BasicButton,
			
			_playerTurn			:String						= '',
			_playerList			:Array,
			_isSpectator		:Boolean					= false,
			_myTurn				:Boolean					= false;

			
			
		/**
		 * Constructor
		 */
		public function GameController($win:String, $arena:BasicArena, $playerList:Array = null, $isSpectator:Boolean = false)
		{
			_playerList = $playerList;
			_isSpectator = $isSpectator;
			
			_world = $arena;
			_windowID = $win;
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		
		
		/**
		 * Event handler triggered when object has been added to stage
		 * 
		 * @param $e :Event - Event.ADDED_TO_STAGE
		 */ 
		 private function init($e:Event):void
		 {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//Reference to assets
			_assets = InstanceManager.getAssetsInstance(_windowID);
			
			// Add event listeners to SmartFox
			_sfs = InstanceManager.getSFSInstance(_windowID).sfs();
			_sfs.addEventListener(SFSEvent.ROOM_VARIABLES_UPDATE, onRoomVarUpdate, false, 0, true);
			_sfs.addEventListener(SFSEvent.OBJECT_MESSAGE, onObjectMessage, false, 0, true);
			
			//Reference to CannonCombat
			_cc = (parent as CannonCombat);
			_cc.bg.visible = false;
			
			//Select arena from global list since spectator did not receive a notification
			if(_isSpectator)
			{
				var arenaList	:Array = Settings.getGlobal('arenas', _windowID),
					len			:int = arenaList.length,
					arenaID		:int;
				
				arenaID = _cc.arenaID;
				
				for(var i:int = 0; i < len; i++)
				{
					if(i == arenaID)	_world = arenaList[i];
				}
			}

			_world.gameController = this;
			_world.windowID = _windowID;
			_soundManager = InstanceManager.getSoundManagerInstance(_windowID);
			
			//Reference to my name
			if(!_isSpectator)	_myName = _sfs.mySelf.name;

			// Set current game room
			_gameRoom = _sfs.lastJoinedRoom;
			
			if(!_isSpectator)
			{
				var update		:ISFSObject = new SFSObject(),
					ready		:BasicButton;
				
				update.putInt('arena', _cc.arenaID);
				broadcastRoomVariable(update, Settings.RV_ARENA);
				
				//Button
				ready = new BasicButton(_windowID, 'READY','default_white_small', true, _assets.button_small_bg, _assets.button_small_bg);
				ready.explicitWidth = 308;
				ready.explicitHeight = 55;
				ready.addEventListener(MouseEvent.CLICK, onReady, false, 0, true);
				addChild(ready);
				
				//Positioning
				PositionUtils.center(ready, null, true, true);
			}
			else
			{
				_msg = TextUtils.createTextField(false, false, 'left');
				_msg.htmlText = '<span class="default_black">Please wait!</span>';
				addChild(_msg);
				
				//Positioning
				PositionUtils.center(_msg, null, true, true);
			}
		}
		
		
		
		/**
		 * Setup arena once player turn has been defined
		 */
		public function setUpArena():void
		{
			//Check who starts
			_playerTurn = _gameRoom.getVariable(Settings.RV_TURN).getStringValue();
			_world.playerTurn = _playerTurn;
			
			//Define who is p1 and p2
			_world.p1 = _playerList[0];
			_world.p2 = _playerList[1];
			
			addChild(_world);

			_p1Score = new Score();
			_p1Score.isItMe = true;
			addChild(_p1Score);
			_p1Score.playerName = _world.p1.name;
			
			_p1TurnIndicator = new TurnIndicator();
			_p1TurnIndicator.x = _p1Score.playerNameTF.x - 18;
			_p1TurnIndicator.y = 19;
			addChild(_p1TurnIndicator);
			
			_p2Score = new Score();
			_p2Score.isItMe = false;
			addChild(_p2Score);
			_p2Score.playerName = _world.p2.name;
			
			_p2TurnIndicator = new TurnIndicator();
			_p2TurnIndicator.x = _p2Score.playerNameTF.x - 18;
			_p2TurnIndicator.y = 97;
			addChild(_p2TurnIndicator);
			
			indicateTurn();
			
			(!_isSpectator) ? _world.init(_myName) : _world.init();
			
			_buttonAudioOff = new BasicButton(_windowID, '','default_white', true, _assets.audio_off, _assets.audio_off);
			_buttonAudioOff.explicitWidth = 58;
			_buttonAudioOff.explicitHeight = 60;
			_buttonAudioOff.x = _buttonAudioOff.y = 6;
			_buttonAudioOff.name = 'off';
			_buttonAudioOff.addEventListener(MouseEvent.CLICK, onAudioClick, false, 0, true);
			addChild(_buttonAudioOff);
			
			_buttonAudioOn = new BasicButton(_windowID, '','default_white', true, _assets.audio_on, _assets.audio_on);
			_buttonAudioOn.explicitWidth = 58;
			_buttonAudioOn.explicitHeight = 60;
			_buttonAudioOn.x = _buttonAudioOn.y = 6;
			_buttonAudioOn.name = 'on';
			_buttonAudioOn.addEventListener(MouseEvent.CLICK, onAudioClick, false, 0, true);
			addChild(_buttonAudioOn);
			
			_soundManager.playSound('background', .3, 0, int.MAX_VALUE, false);
			
			addEventListener(CustomEvent.SOLDIER_KILLED, onSoldierKilled, false, 0, true);
			addEventListener(CustomEvent.GAME_OVER, onGameOver, false, 0, true);
		}
		
		
		
		/**
		 * Light up player's indicators based on whose turn it is
		 */
		private function indicateTurn():void
		{
			if(_playerTurn == _world.p1.name)
			{
				_p1TurnIndicator.gotoAndStop(2);
				_p2TurnIndicator.gotoAndStop(1);
			}
			else if(_playerTurn == _world.p2.name)
			{
				_p2TurnIndicator.gotoAndStop(2);
				_p1TurnIndicator.gotoAndStop(1);
			}
		}
		

		
		/**
		 * Broadcasts object messages to other players via the SmartFoxServer
		 * 
		 * @param $obj :ISFSObject - The object to be sent
		 */
		public function broadcastMessage($obj:ISFSObject, $room:Room = null):void
		{
			var request:ObjectMessageRequest = new ObjectMessageRequest($obj, $room);
			if(_sfs != null)	_sfs.send(request);
		}
		
		
		
		/**
		 * Broadcasts object messages to other players via the SmartFoxServer
		 * 
		 * @param $obj :ISFSObject - The object to be sent
		 */
		public function broadcastRoomVariable($obj:ISFSObject, $varName:String, $room:Room = null):void
		{
			//Always include sender
			if(_myName != null)	$obj.putUtfString('sender', _myName);
			
			var roomVar		:SFSRoomVariable 			= new SFSRoomVariable($varName, $obj),
				request		:SetRoomVariablesRequest 	= new SetRoomVariablesRequest( [ roomVar ], $room);

			_sfs.send(request);
		}
		
		
		
		/**
		 * Broadcasts extensions to other players via the SmartFoxServer
		 * 
		 * @param $type :String		- The type of message
		 * @param $obj 	:ISFSObject	- The SFS object to be sent
		 * @param $udp 	:Boolean	- A flag to set the UDP/TCP usage
		 */
		public function broadcastExtension($type:String, $obj:ISFSObject):void
		{
			var request:ExtensionRequest = new ExtensionRequest($type, $obj, _gameRoom);
			_sfs.send(request);
		}
		
		
		
		/**
		 * Exit the current game room and return to the lobby
		 */
		public function leaveGame():void
		{
			_soundManager.stopAllSounds();
			
			var cc:CannonCombat = (parent as CannonCombat);
			cc.lobbyInitOnce = false;
			cc.setMyVars(Settings.STATUS_IN_LIMBO);
			cc.initLobby();
		}

		
		
		/**
		 * Allows arena to control clock
		 */
		public function controlClock():void
		{
			//Clock set up
			if(_shootingClock == null)
			{
				_shootingClock = new Clock('time');
				_shootingClock.x = Settings.APPLICATION_WIDTH * .5;
				_shootingClock.y = 10;
				_shootingClock.start();
				addChild(_shootingClock);
			}
			else
			{
				_shootingClock.manuallySetClock(Settings.DEFAULT_CLOCK_TIME);
			}
			
			if(!_shootingClock.hasEventListener(Event.COMPLETE))  _shootingClock.addEventListener(Event.COMPLETE, shootingClockHandler, false, 0, true);
		}
		
		
		
		/**
		 * Stop clock (clock refers to the amount of time to shoot)
		 */
		public function stopShootingClock($flagOpp:Boolean):void
		{
			if(_shootingClock != null)	_shootingClock.stop();
			
			//Initiate world timer
			if($flagOpp)	TweenLite.delayedCall(Settings.DEFAULT_CLOCK_TIME, onWorldTimer);
		}
		
		
		
		/**
		 * Stop delayed call to the world timer (it refers to the amount of time one turn takes after a shot has been taken)
		 */
		public function killDelayedCallWorld():void
		{
			TweenLite.killDelayedCallsTo(onWorldTimer);
		}
		
		
		
		/**
		 * Stop delayed call to the world timer and finish turn
		 */
		public function stopWorldTimer():void
		{
			killDelayedCallWorld();
			_world.activeCannon.removeCannonball();
			
			//Finish turn
			onWorldTimer();
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------

		
		
		/**
		 * Event handler for ready button
		 * 
		 * @param $e :MouseEvent - MouseEvent.CLICK
		 */
		private function onReady($e:MouseEvent = null):void
		{
			var target:BasicButton = ($e.target as BasicButton);
			
			target.removeEventListener(MouseEvent.CLICK, onReady);
			
			target.label = 'Wait for opponent!';
			target.explicitWidth = 308;
			
			_sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExit, false, 0, true);

			if(!_isSpectator)
			{
				var update		:ISFSObject = new SFSObject();
				
				//If the other player has hit the ready button we are ready to start the game
				//Therefore we broadcast a reserved room variable to let everyone know the game has started
				if((_playerList[0] as SFSUser).isItMe)
				{
					if((_playerList[1] as SFSUser).getVariable(Settings.GAME_STATUS).getStringValue() == Settings.STATUS_IN_GAME)
						broadcastExtension(Settings.EXT_GAME + Settings.EXT_START, update);
				}
				else
				{
					if((_playerList[0] as SFSUser).getVariable(Settings.GAME_STATUS).getStringValue() == Settings.STATUS_IN_GAME)
						broadcastExtension(Settings.EXT_GAME + Settings.EXT_START, update);
				}
				
				//Tell everyone in the lobby I am now in game status
				_cc.setMyVars(Settings.STATUS_IN_GAME);
			}
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
			
			if( vars.indexOf(Settings.RV_CANNON) != -1)
			{
				obj	= room.getVariable(slot).getSFSObjectValue();
				
				var sender	:String	= obj.getUtfString('sender');
						
				if(sender != _myName)
				{
					//Simulate opponent's cannonball on my screen
					_world.activeCannon.oppShoot(obj.getDouble('posX'), obj.getDouble('ballPointX'), obj.getDouble('ballPointY'), obj.getDouble('dist'), obj.getDouble('angle'));
				}
			}
			else if (vars.indexOf(Settings.RV_TURN) != -1)
			{
				_playerTurn = room.getVariable(slot).getStringValue();
				
				_world.playerTurn = _playerTurn; //Switch turn int the world logic
				
				_world.stop();
				_world.reset();
				
				indicateTurn();
			}
		}
		

		
		/**
		 * onObjectMessage - Handles all room objects responses from SFS2X.
		 * Each object message contains the sender and the message itself
		 * Object messages run in separate threads on the server
		 * So far, direction update and shooting are object messages instead of extensions
		 * 
		 * @param $e :SFSEvent - SFSEvent.OBJECT_MESSAGE
		 */
		private function onObjectMessage($e:SFSEvent):void
		{
			var obj			:ISFSObject 	= $e.params.message as SFSObject,
				sender		:User 			= $e.params.sender,
				bool		:Boolean,
				num			:Number,
				turn		:SFSRoomVariable;

			if (obj.containsKey(Settings.OM_ASLEEP))
			{
				bool = obj.getBool(Settings.OM_ASLEEP);
				
				if(bool)
				{
					TweenLite.killDelayedCallsTo(onWorldTimer);

					turn = new SFSRoomVariable(Settings.RV_TURN, sender.name);
					_sfs.send( new SetRoomVariablesRequest( [ turn ] ) );
				}
			}
			else if (obj.containsKey(Settings.OM_CANNON_ANGLE))
			{
				num = obj.getFloat(Settings.OM_CANNON_ANGLE);
				
				_world.activeCannon.cannon.chamber.rotation = num;
				_world.activeCannon.cannon.chamber.gotoAndStop(2);
				
			}
			else if (obj.containsKey(Settings.OM_GAME_OVER))
			{
				bool = obj.getBool(Settings.OM_GAME_OVER);
				
				if(bool)
				{
					_shootingClock.stop();
					
					TweenLite.delayedCall(1, onGameOverTimer);
				}
			}
		}
		
		
		
		/**
		 * Once a user leaves a game, notify the other player
		 * 
		 * @param $e SFSEvent - SFSEvent.USER_EXIT_ROOM
		 */
		private function onUserExit($e:SFSEvent):void
		{
			_world.stop();
			_shootingClock.stop();
			
			_winGameOver = new WinGameOver();
			addChild(_winGameOver);
			
			(_p1Score.points > _p2Score.points)
			?
				_winGameOver.msg = 'Opponent has left the game. Winner is '+ _p1Score.playerName + ' with '+ _p1Score.points.toString()+' points!'
				:
				_winGameOver.msg = 'Opponent has left the game. Winner is '+ _p2Score.playerName + ' with '+ _p2Score.points.toString()+' points!';
			;
		}
		
		
		
		/**
		 * Keep track of score once a soldier has been killed
		 * 
		 * @param $e :CustomEvent - CustomEvent.SOLDIER_KILLED
		 */
		private function onSoldierKilled($e:CustomEvent):void
		{
			(_playerTurn == _world.p1.name) ? _p1Score.add() : _p2Score.add();
		}
		
		
		
		/**
		 * Game Over
		 * 
		 * @param $e :CustomEvent - CustomEvent.GAME_OVER
		 */
		private function onGameOver($e:CustomEvent):void
		{
			_world.stop();
			_shootingClock.stop();
			
			_sfs.removeEventListener(SFSEvent.USER_EXIT_ROOM, onUserExit);
			
			_winGameOver = new WinGameOver();
			addChild(_winGameOver);
			
			(_p1Score.points > _p2Score.points)
			?
				_winGameOver.msg = 'Winner is '+ _p1Score.playerName + ' with '+ _p1Score.points.toString()+' points!'
			:
				_winGameOver.msg = 'Winner is '+ _p2Score.playerName + ' with '+ _p2Score.points.toString()+' points!';
			
			var update:ISFSObject = new SFSObject();
			update.putBool(Settings.OM_GAME_OVER, true);
			
			if(update.size() > 0)	broadcastMessage(update);
		}
		
		
		
		/**
		 * Event handler for clock timer (time to shoot)
		 * 
		 * @param $e :Event - Event.TIMER_COMPLETE
		 */
		protected function shootingClockHandler($e:Event):void 
		{
			//Clock expired on the turn
			_world.timeExpired();
		}
		
		
		
		/**
		 * Event handler for opponent's screen to finish the game
		 */
		private function onGameOverTimer():void 
		{	
			_world.stop();
			_shootingClock.stop();
			
			_sfs.removeEventListener(SFSEvent.USER_EXIT_ROOM, onUserExit);
			
			_winGameOver = new WinGameOver();
			addChild(_winGameOver);
			
			(_p1Score.points > _p2Score.points)
			?
				_winGameOver.msg = 'Winner is '+ _p1Score.playerName + ' with '+ _p1Score.points.toString()+' points!'
			:
				_winGameOver.msg = 'Winner is '+ _p2Score.playerName + ' with '+ _p2Score.points.toString()+' points!';
			;
		}
		
		
		
		/**
		 * Event handler for world timer (it refers to the amount of time one turn takes after a shot has been taken)
		 */
		private function onWorldTimer():void 
		{
			if(_world != null)
				_world.timeExpired();
		}
		
		
		
		/**
		 * Event handler audio button click
		 * 
		 * @param $e :MouseEvent - MouseEvent.CLICK
		 */
		protected function onAudioClick($e:MouseEvent):void 
		{
			var target:Object = $e.currentTarget;
			
			(target.name == 'on') ? _buttonAudioOn.visible = false : _buttonAudioOn.visible = true;
			(_soundManager.volume == 1) ? _soundManager.volume = 0 : _soundManager.volume = 1;
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public function destroy():void
		{
			// Stop music
			_soundManager.stopSound('gameplay');
			_soundManager.fadeAllSounds();
			_soundManager = null;
			
			_cc.bg.visible = true;
			
			if (_sfs != null)
			{
				_sfs.removeEventListener(SFSEvent.ROOM_VARIABLES_UPDATE, onRoomVarUpdate);
				_sfs.removeEventListener(SFSEvent.OBJECT_MESSAGE, onObjectMessage);
				removeEventListener(CustomEvent.SOLDIER_KILLED, onSoldierKilled);
				removeEventListener(CustomEvent.GAME_OVER, onGameOver);
				_sfs.removeEventListener(SFSEvent.USER_EXIT_ROOM, onUserExit);
			}
			
			if (hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if(!_shootingClock.hasEventListener(Event.COMPLETE))  _shootingClock.removeEventListener(Event.COMPLETE, shootingClockHandler);
			
			_world.stop();
			_world.destroy();
			_world = null;
			
			while (this.numChildren)
			{
				var child:* = removeChildAt(0);
				if(!(child is TextField))
				{
					if(child.numChildren) 
					{
						if(child.numChildren > 0) 
						{
							if('destroy' in child)
							{
								child.destroy();
								child = null;
							}
						}
						
					}
				}
				child = null;
			}
			
			// Nullify global references to objects
			Settings.setGlobal('game_controller', null, _windowID);
			
			_shootingClock		= null;
			_assets				= null;
			_cc					= null;
			_gameRoom			= null;
			_windowID			= null;
			_updateObj			= null;
			_myName				= null;
			_winGameOver		= null;
			_playerList			= null;
			
			//Run GC
			flash.system.System.gc();
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get windowID():String { return _windowID; };
		public function set windowID($value:String):void { _windowID = $value; }
		
		public function get isSpectator():Boolean { return _isSpectator; };
		public function set isSpectator($value:Boolean):void { _isSpectator = $value; }
		
		public function get shootingClock():Clock { return _shootingClock; };
		public function set shootingClock($value:Clock):void { _shootingClock = $value; }
		
	}
}