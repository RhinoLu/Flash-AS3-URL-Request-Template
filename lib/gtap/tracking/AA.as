package gtap.tracking
{
	import flash.external.ExternalInterface;
	
	public class AA
	{
		public static function userClick(message:String):void
		{
			if (ExternalInterface.available) {
				ExternalInterface.call("UserClick", message);
			}
		}
		
	}
}