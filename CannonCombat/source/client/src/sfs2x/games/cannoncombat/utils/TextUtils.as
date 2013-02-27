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
	 * TextUtils
	 * 
	 * Simplifies the creation of text fields
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import sfs2x.games.cannoncombat.config.Settings;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	
	public class TextUtils
	{
		/**
		 * Constructor
		 */
		public function TextUtils():void
		{
			
		}
		
		
		
		/**
		 * Creates and returns a text field
		 * 
		 * @param	$multiline :Boolean
		 * @param	$wordwrap  :Boolean
		 * @param	$autoSize  :String
		 * 
		 * @return TextField
		 */
		public static function createTextField($multiline:Boolean = false, $wordwrap:Boolean = false, $autoSize:String = 'left' ):TextField 
		{
			var tf			:TextField 	= new TextField(),
				css			:StyleSheet = new StyleSheet();
			
			css.parseCSS(Settings.STYLE_SHEET);

			tf.styleSheet = css;
			tf.embedFonts = true;
			tf.mouseEnabled = false;
			tf.condenseWhite = true;
			tf.multiline = $multiline;
			tf.wordWrap = $wordwrap;
			tf.selectable = false;
			tf.autoSize = $autoSize;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			if ($autoSize == 'none') tf.width = 200;

			return tf;
		}
		
		
		
		/**
		 * Create the input text field
		 * 
		 * @param	$style 		:String
		 * @param	$multiline  :Boolean
		 * 
		 * @return TextField
		 */
		public static function createInputTextField($style:String = null, $multiline:Boolean = false):TextField
		{
			var 
				input	:TextField 	= new TextField(),
				css		:StyleSheet = new StyleSheet();
			
			css.parseCSS(Settings.STYLE_SHEET);

			input.type = TextFieldType.INPUT;
			input.multiline = $multiline;
			input.wordWrap = $multiline;
			input.border = false;
			input.borderColor = 0xAAAAAA;
			input.embedFonts = true;
			
			if($style != null) input.defaultTextFormat = css.transform(css.getStyle($style));

			return input;	
		}
		
		
		
		/**
		 * Draw input box
		 * 
		 * @param	$x 			:int
		 * @param	$y  		:int
		 * @param	$width  	:int
		 * @param	$height  	:int
		 * @param	$padding  	:int
		 * 
		 * @return Sprite
		 */
		public static function drawInputBox($x:int, $y:int, $width:int, $height:int, $padding:int):Sprite
		{
			var 
				bg		:Sprite = new Sprite(),
				border	:Shape = new Shape();
			
			//create background
			bg.graphics.clear();
			bg.graphics.beginFill(0x456c81, 0.16);
			bg.graphics.drawRoundRect(-$padding, -$padding, $width + 2*$padding, $height + 2*$padding, Settings.DEFAULT_ELLIPSE, Settings.DEFAULT_ELLIPSE);
			bg.graphics.endFill();
			bg.x = $x;
			bg.y = $y;
			
			// Create border
			border.graphics.clear();
			border.graphics.lineStyle(2, 0xa2a5ac, .7);
			border.graphics.drawRoundRect(-$padding, -$padding, $width + 2*$padding, $height + 2*$padding, 4, 4);
			border.graphics.endFill();
			bg.addChild(border);
			
			return bg;
		}
	}
}