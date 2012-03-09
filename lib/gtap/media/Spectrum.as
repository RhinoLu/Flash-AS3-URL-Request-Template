package gtap.media 
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class Spectrum extends Sprite
	{
		private var autoStart:Boolean;
		private const PLOT_HEIGHT:int = 30;
		private const CHANNEL_LENGTH:int = 256;
		private var bytes:ByteArray;
		private var g:Graphics;
		private var n:Number; // 振幅
		private var stick:uint = 5; // 採樣數
		private var seg:uint = Math.ceil(CHANNEL_LENGTH / stick); // 每隔多少px採樣
		//private var _txt:TextField;
		
		public function Spectrum(_autoStart:Boolean = true) 
		{
			autoStart = _autoStart;
			if (stage) {
				init();
			}else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		// ADDED_TO_STAGE *********************************************************************************************************************************
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			if (autoStart) {
				start();
			}
			g = this.graphics;
			
			/*_txt = new TextField();
			_txt.autoSize = "left";
			_txt.x = 100;
			addChild(_txt);*/
		}
		
		// REMOVED_FROM_STAGE ******************************************************************************************************************************
		protected function onRemove(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			stop();
		}
		
		private function onEnterFrame(event:Event):void
		{
			bytes = new ByteArray();
			
			SoundMixer.computeSpectrum(bytes, false, 0);
			
			g.clear();
			
			g.lineStyle(2, 0x000000, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
			
			n = 0;
			//_txt.text = "";
			for (var i:int = 0; i < CHANNEL_LENGTH; i += seg) {
				var X:uint = Math.floor(i / seg) * 3;
				n = bytes.readFloat() * PLOT_HEIGHT;
				g.moveTo(X, 0);
				n = Math.abs(n);
				if (n < 1) n = 1;
				g.lineTo(X, -n);
				
				//_txt.appendText(X + ",");
			}
		} 
		
		public function start():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function stop():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			//g.clear();
		}
	}
}