package sfs2x.games.cannoncombat.events
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
	 * CustomEvent
	 * 
	 * Custom event types extending Event
	 * 
	 * @author 		Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0
	 */
	
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		public var arg:*;	// An argument that can be of any type

		public static const 
			BUTTON_CLICK		:String = 'button_click',
			DATA_SET			:String = 'data_set',
			ARENA_SELECTED		:String = 'arena_selected',
			CHALLENGE			:String = 'challenge',
			CHALLENGE_ROOM		:String = 'challenge_room',
			SOLDIER_KILLED		:String	= 'soldier_killed',
			GAME_OVER			:String	= 'game_over';
		
			
			
		/**
		 * Constructor - Receives parameters and registers within super class
		 * 
		 * @param $type			:String  - Custom event identifier (const)
		 * @param $bubbles		:Boolean - Indicates whether an event is a bubbling event (up the display list).
		 * @param $cancelable	:Boolean - Indicates whether the behavior associated with the event can be prevented.
		 * @param $a 			:*		 - Optional parameters
		 */
		public function CustomEvent($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false, ... $a:*)
		{
			//$a: unlimited number of arguments of any kind
			super($type, $bubbles, $cancelable);
			arg = $a;
		}
		

		
		/**
		 * Clone must override in order to have a duplicate of the properties
		 * of our custom class available to listener handlers		 
		 * 
		 * @return Event
		 */
		override public function clone():Event
		{
			return new CustomEvent(type, bubbles, cancelable, arg);
		}
	}
}