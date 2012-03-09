package gtap.net
{
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	/**
	 * gotoAndPlay()™ Digital Consulting.
	 * @author Rhino Lu
	 * @version 2011/01/14
	 */
	public class SnsPost
	{
		public static function facebook(_link:String, _str:String = ""):void
		{
			//var url:String = "http://www.facebook.com/sharer.php?u=" + encodeURI(_link) + "&t=" + encodeURI(_str);
			//var url:String = "http://www.facebook.com/sharer.php?u=" + encodeURIComponent(_link) + "&t=" + encodeURI(_str);
			var url:String = "http://www.facebook.com/sharer.php?u=" + encodeURIComponent(_link) + "&t=" + encodeURIComponent(_str);
			//navigateToURL(new URLRequest(url) , "_blank");
			//SWFAddress.href(url , "_blank");
			
			// 防止被 Chrome 檔快顯
			var jscommand:String = "window.open('" + url + "', 'fb', 'height=300, width=500, top=0, left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');";
			var url2:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);");
			navigateToURL(url2, "_self");
			
			//sample
			//window.open('page.html', 'newwindow', 'height=100, width=400, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no')
		}
		
		public static function plurk(_str:String) :void
		{
			var url:String = "http://www.plurk.com/?qualifier=shares&status=" + encodeURIComponent(_str);
			navigateToURL(new URLRequest(url) , "_blank");
			//SWFAddress.href(url , "_blank");
		}
			
		public static function twitter(_str:String):void
		{
			var url:String = "http://twitter.com/home/?status=" + encodeURIComponent(_str);
			navigateToURL(new URLRequest(url) , "_blank");
			//SWFAddress.href(url , "_blank");
		}
	}
}

/*
Facebook Share Sample :
var _link:String = someLink;
var _str:String = someWord;
SnsPost.facebook(_link, _str);

Plurk Share Sample :
var _pic:String = somePicturePath;
var _link:String = someLink;
var _str:String = someWord;
SnsPost.plurk(_pic + " " + _link + " " + "(" + _str + ")");

twitter Share Sample :
var _link:String = someLink;
var _str:String = someWord;
SnsPost.twitter(_link + " " + _str);
*/