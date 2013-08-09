package customobjects
{
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2DUtils;
	
	public final class Spike extends Sensor
	{
		private var hero:MyNewHero;
		
		public function Spike(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override public function handleBeginContact(contact:b2Contact):void {
			onBeginContact.dispatch(contact);
			
			var obj:* = Box2DUtils.CollisionGetOther(this,contact);
			
			if(obj is MyNewHero)
			{
				hero = obj;
				(_ce.state as NewGameControlsState).delayer.push(onDeath);
				
			}
		}
		
		private function onDeath():void
		{
			hero.x = 290;
			hero.y = 1200;
			_ce.sound.playSound("morte");
		}
	}
}