package
{
	import fl.controls.Label;
	import fl.controls.TextInput;
	
	public class VarClip extends BaseAbstract 
	{
		public var txt_value:TextInput;
		public var txt_name:Label;
		
		private var _varName:String;
		private var _varValue:String;
		
		public function VarClip() 
		{
			
		}
		
		public function get varName():String 
		{
			_varName = txt_name.text;
			return _varName;
		}
		
		public function set varName(value:String):void 
		{
			txt_name.text = _varName;
			_varName = value;
		}
		
		public function get varValue():String 
		{
			_varValue = txt_value.text;
			return _varValue;
		}
		
	}
}