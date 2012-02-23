package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Main extends Sprite
	{
		public static const CREATE_API_CLIP:String = "create api clip";
		
		private var clipArray:Array = new Array();
		private var clipCurrent:*;
		
		private var form:APIForm;
		
		public function Main() 
		{
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addAPIForm();
			onResize();
			stage.addEventListener(Event.RESIZE, onResize)
		}
		
		
		
		private function addAPIForm():void
		{
			form = new APIForm();
			addChild(form);
			form.signal.add(onAPIFormCall);
			onResize();
		}
		
		private function onAPIFormCall(type:String, obj:*= null):void 
		{
			//trace(type, obj);
			if (type == Main.CREATE_API_CLIP) {
				t.obj(obj);
				addAPIClip(obj);
			}
		}
		
		private function addAPIClip(obj:Object):void
		{
			var clip:APIClip = new APIClip();
			clip.desc = obj.desc;
			clip.api = obj.api;
			clip.varArray = obj.vars;
			clip.method = obj.method;
			clip.signal.add(onAPIClipCall);
			addChild(clip);
			clipArray.push(clip);
		}
		
		private function removeAPIClip(clip:APIClip):void
		{
			removeChild(clip);
			for (var i:int = 0; i < clipArray.length; i++) 
			{
				if (clipArray[i] == clip) {
					clipArray.splice(i, 1);
					break;
				}
			}
		}
		
		private function onAPIClipCall(type:String, obj:*= null):void 
		{
			//trace(type, obj);
			if (type == BaseAbstract.HIDE_COMPLETE) {
				if (obj is APIClip) {
					removeAPIClip(APIClip(obj));
				}
			}
		}
		
		private function onResize(e:Event = null):void 
		{
			form.x = stage.stageWidth - form.width - 20;
			form.y = 20;
		}
	}

}