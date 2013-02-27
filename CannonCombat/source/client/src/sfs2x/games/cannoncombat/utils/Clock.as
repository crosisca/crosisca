package sfs2x.games.cannoncombat.utils
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
	 * Clock
	 * 
	 * Displays a clock
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.utils.TextUtils;
	
	public class Clock extends Sprite
	{	
		private var 
			_timeRemaining		:int,
			_display			:TextField,
			_label				:TextField,
			_clock				:Timer,
			_expireTimer		:Number;
			
			
			
		/**
		 * Constructor
		 */ 
		public function Clock($label:String = '', $style:String = 'default_blue', $padding:Number = 2) 
		{
			if($label != '')
			{
				_label = TextUtils.createTextField(false, false, 'center');
				_label.x = $padding * 2;
				_label.y = $padding;
				_label.htmlText = '<span class="' + $style + '">' + $label.toUpperCase()+ ' ' + '</span>';
				//_label.filters = [Settings.DROP_SHADOW_BOLD]; //Filters affect performance on mobile according to Adobe. Pls see: http://www.adobe.com/devnet/flash/articles/optimizing-mobile-performance.html
				
				addChild(_label);
			}
			//Clock timer
			_clock = new Timer(1000, Settings.DEFAULT_CLOCK_TIME);
			_clock.addEventListener(TimerEvent.TIMER, onTick, false, 0, true);
			_clock.addEventListener(TimerEvent.TIMER_COMPLETE, onClockExpire, false, 0, true);
			
			//Actual clock
			_display = TextUtils.createTextField(false, false, 'center');
			//_display.filters = [Settings.DROP_SHADOW_BOLD]; //Filters affect performance on mobile according to Adobe. Pls see: http://www.adobe.com/devnet/flash/articles/optimizing-mobile-performance.html
			_display.x = $padding * 2;
			_display.y = $padding * 20;
			addChild(_display);
		}
		

		
		/**
		 * Initialize timer for clock and dispay it
		 * 
		 */
		public function start():void
		{		
			display = timeFormat(Settings.DEFAULT_CLOCK_TIME);
			
			_clock.reset();
			_clock.start();
			
			_expireTimer = int(getTimer()/1000) + Settings.DEFAULT_CLOCK_TIME;
		}
		
		
		
		/**
		 * Stop clock
		 */
		public function stop():void
		{
			if(_clock != null)	_clock.stop();
		}
		
		
		
		/**
		 * Resume clock
		 */
		public function resume():void
		{
			_expireTimer = int(getTimer()/1000) + _timeRemaining;
			_clock.start();
		}

		
		
		/**
		 * Set clock text manually, not based on stored time
		 * 
		 * @param $time :int
		 */
		public function manuallySetClock($time:int):void 
		{
			_expireTimer = int(getTimer()/1000) + $time;
			
			display = timeFormat($time);
			
			_clock.repeatCount = $time;
			
			_clock.reset();
			_clock.start();
		}
		
		
		
		/**
		 * Removes from memory
		 */
		public function destroy():void
		{
			if(_clock)
			{
				_clock.stop();
				_clock.removeEventListener(TimerEvent.TIMER, onTick);
				_clock.removeEventListener(TimerEvent.TIMER_COMPLETE, onClockExpire);
				_clock = null;
			}
			
			while (numChildren) 
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
		}
		
		
		
		/**
		 * Time format
		 * 
		 * @param seconds :int
		 */
		private function timeFormat(seconds:int):String
		{
			var minutes		:int,
				sMinutes	:String,
				sSeconds	:String;
			
			if (seconds > 59)
			{
				minutes = Math.floor(seconds / 60);
				sMinutes = String(minutes);
				if (sMinutes.length == 1) sMinutes = "0" + sMinutes;
				sSeconds = String(seconds % 60);
				if (sSeconds.length == 1) sSeconds = "0" + sSeconds;
			}
			else
			{
				sMinutes = "";
				sSeconds = String(seconds);
			}
			
			if (sMinutes.length < 1) return sSeconds;
			else return sMinutes + ":" + sSeconds;
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Event to count seconds
		 * 
		 * @param $e :TimerEvent
		 */
		private function onTick($e:TimerEvent):void
		{
			if (int(getTimer()/1000) > _expireTimer) 
			{
				onClockExpire(null);
				this.display = timeFormat(0);
			}
			else
			{
				_timeRemaining = _expireTimer - int(getTimer() / 1000);
				this.display = timeFormat(_timeRemaining);
			}
		}
		
		/**
		 * Event when time is up
		 * 
		 * @param $e :TimerEvent
		 */
		private function onClockExpire($e:TimerEvent):void 
		{		
			_clock.stop();
			_clock.reset();
				 
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get display():String { return String(_display.text); }
		public function set display($number:String):void { _display.htmlText = '<span class="default_blue">' + $number + ' '+ '</span>'; }
		
	}
}