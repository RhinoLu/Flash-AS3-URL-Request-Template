package
{
	import com.greensock.data.TweenMaxVars;
	import com.greensock.TweenMax;
	import fl.controls.Button;
	import fl.controls.RadioButton;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequestMethod;
	import gtap.utils.ChkRepeatedValue;
	import gtap.utils.JS;
	
	public class APIForm extends BaseAbstract 
	{
		public static const REMOVE_VAR_FORM:String = "remove var form";
		
		public var btn_make:Button;
		public var btn_add_var:Button;
		public var txt_api:TextInput;
		public var txt_desc:TextInput;
		public var radio_get:RadioButton;
		public var radio_post:RadioButton;
		public var bg:Sprite;
		
		private var varArray:Array = new Array();
		
		private const VAR_FORM_START_AT_X:Number = 10; // -------------------- 「新增參數」初始X位置
		private const VAR_FORM_START_AT_Y:Number = 150; // ------------------- 「新增參數」初始Y位置
		private const VAR_FORM_HEIGHT:Number = 30; // ------------------------ 「新增參數」的高度
		private const BTN_ADD_VAR_FORM_DISTANCE:Number = 50; // -------------- 「新增參數」與按鈕的距離
		
		public function APIForm() 
		{
			
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			btn_add_var.y = VAR_FORM_START_AT_Y;
			btn_make.y = btn_add_var.y + BTN_ADD_VAR_FORM_DISTANCE;
			btn_add_var.addEventListener(MouseEvent.CLICK, addVarForm);
			btn_make.addEventListener(MouseEvent.CLICK, onMakeClick);
			arrangeDistance(0);
		}
		
		private function resetForm():void
		{
			txt_desc.text = "";
			txt_api.text = "";
			var clip:VarForm;
			var len:uint = varArray.length;
			for (var i:int = 0; i < len; i++) 
			{
				clip = varArray[i];
				removeChild(clip);
			}
			varArray = [];
			arrangeDistance();
		}
		
		private function onMakeClick(e:MouseEvent):void 
		{
			if (!chkForm()) return;
			
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
			
			resetForm();
		}
		
		private function chkForm():Boolean
		{
			if (txt_desc.length < 1) {
				JS.alert("Enter description.");
				return false;
			}
			
			if (txt_api.length < 1) {
				JS.alert("Enter API path.");
				return false;
			}
			
			var clip:VarForm;
			for (var i:int = 0; i < varArray.length; i++) 
			{
				clip = varArray[i];
				if (clip.varName.length < 1) {
					JS.alert("Enter variable's name.");
					return false;
				}
			}
			
			var clip1:VarForm;
			var clip2:VarForm;
			var repeatedArray:Array = [];
			ChkRepeatedValue.findRepeatedValue();
			for (var j:int = 0; j < varArray.length - 1; j++) 
			{
				for (var k:int = j + 1; k < varArray.length; k++) 
				{
					clip1 = varArray[j];
					clip2 = varArray[k];
					if (clip1.varName == clip2.varName) {
						//JS.alert("Variable's name repeated.");
						//return false;
						if (!repeatedArray[j]) {
							repeatedArray[j] = [];
						}
						repeatedArray[j].push(k);
					}
				}
				//trace(repeatedArray[j].indexOf(j + 1));
				/*if (repeatedArray[j].indexOf(j + 1) > -1) {
					j++;
				}*/
			}
			if (repeatedArray.length > 0) {
				t.obj(repeatedArray);
				JS.alert("Variable's name repeated.");
				return false;
			}
			
			return true;
		}
		
		private function addVarForm(e:MouseEvent = null):void
		{
			var clip:VarForm = new VarForm();
			addChild(clip);
			clip.x = VAR_FORM_START_AT_X;
			clip.y = VAR_FORM_START_AT_Y + (varArray.length * VAR_FORM_HEIGHT);
			clip.varNum = varArray.length + 1;
			varArray.push(clip);
			clip.signal.add(onVarFormCall);
			
			arrangeDistance();
		}
		
		private function onVarFormCall(type:String, obj:*= null):void 
		{
			if (type == APIForm.REMOVE_VAR_FORM) {
				removeVarForm(obj);
			}
		}
		
		private function removeVarForm(__clip:VarForm):void
		{
			removeChild(__clip);
			var index:uint = varArray.indexOf(__clip);
			varArray.splice(index, 1);
			
			// 重新調整參數序號與位置
			for (var i:int = 0; i < varArray.length; i++) 
			{
				var clip:VarForm = varArray[i];
				clip.varNum = i + 1;
				clip.y = VAR_FORM_START_AT_Y + (i * VAR_FORM_HEIGHT);
			}
			
			arrangeDistance();
		}
		
		private function arrangeDistance(__duration:Number = 0.25):void
		{
			var toValue:Number;
			toValue = VAR_FORM_START_AT_Y + (varArray.length * VAR_FORM_HEIGHT);
			TweenMax.to(btn_add_var, __duration, new TweenMaxVars().y(toValue).vars);
			toValue = toValue + BTN_ADD_VAR_FORM_DISTANCE;
			TweenMax.to(btn_make, __duration, new TweenMaxVars().y(toValue).vars);
			toValue = toValue + btn_make.height + 10;
			TweenMax.to(bg, __duration, new TweenMaxVars().height(toValue).vars);
		}
		
		private function make(value:Object):void
		{
			signal.dispatch(Main.CREATE_API_CLIP, value);
		}
		
		
	}
}