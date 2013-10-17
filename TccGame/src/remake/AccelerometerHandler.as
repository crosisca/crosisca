package remake 
{
	import citrus.input.controllers.Accelerometer;
	
	import org.osflash.signals.Signal;
	
	public final class AccelerometerHandler extends Accelerometer
	{
		/** Quanto menor for esse número, mais o device precisa rodar.
		 * Valor mínimo = 4( Ativa rotacao em 45º, não tem deadzone).Valor 6 funciona bem.*/
		private var sensitivity:int = 8;
		
		private var rotationFactor:Number = Math.PI/sensitivity;
		
		private var idleAngleDown:Number = 0;
		private var idleAngleRight:Number = -Math.PI/2;
		private var idleAngleLeft:Number = Math.PI/2;
		private var idleAngleUp:Number = Math.PI;
		
		public var desiredGravDirection:String = "gravDown";
		
		public static var GravityDown:String = "gravDown";
		public static var GravityLeft:String = "gravLeft";
		public static var GravityRight:String = "gravRight";
		public static var GravityUp:String = "gravUp";
		private var actualGravDirection:String = "gravDown";
		
		private var isRotationAllowed:Boolean = true;
		
		public var onGravityChange:Signal = new Signal();
		
		public function AccelerometerHandler(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override protected function customActions():void
		{
			//Down
			if (rotation.z < rotationFactor && rotation.z > - rotationFactor)
			{
				desiredGravDirection = GravityDown;
			}
			//Right
			else if (rotation.z < idleAngleRight + rotationFactor && rotation.z > idleAngleRight -rotationFactor)
			{
				desiredGravDirection = GravityRight;
			}
			//Left
			else if (rotation.z < idleAngleLeft + rotationFactor && rotation.z > idleAngleLeft -rotationFactor)
			{
				desiredGravDirection = GravityLeft;
			}
			//Up
			else if (rotation.z > idleAngleUp -rotationFactor || rotation.z < -idleAngleUp +rotationFactor)
			{
				desiredGravDirection = GravityUp;
			}
			
			//If gravity is different from last frame
			if(desiredGravDirection != actualGravDirection && isRotationAllowed)
			{
				actualGravDirection = desiredGravDirection;
				//Nao mudar a ordem > isRotAloowed=false > onGravChange.dispatch()
				isRotationAllowed = false;
				onGravityChange.dispatch(actualGravDirection);
			}
		}
		
		public function setIsRotationAllowed(_isRotationAllowed:Boolean):void
		{
			isRotationAllowed = _isRotationAllowed;
		}
	}
}