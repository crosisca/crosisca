package controllers
{
	import citrus.input.controllers.Accelerometer;
	
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
		
		public var gravDirection:String = "down";
		
		public static var GravityDown:String = "gravDown";
		public static var GravityLeft:String = "gravLeft";
		public static var GravityRight:String = "gravRight";
		public static var GravityUp:String = "gravUp";
		public static var GravityChange:String = "gravChange";
		
		private var isGravityChangeOn:Boolean = false;
		private var prevGravDirection:String = "down";
		
		/** Tempo mínimo pra mudar a gravidade entre as rotações da tela. Framerate = 1 segundo.*/
		private var minimumTimeBetweenRotations:int = 10;
		private var delayBetweenRotations:int = minimumTimeBetweenRotations;
		
		public function AccelerometerHandler(name:String, params:Object)
		{
			super(name, params);
		}
		
		override public function update():void
		{
			delayBetweenRotations++;
			super.update();
		}
		
		override protected function customActions():void
		{
			//Default
			if (rotation.z < rotationFactor && rotation.z > - rotationFactor)
			{
				gravDirection = "Down";
				triggerON("gravDown", 1);
				triggerOFF("gravLeft", 0);
				triggerOFF("gravRight", 0);
				triggerOFF("gravUp", 0);
			}
			//Right
			else if (rotation.z < idleAngleRight + rotationFactor && rotation.z > idleAngleRight -rotationFactor)
			{
				gravDirection = "Right";
				triggerOFF("gravDown", 0);
				triggerOFF("gravLeft", 0);
				triggerON("gravRight", 1);
				triggerOFF("gravUp", 0);
			}
			//Left
			else if (rotation.z < idleAngleLeft + rotationFactor && rotation.z > idleAngleLeft -rotationFactor)
			{
				gravDirection = "Left";
				triggerOFF("gravDown", 0);
				triggerON("gravLeft", 1);
				triggerOFF("gravRight", 0);
				triggerOFF("gravUp", 0);
			}
			//Up
			else if (rotation.z > idleAngleUp -rotationFactor || rotation.z < -idleAngleUp +rotationFactor)
			{
				gravDirection = "Up";
				triggerOFF("gravDown", 0);
				triggerOFF("gravLeft", 0);
				triggerOFF("gravRight", 0);
				triggerON("gravUp", 1);
			}
			
			if(delayBetweenRotations >= minimumTimeBetweenRotations)
			{
				if(gravDirection != prevGravDirection)
				{
					prevGravDirection = gravDirection;
					triggerON(GravityChange, 1);
					isGravityChangeOn = true;
					delayBetweenRotations = 0;
				}
			}
		}
		
		public function triggerGravityChangeOff():void
		{
			if(isGravityChangeOn){
				triggerOFF(GravityChange, 0);
				isGravityChangeOn = false;
			}
		}
	}
}