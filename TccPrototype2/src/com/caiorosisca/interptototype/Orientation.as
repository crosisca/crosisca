package com.caiorosisca.interptototype{
	
	import flash.external.ExtensionContext;
	import com.adobe.nativeExtensions.GyroscopeIntervalValue;
	import flash.events.StatusEvent;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import flash.geom.Matrix3D;
	
	public class Orientation {
		private static var context : ExtensionContext ;
		private static var rawB : Vector.<Number>  = new <Number>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] ;
		private static var lastC : Matrix3D  = new Matrix3D() ;
		private static var lastW : Vector3D  = new Vector3D() ;
		private static var lastT : Number  = -1 ;
		public static function init (  ) : void {
			if ( context == null ) {
				context = ExtensionContext.createExtensionContext("com.adobe.gyroscope", null);
				if ( context == null ) {
					
					throw new Error("Failed to create ExtensionContext");
				}
				context.call("init");
				if ( !(context.call("gyroscopeSupport")) ) {
					
					throw new Error("Gyroscope not supported");
				}
				if ( !(context.call("gyroscopeStart", GyroscopeIntervalValue.INTERVAL_FASTEST)) ) {
					
					throw new Error("Failed to start gyroscope");
				}
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}
		}
		public static function dispose (  ) : void {
			if ( context != null ) {
				context.call("gyroscopeStop");
				context.removeEventListener(StatusEvent.STATUS, onStatus);
				context.dispose();
				context = null;
			}
		}
		private static function onStatus ( e : StatusEvent ) : void {
			if ( e.code == "CHANGE" ) {
				var values : Array  = e.level.split("&");
				var w : Vector3D  = new Vector3D(Number(values[0]), Number(values[1]), Number(values[2]));
				// w is in radians per second, so convert t to seconds
				// http://developer.apple.com/library/ios/#documentation/CoreMotion/Reference/CMGyroData_Class/Reference/Reference.html
				var t : Number  = 1e-3 * getTimer();
				if ( lastT > 0 ) {
					var dt : Number  = t - lastT;
					var wt : Vector3D  = w.add(lastW);
					wt.scaleBy(0.5 * dt);
					var s : Number  = wt.length;
					rawB[1] = -wt.z;
					rawB[2] = wt.y;
					rawB[4] = wt.z;
					rawB[6] = -wt.x;
					rawB[8] = -wt.y;
					rawB[9] = wt.x;
					var B2 : Matrix3D  = new Matrix3D(rawB);
					B2.prepend(B2);
					var rawB2 : Vector.<Number>  = B2.rawData;
					// rawB2 <- I + sins/s B + (1-coss)/s2 B2
					// these ratios go apeshit around s = 0, so...
					var s1 : Number  = 1;
					var s2 : Number  = 0.5;
					if ( s > 1e-3 ) {
						s1 = Math.sin(s) / s;
						s2 = (1 - Math.cos(s)) / (s * s);
					}
					for ( var i : int  = 0 ; i < 16 ; i++ ) {
						rawB2[i] = s1 * rawB[i] + s2 * rawB2[i];
						if ( i % 5 == 0 ) {
							rawB2[i] += 1;
						}
					}
					// we only actually add 3x3 matrices, so...
					rawB2[15] = 1;
					// C(t) = C(t-dt) * (I + ... B2)
					lastC.prepend(new Matrix3D(rawB2));
				}
				lastW = w;
				lastT = t;
			}
		}
		public static function reset ( m : Matrix3D  = null ) : Matrix3D {
			m ||= new Matrix3D();
			lastC = m;
			lastT = 1e-3 * getTimer();
			return m;
		}
		public static function get last (  ) : Matrix3D {
			return lastC;
		}
	}
}