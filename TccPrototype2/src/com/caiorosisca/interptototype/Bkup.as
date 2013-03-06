package com.caiorosisca.interptototype
{
	
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	
	import de.ketzler.nativeextension.EulerGyroscope;
	import de.ketzler.nativeextension.EulerGyroscopeEvent;
	
	//import de.ketzler.nativeextension.EulerGyroscopeIntervalValue;
	
	[SWF(frameRate="1")]
	public class TccPrototype2 extends Sprite
	{
		
		
		private var gyroscope:EulerGyroscope = new EulerGyroscope();
		private var accel:Accelerometer;
		private var txtF1:TextField = new TextField();
		private var txtF2:TextField = new TextField();
		private var txtF3:TextField = new TextField();
		
		public function TccPrototype2()
		{
			Orientation.init();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
			/*var sprt:Sprite = new Sprite();
			sprt.graphics.beginFill(0X336644);
			sprt.graphics.drawCircle(100,100, 50);
			sprt.graphics.endFill();
			this.addChild(sprt);
			sprt.x = 50;
			sprt.y = 50;*/
			
			
			
			/*this.addChild(txtF1);
			this.addChild(txtF2);
			this.addChild(txtF3);
			
			txtF1.x = 100;
			txtF2.x = 100;
			txtF3.x = 100;
			txtF1.y = 100;
			txtF2.y = 150;
			txtF3.y = 200;
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 30;
			txtF1.setTextFormat(txtFormat);
			txtF2.setTextFormat(txtFormat);
			txtF3.setTextFormat(txtFormat);
			
			accel = new Accelerometer();
			accel.addEventListener( AccelerometerEvent.UPDATE, onAccelUpdate );
			gyroscope.setRequestedUpdateInterval(EulerGyroscopeIntervalValue.INTERVAL_GAME);
			
			gyroscope.addEventListener(EulerGyroscopeEvent.UPDATE, onGyroscopeUpdate);
			*/			super();
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
			
			graphics.lineStyle(4, 0xFF0000);
			graphics.moveTo(centerX, centerY);
			graphics.lineTo(centerX + axisLength * X.x, centerY + axisLength * X.y);
			
			graphics.lineStyle(4, 0xFF00);
			graphics.moveTo(centerX, centerY);
			graphics.lineTo(centerX + axisLength * Y.x, centerY + axisLength * Y.y);
			
			graphics.lineStyle(4, 0xFF);
			graphics.moveTo(centerX, centerY);
			graphics.lineTo(centerX + axisLength * Z.x, centerY + axisLength * Z.y);
			
		}
		
		
		protected function onGyroscopeUpdate(event:EulerGyroscopeEvent):void
		{
			txtF1.text =  event.pitch.toString();
			txtF2.text =  event.roll.toString();
			txtF3.text =  event.yaw.toString();
		}
		
		protected function onAccelUpdate(event:AccelerometerEvent):void
		{
			// TODO Auto-generated method stub
			//trace(event.accelerationX,event.accelerationY, event.accelerationZ);
		}
	}
}
import com.caiorosisca.interptototype;

