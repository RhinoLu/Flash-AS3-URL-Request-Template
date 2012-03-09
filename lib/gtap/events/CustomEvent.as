package gtap.events
{
	import flash.events.Event;
	/**
	 * @author 陳利
	 * @link http://vanillaloveyou.spaces.live.com/
	 */
	public dynamic class CustomEvent extends Event
	{
		public var userData:Object;
		
		public function CustomEvent(type:String,  bubbles:Boolean = false, cancelable:Boolean = false, userData:Object = null)
		{
			this.userData = userData;
			super(type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			var str = super.toString();
			str = str.substring(0, str.length - 1);
			str += " data=\"" + this.data + "\"]";
			return str;
		}
	}
}

/*
//偵聽端
import org.gotoandplay.events.*;
function someName(e:CustomEvent):void{
	trace(e.userData);
}
this.addEventListener( "someName" , someName);

//發送端
import org.gotoandplay.events.*;
var CustomObj:Object={xx:"oo"};
dispatchEvent( new CustomEvent("someName",true,false,CustomObj));
*/