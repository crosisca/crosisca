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
	 * LobbyController
	 * 
	 * Controls creation, destruction, and management of lobbies and games
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
	import com.smartfoxserver.v2.requests.JoinRoomRequest;
	import com.smartfoxserver.v2.requests.PrivateMessageRequest;
	import com.smartfoxserver.v2.requests.PublicMessageRequest;
	import com.smartfoxserver.v2.requests.RoomEvents;
	import com.smartfoxserver.v2.requests.RoomExtension;
	import com.smartfoxserver.v2.requests.game.CreateSFSGameRequest;
	import com.smartfoxserver.v2.requests.game.InviteUsersRequest;
	import com.smartfoxserver.v2.requests.game.SFSGameSettings;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import sfs2x.games.cannoncombat.config.Assets;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.events.CustomEvent;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.managers.SoundManager;
	import sfs2x.games.cannoncombat.ui.elements.Background;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.ui.elements.ScrollableContent;
	import sfs2x.games.cannoncombat.ui.lists.BasicList;
	import sfs2x.games.cannoncombat.ui.lists.ChallengeListItem;
	import sfs2x.games.cannoncombat.ui.lists.RoomListItem;
	import sfs2x.games.cannoncombat.ui.lists.UserListItem;
	import sfs2x.games.cannoncombat.ui.windows.WinArena;
	import sfs2x.games.cannoncombat.ui.windows.WinChallenge;
	import sfs2x.games.cannoncombat.ui.windows.WinError;
	import sfs2x.games.cannoncombat.utils.PositionUtils;
	import sfs2x.games.cannoncombat.utils.TextUtils;

	public class LobbyController extends Sprite
	{
		private var
			_isInit							:Boolean			= false,	// Indicates whether the lobby is initialized
			
			_assets							:Assets,
			_sfs							:SmartFox,
			_windowID						:String 			= '',
			_soundManager					:SoundManager,
			
			_title							:TextField			= TextUtils.createTextField(),
			_bg								:Background,
			
			_mainMenuButton					:BasicButton,
			_userListButton					:BasicButton,
			_gamesListButton				:BasicButton,
			_chatButton						:BasicButton,
			_notificationButton				:BasicButton,
			
			_currentButton					:Object,
			_gameRoom						:Object,
			
			_topBar							:Bitmap,
			_bottomBar						:Bitmap,
			
			_userList						:BasicList,
			_userListContainer				:ScrollableContent,
			_roomList						:BasicList,
			_roomListContainer				:ScrollableContent,
			_notificationList				:BasicList,
			_notificationListContainer		:ScrollableContent,
			_chatLog						:TextField,
			_chatEntry						:TextField,
			_chatContent					:ScrollableContent,
			_chatContainer					:Sprite,
			
			_viewContainer					:Sprite,
			
			_winChallenge					:WinChallenge,
			_winArena						:WinArena,
			
			_form							:String;
			
			
			
		/**
		 * Constructor
		 */
		public function LobbyController($win:String)
		{
			_windowID = $win;
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		
		
		/**
		 * Event handler when object has been added to stage
		 * 
		 * @param $e :Event
		 */
		private function init($e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			_assets = InstanceManager.getAssetsInstance(_windowID);

			_soundManager = InstanceManager.getSoundManagerInstance(_windowID);
			
			_sfs = InstanceManager.getSFSInstance(_windowID).sfs();
			
			drawUI();
			
			populateRoomList();
			
			populateUserList();
			
			//Register events
			_sfs.addEventListener(SFSEvent.USER_ENTER_ROOM, onUserEnter, false, 0, true);
			_sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExit, false, 0, true);
			_sfs.addEventListener(SFSEvent.ROOM_ADD, onRoomAdded, false, 0, true);
			_sfs.addEventListener(SFSEvent.ROOM_REMOVE, onRoomRemoved, false, 0, true);
			_sfs.addEventListener(SFSEvent.ROOM_CREATION_ERROR, onRoomAddError, false, 0, true);
			_sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE, onPublicMsg, false, 0, true);
			_sfs.addEventListener(SFSEvent.INVITATION_REPLY, onInvitationReply, false, 0, true);
			_sfs.addEventListener(SFSEvent.INVITATION, onInvitationReceived, false, 0, true);
			_sfs.addEventListener(SFSEvent.INVITATION_REPLY_ERROR, onInvitationReplyError, false, 0, true);
			_sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserUpdate, false, 0, true);
			_sfs.addEventListener(SFSEvent.PRIVATE_MESSAGE, onPrivateMessage, false, 0, true);
			addEventListener(CustomEvent.CHALLENGE_ROOM, onChallengeRoom, false, 0, true);
			
			_currentButton = _userListButton;
			
			//Since user list is the default view, disable button and make view visible
			_userListButton.enabled = false;
			
			_userListContainer.visible = true;
			_roomListContainer.visible = false;
			_chatContainer.visible = false;
			_notificationListContainer.visible = false;
		}
		
		
		
		/**
		 * Draws the user interface
		 */
		private function drawUI():void
		{
			//White bg
			_bg = new Background(Settings.APPLICATION_WIDTH, Settings.APPLICATION_HEIGHT, .6, Settings.COLOR_BLACK);
			_bg.draw();
			addChild(_bg);
			
			//Top and bottom bars
			_topBar = _assets.blue_bar;
			_topBar.width = Settings.APPLICATION_WIDTH;
			_topBar.scaleY = _topBar.scaleX;
			addChild(_topBar);
			
			_bottomBar = _assets.blue_bar;
			_bottomBar.width = Settings.APPLICATION_WIDTH;
			_bottomBar.scaleY = _bottomBar.scaleX;
			_bottomBar.y = Settings.APPLICATION_HEIGHT - _bottomBar.height + 4;
			addChild(_bottomBar);
			
			//Title
			_title.htmlText = '<span class="default_white">Lobby </span>';
			_title.filters = [Settings.DROP_SHADOW_BOLD];
			addChild(_title);
			PositionUtils.center(_title, null, true);
			PositionUtils.offset(_title, 0, .01);
			
			_mainMenuButton = new BasicButton(_windowID, 'Main Menu', 'default_white_small', true, _assets.button_main_menu, _assets.button_main_menu_over);
			_mainMenuButton.explicitWidth = 207;
			_mainMenuButton.explicitHeight = 55;
			_mainMenuButton.addEventListener(CustomEvent.BUTTON_CLICK, onMenuClick, false, 0, true);
			addChild(_mainMenuButton);
			PositionUtils.offset(_mainMenuButton, .01, .005);
			
			//Container for selected view
			_viewContainer = new Sprite();
			//_viewContainer.width = Settings.APPLICATION_WIDTH;
			addChild(_viewContainer);
			PositionUtils.offset(_viewContainer, 0, .16);
			
			//Draw views and bottom menu
			drawRoomList();
			drawUserList();
			drawChatLog();
			drawChatEntry();
			drawNotificationList();
			
			drawBottomMenu();
			
			_isInit = true;
		}
		
		
		
		/**
		 * Draws the room list
		 */
		private function drawBottomMenu():void
		{
			var menuContainer:Sprite = new Sprite();
			
			addChild(menuContainer);
			
			_userListButton = new BasicButton(_windowID, 'User List', 'default_white_small', true, _assets.bottom_menu_left, _assets.bottom_menu_left_over);
			_userListButton.x = 120;
			_userListButton.explicitWidth = 275;
			_userListButton.explicitHeight = 52;
			_userListButton.addEventListener(CustomEvent.BUTTON_CLICK, onMenuClick, false, 0, true);

			_gamesListButton = new BasicButton(_windowID, 'Current Games', 'default_white_small', true, _assets.bottom_menu_center, _assets.bottom_menu_center_over);
			_gamesListButton.x = _userListButton.width + _userListButton.x;
			_gamesListButton.explicitWidth = 277;
			_gamesListButton.explicitHeight = 52;
			_gamesListButton.addEventListener(CustomEvent.BUTTON_CLICK, onMenuClick, false, 0, true);
			
			_chatButton = new BasicButton(_windowID, 'Public Chat', 'default_white_small', true, _assets.bottom_menu_right, _assets.bottom_menu_right_over);
			_chatButton.x = _gamesListButton.width + _gamesListButton.x;
			_chatButton.explicitWidth = 278;
			_chatButton.explicitHeight = 52;
			_chatButton.addEventListener(CustomEvent.BUTTON_CLICK, onMenuClick, false, 0, true);
			
			_notificationButton = new BasicButton(_windowID, '!', 'default_white_small', true, _assets.button_notification, _assets.button_notification_over);
			_notificationButton.explicitWidth = 80;
			_notificationButton.explicitHeight = 52;
			_notificationButton.addEventListener(CustomEvent.BUTTON_CLICK, onMenuClick, false, 0, true);
			
			menuContainer.addChild(_userListButton);
			menuContainer.addChild(_gamesListButton);
			menuContainer.addChild(_chatButton);
			menuContainer.addChild(_notificationButton);
			
			menuContainer.width = Settings.APPLICATION_WIDTH - 60;
			menuContainer.scaleY = menuContainer.scaleX;
			PositionUtils.offset(menuContainer, .03, .9);
		}
		
		
		
		/**
		 * Draws the user list
		 */
		private function drawUserList():void
		{
			var w		:int 	= Settings.APPLICATION_WIDTH,
				h		:int 	= Settings.APPLICATION_HEIGHT - 146;
			
			_userList = new BasicList();
			_userList.sortOn = ['name'];
			_userList.sortOrder = [ Array.CASEINSENSITIVE ];
			_userList.addEventListener(Event.COMPLETE, resetUserList, false, 0, true);
			
			_userListContainer = new ScrollableContent(w, h);
			_userListContainer.x = 2;
			_userListContainer.y = 2;
			_userListContainer.content.addChild(_userList);
			_userListContainer.init();
			
			_userListContainer.addEventListener(CustomEvent.CHALLENGE, onChallenge, false, 0, true);
			
			_viewContainer.addChild(_userListContainer);
		}
		
		
		
		/**
		 * Draws the room list
		 */
		private function drawRoomList():void
		{
			var w			:int 	= Settings.APPLICATION_WIDTH,
				h			:int 	= Settings.APPLICATION_HEIGHT - 146;
			
			_roomList = new BasicList();
			_roomList.sortOn = ['name'];
			_roomList.sortOrder = [ Array.CASEINSENSITIVE ];
			_roomList.addEventListener(Event.COMPLETE, resetRoomList, false, 0, true);
			
			_roomListContainer = new ScrollableContent(w, h);
			_roomListContainer.x = 2;
			_roomListContainer.y = 2;
			_roomListContainer.content.addChild(_roomList);
			_roomListContainer.init();
			
			_viewContainer.addChild(_roomListContainer);
		}
		
		
		
		/**
		 * Draws the chat log
		 */
		private function drawChatLog():void
		{
			//chat background
			var w			:int 	= Settings.APPLICATION_WIDTH,
				h			:int 	= Settings.APPLICATION_HEIGHT - 146;
			
			_chatContainer = new Sprite();
			
			//chat entry textfield
			_chatLog = TextUtils.createTextField(true, true);
			_chatLog.selectable = true;
			_chatLog.width = w;
			_chatLog.htmlText = '<p class="chat_orange_bold">[' + _sfs.mySelf.name + '] joined the room...</p>';
			
			//chat scrolling container
			_chatContent = new ScrollableContent(w - 8, h - 60);
			_chatContent.content.addChild(_chatLog);
			_chatContent.init();
			
			_viewContainer.addChild(_chatContainer);
			_chatContainer.addChild(_chatContent);
			_chatContainer.name = 'chatView';
		}
		
		
		
		/**
		 * Draws the chat entry area
		 */
		private function drawChatEntry():void
		{
			var w			:int 	= Settings.APPLICATION_WIDTH - 34,
				h			:int 	= Settings.APPLICATION_HEIGHT - 146,
				border		:Sprite = new Sprite();
			
			_chatEntry = TextUtils.createInputTextField('.chat_default');
			_chatEntry.width = w - 12;
			_chatEntry.height = 22;
			_chatEntry.x = 18;
			PositionUtils.offset(_chatEntry, 0, -60);
			_chatEntry.addEventListener(FocusEvent.FOCUS_IN, enableEnter, false, 0, true);
			
			border = TextUtils.drawInputBox(_chatEntry.x,_chatEntry.y + 2,_chatEntry.width,_chatEntry.height,8);
			
			_chatContainer.addChild(border);
			_chatContainer.addChild(_chatEntry);
		}
		
		
		
		/**
		 * Draws the user list
		 */
		private function drawNotificationList():void
		{
			var w		:int 	= Settings.APPLICATION_WIDTH - 34,
				h		:int 	= Settings.APPLICATION_HEIGHT - 146;
			
			_notificationList = new BasicList();
			_notificationList.sortOn = ['name'];
			_notificationList.sortOrder = [ Array.CASEINSENSITIVE ];
			_notificationList.addEventListener(Event.COMPLETE, resetUserList, false, 0, true);
			
			_notificationListContainer = new ScrollableContent(w, h);
			_notificationListContainer.x = 2;
			_notificationListContainer.y = 2;
			_notificationListContainer.content.addChild(_notificationList);
			_notificationListContainer.init();
			
			_viewContainer.addChild(_notificationListContainer);
		}
		
		
		
		/**
		 * Populates Room List (all game rooms)
		 */
		public function populateRoomList():void
		{
			//List rooms available at the beginning (Lobby)
			var roomList	:Array 	= _sfs.getRoomListFromGroup('games');
			
			for each(var gameroom:Room in roomList)
			{
				var r			:RoomListItem 	= new RoomListItem(_windowID, gameroom.name);
				
				r.data = {name: gameroom.name};
				_roomList.addItem(r);
			} 
			
			_roomList.update();
			_roomListContainer.reset();
		}
		
		
		
		/**
		 * Populates User List
		 */
		public function populateUserList():void
		{
			//List users available at the beginning (Lobby)
			var userList	:Array,
				room		:Room 	= _sfs.getRoomByName(Settings.SFS2X_LOBBY);
			
			userList = room.userList;
			
			for each(var user:User in userList)
			{
				var u			:UserListItem 	= new UserListItem(user.name ,_windowID);

				if (user.isItMe) continue;
				u.data = {name: user.name, user: user.id, status: user.getVariable(Settings.GAME_STATUS).getStringValue()};
				
				_userList.addItem(u);
			} 
			
			_userList.update();
			_userListContainer.reset();	
		}
		
		
		
		/**
		 * Removes challenge from list
		 */
		public function removeChallenge($name:String):void
		{
			_notificationList.removeItem('name', $name);
			_notificationListContainer.reset();
			
			if(_notificationList.items.length == 0)	_notificationButton.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
		}
			
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		

		/**
		 * Handles option for bottom menu
		 * 
		 * @param $e :MouseEvent - MouseEvent.CLICK
		 */
		private function onMenuClick($e:CustomEvent = null):void
		{
			_soundManager.playSound('pop');
			
			var target:* = $e.target;
		
			if(_currentButton != null)
				_currentButton.enabled = true;

			_currentButton = target;
			_currentButton.enabled = false;
			
			_userListContainer.visible = false;
			_roomListContainer.visible = false;
			_chatContainer.visible = false;
			_notificationListContainer.visible = false;

			switch(target.name)
			{
				case 'USER LIST':
					_userListContainer.visible = true;
				break;
				case 'CURRENT GAMES':
					_roomListContainer.visible = true;
				break;
				case 'PUBLIC CHAT':
					_chatContainer.visible = true;
				break;
				case 'MAIN MENU':
					(parent as CannonCombat).destroyLobby();
				break;
				case '!':
					_notificationListContainer.visible = true;
				break;
			}
		}
		
		
		
		/**
		 * Reset user list upon complete event
		 * 
		 * @param $e :Event - Event.COMPLETE
		 */
		private function resetUserList($e:Event = null):void
		{
			_userListContainer.reset();
			_userList.removeEventListener(Event.COMPLETE, resetUserList);
		}
		
		
		
		/**
		 * Reset room list upon complete event
		 * 
		 * @param $e :Event - Event.COMPLETE
		 */
		private function resetRoomList($e:Event = null):void
		{
			_roomListContainer.reset();
			_roomList.removeEventListener(Event.COMPLETE, resetRoomList);
		}
		
		
		
		/**
		 * Reset room list upon complete event
		 * 
		 * @param $e :Event - Event.COMPLETE
		 */
		private function resetNotificationList($e:Event = null):void
		{
			_notificationListContainer.reset();
			_notificationList.removeEventListener(Event.COMPLETE, resetNotificationList);
		}
		
		
		
		/**
		 * Adds a new room when an invitation ACCEPT event is fired
		 * 
		 * @param $e 
		 */
		private function addRoom($inviter:User, $invitee:User):void
		{
			var settings	:SFSGameSettings 	= new SFSGameSettings($inviter.name),
				msgObj		:ISFSObject			= new SFSObject(),
				events		:RoomEvents			= new RoomEvents();
			
			events.allowUserVariablesUpdate = true;
			events.allowUserExit = true;
			events.allowUserEnter = false;
			events.allowUserCountChange = true;

			//Make sure p1 is the invitee
			(parent as CannonCombat).p1 = $invitee;
			(parent as CannonCombat).p2 = $inviter;
			
			//Decide if room creator starts or not
			var coin	:Number = Math.random(),
				update	:ISFSObject = new SFSObject(),
				turn	:SFSRoomVariable;
			
			(coin < .5) ? turn = new SFSRoomVariable(Settings.RV_TURN, $inviter.name) : turn = new SFSRoomVariable(Settings.RV_TURN, $invitee.name);
			
			settings.name = $inviter.name +'_vs_'+$invitee.name;
			settings.maxVariables = 7;
			settings.notifyGameStarted = false;
			settings.maxUsers = 2;
			settings.maxSpectators = 1000;
			settings.isPublic = true;
			settings.minPlayersToStartGame = 2;
			settings.isGame = true;
			settings.groupId = 'games';
			settings.leaveLastJoinedRoom = true;
			settings.events = events;
			settings.extension = new RoomExtension('CannonCombat', 'sfs2x.extensions.games.cannoncombat.CannonCombatGameExtension');
			settings.variables = [new SFSRoomVariable(Settings.RV_CANNON, new SFSObject()), turn];
			
			var request:CreateSFSGameRequest = new CreateSFSGameRequest(settings);
			_sfs.send(request);
		}
		
		
		
		/**
		 * Handles 'room add' events from SmartFoxServer
		 * 
		 * @param $e :SFSEvent - SFSEvent.ROOM_ADD
		 */
		private function onRoomAdded($e:SFSEvent):void
		{
			var room	:Room 			= $e.params.room,
				item	:RoomListItem	= new RoomListItem(_windowID, room.name);

			item.data = {name: room.name};
			
			_roomList.addItem(item);
			_roomList.update();
				
			_roomListContainer.reset();	
		}
		
		
		
		/**
		 * Handles 'room remove' events from SmartFoxServer
		 * 
		 * @param $e :SFSEvent - SFSEvent.ROOM_REMOVE
		 */
		private function onRoomRemoved($e:SFSEvent):void
		{
			var room		:Room 		= $e.params.room;
			
			_roomList.removeItem('name', room.name);
			_roomList.update();
			
			_roomListContainer.reset();	
		}
		
		
		
		/**
		 * Handles 'room creation error' events from SmartFoxServer
		 * 
		 * @param $e :SFSEvent - SFSEvent.ROOM_CREATION_ERROR
		 */
		private function onRoomAddError($e:SFSEvent):void
		{
			var msgObject	:Object 	= (Settings.DEBUG) ? {title:'Room Add Error',msg:$e.params.errorMessage,buttonlabel:'OK'} : Settings.MSG_ERR_ROOMADD,
				errorWin	:WinError 	= new WinError(msgObject);
			
			errorWin.addEventListener(Event.REMOVED_FROM_STAGE, destroyErrorWin, false, 0, true);
			addChild(errorWin);
		}

		

		/**
		 * Handles 'user enter room' events from SmartFoxServer
		 * 
		 * @param $e :SFSEvent - SFSEvent.USER_ENTER_ROOM
		 */
		private function onUserEnter($e:SFSEvent):void
		{
			var user			:User 			= $e.params.user,
				obj				:ISFSObject 	= $e.params.params as SFSObject,
				validateName	:Boolean 		= false;
			
			if (user.isItMe) return;

			var usernames	:Array 	= _userList.items,
				num			:int	= usernames.length;
			
			//Loop through our list (by name) and only add a new item if it doesn't exist
			for(var i:int = 0; i < num; i++)
			{
				var name	:String 	= usernames[i].data.name;

				if(name == user.name) validateName = true;
			}

			if(_sfs.mySelf.name == user.name) validateName = true;
			
			if(!validateName)
			{
				var uname		:String			= user.name,
					item		:UserListItem 	= new UserListItem(uname, _windowID);
				
				item.data = { name: uname, user: user.id, status: user.getVariable(Settings.GAME_STATUS).getStringValue() };
				_userList.addItem(item, true);
			}
			
			_userListContainer.reset();
			
			if (uname != null) _chatLog.htmlText += '<p class="chat_orange_bold">' + uname + ' has joined ...</p>';
			_chatContent.reset(true, false);
		}
		
		
		
		/**
		 * Remove user from room
		 * 
		 * @param $e SFSEvent - SFSEvent.USER_EXIT_ROOM
		 */
		private function onUserExit($e:SFSEvent):void
		{
			var user			:User 			= $e.params.user,
				room			:Room 			= $e.params.room;
			
			if (room.name != 'lobby' || user.isItMe) return;

			var usernames	:Array 	= _userList.items,
				num			:int	= usernames.length;
			
			// Find the player in the user list and remove it
			for(var i:int = 0;i < num; i++)
			{
				var userItem:UserListItem = _userList.getItemByProperty('name', user.name) as UserListItem;
				
				if(userItem != null)
				{
					if(userItem.data['name'] == user.name)
					{
						_userList.removeItem('name', user.name);
					}
				}
				
			}
			_userList.update();
			_userListContainer.reset();	
		}
		
		
		
		/**
		 * Handles 'user variables update' events from SmartFoxServer
		 * 
		 * @param $e :SFSEvent - SFSEvent.USER_VARIABLES_UPDATE
		 */
		private function onUserUpdate($e:SFSEvent):void
		{
			var user		:User 		= $e.params.user,
				vars		:Array 		= $e.params.changedVars;
			
			if(vars.indexOf(Settings.GAME_STATUS) != -1)
			{
				var item:UserListItem = _userList.getItemByProperty('name', user.name) as UserListItem;

				if (item != null)
				{
					item.data.status = user.getVariable(Settings.GAME_STATUS).getStringValue();
					item.updateStatus();
				}
			}
		}	
		
		
		
		/**
		 * Sends public messages when button is clicked
		 * 
		 * @param $e :MouseEvent - MouseEvent.CLICK
		 */
		private function sendPublicMsg($e:MouseEvent = null):void
		{
			_soundManager.playSound('pop');
			if(_chatEntry.text == '') return;
				
			var request:PublicMessageRequest = new PublicMessageRequest(_chatEntry.text);
			_sfs.send(request);

			_chatEntry.text = '';
		}
		
		
		
		/**
		 * Handles 'public message' events from SmartFoxServer
		 * 
		 * @param $e :SFSEvent - SFSEvent.PUBLIC_MESSAGE
		 */
		private function onPublicMsg($e:SFSEvent):void
		{
			_soundManager.playSound('pop');
			
			var sender		:User 		= $e.params.sender,
				msg			:String 	= $e.params.message;
			
			_chatLog.htmlText += '<span class="chat_orange_bold">' + sender.name + ': </span>';
			_chatLog.htmlText += '<p class="chat_default">' + msg + '</p>';
			
			_chatContent.reset(true, false);
		}
		
		
		
		/**
		 * Handles challenge click on a userListItem
		 * 
		 * @param $e :CustomEvent - CustomEvent.CHALLENGE
		 */
		private function onChallenge($e:CustomEvent = null):void
		{
			_gameRoom = {};
			_gameRoom.invitee = $e.arg[0];
			
			_winArena = new WinArena();
			addChild(_winArena);
		}
		
		
		
		/**
		 * Challenger has selected arena
		 * 
		 * @param $arena :int - Index of arena in the list
		 */
		public function onArenaSelected($arena:int):void
		{
			var obj		:Object = {};	

			(parent as CannonCombat).onArenaSelected($arena);
			
			// Send the invitation; recipients have 10 seconds to reply before the invitation expires
			var update:ISFSObject = new SFSObject();
			update.putInt('arena',$arena); 

			_sfs.send(new InviteUsersRequest([_gameRoom.invitee], 10, update));
			
			obj.invitee = _gameRoom.invitee;
			
			_winChallenge = new WinChallenge(obj, _sfs);
			addChild(_winChallenge);
		}
		
		
		
		/**
		 * Handles internal event to create a room if the invitee accepted invitation
		 * 
		 * @param $e :CustomEvent - CustomEvent.CHALLENGE_ROOM
		 */
		private function onChallengeRoom($e:CustomEvent = null):void
		{
			//Invitee creates the room if invitation was accepted
			addRoom($e.arg[0], $e.arg[1]);
		}

		
		
		/**
		 * Listens for an invitation
		 * 
		 * @param $e :SFSEvent
		 */
		private function onInvitationReceived($e:SFSEvent):void
		{
			var obj		:Object		= $e.params;
			
			var uname		:String				= obj.invitation.inviter.name,
				id			:int				= obj.invitation.inviter.id,
				item		:ChallengeListItem 	= new ChallengeListItem(uname, _windowID);
			
			item.data = { name: uname, user: id , invitation: obj.invitation };
			
			var update:ISFSObject = new SFSObject();
			(parent as CannonCombat).onArenaSelected(update.getInt('arena')); 
			
			_notificationList.addItem(item, true);
			_notificationListContainer.reset();
			
			_notificationButton.blinkNotification();
			_soundManager.playSound('notice');
		}
		
		
		
		/**
		 * Listens for an invitation reply
		 * 
		 * @param $e :SFSEvent
		 */
		private function onInvitationReply($e:SFSEvent):void
		{
			if ($e.params.reply == InvitationReply.ACCEPT)
			{
				_winChallenge.destroy();
				_winChallenge = null;
				
				var objSFS:ISFSObject = new SFSObject();
				objSFS = $e.params.data;
				
				_sfs.send(new JoinRoomRequest(objSFS.getUtfString('room_name')));
			}
			else 
			{
				if(!$e.params.invitee.isItMe)
				{
					var msg:String;
					
					($e.params.reply == 255) ? msg = ' did not reply in time!' : msg = ' refused the invitation!';
						
					_winChallenge.message.htmlText = '<span class="default_white_small">' + $e.params.invitee.name + msg + '</span>';
						
					var myTimer:Timer = new Timer(2000, 1);
					myTimer.addEventListener('timer', timerHandler, false, 0, true);
					myTimer.start();
					
					//Dispatch a private message back to the invitee to remove the challenge from the notification list on the invitee screen
					//Message cannot be empty, but it can be the space character
					var request:PrivateMessageRequest = new PrivateMessageRequest(' ', ($e.params.invitee as User).id);
					_sfs.send(request);
				}
				else
				{
					
				}
			}
		}
		
		
		
		/**
		 * Listens for an invitation reply
		 * 
		 * @param $e :SFSEvent
		 */
		private function onPrivateMessage($e:SFSEvent):void
		{
			var sender:User = $e.params.sender;

			if (sender != _sfs.mySelf)
			{
				removeChallenge(sender.name);
			}
		}
		
		
		
		/**
		 * Event handler for invitation reply error
		 * 
		 * @param $e :SFSEvent
		 */
		private function onInvitationReplyError($e:SFSEvent):void
		{
			trace("Failed to reply to invitation due to the following problem: " + $e.params.errorMessage, ' | ', _windowID);
		}
		
		
		
		/**
		 * Event handler for a timer to reply for an invitation
		 * 
		 * @param $e :TimerEvent
		 */
		protected function timerHandler($e:TimerEvent):void 
		{
			$e.currentTarget.removeEventListener('timer', timerHandler);
			
			_winChallenge.destroy();
			_winChallenge = null;
		}
		

		
		/**
		 * Focus Event handler
		 * 
		 * @param $e :FocusEvent - FocusEvent.FOCUS_IN
		 */
		private function enableEnter($e:FocusEvent):void
		{
			_form = $e.currentTarget.name.toString();

			if(!this.hasEventListener(KeyboardEvent.KEY_UP))
			{
				addEventListener(KeyboardEvent.KEY_UP, handleKeyPress, false, 0, true);
			}
		}
		
		
		
		/**
		 * Keyboard Event handler
		 * 
		 * @param $e :KeyboardEvent - KeyboardEvent.KEY_UP
		 */
		private function handleKeyPress($e:KeyboardEvent = null):void
		{
			if($e.keyCode === Keyboard.ENTER) 
			{
				if(_form == _chatEntry.name.toString()) sendPublicMsg();
			}
		}
		
		
		
		/**
		 * Removes the error window from the stage and destroys it
		 * 
		 * @param $e :Event - Event.REMOVED_FROM_STAGE
		 */
		private function destroyErrorWin($e:Event):void
		{
			var child:DisplayObject = $e.currentTarget as DisplayObject;
			if(child.hasEventListener(Event.REMOVED_FROM_STAGE))
			{
				child.removeEventListener(Event.REMOVED_FROM_STAGE, destroyErrorWin);
			}
			child = null;
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public function destroy():void
		{
			if (_sfs != null)
			{
				_sfs.removeEventListener(SFSEvent.USER_ENTER_ROOM, onUserEnter);
				_sfs.removeEventListener(SFSEvent.USER_EXIT_ROOM, onUserExit);
				_sfs.removeEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserUpdate);
				_sfs.removeEventListener(SFSEvent.ROOM_ADD, onRoomAdded);
				_sfs.removeEventListener(SFSEvent.ROOM_CREATION_ERROR, onRoomAddError);
				_sfs.removeEventListener(SFSEvent.ROOM_REMOVE, onRoomRemoved);
				_sfs.removeEventListener(SFSEvent.PUBLIC_MESSAGE, onPublicMsg);
				_sfs.removeEventListener(SFSEvent.INVITATION_REPLY, onInvitationReply);
				_sfs.removeEventListener(SFSEvent.INVITATION, onInvitationReceived);
				_sfs.removeEventListener(SFSEvent.INVITATION_REPLY_ERROR, onInvitationReplyError);
				_sfs.removeEventListener(SFSEvent.PRIVATE_MESSAGE, onPrivateMessage);
				
				if(_userListContainer != null)
				{
					_userListContainer.removeEventListener(CustomEvent.CHALLENGE, onChallenge);
					_userListContainer.destroy();
				}
				
				removeEventListener(CustomEvent.CHALLENGE_ROOM, onChallengeRoom);
				
				if(_chatButton != null)
				{
					_chatButton.removeEventListener(MouseEvent.CLICK, sendPublicMsg);
					_chatButton.removeEventListener(CustomEvent.BUTTON_CLICK, onMenuClick);
					_chatButton.destroy();
				}
				
				if(_chatEntry != null)	_chatEntry.removeEventListener(FocusEvent.FOCUS_IN, enableEnter);
				
				if (this.hasEventListener(KeyboardEvent.KEY_UP))
					removeEventListener(KeyboardEvent.KEY_UP, handleKeyPress);
				
				_userListButton.removeEventListener(CustomEvent.BUTTON_CLICK, onMenuClick);
				_gamesListButton.removeEventListener(CustomEvent.BUTTON_CLICK, onMenuClick);
				_mainMenuButton.removeEventListener(CustomEvent.BUTTON_CLICK, onMenuClick);
				_notificationButton.removeEventListener(CustomEvent.BUTTON_CLICK, onMenuClick);
				
				_notificationList.removeEventListener(Event.COMPLETE, resetNotificationList);
				
				if(_userList != null)
				{
					_userList.removeEventListener(Event.COMPLETE, resetUserList);
					_userList.destroy();
				}
				
				if(_roomList != null)
				{
					_roomList.removeEventListener(Event.COMPLETE, resetRoomList);
					_roomList.destroy();
					_roomListContainer.destroy();
				}
				
				if(_chatContent != null)
				{
					_chatContent.destroy();
				}
				
				
				_isInit = false;
				
				var bmpData:BitmapData,
					child:*,
					grandChild:*;
				
				if(_viewContainer != null)
				{
					while (_viewContainer.numChildren)
					{
						child = _viewContainer.removeChildAt(0);
						if (child is Bitmap)
						{
							bmpData = (child as Bitmap).bitmapData;
							bmpData.dispose();
						}
						else if(child is DisplayObjectContainer) 
						{
							if(child.numChildren > 0) 
							{
								while (child.numChildren)
								{
									grandChild = child.removeChildAt(0);
									if (grandChild is Bitmap)
									{
										bmpData = (grandChild as Bitmap).bitmapData;
										bmpData.dispose();
									}
									if('destroy' in grandChild) grandChild.destroy();
									grandChild = null;
								}
							}
						}
						if('destroy' in child) child.destroy();
						child = null;
					}
				}
				
				
				while (this.numChildren)
				{
					child = removeChildAt(0);
					if (child is Bitmap)
					{
						bmpData = (child as Bitmap).bitmapData;
						bmpData.dispose();
					}
					else if(child is DisplayObjectContainer) 
					{
						if(child.numChildren > 0) 
						{
							while (child.numChildren)
							{
								grandChild = child.removeChildAt(0);
								if (grandChild is Bitmap)
								{
									bmpData = (grandChild as Bitmap).bitmapData;
									bmpData.dispose();
								}
								if('destroy' in grandChild) grandChild.destroy();
								grandChild = null;
							}
						}
					}
					if('destroy' in child) child.destroy();
					child = null;
				}
				
				bmpData = null;
				
				_windowID			= null;
				_userList			= null;
				_userListContainer	= null;
				_roomList			= null;
				_roomListContainer	= null;
				_assets				= null;
				_viewContainer		= null;
				_chatLog			= null;
				_chatEntry			= null;
				_chatButton			= null;
				_chatContent		= null;
				_form				= null;
				
			}
		}

		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get windowID():String { return _windowID; }
		
		public function get roomList():BasicList { return _roomList; };
		public function set roomList($value:BasicList):void { _roomList = $value; }
		
	}
}