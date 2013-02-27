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
	 * A window displaying options to change settings for the game
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.core.FlexGlobals;
	
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.utils.PositionUtils;
	import sfs2x.games.cannoncombat.utils.TextUtils;
	
	import spark.components.ToggleSwitch;
	import spark.components.View;
	import spark.components.ViewNavigator;
	
	public class WinSettings extends BasicWindow
	{
		private var
			_bg					:Bitmap,
			_panel				:Bitmap,
			_txtAudio			:TextField,
			_toggleAudio		:ToggleSwitch,
			_buttonSave			:BasicButton;
		
		
		
		/**
		 * Constructor
		 * 
		 * @param $info 	:Object
		 * @param $width 	:int
		 * @param $height 	:int
		 */
		public function WinSettings()
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
			_panel = _assets.default_panel;
			addChild(_panel);
			
			swapChildren(_panel, _title);//_title has been added by super class first
			
			//Main menu button
			_buttonSave = new BasicButton(_windowID, 'SAVE','default_white_small', true, _assets.button_small_bg, _assets.button_small_bg);
			_buttonSave.explicitWidth = 308;
			_buttonSave.explicitHeight = 55;
			_buttonSave.addEventListener(MouseEvent.CLICK, destroy, false, 0, true);
			addChild(_buttonSave);
			
			//Text
			_txtAudio = TextUtils.createTextField();
			_txtAudio.filters = [Settings.DROP_SHADOW_BOLD];
			_txtAudio.htmlText = '<span class="default_white">AUDIO </span>';
			addChild(_txtAudio);
			
			//ToggleSwitch
			//Since the TogleSwitch component is an UIComponent in Flex, we make reference to the one created in our WindowedApplication file
			var toggle:ToggleSwitch;
			
			if(FlexGlobals.topLevelApplication.className == 'cannon_combat_prod')
			{
				var v:View = (FlexGlobals.topLevelApplication.navigator as ViewNavigator).activeView; 
				for(var i:int = 0; i < v.stage.numChildren; i++)
				{
					if(v.stage.getChildAt(i) is ToggleSwitch)  toggle = v.stage.getChildAt(i) as ToggleSwitch;
				}
			}
			else
			{
				toggle = FlexGlobals.topLevelApplication.audioToggleSwitch;
			}

			_toggleAudio = toggle;
			_toggleAudio.name = 'toggleAudio';
			_toggleAudio.visible = true;
			_toggleAudio.addEventListener(Event.CHANGE, onSwitch, false, 0, true);
			addChild(_toggleAudio);
			
			//Positioning
			PositionUtils.center(_title, null, true);
			PositionUtils.offset(_title, 0, 130);
			
			PositionUtils.center(_panel, null, true, true);
			
			PositionUtils.center(_buttonSave, null, true);
			PositionUtils.offset(_buttonSave, 0, -70);
			
			PositionUtils.offset(_txtAudio, 280, .44);
			
			PositionUtils.center(_toggleAudio, null, true);
			PositionUtils.offset(_toggleAudio, -100, .44);
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
			
			title = 'SETTINGS';
			_title.filters = [Settings.DROP_SHADOW_BOLD];
			
			drawUI();
		}
		
		
		
		/**
		 * Event handler when toggleswitch changes
		 * 
		 * @param $e :Event - Event.CHANGE
		 */
		protected function onSwitch($e:Event = null):void
		{
			(_toggleAudio.selected) ? _soundManager.volume = 1 : _soundManager.volume = 0;
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		override public function destroy($e:MouseEvent = null):void
		{
			_soundManager.playSound('pop');
			_buttonSave.removeEventListener(MouseEvent.CLICK, destroy);
			_toggleAudio.removeEventListener(Event.CHANGE, onSwitch);
			
			while (this.numChildren)
			{
				var child:* = getChildAt(0);
				
				if(child.name != 'toggleAudio')
				{
					removeChildAt(0);
					if('destroy' in child) child.destroy();
					child = null;
				}
				else
				{
					if(FlexGlobals.topLevelApplication.className == 'cannon_combat_prod')
					{
						var v:View = (FlexGlobals.topLevelApplication.navigator as ViewNavigator).activeView; 
						v.stage.addChild(_toggleAudio);
						_toggleAudio.visible = false;
						child = null;
					}
					else
					{
						removeChildAt(0);
						child = null;
					}
				}
			}
			super.destroy($e);
		}
		
	}
}