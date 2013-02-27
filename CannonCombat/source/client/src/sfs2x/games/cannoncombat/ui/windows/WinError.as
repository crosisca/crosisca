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
	 * WinError
	 * 
	 * A window displaying an error and information regarding the error
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.utils.PositionUtils;
	import sfs2x.games.cannoncombat.utils.TextUtils;
	
	public class WinError extends BasicWindow
	{
		private var
			_info		:Object			 = Settings.MSG_ERR_DEFAULT,
			_msg		:TextField,
			_button		:BasicButton,
			_panel		:Bitmap;
		
			
			
		/**
		 * Constructor
		 * 
		 * @param $info 	:Object
		 * @param $width 	:int
		 * @param $height 	:int
		 */
		public function WinError($info:Object = null, $width:int = 0, $height:int = 0)
		{
			_width = Settings.DEFAULT_WIN_WIDTH;
			_height = Settings.DEFAULT_WIN_HEIGHT;
			
			showClose = false;
			
			super($width, $height);
			
			bgAlpha = 0;
			style = 'default_white';
			
			if($info != null) _info = $info;
		}
		

		
		/**
		 * Draw UI
		 */
		private function drawUI():void 
		{
			title = _info['title'] + ' ';
			_title.filters = [Settings.DROP_SHADOW_BOLD];
			
			//Panel
			_panel = _assets.default_panel;
			addChild(_panel);
			
			_msg = TextUtils.createTextField(true, true, 'center');
			_msg.width = Settings.APPLICATION_WIDTH * .6;
			_msg.htmlText = '<span class="default_white_small">' + _info['msg'] +'</span>';
			_msg.filters = [Settings.DROP_SHADOW];
			addChild(_msg);
			
			_button = new BasicButton(_windowID, _info['buttonlabel'], 'default_white', true);
			_button.explicitWidth = 308;
			_button.explicitHeight = 87;
			_button.addEventListener(MouseEvent.CLICK, destroy, false, 0, true);
			addChild(_button);
			
			_soundManager.playSound('wahwah');
			
			//Positioning
			swapChildren(_panel, _title);
			
			PositionUtils.center(_panel, null, true, true);
			
			PositionUtils.center(_msg, null, true, true);
			
			PositionUtils.center(_title, null, true);
			PositionUtils.offset(_title, 0, 130);
			
			PositionUtils.center(_button, null, true);
			PositionUtils.offset(_button, 0, -144);
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
		 */
		override public function destroy($e:MouseEvent = null):void
		{
			_soundManager.playSound('pop');
			_button.removeEventListener(MouseEvent.CLICK, destroy);
			
			while (this.numChildren)
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
			super.destroy($e);
		}

	}
}