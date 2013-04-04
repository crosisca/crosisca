package events
{
	import starling.events.Event;
	
	public class NavigationEvent extends Event
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		public static const MAIN_MENU:String = "mainMenu";
		public static const ABOUT:String = "about";
		public static const WELCOME:String = "welcome";
		
		public var params:Object;
		
		public function NavigationEvent(type:String,_params:Object = null, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
			this.params = _params;
		}
	}
}