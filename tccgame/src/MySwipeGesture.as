package
{
	import org.gestouch.core.Touch;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.gestures.SwipeGestureDirection;
	
	public class MySwipeGesture extends SwipeGesture
	{
		public function MySwipeGesture(target:Object=null)
		{
			super(target);
		}
		
		override protected function onTouchBegin(touch:Touch):void
		{
			if(isTrackingTouch(touch.id))
			{
				if (touchesCount > numTouchesRequired)
				{
					failOrIgnoreTouch(touch);
					return;
				}
				
				if (touchesCount == 1)
				{
					// Because we want to fail as quick as possible
					_startTime = touch.time;
					
					_timer.reset();
					_timer.delay = maxDuration;
					_timer.start();
				}
				if (touchesCount == numTouchesRequired)
				{
					updateLocation();
					_avrgVel.x = _avrgVel.y = 0;
					
					// cache direction condition for performance
					_noDirection = (SwipeGestureDirection.ORTHOGONAL & direction) == 0;
				}
			}
		}
	}
}