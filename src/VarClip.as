package
{
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextInput;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class VarClip extends BaseAbstract 
	{
		public var txt_value:TextInput;
		public var txt_name:Label;
		public var btn_browse:Button;
		
		private var _varName:String;
		private var _varValue:String;
		private var _varType:String;
		private var _fileType:String;
		private var _file:FileReference;
		private var _data:ByteArray;
		
		public function VarClip(type:String) 
		{
			_varType = type;
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			if (_varType == "string") {
				btn_browse.visible = false;
				txt_value.width = 240;
				txt_value.editable = true;
			}else if (_varType == "file") {
				btn_browse.visible = true;
				btn_browse.addEventListener(MouseEvent.CLICK, onClick);
				txt_value.width = 170;
				txt_value.editable = false;
				_file = new FileReference();
			}else {
				trace(this, "_varType error");
			}
		}
		
		override protected function onRemove(e:Event):void 
		{
			super.onRemove(e);
			if (_file) {
				_file.removeEventListener(Event.SELECT, onFileSelected);
				_file.removeEventListener(Event.COMPLETE, onFileLoaded);
				_file = null;
			}
			btn_browse.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			_file.browse();
			_file.addEventListener(Event.SELECT, onFileSelected);
		}
		
		private function onFileSelected(e:Event):void
		{
			_file.removeEventListener(Event.SELECT, onFileSelected);
			_fileType = _file.type;
			txt_value.text = _file.name;
			_file.addEventListener(Event.COMPLETE, onFileLoaded);
			_file.load();
		}
		
		private function onFileLoaded(e:Event):void
		{
			_file.removeEventListener(Event.COMPLETE, onFileLoaded);
			_data = e.target.data;
		}
		
		public function get varName():String 
		{
			return _varName;
		}
		
		public function set varName(value:String):void 
		{
			if (!value) return;
			_varName = value;
			txt_name.text = _varName + " :";
		}
		
		public function get varValue():String 
		{
			_varValue = txt_value.text;
			return _varValue;
		}
		
		public function get varType():String 
		{
			return _varType;
		}
		
		public function get data():ByteArray 
		{
			return _data;
		}
		
		public function get fileType():String 
		{
			return _fileType;
		}
	}
}