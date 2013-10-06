package core.objects
{
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.objects.platformer.box2d.Sensor;
	
	import org.osflash.signals.Signal;
	
	public final class SecretItem extends Sensor
	{
		public var onFound:Signal = new Signal();
		
		public function SecretItem(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
			onFound.dispatch();
		}
	}
}