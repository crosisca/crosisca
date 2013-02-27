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
	 * WinGameOver
	 * 
	 * A window displaying game over information
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sfs2x.games.cannoncombat.GameController;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.utils.PositionUtils;
	import sfs2x.games.cannoncombat.utils.TextUtils;

	public class WinGameOver extends BasicWindow
	{
		private var
			_button			:BasicButton,
			_msg			:TextField,
			_panel			:Bitmap;
			
		
			
		/**
		 * Constructor
		 */
		public function WinGameOver()
		{
			showClose = false;
			
			bgAlpha = 0;
			style = 'default_white';
		}
		

		
		/**
		 * Draw UI
		 */
		private function drawUI():void
		{
			title = 'Game Over';
			_title.filters = [Settings.DROP_SHADOW_BOLD];
			
			//Panel
			_panel = _assets.default_panel;
			addChild(_panel);
			
			var quitButton:BasicButton = new BasicButton(_windowID, 'RETURN TO LOBBY', 'default_white', true);
			quitButton.explicitWidth  = 308;
			quitButton.explicitHeight = 87;
			quitButton.addEventListener(MouseEvent.CLICK, onQuit, false, 0, true);
			addChild(quitButton);
			
			// Initialize message
			_msg = TextUtils.createTextField(true, true, 'center');
			_msg.width = 500;
			_msg.filters = [Settings.DROP_SHADOW_BOLD];
			addChild(_msg);
			
			//Positioning
			swapChildren(_panel, _title);
			
			PositionUtils.center(_panel, null, true, true);
			
			PositionUtils.center(_msg, null, true, true);
			PositionUtils.offset(_msg, 0, 50);
			
			PositionUtils.center(_title, null, true);
			PositionUtils.offset(_title, 0, 130);
			
			PositionUtils.center(quitButton, null, true);
			PositionUtils.offset(quitButton, 0, .8);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
	
		
		/**
		 * Event handler when object has been added to stage
		 * 
		 * @param $e :Event
		 */
		protected override function onAdded($e:Event):void
		{
			super.onAdded(null);
			
			drawUI();
		}
		
		
		
		/**
		 * Quit handler
		 * 
		 * @param $e :MouseEvent
		 */
		private function onQuit($e:MouseEvent):void
		{
			_soundManager.playSound('pop');
			
			var gc:GameController = (parent as GameController);
			gc.leaveGame();
		}
		
		
		
		/**
		 * Removes elements from memory
		 * 
		 * @param $e :MouseEvent
		 */
		override public function destroy($e:MouseEvent = null):void
		{
			while (this.numChildren)
			{
				var child:* = removeChildAt(0);
				
				if('destroy' in child)
				{
					child.destroy();
					child = null;
				}
			}
			super.destroy($e);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get msg():String { return _msg.text; };
		public function set msg($value:String):void 
		{
			_msg.htmlText = '<span class="default_white_small">' + $value + '</span>';
		}

	}
}