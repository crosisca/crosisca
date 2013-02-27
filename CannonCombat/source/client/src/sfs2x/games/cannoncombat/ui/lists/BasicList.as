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
	 * BasicList
	 * 
	 * Creates a basic sortable list of items
	 * 
	 * @author 		Wayne Helman
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BasicList extends Sprite
	{
		private var 
			_items				:Array = [],
			_selectedItem		:ListItem,
			_sortOn				:Array,
			_sortOrder			:Array,
			_animationTime		:Number = 0.5,
			_itemPadding		:int = 4;
		
			
			
		/**
		 * Constructor
		 */
		public function BasicList() 
		{
		}
		

		
		/**
		 * Add an item to the current list
		 * 
		 * @param $item 	:*
		 * @param $update 	:Boolean
		 * @param $animate 	:Boolean
		 */
		public function addItem($item:*, $update:Boolean = false, $animate:Boolean = true):void
		{
			_items.push($item);
			
			$item.alpha = 0;
			addChild($item);
			
			if($update) update($item, $animate);
		}
		
		
		
		/**
		 * Loop through all the list items and make sure they are in the correct position
		 * 
		 * @param $newItem  :ListItem
		 * @param $animate  :Boolean
		 */
		public function update($newItem:ListItem = null, $animate:Boolean = true):void
		{
			if (_sortOrder)
			{
				if(_sortOn) _items.sortOn(_sortOn, _sortOrder);	
			}
			else if (_sortOn)
			{
				_items.sortOn(_sortOn);
			}
			
			var item	:ListItem,
				tweens	:Array  = [],
				l		:int = _items.length;
			
			for (var i:int = 0 ; i < l; ++i) 
			{
				var tweenParams:Object = {};
				item = _items[i];
				
				if(item == null) continue;
				
				tweenParams.y = int(i * (item.height + _itemPadding));
				tweenParams.alpha = 1;
				tweenParams.overwrite = 2;
				
				if ($newItem) 
				{
					tweenParams.onComplete = showNewItem;
					tweenParams.onCompleteParams = [$newItem];
				}
				
				tweens.push( TweenMax.to(item, ($animate) ? _animationTime : 0.01, tweenParams) );
			}
			
			if(tweens.length > 0)
			{
				var timeline:TimelineMax = new TimelineMax({tweens:tweens, align:TweenAlign.START, onComplete:notify });
			}
			else
			{
				notify();
			}
		}
		
		
		
		/**
		 * Remove an item from the current list
		 * 
		 * @param $property :String
		 * @param $value 	:*
		 */
		public function removeItem($property:String, $value:*):void
		{
			var item	:ListItem,
				l		:int = _items.length;
				
			for (var i:int = 0 ; i < l; ++i)
			{
				item = items[i] as ListItem;

				if (item.data[$property] === $value)
				{
					_items.splice(i, 1);
					break;
				}
			}
			
			TweenMax.killTweensOf(item);
			TweenMax.to(item, 0.15, { alpha:0, onComplete: killItem, onCompleteParams:[item] } );
		}		
		
		
		
		/**
		 * Return an item by a property
		 * 
		 * @param $property  :String
		 * @param $value 	 :*
		 * 
		 * @return item  :ListItem
		 */
		public function getItemByProperty($property:String, $value:*):ListItem
		{
			var item	:ListItem,
				l		:int = _items.length;
				
			for (var i:int = 0 ; i < l; ++i)
			{
				item = items[i];
		
				if (item.data[$property] === $value )
				{
					return item;
				}
			}
			
			return null;
		}
		
		
		
		/**
		 * Clear current list removing from array
		 */
		public function clear():void
		{
			if (_items.length == 0) return;
			
			var l		:int = _items.length,
				li		:ListItem;
			
			for (var i:int = 0 ; i < l; i++) 
			{
				li = _items[i];
				
				li.destroy();
				li = null;
				
			}
			_items = [];
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public function destroy():void
		{
			var l		:int = _items.length,
				li		:ListItem;
			
			for (var i:int = 0 ; i < l; i++) 
			{
				li = _items[i];
				li.destroy();
				li = null;
			}
		}
		

		
		/**
		 * Notify complete event when populating list
		 */
		private function notify():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		
		/**
		 * Remove the item from the display list
		 * 
		 * @param $item 	:ListItem
		 * @param $update	:Boolean
		 */
		private function killItem($item:ListItem, $update:Boolean = true):void
		{
			$item.destroy();
			removeChild($item);
			$item = null
			update();
		}
		
		
		
		/**
		 * Tween new item in the list
		 *
 		 * @param $item :ListItem
		 */
		private function showNewItem($item:ListItem):void
		{
			TweenMax.to($item, 0.25, { alpha:1 } );
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get selectedItem():ListItem { return _selectedItem; }
		public function set selectedItem($value:ListItem):void { _selectedItem = $value; }
		
		public function get items():Array { return _items; }
		
		public function set sortOn($value:Array):void { _sortOn = $value; }

		public function set sortOrder($value:Array):void { _sortOrder = $value; }
		
	}
}