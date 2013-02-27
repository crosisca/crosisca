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
	 * ChallengeListItem
	 * 
	 * An item that can appear in the challenge list (notification list) to represent a player challenge
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.requests.game.InvitationReplyRequest;
	
	import flash.events.MouseEvent;
	
	import sfs2x.games.cannoncombat.SFSWrapper;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.events.CustomEvent;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.utils.PositionUtils;

	public class ChallengeListItem extends ListItem
	{
		private var
			_obj			:Object = {},
			_sfs			:SFSWrapper,
			_acceptButton	:BasicButton,
			_denyButton		:BasicButton;
		
			
			
		/**
		 * Constructor
		 * 
		 * $label 		:String
		 * $windowID 	:String
		 */
		public function ChallengeListItem($label:String, $windowID:String)
		{
			super($label + ' challenged you', Settings.APPLICATION_WIDTH, 80);
			
			_windowID = $windowID;
			
			_acceptButton = new BasicButton(_windowID, '', 'default_white_small', true, _assets.button_accept, _assets.button_accept);
			_acceptButton.name = 'accept';
			_acceptButton.explicitWidth = 52;
			_acceptButton.explicitHeight = 55;
			_acceptButton.resetBg();
			_acceptButton.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			addChild(_acceptButton);
			
			_denyButton = new BasicButton(_windowID, '', 'default_white_small', true, _assets.button_deny, _assets.button_deny);
			_denyButton.name = 'deny';
			_denyButton.explicitWidth = 52;
			_denyButton.explicitHeight = 55;
			_denyButton.resetBg();
			_denyButton.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			addChild(_denyButton);
			
			_sfs = InstanceManager.getSFSInstance(_windowID).sfs();
			
			//Positioning
			PositionUtils.offset(_acceptButton, .81);
			PositionUtils.offset(_denyButton, .9);
		}
		

		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Handles option for the action button (accept or deny)
		 * 
		 * @param $e :MouseEvent - MouseEvent.CLICK
		 */
		private function onClick($e:MouseEvent = null):void
		{
			var target:Object = $e.currentTarget;
			
			_soundManager.playSound('pop');
			
			if(target.name == 'deny')
			{
				_sfs.send(new InvitationReplyRequest(_data.invitation, InvitationReply.REFUSE));
			}
			else if(target.name == 'accept')
			{
				var objSFS:ISFSObject = new SFSObject as ISFSObject;
				
				//Save the game room name to be sent to the inviter
				objSFS.putUtfString('room_name', _data.invitation.inviter.name +'_vs_'+_data.invitation.invitee.name);
				
				//Propagate event to the lobby to create the room (invitee is the owner)
				dispatchEvent(new CustomEvent(CustomEvent.CHALLENGE_ROOM, true, false, _data.invitation.inviter, _data.invitation.invitee));
				
				//Send invitation reply back to the inviter
				_sfs.send(new InvitationReplyRequest(_data.invitation, InvitationReply.ACCEPT, objSFS));
			}
			
			destroy();
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public override function destroy():void
		{
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