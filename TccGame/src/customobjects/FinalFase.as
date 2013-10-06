package customobjects
{
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.objects.platformer.box2d.Sensor;
	
	import org.osflash.signals.Signal;
	
	public final class FinalFase extends Sensor
	{
		
		public var onCollision:Signal = new Signal();
		public function FinalFase(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		public override function handleBeginContact(contact:b2Contact):void{
			onCollision.dispatch();
		}
		
	}
}