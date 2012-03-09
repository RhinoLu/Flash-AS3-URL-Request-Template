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
	/**
	 * 選擇客戶端圖片 Flash Player 10
	 * @author gotoAndPlay()™ Digital Consulting.
	 */
	public class MyBrowsePic
	{
		private var file:FileReference;
		private var limitSize:uint; // 圖檔大小限制
		private var onCompleteFunc:Function;
		
		public function MyBrowsePic(limit:uint = 500, onComplete:Function = null):void
		{
			limitSize = limit * 1024;
			onCompleteFunc = onComplete;
			FileReferenceInit();
			BrowseImage();
		}
		
		private function FileReferenceInit() :void
		{
			file = new FileReference();
			file.addEventListener(Event.SELECT , selectHandler);
			file.addEventListener(Event.CANCEL , cancelHandler);
			file.addEventListener(ProgressEvent.PROGRESS , progressHandler);
			file.addEventListener(Event.COMPLETE , loadCompleteDataHandler);
			file.addEventListener(HTTPStatusEvent.HTTP_STATUS , httpStatusHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler);
		}
		
		private function FileReferenceRemove() :void
		{
			file.removeEventListener(Event.SELECT , selectHandler);
			file.removeEventListener(Event.CANCEL , cancelHandler);
			file.removeEventListener(ProgressEvent.PROGRESS , progressHandler);
			file.removeEventListener(Event.COMPLETE , loadCompleteDataHandler);
			file.removeEventListener(HTTPStatusEvent.HTTP_STATUS , httpStatusHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler);
		}
		
		private function BrowseImage():void 
		{
			file.browse([new FileFilter("Images (*.jpg, *.jpeg, *.JPG, *.JPEG)","*.jpg;*.jpeg;*.JPG;*.JPEG")]);
		}
	
		private function loadCompleteDataHandler(e:Event ):void
		{
			//trace("loadCompleteDataHandler");
			//trace(e.target.data);
			FileReferenceRemove();
			onCompleteFunc(e.target.data);
		}

		/*private function loadPhoto(photoURL:String):void 
		{
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, loadPicComplete);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

			var urlReq:URLRequest = new URLRequest(photoURL);
			ldr.load(urlReq);
		}*/

		private function progressHandler(e:ProgressEvent):void 
		{
			//trace("progressHandler name=" + file.name + " bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
			//path_txt.text = e.bytesLoaded + " / " + e.bytesTotal;
		}

		private function selectHandler(e:Event):void 
		{
			if(file.size > limitSize){
				trace("圖檔超過" + (limitSize/1024) + "KB");
				ExternalInterface.call("alert", "照片K數過大，請重新上傳");
			}else{
				//trace("selectHandler: name=" + file.name);
				file.load();
			}
			
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void 
		{
			trace("httpStatusHandler: " + event);
			FileReferenceRemove();
		}

		private function ioErrorHandler(event:IOErrorEvent):void 
		{
			trace("ioErrorHandler: " + event);
			FileReferenceRemove();
		}

		private function cancelHandler(event:Event):void 
		{
			trace("cancelHandler: " + event);
			FileReferenceRemove();
		}

		/*private function loadPicComplete(e:Event):void
		{
			//trace("loadPicComplete");
			var loader:Loader = Loader(e.target.loader);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadPicComplete);
			while(pic_loader.numChildren > 0){
				pic_loader.removeChildAt(0);
			}
			pic_loader.addChild(loader);
			
			//info_mc.text = file.name;
			
			//browsePic = true;
		}*/
		
	}
	
}