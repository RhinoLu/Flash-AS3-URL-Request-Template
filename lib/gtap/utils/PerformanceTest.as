package gtap.utils 
{
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	
	/**
	 * 效能測試
	 * @author Rhino Lu
	 */
	public function PerformanceTest(n:int = 100):Number 
	{
		var orignal:Number = getTimer();
		for(var i:int = 0 ; i < n ; i++){
			var bitmapdata:BitmapData = new BitmapData(1024, 768);
			bitmapdata.dispose();
		}
		return getTimer() - orignal;
	}
}