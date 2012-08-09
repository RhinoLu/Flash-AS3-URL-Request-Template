package
{
	import com.greensock.data.TweenMaxVars;
	import com.greensock.TweenMax;
	import fl.controls.TextArea;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class APIClipResult extends BaseAbstract
	{
		public var txt_result:TextArea;
		public var bg:Sprite;
		
		private var _result:*;
		
		public function APIClipResult()
		{
			
		}
		
		override public function show():void
		{
			TweenMax.from(this, 0.25, new TweenMaxVars().x( -283, true).onComplete(onShowComplete).vars);
		}
		
		public function set result(value:*):void 
		{
			_result = value;
			if (value is String) {
				txt_result.text = value;
			}else if (value is BitmapData) {
				txt_result.visible = false;
				var bmp:Bitmap = new Bitmap(value);
				bmp.x = txt_result.x;
				bmp.y = txt_result.y;
				addChild(bmp);
			}
		}
		
		public function changeHeight(_height:Number):void
		{
			bg.height = _height;
			txt_result.height = _height - 90;
		}
	}
}