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
	 * WinLogin
	 * 
	 * Login window class
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */

	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import sfs2x.games.cannoncombat.CannonCombat;
	import sfs2x.games.cannoncombat.SFSWrapper;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.utils.PositionUtils;
	import sfs2x.games.cannoncombat.utils.TextUtils;
	
	public class WinLogin extends BasicWindow
	{
		private var
			_un				:TextField,		// Username input
			_unBg			:Bitmap,		// Input bg
			_msg			:TextField,
			_padding		:Number = 10,
			_button			:BasicButton;
		
			
			
		/**
		 * Constructor
		 */
		public function WinLogin()
		{
			showClose = false;
		}
		
		
		
		/**
		 * Tween this window into view
		 */
		public function tweenIn():void
		{
			TweenLite.to(this, .4, { delay:.3, y:0, ease: Back.easeOut }); 
		}
		

		
		/**
		 * Draw UI
		 */
		private function drawUI():void
		{
			var 
				tfHeight		:int = 70;
			
			//Title as a bitmap
			_titleBg = _assets.title;
			addChild(_titleBg);
			
			// Initialize message
			_msg = TextUtils.createTextField(false, false, 'left');
			_msg.htmlText = '<span class="default_white">CREATE A USERNAME</span>';
			_msg.filters = [Settings.DROP_SHADOW_BOLD];
			_msg.cacheAsBitmap = true;
			addChild(_msg);
			
			// Initialize username input field and label	
			_un = TextUtils.createInputTextField('.default_black', true);
			_un.width = 608;
			_un.height = tfHeight;
			_un.maxChars = 27;
			_un.text = (Settings.DEBUG) ? ('p_'+_windowID).substr(0,22) : '';
			_unBg = _assets.input_bg;
			addChild(_unBg);
			addChild(_un);
			
			// Initialize Login button
			_button = new BasicButton(_windowID, 'Login','default_white', true);
			_button.explicitWidth = 308;
			_button.explicitHeight = 87;
			_button.addEventListener(MouseEvent.CLICK, handleLogin, false, 0, true);

			addChild(_button);
			
			//Positioning
			PositionUtils.center(_msg, null, true);
			PositionUtils.offset(_msg, 0, .5);
			
			PositionUtils.center(_un, null, true);
			PositionUtils.offset(_un, 290, .66);
			PositionUtils.center(_unBg, null, true);
			PositionUtils.offset(_unBg, 0, .65);
			
			PositionUtils.center(_button, null, true);
			PositionUtils.offset(_button, 0, .8);
			
			PositionUtils.center(_titleBg, null, true);
			PositionUtils.offset(_titleBg, 0, .02);
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
			
			addEventListener(KeyboardEvent.KEY_UP, handleKeyPress, false, 0, true);
		}

		
		
		/**
		 * Login handler.
		 * Sets properties on the server
		 * 
		 * @param $e :MouseEvent
		 */
		private function handleLogin($e:MouseEvent = null):void
		{
			_soundManager.playSound('pop');
			var wrapper:SFSWrapper = InstanceManager.getSFSInstance((this.parent as CannonCombat).windowID);
			wrapper.setUserName = _un.text;
			wrapper.setIP = Settings.SFS2X_IP;
			wrapper.setTCPPort = Settings.SFS2X_PORT;
			wrapper.setUDPPort = Settings.SFS2X_UDP_PORT;
			wrapper.setZone = Settings.SFS2X_ZONE;
			wrapper.connectToServer();
		}

		/**
		 * Key handler
		 * 
		 * @param $e :KeyboardEvent
		 */
		private function handleKeyPress($e:KeyboardEvent = null):void
		{
			if($e.keyCode === Keyboard.ENTER) handleLogin();
		}
		
		
		
		/**
		 * Removes elements from memory
		 * 
		 * @param $e MouseEvent
		 */
		override public function destroy($e:MouseEvent = null):void
		{
			removeEventListener(KeyboardEvent.KEY_UP, handleKeyPress);
			_button.removeEventListener(MouseEvent.CLICK, handleLogin);
			
			var bmpData:BitmapData;
			while (this.numChildren)
			{
				var child:* = removeChildAt(0);
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
							var grandChild:* = child.removeChildAt(0);
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
				if('destroy' in child)
				{
					child.destroy();
					child = null;
				}
			}
			bmpData = null;
			
			_un			= null;
			_button		= null;
			
			super.destroy($e);
		}
		
	}
}