package customobjects
{
	import flash.events.TimerEvent;
	
	import citrus.objects.platformer.box2d.Cannon;
	import citrus.objects.platformer.box2d.Missile;
	
	public class VerticalCannon extends Cannon
	{
		public function VerticalCannon(name:String, params:Object=null)
		{
			missileAngle = 270;
			super(name, params);
		}
		
		override protected function _fire(tEvt:TimerEvent):void {
			
			var missile:Missile;
			
			missile = new Missile("Missile", {x:x, y:y - height, width:missileWidth, height:missileHeight, speed:-missileSpeed, angle:270, explodeDuration:missileExplodeDuration, fuseDuration:missileFuseDuration, view:missileView});
			
			_ce.state.add(missile);
			missile.onExplode.addOnce(_damage);
		}
	}
}