package gtap.facebook
{
	import com.facebook.graph.data.FQLMultiQuery;
	import com.facebook.graph.Facebook;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gtap.utils.JS;
	import gtap.utils.QuickBtn;
	import org.casalib.util.ArrayUtil;
	import org.osflash.signals.Signal;
	
	public class AAlbumList extends Sprite
	{
		public static const STATUS_ALBUM:String = "status album";
		public static const STATUS_PHOTO:String = "status photo";
		public static const SHOW_LOADING:String = "show loading";
		public static const HIDE_LOADING:String = "hide loading";
		
		public var btn_ok:MovieClip; // -------------------- 送出
		public var btn_back:MovieClip; // ------------------ 回相簿目錄
		public var cont_mc:Sprite; // ---------------------- clips 容器
		public var mask_mc:Sprite; // ---------------------- 容器遮罩
		public var signal:Signal;
		
		protected var scroll_mc:Sprite; // ----------------- scroll
		protected var clip_class:Class; // ----------------- clip 的文件類
		protected var clipDefaultX:Number = 3; // ---------- clip 位置
		protected var clipDefaultY:Number = 2; // ---------- clip 位置
		protected var clipSegWidth:Number = 134 + 5; // ---- clip 寬度 + X間距
		protected var clipSegHeight:Number = 65 + 1; // ---- clip 高度 + Y間距
		protected var _viewStatus:String; // --------------- 瀏覽狀態
		
		private var _albumArray:Array; // ------------------ 相簿 array
		private var _currentAlbum:Object; // --------------- 目前相簿
		private var _photoArray:Array; // ------------------ 相片 array
		
		
		
		public function AAlbumList():void
		{
			signal = new Signal();
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			cont_mc.mask = mask_mc;
			getAlbum();
			
			btn_back.visible = false;
			setupBtn();
		}
		
		private function onRemoveFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			signal.removeAll();
		}
		
		/**
		 * 獲取相簿列表
		 */
		private function getAlbum():void
		{
			signal.dispatch(AAlbumList.SHOW_LOADING);
			
			var mq:FQLMultiQuery = new FQLMultiQuery();
			//mq.add("SELECT aid,object_id,name,photo_count,cover_object_id,cover_pid FROM album WHERE owner = me()", "myAlbums");
			mq.add("SELECT aid,object_id,name,photo_count,cover_object_id,cover_pid FROM album WHERE owner = me() AND photo_count>0", "myAlbums");
			mq.add("SELECT aid,src_small,src FROM photo WHERE pid IN (SELECT cover_pid FROM #myAlbums)", "myAlbumsCover");
			Facebook.fqlMultiQuery(mq, onGetAlbums);
		}
		
		private function onGetAlbums(result:Object, fail:Object):void
		{
			signal.dispatch(AAlbumList.HIDE_LOADING);
			
			if (result) {
				//t.obj(result);
				_albumArray = result.myAlbums as Array;
				
				if (_albumArray.length > 0) {
					var i:uint;
					
					// 比對 aid 塞值
					for (i = 0; i < _albumArray.length ; i++) {
						var j:uint;
						for (j = 0; j < result.myAlbumsCover.length ; j++) {
							if (_albumArray[i].aid == result.myAlbumsCover[j].aid) {
								//trace(result.myAlbumsCover[j].src_small, result.myAlbumsCover[j].src);
								_albumArray[i].src_small = result.myAlbumsCover[j].src_small;
								_albumArray[i].src       = result.myAlbumsCover[j].src;
								break;
							}
						}
					}
					
					addClips(AAlbumList.STATUS_ALBUM);
				}else {
					JS.alert("沒有相簿");
					signal.dispatch(FriendsListEvent.OK, null);
				}
			}
			
			if (fail) {
				t.obj(fail);
			}
		}
		
		/**
		 * 離線狀態時
		 * @return
		 */
		protected function makeFakeAlbum():Array { return []; }
		
		protected function addClips(status:String):void
		{
			_viewStatus = status;
			clearContainer(cont_mc);
			
			var i:uint;
			var len:uint;
			if (_viewStatus == AAlbumList.STATUS_ALBUM) {
				len = _albumArray.length;
			}else if (_viewStatus == AAlbumList.STATUS_PHOTO) {
				len = _photoArray.length;
			}
			var clipSegNum:uint = Math.floor(mask_mc.width / clipSegWidth); // clip 每列數量
			var clip:IPhotoClip;
			for (i = 0; i < len; i++) {
				if (_viewStatus == AAlbumList.STATUS_ALBUM) {
					clip = new clip_class(APhotoClip.TYPE_ALBUM, _albumArray[i].name, _albumArray[i].src_small, _albumArray[i].photo_count);
				}else if (_viewStatus == AAlbumList.STATUS_PHOTO) {
					clip = new clip_class(APhotoClip.TYPE_PHOTO, _photoArray[i].name, _photoArray[i].picture);
				}
				DisplayObject(clip).x = clipDefaultX + (clipSegWidth * (i % clipSegNum));
				DisplayObject(clip).y = clipDefaultY + (clipSegHeight * Math.floor(i / clipSegNum));
				QuickBtn.setBtn(Sprite(clip), onClipOver, onClipOut, onClipClick);
				cont_mc.addChild(DisplayObject(clip));
			}
			
			addScrollbar();
		}
		
		private function onClipOver(e:MouseEvent):void 
		{
			var clip:IPhotoClip = e.target as IPhotoClip;
			clip.overEffect();
		}
		
		private function onClipOut(e:MouseEvent):void 
		{
			var clip:IPhotoClip = e.target as IPhotoClip;
			clip.outEffect();
		}
		
		private function onClipClick(e:MouseEvent):void 
		{
			var clip:IPhotoClip = e.target as IPhotoClip;
			if (clip.type == APhotoClip.TYPE_ALBUM) {
				_currentAlbum = ArrayUtil.getItemByKey(_albumArray, "name", clip.name);
				//t.obj(_currentAlbum);
				if (_currentAlbum) {
					getPhotos();
				}else {
					trace("no album match !");
				}
			}else if (clip.type == APhotoClip.TYPE_PHOTO) {
				var obj:Object = ArrayUtil.getItemByKey(_photoArray, "picture", clip.src);
				//t.obj(obj);
				if (obj) {
					signal.dispatch(AlbumPhotoEvent.OK, { "data":obj.source } );
				}else {
					trace("no photo match!");
				}
			}else {
				trace("onClipClick Error!");
			}
		}
		
		
		private function getPhotos():void
		{
			signal.dispatch(AAlbumList.SHOW_LOADING);
			
			clearContainer(cont_mc);
			btn_back.visible = true;
			Facebook.api("/" + _currentAlbum.object_id + "/photos", onGetPhotos);
		}
		
		private function onGetPhotos(result:Object, fail:Object):void
		{
			signal.dispatch(AAlbumList.HIDE_LOADING);
			
			if (result) {
				//t.obj(result);
				_photoArray = result as Array;
				
				if (_photoArray.length > 0) {
					addClips(AAlbumList.STATUS_PHOTO);
				}else {
					trace("no photo");
				}
			}
			
			if (fail) {
				t.obj(fail);
			}
		}
		
		
		
		
		// OK, RESET **************************************************************************************************************************************
		private function setupBtn():void
		{
			QuickBtn.setBtn(btn_ok  , QuickBtn.onOver, QuickBtn.onOut, onOkClick);
			QuickBtn.setBtn(btn_back, QuickBtn.onOver, QuickBtn.onOut, onBackClick);
		}
		
		private function onOkClick(e:MouseEvent):void 
		{
			
		}
		
		private function onBackClick(e:MouseEvent):void 
		{
			btn_back.visible = false;
			addClips(AAlbumList.STATUS_ALBUM);
		}
		
		private function removeBtn():void
		{
			QuickBtn.removeBtn(btn_ok  , QuickBtn.onOver, QuickBtn.onOut, onOkClick);
			QuickBtn.removeBtn(btn_back, QuickBtn.onOver, QuickBtn.onOut, onBackClick);
		}
		
		// scroll bar ***************************************************************************************************************************************
		protected function addScrollbar():void { }
		
		private function clearContainer(doc:DisplayObjectContainer):void
		{
			while (doc.numChildren > 0) {
				doc.removeChildAt(0);
			}
		}
	}
}