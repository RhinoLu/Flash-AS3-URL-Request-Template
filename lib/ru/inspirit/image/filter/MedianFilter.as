package ru.inspirit.image.filter 
{
	import com.joa_ebert.apparat.memory.Memory;

	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * Median Filter
	 * 
	 * Implemented 2 versions of constant time method described here: http://nomis80.org/ctmf.html
	 * but heavily simplified for fast processing in Flash environment
	 * 
	 * constantTimeBA is using TDSI tool created by Joa Ebert (http://blog.joa-ebert.com)
	 * constantTimeLL created using Linked List structure and doesnt rely on Joa's TDSI
	 * 
	 * both methods are based on Mario Klingemann (http://www.quasimondo.com) apply structure
	 * as far as it works faster and a lot more clear written ;)
	 * 
	 * @author Eugene Zatepyakin
	 * @link http://blog.inspirit.ru
	 */
	final public class MedianFilter 
	{
		
		public function MedianFilter(){}
		
		/**
		 * this approach is limited to 33x33 kernel in worst case
		 * because it uses tricky way to pack 3 channel colors in to one integer (like RGB)
		 */
		public function constantTimeBALimit(bitmapData:BitmapData, result:BitmapData, radius:int = 3):void
		{			
			bitmapData.lock();
			
			var pixels:Vector.<uint> = bitmapData.getVector( bitmapData.rect);
			
			var w:int = bitmapData.width;
			var h:int = bitmapData.height;
			var x:int, y:int;
			
			var step:int = (257 << 2);
			var countPos:int = (256 << 2);
			var mainHistOff:int = step * w;
			var clearH:ByteArray = new ByteArray();
			clearH.length = step;
			var Hba:ByteArray = new ByteArray();
			Hba.length = mainHistOff + step + ((w * h) << 2);
			Hba.endian = Endian.LITTLE_ENDIAN;
			
			Memory.select(Hba);
			
			var v:uint, i:int;
			var sum:int, k:int, addr:int, off:int, median:int;
			var cmx:int, cmx2:int;
			
			var readIndex:int = 0;
			var readIndex2:int = 0;
			for ( y = 0; y <= radius; ++y )
			{
				off = 0;
				for ( x = 0; x < w; ++x, ++readIndex )
				{
					v = pixels[readIndex];
					
					cmx = Memory.readInt( (addr = ((v >> 16 & 0xFF)<<2) + off) );
					Memory.writeInt((cmx & 0x008FFFFF) | (((cmx >> 20 & 1023) + 1)<<20), addr);
					
					cmx = Memory.readInt( (addr = ((v >> 8 & 0xFF)<<2) + off) );
					Memory.writeInt((cmx & 0xFFF003FF) | (((cmx >> 10 & 1023) + 1)<<10), addr);
					
					cmx = Memory.readInt( (addr = ((v & 0xFF)<<2) + off) );
					Memory.writeInt((cmx & 0xFFFFFC00) | ((cmx & 1023) + 1), addr);
					
					Memory.writeInt(Memory.readInt( (addr=countPos + off) )+1, addr);
					off += step;
				}		
			}
			
			x = radius;
			off = 0;
			while ( --x > -2 )
			{
				// add histograms to main
				for(k = 0; k < 1024; k += 4)
				{
					cmx = Memory.readInt( k + off );
					if(cmx == 0) continue;
					cmx2 = Memory.readInt( (addr = k + mainHistOff) );
					Memory.writeInt( (((cmx >> 20 & 1023) + (cmx2 >> 20 & 1023)) << 20) | (((cmx >> 10 & 1023) + (cmx2 >> 10 & 1023)) << 10) | ((cmx & 1023) + (cmx2 & 1023)), addr);
				}
				Memory.writeInt(Memory.readInt((addr=countPos + mainHistOff))+Memory.readInt( countPos + off ), addr);
				off += step;
			}
			
			x = y = 0;
			var index:int;
			var ix:int;
			var radius2:int = radius+1;
			var writeIndex:int = mainHistOff + step;
			var rn:int, gn:int, bn:int;
			var ri:int, gi:int, bi:int;
			
			while(true)
			{
				// calculate median value
				median = Memory.readInt(countPos + mainHistOff) >> 1;
				rn = gn = bn = 0;
				ri = gi = bi = -1;
				
				k = mainHistOff;
				while(rn < median || gn < median || bn < median)
				{
					sum = Memory.readInt(k);
					
					if(rn < median)
					{
						rn += sum >> 20 & 1023;
						ri++;
					}
					if(gn < median)
					{
						gn += sum >> 10 & 1023;
						gi++;
					}
					if(bn < median)
					{
						bn += sum & 1023;
						bi++;
					}
					k+=4;
				}
				
				Memory.writeInt(ri << 16 | gi << 8 | bi, writeIndex);
				writeIndex += 4;
					
				x++;
				if ( ( index = x + radius ) < w ) 
				{
					// add next histogram
					off = index * step;
					
					for(k = 0; k < 1024; k += 4)
					{
						cmx = Memory.readInt( k + off );
						if(cmx == 0) continue;
						cmx2 = Memory.readInt( (addr = k + mainHistOff) );
						Memory.writeInt( (((cmx >> 20 & 1023) + (cmx2 >> 20 & 1023)) << 20) | (((cmx >> 10 & 1023) + (cmx2 >> 10 & 1023)) << 10) | ((cmx & 1023) + (cmx2 & 1023)), addr);
					}
					Memory.writeInt(Memory.readInt((addr=countPos + mainHistOff))+Memory.readInt( countPos + off ), addr);
				}
				
				if ( ( index = x - radius2 ) > -1 )
				{
					// substruct old histogram
					off = index * step;
					
					for(k = 0; k < 1024; k += 4)
					{
						cmx2 = Memory.readInt( k + off );
						if(cmx2 == 0) continue;
						cmx = Memory.readInt( (addr = k + mainHistOff) );
						Memory.writeInt( (((cmx >> 20 & 1023) - (cmx2 >> 20 & 1023)) << 20) | (((cmx >> 10 & 1023) - (cmx2 >> 10 & 1023)) << 10) | ((cmx & 1023) - (cmx2 & 1023)), addr);
					}
					Memory.writeInt(Memory.readInt((addr=countPos + mainHistOff))-Memory.readInt( countPos + off ), addr);
				}
				
				if ( x == w )
				{
					x = 0;
					y++;
					if ( y == h ) break;
					
					// clear main histogram
					/*for(i = mainHistOff+1024; i >= mainHistOff; i -= 4) 
					{
						Memory.writeInt(0, i);
					}*/
					Hba.position = mainHistOff;
					Hba.writeBytes(clearH);
					
					if ( y > radius )
					{
						// remove old pixels
						off = 0;
						for ( i = 0; i < w; ++i, ++readIndex2 ) 
						{
							v = pixels[readIndex2];
							
							cmx = Memory.readInt( (addr = ((v >> 16 & 0xFF)<<2) + off) );
							Memory.writeInt((cmx & 0x008FFFFF) | (((cmx >> 20 & 1023) - 1)<<20), addr);
							
							cmx = Memory.readInt( (addr = ((v >> 8 & 0xFF)<<2) + off) );
							Memory.writeInt((cmx & 0xFFF003FF) | (((cmx >> 10 & 1023) - 1)<<10), addr);
							
							cmx = Memory.readInt( (addr = ((v & 0xFF)<<2) + off) );
							Memory.writeInt((cmx & 0xFFFFFC00) | ((cmx & 1023) - 1), addr);
							
							Memory.writeInt(Memory.readInt( (addr=countPos + off) )-1, addr);
							off += step;
						}
					}
					
					if ( y < h - radius)
					{
						// add new pixels
						off = 0;
						for ( i = 0; i < w; ++i, ++readIndex )
						{
							v = pixels[readIndex];
							
							cmx = Memory.readInt( (addr = ((v >> 16 & 0xFF)<<2) + off) );
							Memory.writeInt((cmx & 0x008FFFFF) | (((cmx >> 20 & 1023) + 1)<<20), addr);
							
							cmx = Memory.readInt( (addr = ((v >> 8 & 0xFF)<<2) + off) );
							Memory.writeInt((cmx & 0xFFF003FF) | (((cmx >> 10 & 1023) + 1)<<10), addr);
							
							cmx = Memory.readInt( (addr = ((v & 0xFF)<<2) + off) );
							Memory.writeInt((cmx & 0xFFFFFC00) | ((cmx & 1023) + 1), addr);
							
							Memory.writeInt(Memory.readInt( (addr=countPos + off) )+1, addr);
							off += step;
						}
					}
					
					ix = radius;
					off = 0;
					while ( --ix > -2 )
					{
						// add histogram
						for(k = 0; k < 1024; k += 4)
						{
							cmx = Memory.readInt( k + off );
							if(cmx == 0) continue;
							cmx2 = Memory.readInt( (addr = k + mainHistOff) );
							Memory.writeInt( (((cmx >> 20 & 1023) + (cmx2 >> 20 & 1023)) << 20) | (((cmx >> 10 & 1023) + (cmx2 >> 10 & 1023)) << 10) | ((cmx & 1023) + (cmx2 & 1023)), addr);
						}
						Memory.writeInt(Memory.readInt((addr=countPos + mainHistOff))+Memory.readInt( countPos + off ), addr);
						off += step;
					}
				}
			}
			
			Hba.position = mainHistOff + step;
			result.lock();
			result.setPixels(result.rect, Hba);
			bitmapData.unlock(bitmapData.rect);
			result.unlock(result.rect);
		}
		
		public function constantTimeLL(bitmapData:BitmapData, result:BitmapData, radius:int = 3):void
		{	
			bitmapData.lock();
			
			var pixels:Vector.<uint> = bitmapData.getVector( bitmapData.rect );
			
			var w:int = bitmapData.width;
			var h:int = bitmapData.height;
			var x:int, y:int;
			
			var rowHistograms:Vector.<MedianHistogramLL> = new Vector.<MedianHistogramLL>( w, true );
			var mainHistogram:MedianHistogramLL = new MedianHistogramLL();
			var firstRow:MedianHistogramLL;
			var currentRow:MedianHistogramLL = firstRow = rowHistograms[0] = new MedianHistogramLL();
			
			for ( x = 1; x < w; ++x )
			{
				currentRow = currentRow.next = rowHistograms[x] = new MedianHistogramLL();
			}
			
			var readIndex:int = -1;
			for ( y = -1; y < radius; ++y )
			{
				currentRow = firstRow;
				while ( currentRow = currentRow.addColor( pixels[uint(++readIndex)] )){}		
			}
			
			currentRow = firstRow;
			x = radius;
			while ( --x > -2 )
			{
				currentRow = mainHistogram.addHistogram( currentRow );
			}
			
			x = y = 0;
			var index:int;
			var ix:int;
			var radius2:int = radius+1;
			var writeIndex:int = -1;
			
			while(true)
			{
				pixels[uint(++writeIndex)] = mainHistogram.median();
					
				x++;
				if ( ( index = x + radius ) < w ) 
				{
					mainHistogram.addHistogram( rowHistograms[index] );
				}
				
				if ( ( index = x - radius2 ) > -1 )
				{
					mainHistogram.removeHistogram( rowHistograms[index] );
				}
				
				if ( x == w )
				{
					x = 0;
					y++;
					if ( y == h ) break;
					
					mainHistogram.reset();
					
					if ( y > radius )
					{
						currentRow = firstRow;
						while ( currentRow = currentRow.removeColor() ){}
					}
					
					if ( y < h - radius)
					{
						currentRow = firstRow;
						while ( currentRow = currentRow.addColor( pixels[uint(++readIndex)] ) ){}
					}
					
					currentRow = firstRow;
					ix = radius;
					while ( --ix > -2 )
					{
						currentRow = mainHistogram.addHistogram( currentRow );
					}
				}
			}
			
			result.lock();
			result.setVector(result.rect, pixels);
			bitmapData.unlock(bitmapData.rect);
			result.unlock(result.rect);
		}
		
		public function constantTimeBA(bitmapData:BitmapData, result:BitmapData, radius:int = 3):void
		{			
			bitmapData.lock();
			
			var pixels:Vector.<uint> = bitmapData.getVector( bitmapData.rect );
			
			var w:int = bitmapData.width;
			var h:int = bitmapData.height;
			var x:int, y:int;
			
			var step:int = (769 << 2);
			var countPos:int = (768 << 2);
			var mainHistOff:int = step * w;
			var clearH:ByteArray = new ByteArray();
			clearH.length = step;
			var Hba:ByteArray = new ByteArray();
			Hba.length = mainHistOff + step + ((w * h) << 2);
			Hba.endian = Endian.LITTLE_ENDIAN;
			
			Memory.select(Hba);
			
			var v:uint, i:int, k:int;
			var sum:int, addr:int, off:int, median:int;
			
			var readIndex:int = 0;
			var readIndex2:int = 0;
			for ( y = 0; y <= radius; ++y )
			{
				off = 0;
				for ( x = 0; x < w; ++x, ++readIndex )
				{
					v = pixels[readIndex];
					
					Memory.writeInt( Memory.readInt( (addr = ((v >> 16 & 0xFF)<<2) + off) ) + 1, addr);
					Memory.writeInt( Memory.readInt( (addr = ((256 | (v >> 8 & 0xFF))<<2) + off) ) + 1, addr);
					Memory.writeInt( Memory.readInt( (addr = ((512 | (v & 0xFF))<<2) + off) ) + 1, addr);
					
					Memory.writeInt(Memory.readInt( (addr = countPos + off) ) + 1, addr);
					off += step;
				}		
			}
			
			x = radius;
			off = 0;
			while ( --x > -2 )
			{
				// add histograms to main
				for(k = 0; k < 1024; k += 4)
				{
					if((sum = Memory.readInt( k + off ))) Memory.writeInt( Memory.readInt((addr = k + mainHistOff)) + sum, addr);
					if((sum = Memory.readInt( (1024 | k) + off ))) Memory.writeInt( Memory.readInt((addr = (1024 | k) + mainHistOff)) + sum, addr);
					if((sum = Memory.readInt( (2048 | k) + off ))) Memory.writeInt( Memory.readInt((addr = (2048 | k) + mainHistOff)) + sum, addr); 
				}
				Memory.writeInt(Memory.readInt((addr=countPos + mainHistOff))+Memory.readInt( countPos + off ), addr);
				off += step;
			}
			
			x = y = 0;
			var index:int;
			var ix:int;
			var radius2:int = radius+1;
			var writeIndex:int = mainHistOff + step;
			var rn:int, gn:int, bn:int;
			var ri:int, gi:int, bi:int;
			
			while(true)
			{
				// calculate median value
				median = Memory.readInt(countPos + mainHistOff) >> 1;
				rn = gn = bn = 0;
				ri = gi = bi = -1;
				
				k = mainHistOff;
				while(rn < median || gn < median || bn < median)
				{					
					if(rn < median)
					{
						rn += Memory.readInt(k);
						ri++;
					}
					if(gn < median)
					{
						gn += Memory.readInt(1024 + k);
						gi++;
					}
					if(bn < median)
					{
						bn += Memory.readInt(2048 + k);
						bi++;
					}
					k += 4;
				}
				
				Memory.writeInt(ri << 16 | gi << 8 | bi, writeIndex);
				writeIndex += 4;
					
				x++;
				if ( ( index = x + radius ) < w ) 
				{
					// add next histogram
					off = index * step;
					
					for(k = 0; k < 1024; k += 4)
					{
						if((sum = Memory.readInt( k + off ))) Memory.writeInt( Memory.readInt((addr = k + mainHistOff)) + sum, addr);
						if((sum = Memory.readInt( (1024 | k) + off ))) Memory.writeInt( Memory.readInt((addr = (1024 | k) + mainHistOff)) + sum, addr);
						if((sum = Memory.readInt( (2048 | k) + off ))) Memory.writeInt( Memory.readInt((addr = (2048 | k) + mainHistOff)) + sum, addr);
					}
					Memory.writeInt(Memory.readInt((addr=countPos + mainHistOff))+Memory.readInt( countPos + off ), addr);
				}
				
				if ( ( index = x - radius2 ) > -1 )
				{
					// substruct old histogram
					off = index * step;
					
					for(k = 0; k < 1024; k += 4)
					{
						if((sum = Memory.readInt( k + off ))) Memory.writeInt( Memory.readInt((addr = k + mainHistOff)) - sum, addr);
						if((sum = Memory.readInt( (1024 | k) + off ))) Memory.writeInt( Memory.readInt((addr = (1024 | k) + mainHistOff)) - sum, addr);
						if((sum = Memory.readInt( (2048 | k) + off ))) Memory.writeInt( Memory.readInt((addr = (2048 | k) + mainHistOff)) - sum, addr);
					}
					Memory.writeInt(Memory.readInt((addr=countPos + mainHistOff))-Memory.readInt( countPos + off ), addr);
				}
				
				if ( x == w )
				{
					x = 0;
					y++;
					if ( y == h ) break;
					
					// clear main histogram
					/*for(i = mainHistOff+step; i >= mainHistOff; i -= 4) 
					{
						Memory.writeInt(0, i);
					}*/
					Hba.position = mainHistOff;
					Hba.writeBytes(clearH);
					
					if ( y > radius )
					{
						// remove old pixels
						off = 0;
						for ( i = 0; i < w; ++i, ++readIndex2 ) 
						{
							v = pixels[readIndex2];
							
							Memory.writeInt( Memory.readInt( (addr = ((v >> 16 & 0xFF)<<2) + off) ) - 1, addr);
							Memory.writeInt( Memory.readInt( (addr = ((256 | (v >> 8 & 0xFF))<<2) + off) ) - 1, addr);
							Memory.writeInt( Memory.readInt( (addr = ((512 | (v & 0xFF))<<2) + off) ) - 1, addr);
							
							Memory.writeInt(Memory.readInt( (addr=countPos + off) )-1, addr);
							off += step;
						}
					}
					
					if ( y < h - radius)
					{
						// add new pixels
						off = 0;
						for ( i = 0; i < w; ++i, ++readIndex )
						{
							v = pixels[readIndex];
							
							Memory.writeInt( Memory.readInt( (addr = ((v >> 16 & 0xFF)<<2) + off) ) + 1, addr);
							Memory.writeInt( Memory.readInt( (addr = ((256 | (v >> 8 & 0xFF))<<2) + off) ) + 1, addr);
							Memory.writeInt( Memory.readInt( (addr = ((512 | (v & 0xFF))<<2) + off) ) + 1, addr);
							
							Memory.writeInt(Memory.readInt( (addr=countPos + off) )+1, addr);
							off += step;
						}
					}
					
					ix = radius;
					off = 0;
					while ( --ix > -2 )
					{
						// add histogram
						for(k = 0; k < 1024; k += 4)
						{
							if((sum = Memory.readInt( k + off ))) Memory.writeInt( Memory.readInt((addr = k + mainHistOff)) + sum, addr);
							if((sum = Memory.readInt( (1024 | k) + off ))) Memory.writeInt( Memory.readInt((addr = (1024 | k) + mainHistOff)) + sum, addr);
							if((sum = Memory.readInt( (2048 | k) + off ))) Memory.writeInt( Memory.readInt((addr = (2048 | k) + mainHistOff)) + sum, addr);
						}
						Memory.writeInt(Memory.readInt((addr=countPos + mainHistOff))+Memory.readInt( countPos + off ), addr);
						off += step;
					}
				}
			}
			
			Hba.position = mainHistOff + step;
			result.lock();
			result.setPixels(result.rect, Hba);
			bitmapData.unlock(bitmapData.rect);
			result.unlock(result.rect);
		}
	}
}