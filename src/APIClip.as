package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.data.DataLoaderVars;
	import com.greensock.loading.DataLoader;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import flash.display.Sprite;
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
		
		private const VAR_CLIP_START_AT_Y:Number = 82; // ------------------- 「參數」初始Y位置
		private const VAR_CLIP_HEIGHT:Number = 45; // ----------------------- 「參數」的高度
		private const BTN_CALL_DISTANCE:Number = 55; // --------------------- 「參數」與按鈕的距離
		
		private var _desc:String;
		private var _api:String;
		private var _method:String;
		private var _varArray:Array;
		private var _loader:DataLoader;
		private var clipContainer:Sprite;
		private var clipArray:Array;
		
		
		public function APIClip()
		{
			
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			btn_call.addEventListener(MouseEvent.CLICK, onCallClick);
			txt_api.editable = false;
			
			clipContainer = addChild(new Sprite()) as Sprite;
			clipContainer.y = VAR_CLIP_START_AT_Y;
			
			addVarClip();
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
		
		private function addVarClip():void
		{
			while (clipContainer.numChildren > 0) 
			{
				clipContainer.removeChildAt(0);
			}
			clipArray = [];
			var clip:VarClip;
			for (var i:int = 0; i < _varArray.length; i++) 
			{
				clip = new VarClip();
				clip.y = i * VAR_CLIP_HEIGHT;
				clip.varName = _varArray[i];
				clipContainer.addChild(clip);
				clipArray.push(clip);
			}
			
			arrangeDistance();
		}
		
		private function arrangeDistance():void
		{
			btn_call.y = VAR_CLIP_START_AT_Y + (_varArray.length * VAR_CLIP_HEIGHT) + BTN_CALL_DISTANCE;
		}
		
		private function onCallClick(e:MouseEvent):void 
		{
			var _obj:Object = { };
			var clip:VarClip;
			for (var i:int = 0; i < _varArray.length; i++) 
			{
				clip = clipArray[i];
				_obj[_varArray[i]] = clip.varValue;
			}
			var _request:URLRequest = MyRequest.makeRequest(_api, _obj, _method);
			_loader = new DataLoader(_request, new DataLoaderVars().autoDispose(true).noCache(true).onError(onCallError).onComplete(onCallComplete).vars);
			_loader.load();
		}
		
		private function onCallError(e:LoaderEvent):void 
		{
			txt_result.text = e.text;
			_loader.dispose(true);
		}
		
		private function onCallComplete(e:LoaderEvent):void 
		{
			txt_result.text = _loader.content;
			_loader.dispose(true);
		}
		
		public function get method():String 
		{
			return _method;
		}
		
		public function set method(value:String):void 
		{
			_method = value;
		}
		
		public function get varArray():Array 
		{
			return _varArray;
		}
		
		public function set varArray(value:Array):void 
		{
			_varArray = value;
			
		}
		
		public function get api():String 
		{
			return _api;
		}
		
		public function set api(value:String):void 
		{
			_api = value;
			txt_api.text = _api;
		}
		
		public function get desc():String 
		{
			return _desc;
		}
		
		public function set desc(value:String):void 
		{
			_desc = value;
			txt_desc.text = _desc;
		}
	}
}