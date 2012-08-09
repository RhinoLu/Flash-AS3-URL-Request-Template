package ru.inspirit.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import mx.graphics.codec.*;

    public class LocalFile extends Object
    {
        private static var onOpenCancel:Function;
        private static const j_encoder:JPEGEncoder = new JPEGEncoder(100);
        private static var onData:Function;
        private static var fr:FileReference;
        private static var FILE_TYPES:Array = [new FileFilter("Image File", "*.jpeg;*.jpg;*.gif;*.png")];

        public function LocalFile()
        {
            return;
        }// end function

        private static function onCancel(event:Event) : void
        {
            if (onOpenCancel != null)
            {
                onOpenCancel();
            }
            fr = null;
            return;
        }// end function

        private static function onLoadComplete(event:Event) : void
        {
            var _loc_2:* = fr.data;
            onData(_loc_2);
            fr = null;
            return;
        }// end function

        public static function openFile(param1:Function, param2:Function = null) : void
        {
            fr = new FileReference();
            fr.addEventListener(Event.SELECT, onFileSelect);
            fr.addEventListener(Event.CANCEL, onCancel);
            onData = param1;
            onOpenCancel = param2;
            fr.browse(FILE_TYPES);
            return;
        }// end function

        private static function onSaveLoadError(event:IOErrorEvent) : void
        {
            trace("Error with file : " + event.text);
            fr = null;
            return;
        }// end function

        private static function onFileSelect(event:Event) : void
        {
            fr.addEventListener(Event.COMPLETE, onLoadComplete);
            fr.addEventListener(IOErrorEvent.IO_ERROR, onSaveLoadError);
            fr.load();
            return;
        }// end function

        public static function saveFile(param1, param2:String) : void
        {
            fr = new FileReference();
            fr.addEventListener(Event.COMPLETE, onFileSave);
            fr.addEventListener(Event.CANCEL, onCancel);
            fr.addEventListener(IOErrorEvent.IO_ERROR, onSaveLoadError);
            fr.save(param1, param2);
            return;
        }// end function

        public static function saveImage(param1:BitmapData, param2:String = "image", param3:String = "png", param4:int = 0) : void
        {
            var _loc_5:ByteArray = null;
            var _loc_6:* = param2 + "." + param3;
            if (param3 == "png")
            {
                _loc_5 = PNGEnc.encode(param1, param4);
            }
            else
            {
                _loc_5 = j_encoder.encode(param1);
            }
            saveFile(_loc_5, _loc_6);
            _loc_5 = null;
            return;
        }// end function

        private static function onFileSave(event:Event) : void
        {
            fr = null;
            return;
        }// end function

    }
}
