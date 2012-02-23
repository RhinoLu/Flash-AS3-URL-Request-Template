package
{
	import com.greensock.data.TweenMaxVars;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.osflash.signals.Signal;
	
	public class BaseAbstract extends Sprite implements BaseInterface
	{
		public static const SHOW_COMPLETE:String = "show complete";
		public static const HIDE_COMPLETE:String = "hide complete";
		
		private var _signal:Signal;
		
		public function BaseAbstract() 
		{
			_signal = new Signal();
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
			show();
		}
		
		protected function onRemove(e:Event):void
		{
			_signal.removeAll();
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		public function show():void
		{
			this.alpha = 0;
			TweenMax.to(this, 0.25, new TweenMaxVars().autoAlpha(1).onComplete(onShowComplete).vars);
		}
		
		protected function onShowComplete():void 
		{
			_signal.dispatch(BaseAbstract.SHOW_COMPLETE, this);
		}
		
		public function hide():void
		{
			TweenMax.to(this, 0.25, new TweenMaxVars().autoAlpha(0).onComplete(onHideComplete).vars);
		}
		
		protected function onHideComplete():void 
		{
			_signal.dispatch(BaseAbstract.HIDE_COMPLETE, this);
		}
		
		public function get signal():Signal 
		{
			return _signal;
		}
	}
}