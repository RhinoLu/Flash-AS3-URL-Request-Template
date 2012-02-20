package
{
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextArea;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.osflash.signals.Signal;
	
	/**
	 * 
	 */
	public class Clip extends Sprite
	{
		/*public var btn_get:Button; // ---------------- GET 按鈕
		public var btn_post:Button; // --------------- POST 按鈕
		public var label_title:Label; // ------------- 標題
		public var text_result:TextArea; // ---------- 結果*/
		
		private var _signal:Signal; // --------------- 與外界溝通用
		private var _title:String; // ---------------- 標題
		private var _result:String; // --------------- API 回傳值
		
		public function Clip()
		{
			_signal = new Signal();
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		
		
		/**
		 * 幹掉 Clip
		 */
		public function destory():void
		{
			_signal.removeAll();
			_signal = null;
		}
		
		public function get signal():Signal 
		{
			return _signal;
		}
		
		public function set signal(value:Signal):void 
		{
			_signal = value;
		}
		
	}
}