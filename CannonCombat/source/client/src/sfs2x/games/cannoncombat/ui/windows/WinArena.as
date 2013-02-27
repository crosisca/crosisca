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
	 * WinArena
	 * 
	 * A window displaying a list of available arenas
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sfs2x.games.cannoncombat.LobbyController;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.events.CustomEvent;
	import sfs2x.games.cannoncombat.ui.elements.BasicButton;
	import sfs2x.games.cannoncombat.ui.elements.ScrollableContent;
	import sfs2x.games.cannoncombat.ui.lists.ArenaListItem;
	import sfs2x.games.cannoncombat.ui.lists.BasicList;
	import sfs2x.games.cannoncombat.utils.PositionUtils;
	
	public class WinArena extends BasicWindow
	{
		private var
			_panel					:Bitmap,
			_arenaList				:BasicList,
			_arenaListContainer		:ScrollableContent,
			_buttonCancel			:BasicButton;
		
			
			
		/**
		 * Constructor
		 * 
		 */
		public function WinArena()
		{
			showClose = false;
			
			bgAlpha = 0;
			style = 'default_white';
		}
		

		
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
		 * Draw UI
		 */
		private function drawUI():void
		{
			title = 'SELECT AN ARENA';
			_title.filters = [Settings.DROP_SHADOW_BOLD];
			
			//Panel
			_panel = _assets.arena_panel;
			addChild(_panel);
			_panel.scaleX = _panel.scaleY = .8;
			
			drawArenaList();
			
			//List arenas available at the beginning
			var arenaList	:Array = Settings.getGlobal('arenas', _windowID),
				len			:int = arenaList.length;

			for(var i:int = 0; i < len; i++)
			{
				var a:ArenaListItem 	= new ArenaListItem('Arena_'+(i+1) , _windowID, i);
				
				_arenaList.addItem(a);
			} 
			
			_arenaList.update();
			_arenaListContainer.reset();
			
			addEventListener(CustomEvent.ARENA_SELECTED, onArenaSelected, false, 0, true);
			
			//Button
			_buttonCancel = new BasicButton(_windowID, 'CANCEL','default_white_small', true, _assets.button_small_bg, _assets.button_small_bg);
			_buttonCancel.explicitWidth = 308;
			_buttonCancel.explicitHeight = 55;
			_buttonCancel.addEventListener(MouseEvent.CLICK, destroy, false, 0, true);
			addChild(_buttonCancel);
			
			//Positioning
			swapChildren(_panel, _title);
			
			PositionUtils.center(_title, null, true);
			PositionUtils.offset(_title, 0, 210);
			
			PositionUtils.center(_panel, null, true, true);
			
			PositionUtils.center(_buttonCancel, null, true);
			PositionUtils.offset(_buttonCancel, 0, -155);
		}
		
		
		
		/**
		 * Draws the arena list
		 */
		private function drawArenaList():void
		{
			_arenaList = new BasicList();
			_arenaList.sortOn = ['name'];
			_arenaList.sortOrder = [ Array.CASEINSENSITIVE ];
			_arenaList.addEventListener(Event.COMPLETE, resetArenaList, false, 0, true);
			
			_arenaListContainer = new ScrollableContent(432, 294);
			_arenaListContainer.content.addChild(_arenaList);
			_arenaListContainer.init();
			
			addChild(_arenaListContainer);
			
			PositionUtils.offset(_arenaListContainer, 210, 152);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Reset user list upon complete event
		 * 
		 * @param $e :Event - Event.COMPLETE
		 */
		private function resetArenaList($e:Event = null):void
		{
			_arenaListContainer.reset();
			_arenaList.removeEventListener(Event.COMPLETE, resetArenaList);
		}
		
		
		
		/**
		 * Handles option once an arena is selected
		 * 
		 * @param $e :CustomEvent - CustomEvent.ARENA_SELECTED
		 */
		private function onArenaSelected($e:CustomEvent):void
		{
			(parent as LobbyController).onArenaSelected($e.arg[0]);
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		override public function destroy($e:MouseEvent = null):void
		{
			_soundManager.playSound('pop');
			if(_buttonCancel != null)	_buttonCancel.removeEventListener(MouseEvent.CLICK, destroy);
			
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