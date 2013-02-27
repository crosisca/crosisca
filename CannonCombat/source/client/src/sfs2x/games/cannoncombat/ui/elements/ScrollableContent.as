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
	 * ScrollableContent
	 * 
	 * Displays a scrollbar and scrollable content area containing provided content
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import sfs2x.games.cannoncombat.config.Settings;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ScrollableContent extends Sprite
	{
		private var 
			_scroller					:Scroller,
			_content					:Sprite,
			_hitarea					:Sprite;
		
		protected var
			_width						:int,
			_height						:int,
			_track						:Sprite,
			_handle						:Sprite,
			_trackColor					:uint = 0x456c81,
			_handleColor				:uint = Settings.COLOR_GREEN,
			_scrollerWidth				:int,
			_cornerRadius				:int = 10,
			_padding					:int = 20;
		
			
			
		/**
		 * Constructor
		 * 
		 * @param $width	:Number
		 * @param $height	:Number
		 */
		public function ScrollableContent($width:Number, $height:Number) 
		{
			_width = $width;
			_height = $height;
			
			_scrollerWidth = Settings.SCROLLBAR_WIDTH;
			
			setHitArea();
			setContent();
			
			scrollRect = new Rectangle(0,0, _width + (_padding + _scrollerWidth), _height);
		}

		
		
		/**
		 * Set track, handle and scroller
		 */
		public function init():void 
		{
			setTrack(1, _trackColor);
			setHandle(1, _handleColor);

			_scroller = new Scroller(_content, _handle, _track, _hitarea);
			
			addChild(_scroller);
		}
		
		
		
		/**
		 *  Sets a hit area Sprite to be used for the
		 *  Mouse wheel.
		 */
		public function setHitArea():void
		{
			if (_hitarea) return;
			
			var hitarea:Sprite = new Sprite(); 
			hitarea.graphics.beginFill(Settings.COLOR_BLACK, 0);
			hitarea.graphics.drawRect(0, 0, _width + (_padding + _scrollerWidth), _height);
			hitarea.graphics.endFill();
			
			addChild(hitarea);
			
			_hitarea = hitarea;
		}
		
		
		
		/**
		 * Provides a container that will hold the content to be
		 * scrolled.
		 * 
		 * @param $alpha :Number
		 * @param $color :uint
		 */
		public function setContent($alpha:Number = 0, $color:uint = Settings.COLOR_BLACK):void
		{
			if(_content) return;
			
			var content:Sprite = new Sprite();
			content.graphics.clear();
			content.graphics.beginFill($color, $alpha);
			content.graphics.drawRect(0, 0, _width, _height);
			content.graphics.endFill();
			
			addChild(content);
			
			_content = content;
		}
		
		
		
		/**
		 * Draws the scrollbar track that is then
		 * passed to the scroller.
		 * 
		 * @param $alpha :Number
		 * @param $color :uint
		 */
		public function setTrack($alpha:Number = .16, $color:uint = Settings.COLOR_BLUE):void
		{
			if (_track) return;
			
			var track:Sprite = new Sprite();
			track.graphics.clear();
			track.graphics.beginFill($color, $alpha);
			track.graphics.drawRoundRect(_width + _padding, 0, _scrollerWidth, _height, _cornerRadius, _cornerRadius);
			track.graphics.endFill();
			
			addChild(track);
			
			_track = track;
		}
		
		
		
		/**
		 * Draws the handle that is then
		 * passed to the scroller.
		 * 
		 * @param $alpha :Number
		 * @param $color :uint
		 */
		public function setHandle($alpha:Number = 1, $color:uint = Settings.COLOR_GREY):void
		{
			if (_handle) return;
			
			var handle:Sprite = new Sprite();
			handle.graphics.beginFill($color, $alpha);
			handle.graphics.drawRoundRect(_width + _padding, 0, _scrollerWidth, 50, _cornerRadius, _cornerRadius);
			handle.scale9Grid = new Rectangle(_width+_padding + 1, _cornerRadius, _scrollerWidth - 2, 50 - (_cornerRadius * 2));
			handle.graphics.endFill();
			handle.y = _track.y;
			handle.x = _track.x + int( (_track.width - handle.width) >> 1);

			addChild(handle);
			
			_handle = handle;
		}

		
		
		/**
		 * Resets the scrollbar
		 * 
		 * @param $defaultPos :Boolean
		 * @param $startAtTop :Boolean
		 */
		public function reset($defaultPos:Boolean = false, $startAtTop:Boolean = true):void
		{
			_scroller.reset($defaultPos, $startAtTop);
		}
		
		
		
		/**
		 * Destroy method 
		 */
		public function destroy():void
		{
			while (numChildren) 
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		public function get content():Sprite { return _content; }
		public function set content($value:Sprite):void { _content = $value; }		
	
		public function get scroller():Scroller { return _scroller; }
		
		public function get define():String { return 'ScrollableContent'; }

	}
}