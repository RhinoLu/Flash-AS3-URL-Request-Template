package gtap.utils 
{
	import com.greensock.data.TweenMaxVars;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	/**
	 * 
	 * @author gotoAndPlay()™ Digital Consulting.
	 */
	public class MyFrame
	{
		
		// 獲得 label 所在的 frame **********************************************************************************************************************
		static public function getLabelsFrame(_mc:MovieClip, label:String):uint
		{
			var array:Array = _mc.currentLabels;
			var frameLabel:FrameLabel;
			for (var i:uint = 0; i < array.length ; i++) {
				frameLabel = array[i];
				if (frameLabel.name == label) {
					return frameLabel.frame;
				}
			}
			return 0;
		}
		
		// 往前播 ***************************************************************************************************************************************
		static public function forward(_mc:MovieClip, label:String = null, completeFunc:Function = null, completeParams:Array = null):void
		{
			//TweenMax.killTweensOf(_mc);
			killFrameTween(_mc);
			
			var targetFrame:uint;
			if (label) {
				// 有 label
				targetFrame = getLabelsFrame(_mc, label);
				if (targetFrame < _mc.currentFrame) {
					backward(_mc, label);
					return;
				}
			}else {
				// 無 label，播到底
				targetFrame = _mc.totalFrames;
			}
			TweenMax.to(_mc, targetFrame - _mc.currentFrame, new TweenMaxVars().frame(targetFrame).useFrames(true).ease(Linear.easeNone).onComplete(completeFunc, completeParams).vars );
		}
		
		// 往後播 ***************************************************************************************************************************************
		static public function backward(_mc:MovieClip, label:String = null, completeFunc:Function = null, completeParams:Array = null):void
		{
			//TweenMax.killTweensOf(_mc);
			killFrameTween(_mc);
			
			var targetFrame:uint;
			if (label) {
				// 有 label
				targetFrame = getLabelsFrame(_mc, label);
				if (targetFrame > _mc.currentFrame) {
					forward(_mc, label);
					return;
				}
			}else {
				// 無 label，播到 1
				targetFrame = 1;
			}
			TweenMax.to(_mc, _mc.currentFrame - targetFrame , new TweenMaxVars().frame(targetFrame).useFrames(true).ease(Linear.easeNone).onComplete(completeFunc, completeParams).vars );
		}
		
		// 往某 label 播，不一定往前或往後 **********************************************************************************************************************
		static public function toLabel(_mc:MovieClip, label:String, completeFunc:Function = null):void
		{
			// 判斷往前或後
			if (_mc.currentFrame < getLabelsFrame(_mc, label)) {
				forward(_mc, label, completeFunc);
			}else if (_mc.currentFrame > getLabelsFrame(_mc, label)) {
				backward(_mc, label, completeFunc);
			}else {
				completeFunc();
			}
		}
		
		// 移除 frame tween  *******************************************************************************************************************************
		static public function killFrameTween(_mc:MovieClip):void
		{
			var tween_array:Array = TweenMax.getTweensOf(_mc);
			//trace("killFrameTween : " + tween_array.length + "," + _mc);
			if (tween_array.length > 0) {
				var i :uint;
				var len:uint = tween_array.length;
				var tween:TweenMax;
				var prop:String = "frame";
				for (i = 0; i < len; i++) {
					tween = tween_array[i];
					if (tween.vars[prop]) {
						tween.killProperties([prop]);
					}
				}
			}
		}
	}

}