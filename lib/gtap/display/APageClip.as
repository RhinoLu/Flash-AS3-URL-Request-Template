package gtap.display
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class APageClip extends Sprite implements IPageClip
	{
		public var page_txt:TextField;
		public var bg:MovieClip;
		
		protected var _page:uint;
		
		public function APageClip(page:uint):void
		{
			_page = page;
			
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * ADDED_TO_STAGE
		 */
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			page_txt.autoSize = TextFieldAutoSize.LEFT;
			page_txt.text = String(_page);
			bg.width = page_txt.width;
		}
		
		/**
		 * REMOVED_FROM_STAGE
		 */
		protected function onRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			
		}
		
		/**
		 * OVER EFFECT
		 */
		public function overEffect():void
		{
			
		}
		
		/**
		 * OUT EFFECT
		 */
		public function outEffect():void
		{
			
		}
		
		/**
		 * Clip's Page
		 */
		public function get page():uint 
		{
			return _page;
		}
	}
	
}