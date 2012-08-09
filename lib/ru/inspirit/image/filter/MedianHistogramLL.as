package ru.inspirit.image.filter 
{

	/**
	 * Linked List based Histogram strucure
	 * 
	 * @author Eugene Zatepyakin
	 */
	final public class MedianHistogramLL 
	{
		public var pixels:MedianHistogramLLBin;
		public var poolHead:MedianColorPool;
		public var poolTail:MedianColorPool;
		public var next:MedianHistogramLL;
		
		public var count:int = 0;
		
		public function MedianHistogramLL()
		{
			init();
		}
		
		public function init():void
		{
			var curr:MedianHistogramLLBin = pixels = new MedianHistogramLLBin();
			var i:int = 256;
			while(--i)
			{
				curr = curr.next = new MedianHistogramLLBin();
			}
			poolHead = poolTail = new MedianColorPool();
		}

		public function reset():void
		{
			var pixel:MedianHistogramLLBin = pixels;
			count = 0;
			while(pixel)
			{
				pixel.r = pixel.g = pixel.b = 0;
				pixel = pixel.next;
			}
		}
		
		public function addColor(col:uint):MedianHistogramLL
		{
			var r:int = col >> 16 & 0xFF;
			var g:int = col >> 8 & 0xFF;
			var b:int = col & 0xFF;
			var max:int = b;
			if(g > max) max = g;
			if(r > max) max = r;
			var pixel:MedianHistogramLLBin = pixels;
			var ind:int = -1;
			max++;
			while(++ind < max)
			{
				if(ind == r) pixel.r++;
				if(ind == g) pixel.g++;
				if(ind == b) pixel.b++;
				//ind++;
				pixel = pixel.next;
			}
			
			poolTail = poolTail.next = new MedianColorPool();
			poolTail.color = col;
			
			count++;
			
			return next;
		}

		public function removeColor():MedianHistogramLL
		{
			var col:uint = poolHead.next.color;
			var r:int = col >> 16 & 0xFF;
			var g:int = col >> 8 & 0xFF;
			var b:int = col & 0xFF;
			poolHead.next = poolHead.next.next;
			
			var pixel:MedianHistogramLLBin = pixels;
			var max:int = b;
			if(g > max)max = g;
			if(r > max)max = r;
			var ind:int = -1;
			max++;
			while(++ind < max)
			{
				if(ind == r) pixel.r--;
				if(ind == g) pixel.g--;
				if(ind == b) pixel.b--;
				//ind++;
				pixel = pixel.next;
			}
			count--;
			
			return next;
		}

		public function addHistogram(hist:MedianHistogramLL):MedianHistogramLL
		{
			var pixel:MedianHistogramLLBin = pixels;
			var pixel2:MedianHistogramLLBin = hist.pixels;
			while(pixel) 
			{
				pixel.r += pixel2.r;
				pixel.g += pixel2.g;
				pixel.b += pixel2.b;
				
				pixel = pixel.next;
				pixel2 = pixel2.next;
			}
			count += hist.count;
			
			return hist.next;
		}
		
		public function removeHistogram(hist:MedianHistogramLL):void
		{
			var pixel:MedianHistogramLLBin = pixels;
			var pixel2:MedianHistogramLLBin = hist.pixels;
			while(pixel) 
			{
				pixel.r -= pixel2.r;
				pixel.g -= pixel2.g;
				pixel.b -= pixel2.b;
				
				pixel = pixel.next;
				pixel2 = pixel2.next;
			}
			count -= hist.count;
		}
		
		public function median():uint
		{
			var median:int = count >> 1;
			var pixel:MedianHistogramLLBin = pixels;
			var sumr:int = 0, sumg:int = 0, sumb:int = 0;
			var indr:int = -1, indg:int = -1, indb:int = -1;
			
			while(sumr < median || sumg < median || sumb < median)
			{
				if(sumr < median) {
					sumr += pixel.r;
					indr++;
				}
				if(sumg < median) {
					sumg += pixel.g;
					indg++;
				}
				if(sumb < median) {
					sumb += pixel.b;
					indb++;
				}
				pixel = pixel.next;
			}
			
			return indr << 16 | indg << 8 | indb;
		}
	}
}
