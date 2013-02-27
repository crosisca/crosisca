package sfs2x.games.cannoncombat.ui.elements
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
	 * Background
	 * 
	 * Returns a background for use in UI elements
	 * 
	 * @author 		Wayne Helman
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import sfs2x.games.cannoncombat.config.Settings;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	public class Background extends Shape
	{
		private var
			_width				:int,
			_height				:int,
			_color				:uint,
			_gradient			:Boolean 	= false,
			_stroke				:Boolean 	= false,
			_centered			:Boolean 	= false,
			_round				:Boolean 	= false,
			_strokeStartColor	:uint,
			_strokeEndColor		:uint,
			_startColor			:uint,
			_endColor			:uint,
			_bgalpha			:Number,
			_radius				:int;
			
			
			
		/**
		 * Constructor
		 * 
		 * @param $width 	:int
		 * @param $height 	:int
		 * @param $alpha 	:Number
		 * @param $color 	:uint
		 * @param $radius 	:int - The radius of the rounded corners of the background
		 */
		public function Background($width:int, $height:int, $alpha:Number = 1, $color:uint = Settings.COLOR_BLACK, $radius:int = Settings.DEFAULT_ELLIPSE)
		{
			_width = $width;
			_height = $height;
			_color = $color;
			_bgalpha = $alpha;
			_radius = $radius;
		}
		

		
		/**
		 * Style our background with available properties
		 */
		public function draw():void
		{
			graphics.clear();

			if(_stroke) 
			{
				var lineGradientMatrix:Matrix = new Matrix();
				lineGradientMatrix.createGradientBox(_width, _height);
				graphics.lineStyle(1,0,.5);
				graphics.lineGradientStyle(GradientType.LINEAR, [_strokeStartColor, _strokeEndColor, _strokeStartColor], [1.0, 1.0, 1.0], [0, 255*.5, 255], lineGradientMatrix);
			}
			
			if(_gradient) 
			{
				var gradientMatrix:Matrix = new Matrix();
				gradientMatrix.createGradientBox(_width, _height);
				graphics.beginGradientFill( GradientType.LINEAR, [_startColor, _endColor, _startColor], [1.0, 1.0, 1.0], [0, 255*.5, 255], gradientMatrix);
			}
			else
			{
				graphics.beginFill(_color, _bgalpha);
			}

			if (_centered)
			{
				(_round) ? graphics.drawRoundRect(-_width * .5, -_height * .5, _width, _height, _radius) : graphics.drawRect(-_width * .5, -_height * .5, _width, _height);
			}
			else
			{
				(_round) ? graphics.drawRoundRect(0, 0, _width, _height, _radius) : graphics.drawRect(0, 0, _width, _height);
			}
			
			graphics.endFill();
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		public function get color():uint { return _color; }		
		public function set color(value:uint):void { _color = value; }
		
		public function get gradient():Boolean { return _gradient; }		
		public function set gradient(value:Boolean):void { _gradient = value; }
		
		public function get gradientStartColor():uint { return _startColor; }		
		public function set gradientStartColor(value:uint):void { _startColor = value; }
		
		public function get gradientEndColor():uint { return _endColor; }		
		public function set gradientEndColor(value:uint):void { _endColor = value; }
		
		public function get bgalpha():Number { return _bgalpha; }		
		public function set bgalpha(value:Number):void { _bgalpha = value; }
		
		public function get strokeStartColor():uint { return _strokeStartColor; }		
		public function set strokeStartColor(value:uint):void { _strokeStartColor = value; }
		
		public function get strokeEndColor():uint { return _strokeEndColor; }		
		public function set strokeEndColor(value:uint):void { _strokeEndColor = value; }
		
		public function set stroke(value:Boolean):void { _stroke = value; }
		public function set radius(value:int):void { _radius = value; }
		public function set centered(value:Boolean):void { _centered = value; }
		public function set round(value:Boolean):void { _round = value; }
		
	}
}