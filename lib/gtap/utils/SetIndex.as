package gtap.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class SetIndex
	{
		public static function toTop(_clip:DisplayObject) :void
		{
			var _container:DisplayObjectContainer = _clip.parent as DisplayObjectContainer;
			_container.setChildIndex(_clip, _container.numChildren - 1);
		}
	}
}