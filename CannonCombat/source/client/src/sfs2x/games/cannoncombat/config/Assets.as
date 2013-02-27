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
	 * Assets
	 * 
	 * Loads and returns new instances of embedded assets
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	
	
	public class Assets
	{
		private var disposables:Dictionary = new Dictionary(true); // Objects to be destroyed
		
		/**
		 * Fonts
		 */
		
		[Embed(source='../../../../assets/fonts/HelveticaLTStdRoman.otf', fontName = 'Helvetica', fontWeight = 'normal', mimeType = 'application/x-font', unicodeRange="U+0041-U+005A,U+0020-U+0040,U+0061-U+007A,U+005F,U+007E", embedAsCFF='false')]
		private static var Helvetica:Class;
		
		[Embed(source='../../../../assets/fonts/HelveticaNeueLTStdBd.otf', fontName = 'HelveticaBold', fontWeight = 'bold', mimeType = 'application/x-font', unicodeRange="U+0041-U+005A,U+0020-U+0040,U+0061-U+007A,U+005F,U+007E", embedAsCFF='false')]
		private static var HelveticaBold:Class;
		
		//NOTE: Font Bangers.ttf is embedded and exported to Actionscript in the swc file because it's used on Soldier MovieClip's timeline.

		
		/**
		 * Images
		 */
		
		[ Embed(source='../../../../assets/images/bg.jpg') ]
		private static const _bg:Class;
		
		[ Embed(source='../../../../assets/images/title.png') ]
		private static const _title:Class;
		
		[ Embed(source='../../../../assets/images/button_bg.png') ]
		private static const _button_bg:Class;
		
		[ Embed(source='../../../../assets/images/button_small_bg.png') ]
		private static const _button_small_bg:Class;
		
		[ Embed(source='../../../../assets/images/button_over_bg.png') ]
		private static const _button_over_bg:Class;
		
		[ Embed(source='../../../../assets/images/button_options_bg.png') ]
		private static const _button_options_bg:Class;
		
		[ Embed(source='../../../../assets/images/button_rules_bg.png') ]
		private static const _button_rules_bg:Class;
		
		[ Embed(source='../../../../assets/images/input_bg.png') ]
		private static const _input_bg:Class;
		
		[ Embed(source='../../../../assets/images/default_panel.png') ]
		private static const _default_panel:Class;
		
		[ Embed(source='../../../../assets/images/guide_panel.png') ]
		private static const _guide_panel:Class;
		
		[ Embed(source='../../../../assets/images/arena_panel.png') ]
		private static const _arena_panel:Class;
		
		[ Embed(source='../../../../assets/images/bottom_menu_center.png') ]
		private static const _bottom_menu_center:Class;
		
		[ Embed(source='../../../../assets/images/bottom_menu_left.png') ]
		private static const _bottom_menu_left:Class;
		
		[ Embed(source='../../../../assets/images/bottom_menu_right.png') ]
		private static const _bottom_menu_right:Class;
		
		[ Embed(source='../../../../assets/images/bottom_menu_center_over.png') ]
		private static const _bottom_menu_center_over:Class;
		
		[ Embed(source='../../../../assets/images/bottom_menu_left_over.png') ]
		private static const _bottom_menu_left_over:Class;
		
		[ Embed(source='../../../../assets/images/bottom_menu_right_over.png') ]
		private static const _bottom_menu_right_over:Class;
		
		[ Embed(source='../../../../assets/images/button_notification.png') ]
		private static const _button_notification:Class;
		
		[ Embed(source='../../../../assets/images/button_notification_over.png') ]
		private static const _button_notification_over:Class;
		
		[ Embed(source='../../../../assets/images/button_main_menu.png') ]
		private static const _button_main_menu:Class;
		
		[ Embed(source='../../../../assets/images/button_main_menu_over.png') ]
		private static const _button_main_menu_over:Class;
		
		[ Embed(source='../../../../assets/images/blue_bar.png') ]
		private static const _blue_bar:Class;
		
		[ Embed(source='../../../../assets/images/button_accept.png') ]
		private static const _button_accept:Class;
		
		[ Embed(source='../../../../assets/images/button_deny.png') ]
		private static const _button_deny:Class;
		
		[ Embed(source='../../../../assets/images/audio_on.png') ]
		private static const _audio_on:Class;
		
		[ Embed(source='../../../../assets/images/audio_off.png') ]
		private static const _audio_off:Class;
		
	   /**
		* Constructor 
		*/
		public function Assets() {}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get bg():Bitmap { var val:Bitmap = new _bg(); disposables[val] = true; return val;}
		public function get title():Bitmap { var val:Bitmap = new _title(); disposables[val] = true; return val;}
		
		public function get button_bg():Bitmap { var val:Bitmap = new _button_bg(); disposables[val] = true; return val;}
		public function get button_small_bg():Bitmap { var val:Bitmap = new _button_small_bg(); disposables[val] = true; return val;}
		public function get button_over_bg():Bitmap { var val:Bitmap = new _button_over_bg(); disposables[val] = true; return val;}
		public function get button_options_bg():Bitmap { var val:Bitmap = new _button_options_bg(); disposables[val] = true; return val;}
		public function get button_rules_bg():Bitmap { var val:Bitmap = new _button_rules_bg(); disposables[val] = true; return val;}
		public function get input_bg():Bitmap { var val:Bitmap = new _input_bg(); disposables[val] = true; return val;}
		
		public function get default_panel():Bitmap { var val:Bitmap = new _default_panel(); disposables[val] = true; return val;}
		public function get guide_panel():Bitmap { var val:Bitmap = new _guide_panel(); disposables[val] = true; return val;}
		public function get arena_panel():Bitmap { var val:Bitmap = new _arena_panel(); disposables[val] = true; return val;}
		
		public function get bottom_menu_center():Bitmap { var val:Bitmap = new _bottom_menu_center(); disposables[val] = true; return val;}
		public function get bottom_menu_left():Bitmap { var val:Bitmap = new _bottom_menu_left(); disposables[val] = true; return val;}
		public function get bottom_menu_right():Bitmap { var val:Bitmap = new _bottom_menu_right(); disposables[val] = true; return val;}
		public function get bottom_menu_center_over():Bitmap { var val:Bitmap = new _bottom_menu_center_over(); disposables[val] = true; return val;}
		public function get bottom_menu_left_over():Bitmap { var val:Bitmap = new _bottom_menu_left_over(); disposables[val] = true; return val;}
		public function get bottom_menu_right_over():Bitmap { var val:Bitmap = new _bottom_menu_right_over(); disposables[val] = true; return val;}
		public function get button_notification():Bitmap { var val:Bitmap = new _button_notification(); disposables[val] = true; return val;}
		public function get button_notification_over():Bitmap { var val:Bitmap = new _button_notification_over(); disposables[val] = true; return val;}
		public function get button_main_menu():Bitmap { var val:Bitmap = new _button_main_menu(); disposables[val] = true; return val;}
		public function get button_main_menu_over():Bitmap { var val:Bitmap = new _button_main_menu_over(); disposables[val] = true; return val;}
		public function get button_accept():Bitmap { var val:Bitmap = new _button_accept(); disposables[val] = true; return val;}
		public function get button_deny():Bitmap { var val:Bitmap = new _button_deny(); disposables[val] = true; return val;}
		public function get audio_on():Bitmap { var val:Bitmap = new _audio_on(); disposables[val] = true; return val;}
		public function get audio_off():Bitmap { var val:Bitmap = new _audio_off(); disposables[val] = true; return val;}
		
		public function get blue_bar():Bitmap { var val:Bitmap = new _blue_bar(); disposables[val] = true; return val;}
		
		
		
		/**
		 * Dispose all bitmapdata objects that have been instantiated
		 */
		public function destroy():void
		{
			for (var o:Object in disposables)
			{
				try
				{
					var bmpData:BitmapData = (o as Bitmap).bitmapData;
					bmpData.dispose();
					o = null;
				}
				catch (e:*)
				{
					//trace('Assets dispose error: '+e);
				}
			}
		}
	}
}