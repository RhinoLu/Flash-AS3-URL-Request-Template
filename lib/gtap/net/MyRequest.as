package gtap.net
{
	import flash.display.DisplayObject;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	/**
	 * 
	 * @author gotoAndPlay()™ Digital Consulting.
	 */
	public class MyRequest
	{
		// 依環境產生 URLRequest
		public static function makeRequest(apiPath:String, postObject:Object, method:String = URLRequestMethod.POST):URLRequest
		{
			var postRequest:URLRequest;
			if ((new LocalConnection().domain == "localhost") || Capabilities.playerType == "Desktop") {
				// Local
				postRequest = new URLRequest(apiPath);
				if (apiPath.indexOf("http") > -1) {
					postRequest.method = method;
				}else {
					postRequest.method = URLRequestMethod.POST;
				}
			}else {
				// Online
				//postRequest = new URLRequest(apiPath + "?r=" + Math.random()); // 亂數  (Server 負擔較重)
				postRequest = new URLRequest(apiPath + "?r=" + Math.floor(new Date().getTime() / 86400 / 1000) + "&"); // (Server 負擔較輕)
				postRequest.method = method;
			}
				
			var postData:URLVariables = new URLVariables();
			for(var i in postObject){
				postData[i] = postObject[i];
			}
			postRequest.data = postData;
			
			return postRequest;
		}
	}
	
}