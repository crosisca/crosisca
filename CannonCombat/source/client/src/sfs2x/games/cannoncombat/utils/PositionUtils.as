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
	 * PositionUtil
	 * 
	 * A class to handle relative positioning within the parent
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */

	import flash.display.Sprite;
	
	import sfs2x.games.cannoncombat.config.Settings;
	
	public class PositionUtils extends Sprite
	{
		private var 
			_parent		:Object,
			_child		:Object;
			
			
		/**
		 * Constructor
		 */ 
		public function PositionUtils():void
		{
			
		}
		
		
		
		/**
		 * Centers the object
		 * 
		 * @param $child		:Object  - Child object to be centered
		 * @param $parent		:Object  - Paobject
		 * @param $horizontal	:Boolean - Indicates if centering is horizontal (x axis)
		 * @param $vertical		:Boolean - Indicates if centering is vertical (y axis)
		 */
		public static function center($child:Object = null, $parent:Object = null, $horizontal:Boolean = false, $vertical:Boolean = false):void
		{
			if($horizontal) $child.x = (Settings.APPLICATION_WIDTH * .5) - ($child.width * .5);
			if($vertical)	$child.y = (Settings.APPLICATION_HEIGHT * .5) - ($child.height * .5);
		}
		
		
		
		/**
		 * Offsets the object
		 * 
		 * @param $child	:Object  - Child object to be positioned according to percentage
		 * @param $x		:Number  - Percentage to be offset in the x axis
		 * @param $y		:Number  - Percentage to be offset in the y axis
		 */
		public static function offset($child:Object = null, $x:Number = 0, $y:Number = 0):void
		{
			if($x != 0)
			{
				(Math.abs($x) < 1)
				?
				$child.x = (Settings.APPLICATION_WIDTH * $x)
				:
				$child.x = (Settings.APPLICATION_WIDTH * .5) - $x;
			}
			
			if($y != 0)
			{
				(Math.abs($y) < 1)
				?
				$child.y = (Settings.APPLICATION_HEIGHT * $y)
				:
				$child.y = (Settings.APPLICATION_HEIGHT * .5) - $y;
			
			}
		}
	}
}