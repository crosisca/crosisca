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
	 * ListItem
	 * 
	 * Simple item that appears in a list - see BasicList
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sfs2x.games.cannoncombat.config.Assets;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.events.CustomEvent;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.managers.SoundManager;
	import sfs2x.games.cannoncombat.utils.TextUtils;
	
	public class ListItem extends Sprite
	{
		private var
			_bg					:Sprite,
			_bgOver				:Sprite,
			_bgColor			:uint,
			_highLightColor		:uint,
			_bgAlpha			:Number 		= 0.1;
			
		protected var
			_label				:TextField,
			_width				:int,
			_height				:int,
			_data				:Object,
			_assets				:Assets,
			_soundManager		:SoundManager,
			_windowID			:String			= '';

			
			
		/**
		 * Constructor
		 * 
		 * @param $label			:String
		 * @param $width			:int
		 * @param $height			:int
		 * @param bgColor			:uint
		 * @param bgHighLightColor	:uint
		 */
		public function ListItem($label:String, $width:int = 480, $height:int = 80, $bgColor:uint = Settings.COLOR_WHITE, $bgHighLightColor:uint = Settings.COLOR_BLACK) 
		{
			//PS: For Cannon Combat we don't need bg and rollovers, but methods are still in place
			_width = $width;
			_height = $height;

			_bgColor = $bgColor;
			_highLightColor = $bgHighLightColor;
			
			init($label);
			
			_soundManager = InstanceManager.getSoundManagerInstance(_windowID);
			_assets = InstanceManager.getAssetsInstance(_windowID);
		}
		
		
		
		/**
		 * Init
		 * 
		 * @param $label :String
		 */
		protected function init($label:String):void
		{
			_label = TextUtils.createTextField();
			_label.htmlText = '<span class="default_white_small">' + $label + '</span>';
			_label.mouseEnabled = false;
			_label.x = 2;
			_label.y = 6;
			_label.filters = [Settings.DROP_SHADOW_BOLD];
			addChild(_label);
		}
		

		
		/**
		 * Update status
		 * 
		 * @param $status :String
		 */
		public function updateStatus():void
		{
			// Overridden by extending classes
		}
		
		
		
		/**
		 * Animate item in the list
		 * 
		 * @param $delay :Number
		 */
		public function animateIn($delay:Number = 0):void
		{
			this.alpha = 0;
			this.y += 20;
			
			TweenMax.to(this, 0.5, { alpha:1, y:20, delay:$delay } );
		}
		
		
		
		/**
		 * Draw BG
		 */
		public function drawBG():void
		{
			_bg = new Sprite();

			_bg.graphics.clear();
			_bg.graphics.beginFill(_bgColor, _bgAlpha);	
			_bg.graphics.drawRoundRect(0, 0, _width, _height, Settings.DEFAULT_ELLIPSE *.5, Settings.DEFAULT_ELLIPSE *.5);
			_bg.graphics.endFill();
			
			addChild(_bg);
			
			_bgOver = new Sprite();
			
			_bgOver.graphics.clear();
			_bgOver.graphics.beginFill(_highLightColor, _bgAlpha);	
			_bgOver.graphics.drawRoundRect(0, 0, _width, _height, Settings.DEFAULT_ELLIPSE *.5, Settings.DEFAULT_ELLIPSE *.5);
			_bgOver.graphics.endFill();
			_bgOver.alpha = 0;
			
			addChild(_bgOver);
		}
		
		
		
		/**
		 * Add over/out events
		 */
		public function addRollOvers():void
		{
			addEventListener(MouseEvent.ROLL_OVER, handleOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, handleOut, false, 0, true);
		}
		
		
		
		/**
		 * Remove over/out events		 
		 */
		public function removeRollOvers():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, handleOver);
			removeEventListener(MouseEvent.ROLL_OUT, handleOut);
		}
		
		

		/**
		 * Select item in the list
		 */
		public function select():void
		{
			removeRollOvers();
			
			handleOut( null );
			
			highlight();
			
			this.buttonMode = false;
		}
		
		
		
		/**
		 * Deselect item in the list
		 * 
		 * @param $rollovers :Boolean
		 */
		public function deselect($rollovers:Boolean = true):void
		{
			removeHighlight();
			
			this.buttonMode = true;
			
			if ($rollovers) addRollOvers();
		}
		
		
		
		/**
		 * Highlight this list item
		 */
		public function highlight():void
		{
			// Overridden by extending classes
		}
		
		
		
		/**
		 * Remove the highlighting from this list item
		 */
		public function removeHighlight():void
		{
			handleOut();
		}
		
		
		
		/**
		 * Enable the selection of this list item
		 */
		public function enable():void
		{
			// Overridden by extending classes
		}
		
		
		
		/**
		 * Disable the selection of this list item
		 */
		public function disable():void
		{
			// Overridden by extending classes
		}
		
		
		
		/**
		 * Update label
		 * 
		 * @param $label :String
		 */
		protected function updateLabel($label:String):void
		{
			_label.htmlText = '<span class="default_white_small">' + $label + '</span>';
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Over handler
		 * 
		 * @param $e :MouseEvent
		 */
		protected function handleOver($e:MouseEvent = null):void 
		{
			TweenMax.to(_bgOver, 0.4, { alpha:1 } );
		}
		
		
		
		/**
		 * Out handler
		 * 
		 * @param $e :MouseEvent
		 */
		protected function handleOut($e:MouseEvent = null):void 
		{
			TweenMax.to(_bgOver, 0.4, { alpha:0 } );
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public function destroy():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, handleOver);
			removeEventListener(MouseEvent.ROLL_OUT, handleOut);
			
			while (this.numChildren)
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		

		public function get label():String { return _label.text; };
		public function set label($text:String):void { this.updateLabel($text); }
		
		public function get data():Object { return _data; }
		public function set data($value:Object):void
		{
			_data = $value;
			dispatchEvent(new CustomEvent(CustomEvent.DATA_SET));
		}
		
		public function get highLightColor():uint { return _highLightColor; }
		public function set highLightColor($value:uint):void { _highLightColor = $value; }
		
	}
}