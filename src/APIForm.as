package
{
	import fl.controls.Button;
	import fl.controls.RadioButton;
	import fl.controls.TextInput;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequestMethod;
	
	public class APIForm extends BaseAbstract 
	{
		public static const REMOVE_VAR_FORM:String = "remove var form";
		
		public var btn_make:Button;
		public var btn_add_var:Button;
		public var txt_api:TextInput;
		public var txt_desc:TextInput;
		public var radio_get:RadioButton;
		public var radio_post:RadioButton;
		
		private var varArray:Array = new Array();
		
		public function APIForm() 
		{
			
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			btn_add_var.y = 100;
			btn_make.y = btn_add_var.y + 50;
			btn_add_var.addEventListener(MouseEvent.CLICK, addVarForm);
			btn_make.addEventListener(MouseEvent.CLICK, onMakeClick);
		}
		
		private function onMakeClick(e:MouseEvent):void 
		{
			var obj:Object = { };
			obj.desc = txt_desc.text;
			obj.api = txt_api.text;
			obj.vars = [];
			for (var i:int = 0; i < varArray.length; i++) 
			{
				var clip:VarForm = varArray[i];
				obj.vars[i] = clip.varName;
			}
			obj.method = (radio_get.selected)?URLRequestMethod.GET:URLRequestMethod.POST;
			
			make(obj);
		}
		
		private function addVarForm(e:MouseEvent = null):void
		{
			var clip:VarForm = new VarForm();
			addChild(clip);
			clip.x = 0;
			clip.y = 100 + (varArray.length * 30);
			clip.varNum = varArray.length + 1;
			varArray.push(clip);
			clip.signal.add(onVarFormCall);
			
			btn_add_var.y = 100 + (varArray.length * 30);
			btn_make.y = btn_add_var.y + 50;
		}
		
		private function onVarFormCall(type:String, obj:*= null):void 
		{
			if (type == APIForm.REMOVE_VAR_FORM) {
				removeVarForm(obj);
			}
		}
		
		private function removeVarForm(clip:VarForm):void
		{
			removeChild(clip);
			var index:uint = varArray.indexOf(clip);
			varArray.splice(index, 1);
			
			btn_add_var.y = 100 + (varArray.length * 30);
			btn_make.y = btn_add_var.y + 50;
		}
		
		private function make(value:Object):void
		{
			signal.dispatch(Main.CREATE_API_CLIP, value);
		}
		
		
	}
}