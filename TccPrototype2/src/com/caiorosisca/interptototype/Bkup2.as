package com.caiorosisca.interptototype
{
	
	import com.adobe.nativeExtensions.GyroscopeEvent;
	
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	//import de.ketzler.nativeextension.EulerGyroscopeIntervalValue;
	
	[SWF(frameRate="60")]
	public class TccPrototype2 extends Sprite
	{
		private var alphaRot:Number;
		
		private var debugTxt:TextField = new TextField();
		private var debugTxt2:TextField = new TextField();
		private var debugTxt3:TextField = new TextField();
		private var txtForm:TextFormat = new TextFormat();
		
		public function TccPrototype2()
		{
			Orientation.init();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addChild(new FrameRateTracker());
			super();
			addEventListener(GyroscopeEvent.UPDATE, onGyroUpdate);
			txtForm.size = 30;
			
			debugTxt.setTextFormat(txtForm);
			debugTxt2.setTextFormat(txtForm);
			debugTxt3.setTextFormat(txtForm);
			
			debugTxt.y = 150;
			debugTxt2.y = 250;
			debugTxt3.y = 350;
			
			addChild(debugTxt);
			addChild(debugTxt2);
			addChild(debugTxt3);
		}
		
		protected function onGyroUpdate(event:Event):void
		{
			// TODO Auto-generated method stub
			trace(event);
		}
		
		private function onEnterFrame ( e : Event ) : void {
			// attitude
			var C : Vector.<Number>  = Orientation.last.rawData;
			
			var R : Matrix  = new Matrix();
			switch ( stage["orientation"] ) {
				case  ( StageOrientation.ROTATED_LEFT ) : {
					R.rotate(Math.PI / 2);
					break ;
				}
				case  ( StageOrientation.ROTATED_RIGHT ) : {
					R.rotate(-Math.PI / 2);
					break ;
				}
				case  ( StageOrientation.UPSIDE_DOWN ) : {
					R.rotate(Math.PI);
					break ;
				}
				default : {
					
				}
			}
			
			// the signs below may not look right, but they work
			var X : Point  = R.transformPoint(new Point(C[0], C[4]));
			var Y : Point  = R.transformPoint(new Point(C[1], C[5]));
			var Z : Point  = R.transformPoint(new Point(C[2], -C[6]));
			
			var centerX : Number  = stage.stageWidth / 2;
			var centerY : Number  = stage.stageHeight / 2;
			var axisLength : Number  = 200;
			
			graphics.clear();
			//vermelho X
			graphics.lineStyle(4, 0xFF0000);
			graphics.moveTo(centerX, centerY);
			graphics.lineTo(centerX + axisLength * X.x, centerY + axisLength * X.y);
			//verde Y
			graphics.lineStyle(4, 0xFF00);
			graphics.moveTo(centerX, centerY);
			graphics.lineTo(centerX + axisLength * Y.x, centerY + axisLength * Y.y);
			//azul Z
			graphics.lineStyle(4, 0xFF);
			graphics.moveTo(centerX, centerY);
			graphics.lineTo(centerX + axisLength * Z.x, centerY + axisLength * Z.y);
			
		}
	}
}
import com.caiorosisca.interptototype;

