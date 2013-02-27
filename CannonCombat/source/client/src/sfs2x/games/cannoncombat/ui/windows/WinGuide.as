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
	 * A window displaying a guide image as gameplay instruction
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
	
	public class WinGuide extends BasicWindow
	{
		private var
			_bg					:Bitmap,
			_panel				:Bitmap,
			_buttonContinue		:BasicButton;
		
			
			
		/**
		 * Constructor
		 * 
		 */
		public function WinGuide()
		{
			showClose = false;
		}
		

		
		/**
		 * Draw UI
		 */
		private function drawUI():void
		{
			//BG
			_bg = _assets.bg;
			_bg.width = Settings.APPLICATION_WIDTH;
			_bg.height = Settings.APPLICATION_HEIGHT;
			addChild(_bg);
			
			swapChildren(_bg, _title);//_title has been added by super class first
			
			//Panel
			_panel = _assets.guide_panel;
			addChild(_panel);
			
			swapChildren(_panel, _title);//_title has been added by super class first
			
			//Button
			_buttonContinue = new BasicButton(_windowID, 'CONTINUE','default_white_small', true, _assets.button_small_bg, _assets.button_small_bg);
			_buttonContinue.explicitWidth = 308;
			_buttonContinue.explicitHeight = 55;
			_buttonContinue.addEventListener(MouseEvent.CLICK, destroy, false, 0, true);
			addChild(_buttonContinue);
			
			
			//Positioning
			PositionUtils.center(_title, null, true);
			PositionUtils.offset(_title, 0, 224);
			
			PositionUtils.center(_panel, null, true, true);
			
			PositionUtils.center(_buttonContinue, null, true);
			PositionUtils.offset(_buttonContinue, 0, -168);
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
			
			title = 'GUIDE';
			_title.filters = [Settings.DROP_SHADOW_BOLD];
			
			drawUI();
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		override public function destroy($e:MouseEvent = null):void
		{
			_soundManager.playSound('pop');
			_buttonContinue.removeEventListener(MouseEvent.CLICK, destroy);
			
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