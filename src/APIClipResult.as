package
{
	import com.greensock.data.TweenMaxVars;
	import com.greensock.TweenMax;
	import fl.controls.TextArea;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class APIClipResult extends BaseAbstract
	{
		public var txt_result:TextArea;
		public var bg:Sprite;
		
		private var _result:String;
		
		public function APIClipResult()
		{
			
		}
		
		override public function show():void
		{
			TweenMax.from(this, 0.25, new TweenMaxVars().x( -283, true).onComplete(onShowComplete).vars);
		}
		
		public function set result(value:String):void 
		{
			_result = value;
			txt_result.text = value;
		}
		
		public function changeHeight(_height:Number):void
		{
			bg.height = _height;
			txt_result.height = _height - 90;
		}
	}
}