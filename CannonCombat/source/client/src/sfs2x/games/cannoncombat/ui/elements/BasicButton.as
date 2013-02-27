package sfs2x.games.cannoncombat.ui.elements
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
	 * BasicButton
	 * 
	 * Generates a basic button for UI usage
	 * 
	 * @author 		Wayne Helman
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0
	 */
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sfs2x.games.cannoncombat.config.Assets;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.events.CustomEvent;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.utils.TextUtils;

	public class BasicButton extends Sprite
	{
		protected var
			_assets					:Assets,
			_label					:TextField,
			_width					:int = 0,
			_height					:int = 0,
			_style					:String,
			_text					:String,
			_bg						:*,
			_bgOver					:*,
			_isBgGraphics			:Boolean,
			_isBgBitmap				:Boolean	= false,
			_bmpAsset				:Bitmap,
			_bmpAssetOver			:Bitmap,
			_showBG					:Boolean,
			_clicked				:Boolean 	= false,
			_windowID				:String,
			_enabled				:Boolean;
		
			
			
		/**
		 * Constructor
		 * 
		 * @param $win		:String
		 * @param $label	:String
		 * @param $style	:String
		 * @param $padding	:Number
		 * @param $bg		:Boolean
		 */	
		public function BasicButton($win:String, $label:String, $style:String, $bitmap:Boolean = false, $asset:Bitmap = null, $assetOver:Bitmap = null, $padding:Number = 6, $bg:Boolean = true) 
		{
			_windowID = $win;
			
			_style = $style;
			_text = $label + ' ';// This is a hack-ish fix: Dropshadow filter on dynamic texfield causes the last letter to be cut off partially. Just add space to the end
			
			if($label != '')	name = $label.toUpperCase();
			
			_assets = InstanceManager.getAssetsInstance(_windowID);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			
			createLabel(_text, _style, $padding);
			
			if($bitmap)
			{
				_isBgBitmap = $bitmap;
				_showBG = $bitmap;
				if($asset != null)
				{
					_bmpAsset = $asset;
					_bmpAssetOver = $assetOver;
				}
				else
				{
					_bmpAsset = _assets.button_bg;
					_bmpAssetOver = _assets.button_over_bg;
				}
			}
			else
			{
				_showBG = $bg;
			}
			
			drawBG();
		}
		
		
		
		/**
		 * Sets string as button label
		 * 
		 * @param $label 	:String
		 * @param $style 	:String
		 * @param $padding 	:String
		 */
		protected function createLabel($label:String, $style:String, $padding:Number):void
		{				
			_label = TextUtils.createTextField(false, false, 'left');
			_label.x = $padding * 6;
			_label.y = $padding;
			_label.filters = [Settings.DROP_SHADOW];
			_label.htmlText = '<span class="' + _style + '">' + _text + '</span>';
			
			addChild(_label);
		}		
		
		
		
		/**
		 * Draws our bg with gradient
		 * 
		 * @param $startColor 	:uint
		 * @param $endColor 	:uint 
		 * @param $startOnColor :uint 
		 * @param $endOnColor 	:uint  
		 */
		protected function drawBG(
			$startColor:uint = Settings.DEFAULT_BUT_START_COLOR,
			$endColor:uint = Settings.DEFAULT_BUT_END_COLOR,
			$startOnColor:uint = Settings.DEFAULT_BUT_MO_START_COLOR,
			$endOnColor:uint = Settings.DEFAULT_BUT_MO_END_COLOR):void
		{	
			var 
				bg:*,
				bgOver:*;
			
			if(_isBgBitmap)//Decide if bg is a bitmap form the Assets class or just graphics drawn with the AS3 API.
			{
					bg = new Bitmap();
					bg = _bmpAsset;
					addChildAt(bg,0);
					_bg = bg;
					
					bgOver = new Bitmap();
					bgOver = _bmpAssetOver;
					addChildAt(bgOver,1);
					_bgOver = bgOver;
					_bgOver.visible = false;
			}
			else
			{
				var 
					bgWidth:Number = (_width > 0) ? _width : _label.width + _label.x * 2,
					bgHeight:Number = (_height > 0) ? _height : _label.height + _label.y * 2;
				
				bg = new Background(bgWidth, bgHeight, 1);
				bgOver = new Background(bgWidth, bgHeight, 1);
					
				bg.gradient = false;
				bg.stroke = false;
				bg.color = 0xb6b6b6;
				bg.strokeStartColor = 0x174146;
				bg.strokeEndColor = 0x6dacb4;
				bg.gradientStartColor = $startColor;
				bg.gradientEndColor = $endColor;
				bg.draw();
				
				bg.cacheAsBitmap = true;
				if (!_showBG) bg.alpha = 0;
				
				addChildAt(bg,0);
				
				_bg = bg;
				
				bgOver.gradient = false;
				bgOver.stroke = false;
				bg.color = 0xb6b6b6;
				bgOver.strokeStartColor = 0x6dacb4;
				bgOver.strokeEndColor = 0x174146;
				bgOver.gradientStartColor = $startOnColor;
				bgOver.gradientEndColor = $endOnColor;
				bgOver.draw();
				bgOver.alpha = 0;
				
				_bgOver = bgOver;
				
				if (!_showBG) _bgOver.visible = false;
				addChildAt(_bgOver,1);
			}
		}	
		
		
		
		/**
		 * Init events		 
		 */
		protected function initEvents():void
		{
			buttonMode = true;
			
			handleOut( null );
			addEventListener(MouseEvent.ROLL_OVER, handleOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, handleOut, false, 0, true);
			addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
		}
		
		
		/**
		 * Remove events
		 */
		protected function removeEvents():void
		{
			buttonMode = false;

			removeEventListener(MouseEvent.ROLL_OVER, handleOver);
			removeEventListener(MouseEvent.ROLL_OUT, handleOut);
			removeEventListener(MouseEvent.CLICK, handleClick);
		}
		
		
		
		/**
		 * Remove events
		 */
		public function blinkNotification():void
		{
			if(_bgOver != null) (_bgOver.visible == false) ? handleOver() : handleOut();

			TweenLite.delayedCall(1, blinkNotification);
		}
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * When added to stage initialize events
		 * 
		 * @param $e Event when object has been added to stage
		 */
       	protected function onAdded($e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			initEvents();
			cacheAsBitmap = true;
		}


		
		/**
		 * Click handler
		 * 
		 * @param $e MouseEvent
		 */
		protected function handleClick($e:MouseEvent):void 
		{
			//InstanceManager.getSoundManagerInstance(_windowID).playSound('buttonClick');
			TweenLite.killDelayedCallsTo(blinkNotification);
			handleOut();
			dispatchEvent(new CustomEvent(CustomEvent.BUTTON_CLICK));
		}
		
		
		
		/**
		 * Over event
		 * 
		 * @param $e MouseEvent
		 */
		protected function handleOver($e:MouseEvent = null):void
		{
			if(_isBgBitmap)
			{
				_bg.visible = false;
				_bgOver.visible = true;
			}
			else
			{
				_bg.color = 0x8a8a8a;
				_bg.draw();
			}
		}
		
		
		
		/**
		 * Out handler
		 * 
		 * @param $e MouseEvent
		 */
		protected function handleOut($e:MouseEvent = null):void 
		{
			if(_isBgBitmap)
			{
				if(_bg != null) _bg.visible = true;
				if(_bgOver != null) _bgOver.visible = false;
			}
			else
			{
				_bg.color = 0xb6b6b6;
				_bg.draw();
			}
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public function destroy():void
		{
			removeEvents();
			
			while (numChildren) 
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
			
			_label		= null;
			_style		= null;
			_text		= null;
			_bgOver		= null;
			_bg			= null;
			_windowID	= null;
		}
		

		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		public function get label():String { return _label.text; }
		public function set label($label:String):void
		{
			_text = $label.toUpperCase() + ' ';
			_label.htmlText = '<span class="'+ _style + '">' + _text + '</span>';
		}
		
		
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled($enabled:Boolean):void 
		{
			_enabled = $enabled;
			if ($enabled)
			{
				initEvents();
			}
			else
			{
				handleOver( null );
				removeEvents();
			}
		}
		
		public function get explicitWidth():int { return _width; }		
		public function set explicitWidth($value:int):void 
		{
			_width = $value;
			_label.x = (_width - _label.width) * 0.5;
			resetBg();
		}
		
		public function get explicitHeight():int { return _height; }		
		public function set explicitHeight($value:int):void
		{
			_height = $value;
			_label.y = (_height - _label.height) * 0.5;
			resetBg();
		}
		
		public function resetBg():void
		{
			removeChild(_bg);
			removeChild(_bgOver);
			drawBG();
		}
	}
}