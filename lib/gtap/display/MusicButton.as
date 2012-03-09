package gtap.display 
{
	import flash.events.Event;
	import gtap.abstract.AbstractBase;
	import gtap.media.Spectrum;

	public class MusicButton extends AbstractBase
	{
		private var spectrum:Spectrum;
		private var _status:Boolean;
		
		public function MusicButton() 
		{
			
		}
		
		override protected function init(e:Event = null):void
		{
			super.init(e);
			
			spectrum = new Spectrum();
			spectrum.x = 40;
			spectrum.y = 13;
			addChild(spectrum);
		}
		
		// REMOVED_FROM_STAGE ******************************************************************************************************************************
		override protected function onRemove(e:Event):void
		{
			super.onRemove(e);
			spectrum.stop();
		}
		
		public function get status():Boolean 
		{
			return _status;
		}
		
		public function set status(value:Boolean):void 
		{
			_status = value;
			if (value) {
				spectrum.start();
			}else {
				spectrum.stop();
			}
		}
		
		
	}

}