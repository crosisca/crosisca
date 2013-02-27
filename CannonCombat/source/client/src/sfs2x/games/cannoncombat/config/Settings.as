package sfs2x.games.cannoncombat.config
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
	 * Settings
	 * 
	 * Application settings comprised of static properties and methods
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0
	 */
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	
	
	
	public class Settings
	{
		public static const
			//Application settings
			VERSION						:String				= '1.0',
			DEBUG						:Boolean			= true,			// Debug mode
			SFS_DEBUG					:Boolean			= false,		// Enables verbose tracing for all SFS interactions
			DEBUG_WINS					:int				= 1, 			// Additional client windows for testing in debug mode
			FRAME_RATE					:int				= 30,
			MOBILE						:Boolean			= false,
			
			//SmartFoxServer configuration
			SFS2X_IP					:String				= '127.0.0.1',
			SFS2X_PORT					:int				= 9933,
			SFS2X_HTTP_PORT				:int				= 8080,
			SFS2X_UDP_PORT				:int				= 9933,
			SFS2X_ZONE					:String				= 'CannonCombat',
			SFS2X_LOBBY					:String				= 'lobby',
			
			//Default application UI elements
			SCROLLBAR_WIDTH				:int				= 4,			// The default width of a scrollbar
			
			DEFAULT_ELLIPSE				:int				= 10,			// The default ellipse radius used for rounded edges
			
			COLOR_WHITE					:uint				= 0xffffff,
			COLOR_BLACK					:uint				= 0x000000,
			COLOR_GREY					:uint				= 0x666666,
			COLOR_GREEN					:uint				= 0x586a22,
			COLOR_BLUE					:uint				= 0x315d71,
			
			DEFAULT_BUT_START_COLOR		:uint 				= 0xcacaca,		// The gradient starting colour for default buttons
			DEFAULT_BUT_END_COLOR		:uint 				= 0xcacaca,		// The gradient ending colour for default buttons
			
			DEFAULT_BUT_MO_START_COLOR	:uint 				= 0x8a8a8a,		// The gradient starting colour for default buttons when the mouse is over them
			DEFAULT_BUT_MO_END_COLOR	:uint 				= 0x8a8a8a,		// The gradient ending colour for default buttons when the mouse is over them  
			
			GLOW_FILTER					:GlowFilter			= new GlowFilter(0x99fffb, .4, 8, 8, 4, 2),
			DROP_SHADOW					:DropShadowFilter	= new DropShadowFilter(4,45,0x000000,.5),
			DROP_SHADOW_BOLD			:DropShadowFilter	= new DropShadowFilter(2,90,0x000000,.8,2,2,2),
			
			DEFAULT_CLOCK_TIME			:int 				= 15,
			
			PLAYER_NAME					:String				= 'pn',
			GAME_STATUS					:String				= 's',
			
			//Game status codes
			STATUS_IN_LIMBO				:String				= 'i', 			//Limbo is prior to Lobby, user cannot play until they hit Play Game button
			STATUS_IN_LOBBY				:String				= 'l',
			STATUS_IN_GAME				:String				= 'g',

			//Extension commands
			EXT_GAME					:String				= 'G.',
			EXT_START					:String				= 'S',
			
			//Room Variable Updates
			RV_CANNON					:String				= 'c',
			RV_TURN						:String				= 't',
			RV_ARENA					:String				= 'a',
			
			//Object message
			OM_ASLEEP					:String				= 'a',
			OM_CANNON_ANGLE				:String				= 'c',
			OM_GAME_OVER				:String				= 'o',
			 
			//Messages
			MSG_ERR_DEFAULT				:Object				= {title:'Error', msg:'Sorry, an error has occured', buttonlabel:'Close'},
			MSG_ERR_CONN				:Object				= {title:'Error Connecting to SFS2X', msg:'Sorry, there has been a problem connecting to the server. Please try again.', buttonlabel:'OK'},
			MSG_ERR_LOGIN				:Object				= {title:'Error Logging on to SFS2X', msg:'Sorry, there has been a problem with your login. Please try another user name.', buttonlabel:'OK'},
			MSG_ERR_ROOMJOIN			:Object				= {title:'Error Joining Room', msg:'Sorry, there has been a problem joining the room. Please try again.', buttonlabel:'OK'},
			MSG_ERR_ROOMADD				:Object				= {title:'Error Creating Room', msg: 'Sorry, the room name you specified is already in use.  Please specify a different room name.', buttonlabel:'OK'},
			MSG_CONN_LOST				:Object				= {title:'Connection Lost', msg: 'Sorry, you have exceeded the inactivity limit. Please log on again.', buttonlabel:'OK'},
			
			//CSS Definitions
			STYLE_SHEET					:String				= 	'.default_black			{ font-size: 48; font-family: Bangers;  color: #000000; }' +
																'.default_white			{ font-size: 48; font-family: Bangers;  color: #ffffff; }' +
																'.default_white_small	{ font-size: 30; font-family: Bangers;  color: #ffffff; }' +
																'.chat_default			{ font-size: 20; font-family: Helvetica; color: #ffffff; }' +
																'.chat_orange_bold		{ font-size: 20; font-family: HelveticaBold; color: #e36628; }' +
																'.default_blue			{ font-size: 48; font-family: Bangers;  color: #213f4e; }' +
																'.default_blue_small	{ font-size: 30; font-family: Bangers;  color: #213f4e; }' +
																'.chat_orange			{ font-size: 20; font-family: Helvetica; color: #e36628; }';
			

		private static var 
			_global						:Object;
			
		public static var
			//For dev, we use the Android Nexus S settings (W = 800, H = 480)
			//For prod, please see the first view MXML and the document class MXML
			APPLICATION_WIDTH			:int				= 800,
			APPLICATION_HEIGHT			:int				= 480,
			
			DEFAULT_WIN_WIDTH			:int				= 800,			// The default width for popup windows
			DEFAULT_WIN_HEIGHT			:int				= 480;			// The default height for popup windows
			
			

			
		/**
		 * Initialize global dictionary
		 */	
		private static function init():void
		{
			_global = new Object();
			_global['SFS2X Cannon Combat'] = new Dictionary(true);
		
			//If DEBUG is set to true create the same dictionary for each debug window
			if(DEBUG)
			{
				for(var i:int = 1; i < DEBUG_WINS + 1; i++)
				{
					_global['debug' + i] = new Dictionary(true);
				}
			}
		}
		
		
		
		/**
		 * Make a property available from all classes (via getGlobal)
		 * 
		 * @param $key		:String - The string by which this property will be referenced
		 * @param $value	:*		- The property to be set global
		 * @param $win		:String - The window ID
		 */	
		public static function setGlobal($key:String, $value:*, $win:String = ''):void 
		{
			if(_global == null) init();
			_global[$win][$key] = $value;
		}
		
		
		
		/**
		 * Retrieve a property that has been setGlobal()
		 * 
		 * @param $key		:String - The string identifying the desired property
		 * @param $win		:String - The window ID
		 */	
		public static function getGlobal($key:String, $win:String):*
		{
				return _global[$win][$key];
		}
		
		
		
		/**
		 * Removes elements from memory
		 */
		public static function destroy($win:String):void
		{
			if(_global != null)
			{
				for(var i:* in _global[$win])
				{
					delete _global[$win][i];
				}
				delete _global[$win];
			}
		}
	}
}