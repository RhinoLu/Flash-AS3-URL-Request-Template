package gtap.utils
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class JS
	{

		public static function alert(message:String, type:uint = 0):void
		{
			if (ExternalInterface.available) {
				trace(message);
				//ExternalInterface.call("alert", message);
				if (type == 0) {
					ExternalInterface.call("setTimeout", "alert('" + message + "')", 0);
				}else if (type == 1) {
					var jscommand:String = "alert('" + message + "');";
					var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);");
					navigateToURL(url, "_self");
				}
			}
		}
	}
}


/*

setTimeout("alert('" + pMsg + "')", 0)

var jscommand:String = "openTest();";
var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);");
navigateToURL(url, "_self");

*/