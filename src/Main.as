package
{
	import com.greensock.data.TweenMaxVars;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.data.DataLoaderVars;
	import com.greensock.loading.DataLoader;
	import com.greensock.TweenMax;
	import fl.controls.Button;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import gtap.net.MyBrowseXML;
	import gtap.utils.ChkRepeatedValue;
	import gtap.utils.QuickBtn;
	import flash.net.FileReference;
	
	public class Main extends Sprite
	{
		public static const CREATE_API_CLIP:String = "create api clip";
		
		public var btn_load:Button;
		public var btn_export:Button;
		
		private var clipContainer:Sprite;
		private var clipArray:Array = new Array();
		private var clipCurrent:*;
		
		private var form:APIForm;
		
		private var consoleLoader:DataLoader;
		private var consoleXML:XML;
		
		private var file:FileReference;
		
		public function Main() 
		{
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
			clipContainer = addChildAt(new Sprite(), 0) as Sprite;
			loadDefaultXML();
			
			QuickBtn.setBtn(btn_load  , null, null, onClick);
			QuickBtn.setBtn(btn_export, null, null, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var btn:Button = e.target as Button;
			if (btn == btn_load) {
				loadLocalXML();
			}else if (btn == btn_export) {
				exportXML();
			}
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
			trace(obj.returnType);
			if (obj.returnType) {
				clip.returnType = obj.returnType;
			}else {
				clip.returnType = "string";
			}
			clip.signal.add(onAPIClipCall);
			clip.x = 100 + (clipContainer.numChildren * 50);
			clip.y = 100 + (clipContainer.numChildren * 50);
			clipContainer.addChild(clip);
			clipArray.push(clip);
			
			TweenMax.from(clip, 0.5, new TweenMaxVars().x(clip.x + (Math.random() * 100 - 50)).y(clip.y + (Math.random() * 100 - 50)).vars);
		}
		
		private function removeAPIClip(clip:APIClip):void
		{
			clipContainer.removeChild(clip);
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
		
		// load local XML ****************************************************************************************************************************
		private function loadLocalXML():void
		{
			var myBrowseXML:MyBrowseXML = new MyBrowseXML();
			myBrowseXML.signal.add(onMyBrowseXMLCall);
		}
		
		private function onMyBrowseXMLCall(type:String, obj:*= null):void 
		{
			trace("type : " + type);
			if (type == Event.COMPLETE) {
				//t.obj(obj);
				//trace(ByteArray(obj).readUTFBytes(ByteArray(obj).length));
				var xml:XML = XML(ByteArray(obj).readUTFBytes(ByteArray(obj).length));
				parseXML(xml);
			}
		}
		
		// export XML ****************************************************************************************************************************
		private function exportXML():void
		{
			var xml:XML;
			var clip:APIClip;
			var str:String = "<data>";
			var varsStr:String;
			for (var i:int = 0; i < clipContainer.numChildren; i++) 
			{
				clip = clipContainer.getChildAt(i) as APIClip;
				varsStr = "";
				for (var j:int = 0; j < clip.varArray.length; j++) 
				{
					varsStr += "<vars><name><![CDATA[" + clip.varArray[j].varName + "]]></name><type><![CDATA[" + clip.varArray[j].varType + "]]></type></vars>";
				}
				str += "<console><desc><![CDATA[" + clip.desc + "]]></desc><api><![CDATA[" + clip.api + "]]></api><method>" + clip.method + "</method><returnType>string</returnType>" + varsStr + "</console>";
			}
			str += "</data>";
			//trace(str);
			xml = new XML(str);
			//trace(xml);
			
			var MyFile:FileReference = new FileReference();
			MyFile.save(xml, "console.xml");
		}
		
		// load default XML ***************************************************************************************************************************
		private function loadDefaultXML():void
		{
			consoleLoader = new DataLoader("xml/console.xml", new DataLoaderVars().autoDispose(true).noCache(true).onComplete(onloadDefaultXMLComplete).onError(onloadDefaultXMLError).vars);
			consoleLoader.load();
		}
		
		private function onloadDefaultXMLComplete(e:LoaderEvent):void 
		{
			consoleXML = XML(consoleLoader.content);
			//t.obj(consoleXML);
			consoleLoader.dispose(true);
			parseXML(consoleXML);
		}
		
		private function onloadDefaultXMLError(e:LoaderEvent):void 
		{
			trace(e);
		}
		
		// parse XML *******************************************************************************************************************************
		private function parseXML(xml:XML):void
		{
			//trace(xml);
			while (clipContainer.numChildren > 0) 
			{
				clipContainer.removeChildAt(0);
			}
			
			var len:uint = xml.console.length();
			var obj:Object;
			for (var i:int = 0; i < len; i++) 
			{
				obj = { };
				obj.desc       = xml.console[i].desc;
				obj.api        = xml.console[i].api;
				obj.method     = xml.console[i].method;
				obj.returnType = xml.console[i].returnType;
				obj.vars = [];
				var vars_len:uint = xml.console[i].vars.length();
				for (var j:int = 0; j < vars_len; j++) 
				{
					obj.vars.push( { 
						"varName"   :xml.console[i].vars[j].name,
						"varType"   :xml.console[i].vars[j].type
					} );
				}
				addAPIClip(obj);
			}
		}
	}

}