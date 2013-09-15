package customobjects
{
	import flash.utils.setTimeout;
	
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2DUtils;
	
	import core.objects.SpawnPoint;
	
	import remake.MyNewHero;
	
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
				//(_ce.state as NewGameControlsState).delayer.push(onDeath);
				//setimeout faz o papel do delayer
				setTimeout(onDeath,0);
			}
		}
		
		private function onDeath():void
		{
			//Pause, run dying animation..set hero's pos(after 1 sec maybe)
			hero.x = (_ce.state.getFirstObjectByType(SpawnPoint) as SpawnPoint).x;
			hero.y = (_ce.state.getFirstObjectByType(SpawnPoint) as SpawnPoint).y;
			//_ce.sound.playSound("morte");
		}
	}
}