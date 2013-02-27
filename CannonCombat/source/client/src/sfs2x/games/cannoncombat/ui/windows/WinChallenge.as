package sfs2x.games.cannoncombat.ui.windows
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
	 * WinChallenge
	 * 
	 * A window displaying a message when a challenge happens
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.utils.PositionUtils;
	import sfs2x.games.cannoncombat.utils.TextUtils;
	
	public class WinChallenge extends BasicWindow
	{
		private var
			_sfs				:SmartFox,
			_objSFS				:ISFSObject,
			_obj				:Object,
			_msg				:TextField,
			_panel				:Bitmap,
			_button				:BasicButton,
			_buttonIgnore		:BasicButton;
		
			
		
		/**
		 * Constructor
		 * 
		 * @param $obj 	:Object
		 * @param $sfs 	:SmartFox
		 */
		public function WinChallenge($obj:Object = null, $sfs:SmartFox = null)
		{
			if($sfs != null) _sfs = $sfs;
			if($obj != null) _obj = $obj;
			
			showClose = false;
			
			bgAlpha = 0;
			style = 'default_white';
			
			if (_obj.invitation != null)
				_objSFS = _obj.invitation.params as SFSObject;
		}
		
		

		/**
		 * Draw UI
		 */
		private function drawUI():void
		{
			title = 'Challenge';
			_title.filters = [Settings.DROP_SHADOW_BOLD];
			
			//Panel
			_panel = _assets.default_panel;
			addChild(_panel);
			
			_msg = TextUtils.createTextField(true, true, 'center');
			_msg.width = Settings.APPLICATION_WIDTH *.5;
			_msg.filters = [Settings.DROP_SHADOW];
			addChild(_msg);

			_msg.htmlText = '<span class="default_white_small">You have requested a challenge with '+ _obj.invitee.name +'.<br>Wait for a reply!</span>';

			//Positioning
			swapChildren(_panel, _title);
			PositionUtils.center(_panel, null, true, true);
			PositionUtils.center(_msg, null, true, true);
			PositionUtils.offset(_msg, 0, 50);
			
			PositionUtils.center(_title, null, true, true);
			PositionUtils.offset(_title, 0, 130);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Event handler when object has been added to stage
		 * 
		 * @param $e Event - Event.ADDED_TO_STAGE
		 */
		protected override function onAdded($e:Event):void
		{
			super.onAdded(null);
			
			drawUI();
		}
		
		
		
		/**
		 * Removes elements from memory
		 *
		 * @param $e :MouseEvent - MouseEvent.CLICK
		 */
		override public function destroy($e:MouseEvent = null):void
		{
			while (this.numChildren)
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
			super.destroy($e);
		}

		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get message():TextField { return _msg; }
		public function set message($value:TextField):void { _msg = $value; }
		
	}
}