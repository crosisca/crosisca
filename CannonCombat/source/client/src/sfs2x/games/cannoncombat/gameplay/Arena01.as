package sfs2x.games.cannoncombat.gameplay
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
	 * Arena01
	 * 
	 * Example arena
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0
	 */
	
	import Box2D.Dynamics.b2Body;
	
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	
	public class Arena01 extends BasicArena
	{
		private var 
			_arrFortress:Array;
			
			
			
		/**
		 * Constructor
		 */
		public function Arena01()
		{
			super();
		}
		
		
		
		/**
		 * Initial setup of the arena (not a reset)
		 */
		override public function setUp():void
		{
			_arrFortress = 
				[
					{width:5.3, height:0.93, side:"left", x:6.933, y:17.70, type:'BOOK_BLUE'},
					{width:0.92, height:1.0, side:"left", x:9.467, y:13.33, type:'SOLDIER'},
					{width:0.40, height:0.80, side:"left", x:6.833, y:13.00, type:'DOMINO_1'},
					{width:2.8, height:0.18, side:"left", x:4.733, y:12.07, type:'PENCIL'},
					{width:0.80, height:0.80, side:"left", x:6.533, y:11.03, type:'BLOCK_A'},
					{width:0.92, height:1.0, side:"left", x:4.333, y:10.87, type:'SOLDIER'},
					{width:28, height:0.73, side:"left", x:28.01, y:19.32, type:'DESK'},
					{width:5.3, height:0.93, side:"right", x:69.03, y:17.67, type:'BOOK_BLUE'},
					{width:0.92, height:1.0, side:"right", x:71.03, y:13.73, type:'SOLDIER'},
					{width:0.40, height:0.80, side:"right", x:69.27, y:13.00, type:'DOMINO_1'},
					{width:2.8, height:0.18, side:"right", x:71.23, y:12.00, type:'PENCIL'},
					{width:0.80, height:0.80, side:"right", x:69.47, y:11.00, type:'BLOCK_A'},
					{width:0.92, height:1.0, side:"right", x:71.67, y:10.83, type:'SOLDIER'},
					{width:0.92, height:1.0, side:"left", x:13.93, y:17.63, type:'SOLDIER'},
					{width:0.92, height:1.0, side:"left", x:5.000, y:13.73, type:'SOLDIER'},
					{width:0.80, height:0.80, side:"left", x:3.033, y:13.90, type:'BLOCK_B'},
					{width:0.80, height:0.80, side:"left", x:10.93, y:15.93, type:'BLOCK_C'},
					{width:1.6, height:0.20, side:"left", x:9.800, y:14.50, type:'CRAYON_G'},
					{width:1.6, height:0.20, side:"left", x:11.03, y:14.90, type:'CRAYON_O'},
					{width:0.20, height:1.6, side:"left", x:5.467, y:10.20, type:'CRAYON_B'},
					{width:0.80, height:0.40, side:"left", x:7.200, y:14.30, type:'DOMINO_2'},
					{width:0.80, height:0.40, side:"left", x:2.967, y:12.70, type:'DOMINO_3'},
					{width:0.85, height:1.5, side:"left", x:16.43, y:17.10, type:'KNIGHT'},
					{width:0.80, height:0.80, side:"right", x:73.00, y:13.87, type:'BLOCK_B'},
					{width:0.80, height:0.80, side:"right", x:65.03, y:15.90, type:'BLOCK_C'},
					{width:0.20, height:1.6, side:"right", x:70.53, y:10.13, type:'CRAYON_B'},
					{width:1.6, height:0.20, side:"right", x:66.20, y:14.43, type:'CRAYON_G'},
					{width:1.6, height:0.20, side:"right", x:65.33, y:14.87, type:'CRAYON_O'},
					{width:0.80, height:0.40, side:"right", x:68.88, y:14.33, type:'DOMINO_2'},
					{width:0.80, height:0.40, side:"right", x:72.97, y:12.67, type:'DOMINO_3'},
					{width:0.85, height:1.5, side:"right", x:59.73, y:17.10, type:'KNIGHT'},
					{width:0.92, height:1.0, side:"right", x:66.67, y:13.33, type:'SOLDIER'},
					{width:0.92, height:1.0, side:"right", x:62.07, y:17.63, type:'SOLDIER'},
					{width:3.5, height:1.0, side:"right", x:70.47, y:15.73, type:'BOOK_RED'},
					{width:3.5, height:1.0, side:"left", x:5.800, y:15.73, type:'BOOK_RED'},
					{width:0.20, height:1.6, side:"left", x:10.53, y:12.67, type:'CRAYON_P'},
					{width:0.20, height:1.6, side:"right", x:65.57, y:12.60, type:'CRAYON_P'},
					{width:0.92, height:1.0, side:"left", x:18.97, y:17.63, type:'SOLDIER'},
					{width:0.92, height:1.0, side:"right", x:57.23, y:17.63, type:'SOLDIER'}
				];

			reset();
			
			//Clear all physics bodies
			for (var currentBody:b2Body = _worldB2.GetBodyList(); currentBody; currentBody = currentBody.GetNext())
			{
				_worldB2.DestroyBody(currentBody);
			}
			
			//Clear display list
			var i		:int = 0,
				num		:int = numChildren - 1;
			
			for (i = num; i >= 0; i--)
			{
				var child:* = getChildAt(i);
				if(child.name == 'BOOK_BLUE' || child.name == 'BOOK_RED' || child.name == 'BLOCK' || child.name == 'SOLDIER' || child.name == 'DOMINO' || child.name == 'PENCIL' || child.name == 'CRAYON') //Only blocks
					removeChildAt(i);
			}
			
			//Add physics elements
			var
				len			:int 		= _arrFortress.length,
				w			:Number,
				h			:Number,
				side		:String,
				posX		:Number,
				posY		:Number,
				type		:String,
				index		:Number;
			
			for(i = 0; i < len; i++)
			{
				w 		= _arrFortress[i].width;
				h 		= _arrFortress[i].height;
				side	= _arrFortress[i].side;
				posX 	= _arrFortress[i].x;
				posY 	= _arrFortress[i].y;
				type 	= _arrFortress[i].type;
				index	= i;
				
				addBody(w, h, side, posX, posY, type, index);
			}
			
			//We added soldiers for both sides, therefore we count half
			if(!_gameController.isSpectator)	_numberSoldiers *= .5;
		}
		
		
		
		/**
		 * It resets the world for each turn played
		 */
		override public function reset():void
		{
			super.reset();
			
			_following = false;
			
			//Clear display list
			var i		:int = 0,
				num		:int = numChildren - 1;
			
			for (i = num; i >= 0; i--)
			{
				var child:* = getChildAt(i);
				if(child.name == 'CANNONBALL')
					removeChildAt(i);
			}
			
			//Set all bodies to sleep state
			super.setAsleep();
			
			//Based on the player turn, decide which cannon is active
			if (_playerTurn == _p1.name)
			{
				_activeCannon = _p1Cannon;
				_inActiveCannon = _p2Cannon;
			}
			else
			{
				_activeCannon = _p2Cannon;
				_inActiveCannon = _p1Cannon;
			}
			
			//Allow only myself to click on the cannon
			if(_playerTurn == _myName)
				_activeCannon.load();
			
			//Position camera
			y = - _activeCannon.y * .5 + 100;
			
			TweenLite.to(this, 1, {delay:1, x:400 - _activeCannon.x,
				onComplete:function():void
				{
					addEventListener(Event.ENTER_FRAME, updateWorld, false, 0, true);
					
					if(_gameController.shootingClock != null)	_gameController.shootingClock.visible = true;
					_gameController.controlClock();
				} 
			});
		}
	}
}