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
	 * Scroller
	 * 
	 * Creates a scrollbar within ScrollableContent
	 * 
	 * @author 		Wayne Helman, based on original work by Fuori dal Cerchio (http://www.fuoridalcerchio.net/)
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0
	 */
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle; 
	
	public class Scroller extends Sprite
	{
		private var
			_stage				:Stage,
			_hitarea			:Sprite,
			_track				:Sprite,
			_dragged			:*,
			_handle				:Sprite,
			_mask				:Sprite,

			_blurred			:Boolean,
			_yFactor			:int, 
		
			_initY				:int, 
			_minY				:int,
			_maxY				:int,
			_percentage			:int,
			_startY				:int,
			_bf					:BlurFilter,
		
			_initialized		:Boolean = false; 
		
		/**
		 * Constructor
		 * 
		 * @param dragged	:*
		 * @param handle	:Sprite
		 * @param track		:Sprite
		 * @param hit		:Sprite
		 * @param blurred	:Sprite
		 * @param blurred	:Sprite
		 */
		public function Scroller(dragged:*, handle:Sprite, track:Sprite, hit:Sprite, blurred:Boolean = true, yfactor:int = 3)
		{
			_dragged = dragged; 
			_mask = hit; 
			_handle = handle; 
			_track = track; 
			_hitarea = hit; 
			_blurred = blurred; 
			_yFactor = yfactor; 
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		

		
		/**
		 * Initialize elements
		 * 
		 * @param $e :Event
		 */
		public function init($e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (_initialized) reset();
		
			_bf = new BlurFilter(0, 0, 1); 
			_dragged.filters = new Array(_bf); 
			_dragged.cacheAsBitmap = true; 
			
			_minY = _track.y; 
			_startY = _dragged.y; 
			_handle.buttonMode = true; 
			
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			_track.addEventListener(MouseEvent.MOUSE_UP, onTrackClick, false, 0, true);
			
			_stage = stage;
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true); 
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			_initialized = true; 
		}
		

		
		/**
		 * Position content (list) up and down
		 */
		public function positionContent():void
		{
			var h:Number = (_mask.height / _dragged.height) * _track.height;
			_handle.height = (h < 20) ? 20 : h;
			
			_maxY = _track.height - _handle.height;	
			
			if(_dragged.height <= _mask.height)
			{
				_handle.visible = false;
				_track.alpha = .1;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else
			{
				_handle.visible = true;
				_track.alpha = .16;
				
				if (_handle.y >= _maxY) _handle.y = _maxY; 
				
				_percentage = (100 / _maxY) * _handle.y;
				
				var downY		:Number = _dragged.height - (_mask.height >> 1) + 4,
					fx			:Number = _startY - (((downY - (_mask.height >> 1)) * .01) * _percentage),
					currY		:Number = _dragged.y; 
				
				if (currY !== fx)
				{
					var diff		:int = fx-currY,
						bfactor		:int = ((diff ^ (diff >> 31)) - (diff >> 31) )  >> 1;
					
					currY += diff / _yFactor; 
					
					_bf.blurY = bfactor; 
					
					if (_blurred) _dragged.filters = new Array(_bf);
					
				}
				
				_dragged.y = currY; 
			}
		}
		
		/**
		 * Reset content back to initial state
		 * 
		 * @param 	$defaultPos :Boolean
		 * @param 	$startAtTop :Boolean
		 */
		public function reset($defaultPos:Boolean = false, $startAtTop:Boolean = true):void
		{
			_handle.height = (_mask.height / _dragged.height) * _track.height;
			
			if($defaultPos)
			{
				if($startAtTop)
				{
					_dragged.y = _startY; 
					_handle.y = 0;
				}
				else
				{
					_handle.y = _maxY = _track.height - _handle.height;
					_dragged.y = _mask.height - _dragged.height; 
				}
			}
			
			if(_dragged.height > _mask.height)
			{
				addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true); 
			}
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public function destroy():void
		{
			_handle.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); 
			_track.removeEventListener(MouseEvent.MOUSE_UP, onTrackClick);
			
			if(stage!= null)	stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp); 
			if(stage!= null)	stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel); 
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		

		
		/**
		 * Move data to requested position
		 * 
		 * @param $q :int
		 */
		private function scrollData($q:int):void
		{
			var d		:Number,
			goto		:Number,
			quantity	:Number = _handle.height * .2; 
			
			d = (~$q + 1) * ((quantity ^ (quantity >> 31)) - (quantity >> 31));
			
			if (d > 0)
			{
				goto = Math.min(_maxY, _handle.y + d);
			}
			else if (d < 0)
			{
				goto = Math.max(_minY, _handle.y + d);
			}
			
			TweenLite.to(_handle, .1, { y: goto, ease: Linear.easeOut});
			
			positionContent();
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Mouse down handler 
		 * 
		 * @param $e :MouseEvent
		 */
		private function onMouseDown($e:MouseEvent):void
		{
			var rect:Rectangle = new Rectangle(_track.x, _minY, 0, _maxY);
			_handle.startDrag(false, rect);
		}
		
		
		
		/**
		 * Click handler for track
		 * 
		 * @param $e :MouseEvent
		 */
		private function onTrackClick($e:MouseEvent):void
		{
			var goto		:Number,
				localY		:Number = $e.localY,
				top			:Number = _handle.y,
				bottom		:Number = _handle.y + _handle.height; 
			
			if(localY <= _handle.y)
			{
				goto = localY;
			}
			else if(localY >= bottom)
			{
				goto = localY - _handle.height;
			}
			
			TweenLite.to(_handle, .2, { y: goto, ease: Linear.easeOut});
			
			positionContent();
		}
		
		
		
		/**
		 * Mouse up handler
		 * 
		 * @param $e :MouseEvent
		 */
		private function onMouseUp($e:MouseEvent):void
		{
			_handle.stopDrag();
		}
		
		
		
		/**
		 * Mouse wheel handler
		 * 
		 * @param $e :MouseEvent
		 */
		private function onMouseWheel($e:MouseEvent):void
		{
			if (_hitarea.hitTestPoint(_stage.mouseX, _stage.mouseY)) scrollData($e.delta);
		}
		
		
		
		/**
		 * Enter frame handler
		 * 
		 * @param $e :Event
		 */
		private function onEnterFrame($e:Event):void
		{
			positionContent();
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function set dragged ($value:*):void { _dragged = $value; }
		
		public function set maskclip ($value:Sprite):void { _mask = $value; }
		
		public function set handle ($value:Sprite):void { _handle = $value; }
		
		public function set track ($value:Sprite):void { _track = $value; }
		
		public function set hitarea ($value:Sprite):void { _hitarea = $value; }	
		
	}
}