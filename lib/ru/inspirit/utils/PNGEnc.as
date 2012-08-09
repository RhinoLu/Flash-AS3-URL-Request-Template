package ru.inspirit.utils
{
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class PNGEnc extends Object
    {
        private static var crcTableComputed:Boolean = false;
        private static var crcTable:Array;

        public function PNGEnc()
        {
            return;
        }// end function

        private static function writeSub(param1:BitmapData, param2:ByteArray) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_10:uint = 0;
            var _loc_11:uint = 0;
            var _loc_12:uint = 0;
            var _loc_13:uint = 0;
            var _loc_14:uint = 0;
            var _loc_15:int = 0;
            var _loc_16:int = 0;
            var _loc_17:uint = 0;
            var _loc_18:* = param1.height;
            var _loc_19:* = param1.width;
            _loc_15 = 0;
            while (_loc_15 < _loc_18)
            {
                
                param2.writeByte(1);
                if (!param1.transparent)
                {
                    _loc_3 = 0;
                    _loc_4 = 0;
                    _loc_5 = 0;
                    _loc_6 = 255;
                    _loc_16 = 0;
                    while (_loc_16 < _loc_19)
                    {
                        
                        _loc_17 = param1.getPixel(_loc_16, _loc_15);
                        _loc_7 = _loc_17 >> 16 & 255;
                        _loc_8 = _loc_17 >> 8 & 255;
                        _loc_9 = _loc_17 & 255;
                        _loc_11 = _loc_7 - _loc_3 + 256 & 255;
                        _loc_12 = _loc_8 - _loc_4 + 256 & 255;
                        _loc_13 = _loc_9 - _loc_5 + 256 & 255;
                        param2.writeByte(_loc_11);
                        param2.writeByte(_loc_12);
                        param2.writeByte(_loc_13);
                        _loc_3 = _loc_7;
                        _loc_4 = _loc_8;
                        _loc_5 = _loc_9;
                        _loc_6 = 0;
                        _loc_16++;
                    }
                }
                else
                {
                    _loc_3 = 0;
                    _loc_4 = 0;
                    _loc_5 = 0;
                    _loc_6 = 0;
                    _loc_16 = 0;
                    while (_loc_16 < _loc_19)
                    {
                        
                        _loc_17 = param1.getPixel32(_loc_16, _loc_15);
                        _loc_10 = _loc_17 >> 24 & 255;
                        _loc_7 = _loc_17 >> 16 & 255;
                        _loc_8 = _loc_17 >> 8 & 255;
                        _loc_9 = _loc_17 & 255;
                        _loc_11 = _loc_7 - _loc_3 + 256 & 255;
                        _loc_12 = _loc_8 - _loc_4 + 256 & 255;
                        _loc_13 = _loc_9 - _loc_5 + 256 & 255;
                        _loc_14 = _loc_10 - _loc_6 + 256 & 255;
                        param2.writeByte(_loc_11);
                        param2.writeByte(_loc_12);
                        param2.writeByte(_loc_13);
                        param2.writeByte(_loc_14);
                        _loc_3 = _loc_7;
                        _loc_4 = _loc_8;
                        _loc_5 = _loc_9;
                        _loc_6 = _loc_10;
                        _loc_16++;
                    }
                }
                _loc_15++;
            }
            return;
        }// end function

        private static function writeChunk(param1:ByteArray, param2:uint, param3:ByteArray) : void
        {
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            var _loc_6:int = 0;
            var _loc_9:uint = 0;
            var _loc_10:uint = 0;
            if (!crcTableComputed)
            {
                crcTableComputed = true;
                crcTable = [];
                _loc_9 = 0;
                while (_loc_9 < 256)
                {
                    
                    _loc_4 = _loc_9;
                    _loc_10 = 0;
                    while (_loc_10 < 8)
                    {
                        
                        if (_loc_4 & 1)
                        {
                            _loc_4 = uint(uint(3988292384) ^ uint(_loc_4 >>> 1));
                        }
                        else
                        {
                            _loc_4 = uint(_loc_4 >>> 1);
                        }
                        _loc_10 = _loc_10 + 1;
                    }
                    crcTable[_loc_9] = _loc_4;
                    _loc_9 = _loc_9 + 1;
                }
            }
            var _loc_7:uint = 0;
            if (param3 != null)
            {
                _loc_7 = param3.length;
            }
            param1.writeUnsignedInt(_loc_7);
            _loc_5 = param1.position;
            param1.writeUnsignedInt(param2);
            if (param3 != null)
            {
                param1.writeBytes(param3);
            }
            var _loc_8:* = param1.position;
            param1.position = _loc_5;
            _loc_4 = 4294967295;
            _loc_6 = 0;
            while (_loc_6 < _loc_8 - _loc_5)
            {
                
                _loc_4 = uint(crcTable[(_loc_4 ^ param1.readUnsignedByte()) & 255] ^ _loc_4 >>> 8);
                _loc_6++;
            }
            _loc_4 = uint(_loc_4 ^ uint(4294967295));
            param1.position = _loc_8;
            param1.writeUnsignedInt(_loc_4);
            return;
        }// end function

        public static function encode(param1:BitmapData, param2:uint = 0) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeUnsignedInt(2303741511);
            _loc_3.writeUnsignedInt(218765834);
            var _loc_4:* = new ByteArray();
            new ByteArray().writeInt(param1.width);
            _loc_4.writeInt(param1.height);
            if (param1.transparent || param2 == 0)
            {
                _loc_4.writeUnsignedInt(134610944);
            }
            else
            {
                _loc_4.writeUnsignedInt(134348800);
            }
            _loc_4.writeByte(0);
            writeChunk(_loc_3, 1229472850, _loc_4);
            var _loc_5:* = new ByteArray();
            switch(param2)
            {
                case 0:
                {
                    writeRaw(param1, _loc_5);
                    break;
                }
                case 1:
                {
                    writeSub(param1, _loc_5);
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_5.compress();
            writeChunk(_loc_3, 1229209940, _loc_5);
            writeChunk(_loc_3, 1229278788, null);
            return _loc_3;
        }// end function

        private static function writeRaw(param1:BitmapData, param2:ByteArray) : void
        {
            var _loc_5:ByteArray = null;
            var _loc_6:uint = 0;
            var _loc_7:int = 0;
            var _loc_9:int = 0;
            var _loc_3:* = param1.height;
            var _loc_4:* = param1.width;
            var _loc_8:* = param1.transparent;
            _loc_7 = 0;
            while (_loc_7 < _loc_3)
            {
                
                if (!_loc_8)
                {
                    _loc_5 = param1.getPixels(new Rectangle(0, _loc_7, _loc_4, 1));
                    _loc_5[0] = 0;
                    param2.writeBytes(_loc_5);
                    param2.writeByte(255);
                }
                else
                {
                    param2.writeByte(0);
                    _loc_9 = 0;
                    while (_loc_9 < _loc_4)
                    {
                        
                        _loc_6 = param1.getPixel32(_loc_9, _loc_7);
                        param2.writeUnsignedInt(uint((_loc_6 & 16777215) << 8 | _loc_6 >>> 24));
                        _loc_9++;
                    }
                }
                _loc_7++;
            }
            return;
        }// end function

    }
}
