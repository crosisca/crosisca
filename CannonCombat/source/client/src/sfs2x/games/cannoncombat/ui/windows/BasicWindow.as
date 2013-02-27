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
	 * BasicWindow
	 * 
	 * Default window class
	 * 
	 * @author 		Wayne Helman
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sfs2x.games.cannoncombat.CannonCombat;
	import sfs2x.games.cannoncombat.config.Assets;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.managers.SoundManager;
	import sfs2x.games.cannoncombat.ui.elements.Background;
	import sfs2x.games.cannoncombat.utils.TextUtils;
	
	public class BasicWindow extends Sprite
	{
		private var
			_lineColor		:uint 			= 0x333300,
			_bgColor		:uint 			= Settings.COLOR_BLACK,
			_bgAlpha		:Number 		= 1,
			_cornerRadius	:int 			= 18,
			_padding		:int 			= 10,
			_checkBounds	:Boolean 		= false,
			_bg				:Background,
			_close			:Sprite;
			
		protected var
			_windowID		:String			= '',
			_assets			:Assets,
			_soundManager	:SoundManager,
			_width			:int,
			_height			:int,
			_titleBg		:Bitmap,
			_style			:String			= 'default_white',
			_title			:TextField		= TextUtils.createTextField(),
			_showClose		:Boolean 		= false;

			
			
		/**
		 * Constructor
		 * 
		 * @param $width :int
		 * @param $height :int
		 */
		public function BasicWindow($width:int = 0, $height:int = 0)
		{
			_width = Settings.DEFAULT_WIN_WIDTH;
			_height = Settings.DEFAULT_WIN_HEIGHT;
			
			//_width = $width;
			//_height = $height;
		
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
		}
       
		
		
		/**
		 * Event handler when object has been added to stage
		 * 
		 * @param $e :Event
		 */
		 protected function onAdded($e:Event):void
		 {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			//Depending if we are on dev or prod the number of children change, also if we have debug windows
			//Simplest way is to loop through children and detect who is CannonCombat class
			//Usually we have 4 objects: SystemManager, Shape, CannonCombat and Stage
			for(var i:int = 0; i < stage.numChildren; i++)
			{
				if(stage.getChildAt(i) is CannonCombat) var cc:CannonCombat = stage.getChildAt(i) as CannonCombat;
			} 
			
			_windowID = cc.windowID;
			
			_soundManager = InstanceManager.getSoundManagerInstance(_windowID);
			
			_assets = InstanceManager.getAssetsInstance(_windowID);
			
			draw();
		}
		

		
		/**
		 * Uses our style properties to draw our window
		 */
		protected function draw():void
		{
			if (!_bg)
			{
				_bg = new Background(_width, _height, _bgAlpha, _bgColor);
				_bg.draw();
			}
			
			if (_title) _title = TextUtils.createTextField();
			
			addChild(_bg);
			addChild(_title);

			if(_showClose) createClose();
			
			this.x = (stage.stageWidth *.5) - (_width * .5);
			this.y = (stage.stageHeight *.5) - (_height * .5);
		}
		
		
		
		/**
		 * Create close button
		 */
		protected function createClose():void
		{
			_close = new Sprite();
			//_close.addChild(_assets.xButton);
			_close.x = _width - 45;
			_close.y = 11;
			_close.addEventListener(MouseEvent.CLICK, destroy, false, 0, true);
			addChild(_close);
		}

		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Mouse down handler
		 * 
		 * @param $e :MouseEvent
		 */
		protected function handleMouseDown($e:MouseEvent):void 
		{
			if ($e.target != this) return;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, handleUp, false, 0, true);
			
			parent.addChild(this);
			
			if(checkBounds) addEventListener(Event.ENTER_FRAME, checkPosition, false, 0, true);
			
			startDrag();
		}
		
		
		
		/**
		 * Mouse up handler
		 * 
		 * @param $e :MouseEvent
		 */
		protected function handleUp($e:MouseEvent):void 
		{
			stopDrag();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleUp);
			
			removeEventListener(Event.ENTER_FRAME, checkPosition);
			
			checkPosition();
		}
		
		
		
		/**
		 * Keep it inside stage
		 * 
		 * @param $e :Event
		 */
		private function checkPosition($e:Event = null):void 
		{
			if (this.x < 0) x = 0;
			if (this.x > stage.stageWidth - _width) this.x = stage.stageWidth - _width;
			if (this.y < 0) y = 0;
			if (this.y > stage.stageHeight - _height) this.y = stage.stageHeight - _height;
		}

		
		
		/**
		 * Removes elements from memory
		 * 
		 * @param $e :MouseEvent
		 */
		public function destroy($e:MouseEvent = null):void
		{
			if(stage != null)	stage.removeEventListener(MouseEvent.MOUSE_UP, handleUp);
			
			removeEventListener(Event.ENTER_FRAME, checkPosition);
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			if(_close != null)
			{	
				if(contains(_close))
				{
					_close.removeEventListener(MouseEvent.CLICK, destroy);
				}
				_close = null;
			}
			
			while (numChildren) 
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
			
			_bg = null;
			_title = null;
			
			if(parent != null)
			{
				var parent:DisplayObjectContainer = parent;
				parent.removeChild(this);
			}
			
			_assets = null;
			
			_bg			 = null;
			_title		 = null;
			_close		 = null;
			_windowID	 = null;
			_assets		 = null;
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		public function get windowID():String { return _windowID; }
		public function set windowID($value:String):void { _windowID = $value; }
		
		public function get bgAlpha():Number { return _bgAlpha; }
		public function set bgAlpha($value:Number):void { _bgAlpha = $value; }
		
		public function get bgColor():uint { return _bgColor; }
		public function set bgColor($value:uint):void { _bgColor = $value; }
				
		public function get cornerRadius():int { return _cornerRadius; }
		public function set cornerRadius($value:int):void { _cornerRadius = $value; }
			
		public function set draggable($draggable:Boolean):void { ($draggable) ? addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true) : removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown); }
		
		public function get bg():Shape { return _bg; }

		public function get padding():int { return _padding; }
		public function set padding($value:int):void { _padding = $value; }
		
		public function get checkBounds():Boolean { return _checkBounds; }
		public function set checkBounds($value:Boolean):void { _checkBounds = $value; }
				
		public function get showClose():Boolean { return _showClose; }
		public function set showClose($value:Boolean):void { _showClose = $value; }
		
		public function get style():String { return _style; }
		public function set style($value:String):void { _style = $value; }
		
		public function set title($title:String):void
		{
			_title.htmlText = '<span class="'+_style+'">' + $title + ' </span>';
		}
		
	}
}