package gtap.utils
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class QuickBtn
	{
		public static function setBtn(_mc:Sprite, overFunc:Function = null, outFunc:Function = null, clickFunc:Function = null):void
		{
			_mc.buttonMode = true;
			_mc.mouseChildren = false;
			_mc.mouseEnabled = true;
			
			if (overFunc != null) {
				_mc.addEventListener(MouseEvent.ROLL_OVER , overFunc);
			}
			if (outFunc != null) {
				_mc.addEventListener(MouseEvent.ROLL_OUT , outFunc);
			}
			if (clickFunc != null) {
				_mc.addEventListener(MouseEvent.CLICK , clickFunc);
			}
		}
		
		public static function removeBtn(_mc:Sprite, overFunc:Function = null, outFunc:Function = null, clickFunc:Function = null):void
		{
			_mc.buttonMode = false;
			_mc.mouseChildren = true;
			_mc.mouseEnabled = false;
			
			if (overFunc != null) {
				_mc.removeEventListener(MouseEvent.ROLL_OVER , overFunc);
			}
			if (outFunc != null) {
				_mc.removeEventListener(MouseEvent.ROLL_OUT , outFunc);
			}
			if (clickFunc != null) {
				_mc.removeEventListener(MouseEvent.CLICK , clickFunc);
			}
		}
		
		public static function onOver(e:MouseEvent) :void
		{
			if (e.target is MovieClip) {
				var _mc:MovieClip = e.target as MovieClip;
				MyFrame.forward(_mc);
			}
		}
		
		public static function onOut(e:MouseEvent):void
		{
			if (e.target is MovieClip) {
				var _mc:MovieClip = e.target as MovieClip;
				MyFrame.backward(_mc);
			}
		}
		
		public static function onOverPlay(e:MouseEvent) :void
		{
			if (e.target is MovieClip) {
				var _mc:MovieClip = e.target as MovieClip;
				_mc.gotoAndPlay("mouse over");
			}
		}
		
		public static function onOutPlay(e:MouseEvent):void
		{
			if (e.target is MovieClip) {
				var _mc:MovieClip = e.target as MovieClip;
				_mc.gotoAndPlay("mouse out");
			}
		}
	}
}