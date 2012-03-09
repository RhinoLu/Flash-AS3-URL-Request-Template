package gtap.utils 
{

	public class MyString 
	{
		
		public static const RESTRICT_EMAIL:String    = "a-z A-Z 0-9 @ \\- _ .";
		public static const RESTRICT_NORMAL:String   = "^&?=";
		public static const RESTRICT_PHONE:String    = "0-9 () #";
		public static const RESTRICT_MOBILE:String   = "0-9";
		public static const RESTRICT_PASSWORD:String = " -~";
		
		
		public static function formatNumber(number:Number):String
		{
			var numString:String = number.toString();
			var result:String = "";
			
			while (numString.length > 3) {
				var chunk:String = numString.substr( -3);
				numString = numString.substr(0, numString.length - 3);
				result = "," + chunk + result;
			}
			
			if (numString.length > 0) {
				result = numString + result;
			}
			
			return result;
		}
	}
}