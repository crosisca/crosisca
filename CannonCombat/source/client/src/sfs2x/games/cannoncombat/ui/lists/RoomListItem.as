package sfs2x.games.cannoncombat.ui.lists
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
	 * RoomListItem
	 * 
	 * An item that can appear in the room list to represent a game room
	 * 
	 * @author 		Wayne Helman
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import com.smartfoxserver.v2.requests.JoinRoomRequest;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sfs2x.games.cannoncombat.SFSWrapper;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;

	public class RoomListItem extends ListItem
	{
		private var
			_sfs			:SFSWrapper,
			_status			:TextField,
			_actionButton	:BasicButton,
			_join			:BasicButton;
		
			
			
		/**
		 * Constructor
		 * 
		 * @param $windowID :String
		 * @param $label 	:String
		 */
		public function RoomListItem($windowID:String, $label:String)
		{
			super($label, Settings.APPLICATION_WIDTH, 80);
			
			_windowID = $windowID;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			
			_actionButton = new BasicButton(_windowID, 'Watch', 'default_white_small', true, _assets.button_small_bg, _assets.button_small_bg);
			_actionButton.x = Settings.APPLICATION_WIDTH - _actionButton.width - 20;
			_actionButton.explicitWidth = 308;
			_actionButton.explicitHeight = 55;
			_actionButton.resetBg();
			_actionButton.addEventListener(MouseEvent.CLICK, onAction, false, 0, true);
			
			addChild(_actionButton);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Added to stage handler
		 * 
		 * @param $e :Event
		 */
		private function onAdded($e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_sfs = InstanceManager.getSFSInstance(_windowID).sfs();
		}
		
		
		
		/**
		 * Handles option for the action button
		 * 
		 * @param $e :MouseEvent - MouseEvent.CLICK
		 */
		private function onAction($e:MouseEvent = null):void
		{
			var request:JoinRoomRequest = new JoinRoomRequest(this._data['name'], null, NaN, true);
			_sfs.send(request);
			
			_soundManager.playSound('pop');
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public override function destroy():void
		{
			if(_actionButton != null)
			{
				_actionButton.removeEventListener(MouseEvent.CLICK, onAction);
				_actionButton.destroy();
				removeChild(_actionButton);
				_actionButton = null;
				
			}
			while (this.numChildren)
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
			super.destroy();
		}
	}
}