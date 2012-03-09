package gtap.events
{
	import flash.utils.Dictionary;
	import flash.events.EventDispatcher;
	/**
	 * @author 陳利
	 * @link http://vanillaloveyou.spaces.live.com/
	 */
	public class EventTurnel
	{
		public static var turnels:Dictionary = new Dictionary(true);
		public static function getInstance(name:String)
		{
			if (!turnels[name]) {
				turnels[name] = new EventDispatcher();
			}
			return turnels[name];
		}
	}
}

/*
發
EventTurnel.getInstance("global").dispatchEvent(new Event("event_name"))

收
EventTurnel.getInstance("global").addEventListener("event_name",function(e){

});
*/