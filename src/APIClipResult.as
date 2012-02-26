package
{
	import com.greensock.data.TweenMaxVars;
	import com.greensock.TweenMax;
	import fl.controls.TextArea;
	import flash.events.Event;
	
	public class APIClipResult extends BaseAbstract
	{
		public var txt_result:TextArea;
		
		private var _result:String;
		
		public function APIClipResult()
		{
			
		}
		
		override public function show():void
		{
			TweenMax.from(this, 0.5, new TweenMaxVars().x( -283, true).onComplete(onShowComplete).vars);
		}
		
		public function set result(value:String):void 
		{
			_result = value;
			txt_result.text = decodeURIComponent(value);
		}
	}
}