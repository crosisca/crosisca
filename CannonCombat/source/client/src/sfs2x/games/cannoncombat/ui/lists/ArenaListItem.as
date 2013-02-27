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
	 * ArenaListItem
	 * 
	 * An item that can appear in the arena list to represent an available arena
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sfs2x.games.cannoncombat.SFSWrapper;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.events.CustomEvent;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.utils.TextUtils;

	public class ArenaListItem extends ListItem
	{
		private var
			_sfs			:SFSWrapper,
			_arena			:int,
			_ticker			:Bitmap;
		
			
			
		/**
		 * Constructor
		 * 
		 * @param $label 	:String - Label for the arena 
		 * @param $windowID :String - windowID
		 * @param $arena 	:int - Index of the arena item in the arena array
		 */
		public function ArenaListItem($label:String, $windowID:String, $arena:int)
		{
			_arena = $arena;
			
			graphics.beginFill(Settings.COLOR_WHITE,0);
			graphics.drawRect(4, 8, 420, 34);
			graphics.endFill();
			
			super($label, Settings.APPLICATION_WIDTH, 80);
			
			_windowID = $windowID;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			
			_ticker = _assets.button_accept;
			_ticker.x = 380;
			addChild(_ticker);
			
			if(_label == null)
			{
				_label = TextUtils.createTextField();
				_label.mouseEnabled = false;
				_label.x = 360;
				_label.y = super._label.y;
				_label.filters = [Settings.DROP_SHADOW_BOLD];
				addChild(_label);
				_label.htmlText = '<span class="default_white_small">' + $label + '</span>';
			}
			
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Added to stage handler
		 * 
		 * @param $e :Event
		 */
		private function onAdded($e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_sfs = InstanceManager.getSFSInstance(_windowID).sfs();
		}
		
		
		
		/**
		 * Arena item clicked
		 * 
		 * @param $e :MouseEvent - MouseEvent.CLICK
		 */
		private function onClick($e:MouseEvent = null):void
		{
			_soundManager.playSound('pop');
			dispatchEvent(new CustomEvent(CustomEvent.ARENA_SELECTED, true, false, _arena));
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public override function destroy():void
		{
			while (this.numChildren)
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
			super.destroy();
		}
	}
}