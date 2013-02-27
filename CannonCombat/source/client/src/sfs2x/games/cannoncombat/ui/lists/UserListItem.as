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
	 * UserListItem
	 * 
	 * An item that can appear in the user list to represent a player
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import com.smartfoxserver.v2.entities.User;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sfs2x.games.cannoncombat.SFSWrapper;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.events.CustomEvent;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.utils.TextUtils;

	public class UserListItem extends ListItem
	{
		private var
			_sfs			:SFSWrapper,
			_status			:TextField,
			_actionButton	:BasicButton,
			_statusVal		:String;
		
			
			
		/**
		 * Constructor
		 * 
		 * $windowID 	:String
		 * $label 		:String
		 */
		public function UserListItem($label:String, $windowID:String)
		{
			super($label, Settings.APPLICATION_WIDTH, 80);
			
			_windowID = $windowID;
			
			addEventListener(CustomEvent.DATA_SET, onDataSet, false, 0, true);
			
			_actionButton = new BasicButton(_windowID, 'Challenge', 'default_white_small', true, _assets.button_small_bg, _assets.button_small_bg);
			_actionButton.x = Settings.APPLICATION_WIDTH - _actionButton.width - 20;
			_actionButton.explicitWidth = 308;
			_actionButton.explicitHeight = 55;
			_actionButton.resetBg();
			_actionButton.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			addChild(_actionButton);
			
			_sfs = InstanceManager.getSFSInstance(_windowID).sfs();
		}
		

		
		/**
		 * Update status
		 */
		public override function updateStatus():void
		{
			var val:String = '';
			
			if(_status == null)
			{
				_status = TextUtils.createTextField();
				_status.mouseEnabled = false;
				_status.x = 360;
				_status.y = super._label.y;
				_status.filters = [Settings.DROP_SHADOW_BOLD];
				addChild(_status);
			}

			switch(_data['status'])
			{
				case Settings.STATUS_IN_LOBBY:
					val = 'In Lobby';
					break;
					
				case Settings.STATUS_IN_GAME:
					val = 'In Game';
					break;
			}
			_status.htmlText = '<span class="default_white_small">' + val + '</span>';			
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Handles option for the action button
		 * 
		 * @param $e :MouseEvent - MouseEvent.CLICK
		 */
		private function onClick($e:MouseEvent = null):void
		{
			_soundManager.playSound('pop');

			var invitee:User = _sfs.userManager.getUserByName(_label.text);
			
			if(invitee != null)
			{
				dispatchEvent(new CustomEvent(CustomEvent.CHALLENGE, true, false, invitee));
			}
			
			
		}
		
		
		
		/**
		 * On Data set
		 * 
		 * @param $e :CustomEvent
		 */
		protected function onDataSet($e:CustomEvent):void
		{
			updateStatus();
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public override function destroy():void
		{
			removeEventListener(CustomEvent.DATA_SET, onDataSet);
			
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