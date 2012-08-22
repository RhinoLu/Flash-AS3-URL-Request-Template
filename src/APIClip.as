package
{
	import com.dynamicflash.util.Base64;
	import com.greensock.data.TweenMaxVars;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.loading.data.DataLoaderVars;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenMax;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import gtap.net.MyRequest;
	import ru.inspirit.net.MultipartURLLoader;
	
	public class APIClip extends BaseAbstract
	{
		public var btn_call:Button; // --------------- 呼叫按鈕
		public var txt_api:TextInput; // ------------- API 路徑
		public var txt_desc:TextField; // ------------ 描述
		public var bgTitle:Sprite; // ---------------- 
		public var bg:Sprite; // --------------------- 
		public var bgEmpty:Sprite; // ---------------- 
		public var btn_close:Sprite; // -------------- 
		
		private const VAR_CLIP_START_AT_X:Number = 20; // ------------------- 「參數」初始X位置
		private const VAR_CLIP_START_AT_Y:Number = 102; // ------------------ 「參數」初始Y位置
		private const VAR_CLIP_HEIGHT:Number = 45; // ----------------------- 「參數」的高度
		private const BTN_CALL_DISTANCE:Number = 20; // --------------------- 「參數」與按鈕的距離
		
		private var _desc:String;
		private var _api:String;
		private var _method:String;
		private var _varArray:Array;
		private var _loader:LoaderItem;
		private var clipContainer:Sprite;
		private var clipArray:Array;
		
		private var _result:APIClipResult;
		private var _sendByMultipartURLLoader:Boolean = false;
		private var ml:MultipartURLLoader;
		private var _returnType:String;
		
		public function APIClip()
		{
			txt_desc.autoSize = TextFieldAutoSize.LEFT;
		}
		
		override protected function init(e:Event = null):void
		{
			super.init(e);
			btn_call.addEventListener(MouseEvent.CLICK, onCallClick);
			txt_api.editable = false;
			
			clipContainer = addChild(new Sprite()) as Sprite;
			clipContainer.x = VAR_CLIP_START_AT_X;
			clipContainer.y = VAR_CLIP_START_AT_Y;
			
			addVarClip();
			arrangeDistance(0);
			
			//bgTitle.addEventListener(MouseEvent.MOUSE_DOWN, onTitleDown);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			btn_close.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		private function onCloseClick(e:MouseEvent):void 
		{
			hide();
		}
		/*
		private function onTitleDown(e:MouseEvent):void 
		{
			bgTitle.removeEventListener(MouseEvent.MOUSE_DOWN, onTitleDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onTitleUp);
			this.startDrag();
			
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		private function onTitleUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onTitleUp);
			bgTitle.addEventListener(MouseEvent.MOUSE_DOWN, onTitleDown);
			this.stopDrag();
		}
		*/
		private function onDown(e:MouseEvent):void 
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			this.startDrag();
			
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		private function onUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			this.stopDrag();
		}
		
		override protected function onRemove(e:Event):void
		{
			super.onRemove(e);
			btn_call.removeEventListener(MouseEvent.CLICK, onCallClick);
			if (_loader)
			{
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
				if (_varArray[i].varType == "file") {
					_sendByMultipartURLLoader = true;
				}
				clip = new VarClip(_varArray[i].varType);
				clip.x = 0;
				clip.y = i * VAR_CLIP_HEIGHT;
				//clip.varName = _varArray[i];
				clip.varName = _varArray[i].varName;
				clipContainer.addChild(clip);
				clipArray.push(clip);
			}
		}
		
		private function arrangeDistance(__duration:Number = 0.25):void
		{
			var toValue:Number;
			toValue = VAR_CLIP_START_AT_Y + (_varArray.length * VAR_CLIP_HEIGHT) + BTN_CALL_DISTANCE;
			TweenMax.to(btn_call, __duration, new TweenMaxVars().y(toValue).vars);
			toValue = btn_call.y + btn_call.height + 10;
			if (toValue < 320) toValue = 320;
			TweenMax.to(bg, __duration, new TweenMaxVars().height(toValue).vars);
		}
		
		private function onCallClick(e:MouseEvent):void
		{
			if (_sendByMultipartURLLoader) {
				sendFormByMultipartURLLoader();
			}else {
				sendFormByGSLoader();
			}
		}
		
		private function sendFormByGSLoader():void
		{
			var _obj:Object = {};
			var clip:VarClip;
			for (var i:int = 0; i < _varArray.length; i++)
			{
				clip = clipArray[i];
				_obj[_varArray[i].varName] = clip.varValue;
			}
			var _request:URLRequest = MyRequest.makeRequest(_api, _obj, _method);
			if (_returnType == "bitmapdata") {
				_loader = new ImageLoader(_request, new ImageLoaderVars().autoDispose(true).noCache(true).onError(onCallError).onComplete(onCallComplete).vars);
			}else {
				_loader = new DataLoader(_request, new DataLoaderVars().autoDispose(true).noCache(true).onError(onCallError).onComplete(onCallComplete).vars);
			}
			_loader.load();
		}
		
		private function sendFormByMultipartURLLoader():void
		{
			ml = new MultipartURLLoader();
			ml.addEventListener(Event.COMPLETE, onCallComplete);
			ml.addEventListener(IOErrorEvent.IO_ERROR, onCallError);
			var clip:VarClip;
			for (var i:int = 0; i < _varArray.length; i++)
			{
				clip = clipArray[i];
				if (_varArray[i].varType == "file") {
					if (clip.data) {
						//trace("tmp" + i + "." + clip.fileName);
						ml.addFile(clip.data, "tmp" + i + "." + clip.fileName, _varArray[i].varName);
					}
				}else if (_varArray[i].varType == "string") {
					ml.addVariable(_varArray[i].varName, clip.varValue);
				}
			}
			ml.load(_api);
		}
		
		private function onCallError(e:Event):void
		{
			//trace("onCallError:" + e);
			if (e is LoaderEvent) {
				addResult(LoaderEvent(e).text);
				_loader.dispose(true);
			}else {
				addResult(e.toString());
				ml.dispose();
			}
		}
		
		private function onCallComplete(e:Event):void
		{
			if (e is LoaderEvent) {
				if (_returnType == "bitmapdata") {
					addResult(ImageLoader(_loader).rawContent.bitmapData);
				}else {
					addResult(_loader.content);
				}
				_loader.dispose(true);
			}else {
				addResult(ml.loader.data);
				ml.dispose();
			}
		}
		
		private function addResult(value:*):void
		{
			if (!_result)
			{
				_result = new APIClipResult();
				_result.x = 283;
				_result.y = 11;
				_result.changeHeight(bg.height);
				addChildAt(_result, 0);
			}
			_result.result = value;
			
			
			TweenMax.to(btn_close, 0.25, new TweenMaxVars().x(283 * 2 - 8).vars);
			TweenMax.to(bgTitle, 0.25, new TweenMaxVars().width(283 * 2 + 2).vars);
		}
		
		public function get method():String
		{
			return _method;
		}
		
		public function set method(value:String):void
		{
			_method = value;
			btn_call.label = _method;
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
			bgEmpty.width = 283 - txt_desc.textWidth - 30;
		}
		
		public function get returnType():String 
		{
			return _returnType;
		}
		
		public function set returnType(value:String):void 
		{
			_returnType = value;
		}
		
		
	}
}