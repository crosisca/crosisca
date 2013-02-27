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
	 * Score
	 * 
	 * Displays a clock
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import sfs2x.games.cannoncombat.config.Settings;
	
	public class Score extends Sprite
	{	
		private var 
			_points				:int			= 0,
			_style				:String 		= 'default_blue_small',
			_isItMe				:Boolean,	
			_score				:TextField,
			_pName				:String			= '',
			_playerName			:TextField;
			
			
			
		/**
		 * Constructor
		 */ 
		public function Score() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		
		
		/**
		 * Adds points
		 * 
		 * @param $points :int - Number of points to be added
		 */
		public function add($points:int = 100):void
		{
			_points += $points;
			_score.htmlText = '<span class="' + _style + '">' + _points.toString()+ ' ' + '</span>';
		}
		
		
		
		/**
		 * Removes from memory
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
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Initialize graphical elements and sounds
		 * 
		 * @param $e :Event - Event.ADDED_TO_STAGE
		 */
		private function init($e:Event = null):void
		{
			//Points
			_score = TextUtils.createTextField(false, false, 'right');
			_score.x = Settings.APPLICATION_WIDTH - _score.width - 8;
			_score.htmlText = '<span class="' + _style + '">' + _points.toString()+ ' ' + '</span>';
			//_score.filters = [Settings.DROP_SHADOW_BOLD]; //Filters affect performance on mobile according to Adobe. Pls see: http://www.adobe.com/devnet/flash/articles/optimizing-mobile-performance.html
			addChild(_score);
			
			//Player name
			_playerName = TextUtils.createTextField(false, false, 'right');
			_playerName.x = Settings.APPLICATION_WIDTH - _playerName.width - 8;
			//_playerName.filters = [Settings.DROP_SHADOW_BOLD]; //Filters affect performance on mobile according to Adobe. Pls see: http://www.adobe.com/devnet/flash/articles/optimizing-mobile-performance.html
			addChild(_playerName);
			
			if(isItMe)
			{
				_score.y = 32;
				_playerName.y = 2;
			}
			else
			{
				_score.y = 112;
				_playerName.y = 80;
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get playerName():String { return _playerName.text; };
		public function set playerName($value:String):void 
		{
			_pName = $value;
			_playerName.htmlText = '<span class="' + _style + '">' + _pName.toUpperCase()+ ' ' + '</span>';
			_playerName.x = Settings.APPLICATION_WIDTH - _playerName.width - 8;
		}
		
		public function get playerNameTF():TextField { return _playerName; };
		public function set playerNameTF($value:TextField):void 
		{
		}
		
		public function get points():int { return _points; };
		public function set points($value:int):void { _points = $value; }
		
		public function get isItMe():Boolean { return _isItMe; };
		public function set isItMe($value:Boolean):void { _isItMe = $value }
		
	}
}