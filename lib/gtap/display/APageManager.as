package gtap.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gtap.utils.QuickBtn;
	
	public class APageManager extends Sprite
	{
		public var info_txt:TextField; // ----------------- debug
		public var next_mc:MovieClip; // ------------------ 下1頁
		public var prev_mc:MovieClip; // ------------------ 上1頁
		
		protected var clip_container:Sprite; // ----------- 放 clip 的容器
		protected var clip_num:uint = 10; // -------------- 最多出現多少 clip
		protected var clip_class:Class; // ---------------- clip_class
		protected var clip_distance:Number = 5; // -------- clip 間距
		
		private var handle_func:Function; // -------------- 外面換頁的程式
		private var _start:uint; // ----------------------- 開始頁數
		private var _end:uint; // ------------------------- 結束頁數
		private var _now:uint; // ------------------------- 目前頁數
		private var _total:uint; // ----------------------- 總頁數
		
		public function APageManager(nowPage:uint, totalPages:uint, func:Function = null):void
		{
			_now = nowPage;
			_total = totalPages;
			handle_func = func;
			
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * ADDED_TO_STAGE
		 */
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			QuickBtn.setBtn(prev_mc, QuickBtn.onOver, QuickBtn.onOut, prevPage);
			QuickBtn.setBtn(next_mc, QuickBtn.onOver, QuickBtn.onOut, nextPage);
			prev_mc.visible = next_mc.visible = false;
			
			//info_txt.visible = false;
			removeChild(info_txt);
			info_txt = null;
			
			clip_container = new Sprite();
			addChild(clip_container);
			
			refresh(_now, _total);
		}
		
		/**
		 * REMOVED_FROM_STAGE
		 */
		protected function onRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			QuickBtn.removeBtn(prev_mc, QuickBtn.onOver, QuickBtn.onOut, prevPage);
			QuickBtn.removeBtn(next_mc, QuickBtn.onOver, QuickBtn.onOut, nextPage);
		}
		
		/**
		 * REFRESH
		 */
		public function refresh(nowPage:uint, totalPages:uint):void
		{
			_now = nowPage;
			_total = totalPages;
			_start = findStart();
			_end = findEnd();
			
			addClip();
			prev_mc.visible = !(_now == 1);
			next_mc.visible = !(_now == _total);
			arrangeClipPosition();
			arrangePosition();
		}
		
		private function findStart():uint
		{
			return Math.floor((_now - 1) / clip_num) * clip_num + 1;
		}
		
		private function findEnd():uint
		{
			var zone:int = Math.ceil(findStart() / clip_num) * clip_num;
			if(total > zone){
				return zone;
			}else{
				return _total;
			}
		}
		
		/**
		 * Arrange Clip Position
		 */
		protected function arrangeClipPosition():void
		{
			var i:uint;
			var len:uint = (_end - _start) + 1;
			var clip:DisplayObject;
			var prev_clip:DisplayObject;
			for (i = 0; i < len; i++) {
				clip = clip_container.getChildAt(i);
				if (i > 0) {
					prev_clip = clip_container.getChildAt(i - 1);
					clip.x = prev_clip.x + prev_clip.width + clip_distance;
				}
			}
		}
		
		protected function arrangePosition():void
		{
			
		}
		
		/**
		 * ADD CLIP
		 */
		protected function addClip():void
		{
			//info_txt.visible = false;
			if (info_txt) {
				info_txt.text = "_start:" + _start + ", " + "_now:" + _now + ", " + "_end:" + _end + ", " + "_total:" + _total;
			}
			
			while (clip_container.numChildren > 0) {
				clip_container.removeChildAt(0);
			}
			
			var i:uint;
			var len:uint = (_end - _start) + 1;
			var clip:IPageClip;
			for (i = 0; i < len; i++) {
				clip = new clip_class(_start + i);
				clip_container.addChild(DisplayObject(clip));
				QuickBtn.setBtn(Sprite(clip), onClipOver, onClipOut, onClipClick);
				if (_start + i == _now) {
					clip.overEffect();
				}
			}
		}
		
		/**
		 * Clip Over
		 */
		private function onClipOver(e:MouseEvent):void
		{
			var clip:IPageClip = e.target as IPageClip;
			if (clip.page != _now) {
				clip.overEffect();
				Sprite(clip).buttonMode = true;
			}else {
				Sprite(clip).buttonMode = false;
			}
		}
		
		/**
		 * Clip Out
		 */
		private function onClipOut(e:MouseEvent):void
		{
			var clip:IPageClip = e.target as IPageClip;
			if(clip.page != _now){
				clip.outEffect();
			}
		}
		
		/**
		 * Clip Click
		 */
		private function onClipClick(e:MouseEvent):void
		{
			var clip:IPageClip = e.target as IPageClip;
			if(clip.page != _now && handle_func != null){
				handle_func(clip.page);
			}
		}
		
		/**
		 * Previous Page
		 */
		protected function prevPage(e:MouseEvent):void
		{
			if (handle_func != null) handle_func(_now - 1);
		}
		
		/**
		 * Next Page
		 */
		protected function nextPage(e:MouseEvent):void
		{
			
			if (handle_func != null) handle_func(_now + 1);
		}
		
		// 開始頁數 *****************************************************************************************************************************************
		public function get start():uint 
		{
			return _start;
		}
		
		// 結束頁數 *****************************************************************************************************************************************
		public function get end():uint 
		{
			return _end;
		}
		
		// 目前頁數 *****************************************************************************************************************************************
		public function get now():uint 
		{
			return _now;
		}
		
		// 總頁數 *******************************************************************************************************************************************
		public function get total():uint 
		{
			return _total;
		}
	}
	
}