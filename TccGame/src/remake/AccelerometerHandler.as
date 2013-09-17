package remake 
{
	import citrus.input.controllers.Accelerometer;
	
	import core.utils.Debug;
	
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
		
		public var desiredGravDirection:String = "down";
		
		public static var GravityDown:String = "gravDown";
		public static var GravityLeft:String = "gravLeft";
		public static var GravityRight:String = "gravRight";
		public static var GravityUp:String = "gravUp";
		public static var GravityChange:String = "gravChange";
		
		//private var isGravityChangeOn:Boolean = false;
		private var actualGravDirection:String = "down";
		
		//** Tempo mínimo pra mudar a gravidade entre as rotações da tela. Framerate = 1 segundo.*/
		//private var minimumTimeBetweenRotations:int = 10;
		//private var delayBetweenRotations:int = minimumTimeBetweenRotations;
		
		private var isRotationAllowed:Boolean = true;
		
		
		public function AccelerometerHandler(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function update():void
		{
			//delayBetweenRotations++;
			super.update();
		}
		
		override protected function customActions():void
		{
			//Default
			if (rotation.z < rotationFactor && rotation.z > - rotationFactor)
			{
				desiredGravDirection = "Down";
				triggerON("gravDown", 1);
				triggerOFF("gravLeft", 0);
				triggerOFF("gravRight", 0);
				triggerOFF("gravUp", 0);
			}
			//Right
			else if (rotation.z < idleAngleRight + rotationFactor && rotation.z > idleAngleRight -rotationFactor)
			{
				desiredGravDirection = "Right";
				triggerOFF("gravDown", 0);
				triggerOFF("gravLeft", 0);
				triggerON("gravRight", 1);
				triggerOFF("gravUp", 0);
			}
			//Left
			else if (rotation.z < idleAngleLeft + rotationFactor && rotation.z > idleAngleLeft -rotationFactor)
			{
				desiredGravDirection = "Left";
				triggerOFF("gravDown", 0);
				triggerON("gravLeft", 1);
				triggerOFF("gravRight", 0);
				triggerOFF("gravUp", 0);
			}
			//Up
			else if (rotation.z > idleAngleUp -rotationFactor || rotation.z < -idleAngleUp +rotationFactor)
			{
				desiredGravDirection = "Up";
				triggerOFF("gravDown", 0);
				triggerOFF("gravLeft", 0);
				triggerOFF("gravRight", 0);
				triggerON("gravUp", 1);
			}
			
			Debug.log("Desired Gravity:",desiredGravDirection);
			//if(delayBetweenRotations >= minimumTimeBetweenRotations){
				if(desiredGravDirection != actualGravDirection && isRotationAllowed)
				{
					actualGravDirection = desiredGravDirection;
					triggerON(GravityChange, 1);
					//isGravityChangeOn = true;
					//delayBetweenRotations = 0;
					isRotationAllowed = false;
					Debug.log("GravityChange TRIGGERED ON!");
				}
			//}
		}
		
		public function triggerGravityChangeOff():void
		{
			_ce.input.isDoing(GravityChange)
			{
				triggerOFF(GravityChange, 0);
				//isGravityChangeOn = false;
			}
			//if(isGravityChangeOn){}
		}
		
		public function getIsRotationAllowed():Boolean
		{
			return isRotationAllowed;
		}
		
		public function setIsRotationAllowed(_isRotationAllowed:Boolean):void
		{
			isRotationAllowed = _isRotationAllowed;
		}
	}
}