package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.data.DataLoaderVars;
	import com.greensock.loading.DataLoader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import gtap.utils.ChkRepeatedValue;
	
	public class Main extends Sprite
	{
		public static const CREATE_API_CLIP:String = "create api clip";
		
		private var clipArray:Array = new Array();
		private var clipCurrent:*;
		
		private var form:APIForm;
		
		private var consoleLoader:DataLoader;
		private var consoleXML:XML;
		
		public function Main() 
		{
			ChkRepeatedValue.findRepeatedValue([9,2,0,1,0,2,0]);
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.align = StageAlign.TOP_LEFT;
			//stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false; // 防止按 tab 出現黃框
			addAPIForm();
			onResize();
			stage.addEventListener(Event.RESIZE, onResize);
			
			loadXML();
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
				//t.obj(obj);
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
			clip.x = int((stage.stageWidth - 283) * 0.5 + (Math.random() * 20 - 10));
			clip.y = int((stage.stageHeight - 331) * 0.5 + (Math.random() * 20 - 10));
			addChild(clip);
			clipArray.push(clip);
		}
		
		private function removeAPIClip(clip:APIClip):void
		{
			removeChild(clip);
			var index:int = clipArray.indexOf(clip);
			if ( index > -1) {
				clipArray.splice(index, 1);
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
		
		// load XML ***************************************************************************************************************************
		private function loadXML():void
		{
			consoleLoader = new DataLoader("xml/console.xml", new DataLoaderVars().autoDispose(true).noCache(true).onComplete(onLoadXMLComplete).onError(onLoadXMLError).vars);
			consoleLoader.load();
		}
		
		private function onLoadXMLComplete(e:LoaderEvent):void 
		{
			consoleXML = XML(consoleLoader.content);
			//t.obj(consoleXML);
			consoleLoader.dispose(true);
			trace(consoleXML.console);
			trace(consoleXML.console.length());
			var len:uint = consoleXML.console.length();
			var obj:Object;
			for (var i:int = 0; i < len; i++) 
			{
				obj = { };
				obj.desc = consoleXML.console[i].desc;
				obj.api = consoleXML.console[i].api;
				obj.method = consoleXML.console[i].method;
				obj.vars = [];
				var vars_len:uint = consoleXML.console[i].vars.length();
				for (var j:int = 0; j < vars_len; j++) 
				{
					obj.vars.push(consoleXML.console[i].vars[j]);
				}
				addAPIClip(obj);
			}
		}
		
		private function onLoadXMLError(e:LoaderEvent):void 
		{
			trace(e);
		}
		
		
	}

}