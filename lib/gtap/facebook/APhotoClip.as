package gtap.facebook
{
	import com.facebook.graph.Facebook;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import gtap.utils.Online;
	
	public class APhotoClip extends MovieClip implements IPhotoClip
	{
		public static const TYPE_ALBUM:String = "type album";
		public static const TYPE_PHOTO:String = "type photo";
		public var name_txt:TextField;
		public var container:Sprite;
		
		private var _loader:ImageLoader; // ----- 
		private var _name:String; // ------------ Album/Photo name
		private var _src:String; // ------------- Album/Photo small pic
		private var _count:uint; // ------------- Album count
		private var _type:String; // ------------ Album/Photo
		
		
		/**
		 * @param	type Album/Photo
		 * @param	name Album/Photo name
		 * @param	src Album/Photo small pic
		 * @param	count Album count
		 */
		public function APhotoClip(type:String, name:String, src:String, count:uint = 0):void
		{
			//trace(type, name, src, count);
			trace("name : " + name);
			_type = type;
			_name = name;
			_src = src;
			_count = count;
			
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			name_txt.text = _name?_name:"";
			if (_type == APhotoClip.TYPE_ALBUM) {
				name_txt.appendText("\n" + _count + "張");
			}
			if (Online()) {
				loadPic();
			}
		}
		
		protected function onRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			if (_loader) {
				_loader.dispose(true);
				_loader = null;
			}
		}
		
		private function loadPic():void
		{
			_loader = new ImageLoader(_src, new ImageLoaderVars().alpha(0).crop(true).width(50).height(50).scaleMode("proportionalInside").smoothing(true).autoDispose(true).onComplete(onPicComplete).vars );
			_loader.load();
		}
		
		private function onPicComplete(e:LoaderEvent):void 
		{
			TweenMax.to(_loader.content, 0.5, { alpha:1 } );
			container.addChild(_loader.content);
		}
		
		public function overEffect():void { }
		
		public function outEffect():void { }
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		override public function get name():String 
		{
			return _name;
		}
		
		public function get src():String 
		{
			return _src;
		}
		
	}
}