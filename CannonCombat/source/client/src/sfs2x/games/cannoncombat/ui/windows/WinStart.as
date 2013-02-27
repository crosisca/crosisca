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
	 * WinStart
	 * 
	 * A window to enter the game
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sfs2x.games.cannoncombat.CannonCombat;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.utils.PositionUtils;
	
	public class WinStart extends BasicWindow
	{
		private var
			_winGuide			:WinGuide,
			_winSettings		:WinSettings,
			_buttonPlay			:BasicButton,
			_buttonRules		:BasicButton,
			_buttonOptions		:BasicButton;
		
			
			
		/**
		 * Constructor
		 */
		public function WinStart()
		{
			showClose = false;
		}
		

		
		/**
		 * Draw UI
		 */
		private function drawUI():void
		{
			//Title as a bitmap
			_titleBg = _assets.title;
			addChild(_titleBg);
			
			_buttonPlay = new BasicButton(_windowID, 'PLAY GAME','default_white', true);
			_buttonPlay.explicitWidth = 308;
			_buttonPlay.explicitHeight = 87;
			_buttonPlay.name = 'PLAY';
			_buttonPlay.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			addChild(_buttonPlay);
			
			_buttonRules = new BasicButton(_windowID, '','default_white', true, _assets.button_rules_bg, _assets.button_rules_bg);
			_buttonRules.explicitWidth = 88;
			_buttonRules.explicitHeight = 91;
			_buttonRules.name = 'RULES';
			_buttonRules.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			addChild(_buttonRules);
			
			_buttonOptions = new BasicButton(_windowID, '','default_white', true, _assets.button_options_bg, _assets.button_options_bg);
			_buttonOptions.explicitWidth = 88;
			_buttonOptions.explicitHeight = 91;
			_buttonOptions.name = 'SETTINGS';
			_buttonOptions.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			addChild(_buttonOptions);
			
			//Positioning
			PositionUtils.center(_buttonPlay, null, true);
			PositionUtils.offset(_buttonPlay, 0, .52);
			PositionUtils.center(_buttonRules, null, true);
			PositionUtils.offset(_buttonRules, .35, .78);
			PositionUtils.center(_buttonOptions, null, true);
			PositionUtils.offset(_buttonOptions, .54, .78);
			
			PositionUtils.center(_titleBg, null, true);
			PositionUtils.offset(_titleBg, 0, .02);
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
		protected function onClick($e:MouseEvent = null):void
		{
			var target:Object = $e.currentTarget;

			_soundManager.playSound('pop');
			
			switch(target.name)
			{
				case 'PLAY':
					(parent as CannonCombat).initLobby();
					destroy($e);
				break;
				case 'RULES':
					_winGuide = new WinGuide();
					_winGuide.visible = true;
					_winGuide.windowID = this.windowID;
					addChild(_winGuide);
				break;
				case 'SETTINGS':
					_winSettings = new WinSettings();
					_winSettings.visible = true;
					_winSettings.windowID = this.windowID;
					addChild(_winSettings);
				break;
			}
		}
		
		
		
		/**
		 * Removes elements from memory
		 * 
		 * @param $e :MouseEvent - MouseEvent.CLICK
		 */
		override public function destroy($e:MouseEvent = null):void
		{
			_buttonPlay.removeEventListener(MouseEvent.CLICK, onClick);
			_buttonRules.removeEventListener(MouseEvent.CLICK, onClick);
			_buttonOptions.removeEventListener(MouseEvent.CLICK, onClick);
			
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