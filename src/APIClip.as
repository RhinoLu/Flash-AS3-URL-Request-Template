package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.data.DataLoaderVars;
	import com.greensock.loading.DataLoader;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import gtap.net.MyRequest;
	
	public class APIClip extends BaseAbstract
	{
		public var btn_call:Button; // --------------- 呼叫按鈕
		public var txt_api:TextInput; // ------------- API 路徑
		public var txt_desc:Label; // ---------------- 描述
		public var txt_result:TextArea; // ----------- 結果
		
		private var _obj:Object;
		private var _method:String;
		private var _loader:DataLoader;
		
		public function APIClip()
		{
			
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			btn_call.addEventListener(MouseEvent.CLICK, onCallClick);
			txt_api.editable = false;
		}
		
		override protected function onRemove(e:Event):void 
		{
			super.onRemove(e);
			btn_call.removeEventListener(MouseEvent.CLICK, onCallClick);
			if (_loader) {
				_loader.dispose(true);
				_loader = null;
			}
		}
		
		private function onCallClick(e:MouseEvent):void 
		{
			var _request:URLRequest = MyRequest.makeRequest(txt_api.text, _obj, _method);
			_loader = new DataLoader(_request, new DataLoaderVars().autoDispose(true).noCache(true).onComplete(onCallComplete).vars);
			_loader.load();
		}
		
		private function onCallComplete(e:LoaderEvent):void 
		{
			txt_result.text = _loader.content;
			_loader.dispose(true);
		}
	}
}