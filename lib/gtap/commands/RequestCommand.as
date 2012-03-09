package gtap.commands 
{
	import com.adobe.serialization.json.JSON;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.data.DataLoaderVars;
	import com.greensock.loading.DataLoader;
	import flash.net.URLRequest;
	import gtap.commands.Command;
	
	public class RequestCommand extends Command
	{
		private var _loader:DataLoader;
		private var _request:URLRequest;
		private var _callBack:Function;
		
		public function RequestCommand(delay:Number = 0, request:URLRequest = null, callBack:Function = null) 
		{
			super(delay);
			_request = request;
			_callBack = callBack;
		}
		
		override protected function execute():void
		{
			//trace("execute");
			_loader = new DataLoader(_request, new DataLoaderVars().autoDispose(true).noCache(true).onComplete(onGetDataComplete).vars);
			_loader.load();
		}
		
		private function onGetDataComplete(e:LoaderEvent):void 
		{
			var obj:Object = JSON.decode(_loader.content);
			// 小心，文字資料才可以立即dispose
			_loader.dispose(true);
			//t.obj(obj);
			if (_callBack != null) {
				_callBack(obj);
			}
			complete();
		}
		
		public function stop():void
		{
			if (_loader) {
				_loader.dispose(true);
			}
		}
		
		/**
		 *  臨時更換 URLRequest
		 */
		public function set request(value:URLRequest):void 
		{
			_request = value;
		}
	}
}

