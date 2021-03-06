package
{
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.TextInput;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class VarForm extends BaseAbstract 
	{
		public var btn_remove:Button;
		public var txt_name:TextInput;
		public var txt_num:Label;
		public var radio_string:RadioButton;
		public var radio_file:RadioButton;
		
		private var _varName:String;
		private var _varNum:uint;
		private var _varType:String;
		
		public function VarForm() 
		{
			
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			radio_string.group = radio_file.group = new RadioButtonGroup(this.name);
			btn_remove.addEventListener(MouseEvent.CLICK, onRemoveClick);
		}
		
		override protected function onRemove(e:Event):void
		{
			super.onRemove(e);
			btn_remove.removeEventListener(MouseEvent.CLICK, onRemoveClick);
		}
		
		private function onRemoveClick(e:MouseEvent):void 
		{
			signal.dispatch(APIForm.REMOVE_VAR_FORM, this);
		}
		
		public function get varName():String 
		{
			_varName = txt_name.text;
			return _varName;
		}
		
		public function set varNum(value:uint):void 
		{
			_varNum = value;
			txt_num.text = "var" + value + " :";
		}
		
		public function get varType():String 
		{
			if (radio_string.selected) {
				return "string";
			}else {
				return "file";
			}
		}
		
		public function drawFocus(draw:Boolean):void
		{
			txt_name.drawFocus(draw);
		}
	}
}