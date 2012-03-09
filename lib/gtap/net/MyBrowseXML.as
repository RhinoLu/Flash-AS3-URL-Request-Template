package gtap.net
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.FileFilter;
	import org.osflash.signals.Signal;
	
	/**
	 * 選擇客戶端 XML Flash Player 10
	 * @author Let's Play™ Digital Consulting.
	 */
	public class MyBrowseXML
	{
		private var file:FileReference;
		private var _signal:Signal;
		
		public function MyBrowseXML():void
		{
			init();
		}
		
		private function init():void
		{
			file = new FileReference();
			file.addEventListener(Event.SELECT               , selectHandler);
			file.addEventListener(Event.CANCEL               , cancelHandler);
			file.addEventListener(ProgressEvent.PROGRESS     , progressHandler);
			file.addEventListener(Event.COMPLETE             , loadCompleteDataHandler);
			file.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR      , ioErrorHandler);
			file.browse([new FileFilter("XML (*.xml; *.XML)", "*.xml; *.XML")]);
			_signal = new Signal();
		}
		
		private function remove():void
		{
			file.removeEventListener(Event.SELECT               , selectHandler);
			file.removeEventListener(Event.CANCEL               , cancelHandler);
			file.removeEventListener(ProgressEvent.PROGRESS     , progressHandler);
			file.removeEventListener(Event.COMPLETE             , loadCompleteDataHandler);
			file.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR      , ioErrorHandler);
			_signal.removeAll();
		}
	
		private function loadCompleteDataHandler(e:Event):void
		{
			//trace(e.target.data);
			_signal.dispatch(Event.COMPLETE, e.target.data);
			remove();
		}

		private function progressHandler(e:ProgressEvent):void 
		{
			//trace("progressHandler name=" + file.name + " bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
			//path_txt.text = e.bytesLoaded + " / " + e.bytesTotal;
			_signal.dispatch(ProgressEvent.PROGRESS, (e.bytesLoaded / e.bytesTotal));
		}

		private function selectHandler(e:Event):void 
		{
			file.load();
			_signal.dispatch(Event.SELECT);
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void 
		{
			trace("httpStatusHandler: " + event);
			_signal.dispatch(HTTPStatusEvent.HTTP_STATUS);
			remove();
		}

		private function ioErrorHandler(event:IOErrorEvent):void 
		{
			trace("ioErrorHandler: " + event);
			_signal.dispatch(IOErrorEvent.IO_ERROR);
			remove();
		}

		private function cancelHandler(event:Event):void 
		{
			trace("cancelHandler: " + event);
			_signal.dispatch(Event.CANCEL);
			remove();
		}
		
		public function get signal():Signal 
		{
			return _signal;
		}
	}
}