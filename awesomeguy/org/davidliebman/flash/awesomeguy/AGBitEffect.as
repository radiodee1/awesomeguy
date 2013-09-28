package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AGBitEffect {

		private var scroll:int = 0;

		public function AGBitEffect() {
			// constructor code
		}

		public function swishBits(i:Bitmap, num:int = 0):Bitmap {
			
			if (num != 0) {
				scroll = num;
			}
			else {
				scroll ++;
				
			}
			if (scroll > 16) scroll = 0;
			
			var scroll_b:int = 0;
			
			var bmd_i:BitmapData = i.bitmapData;
			var bmd_o:BitmapData = new BitmapData(2* i.width, i.height, true, 0x000000);
			
			var pixel:uint = 0x0;
			
			var width:int = i.width/2;
			var cycle:int = int (i.height / width ) + 1;
			var side:int = 0;
			var yy:int = 0;
			
			scroll_b = scroll * width/ 16;
			//trace(scroll_b);
			
			for (var ii:int =  -1 ; ii < cycle; ii ++ ) {
				for (var jj:int = 0; jj < width *2; jj ++) {
					
					if (ii % 2 == 0) {
						side = int (Math.sqrt((width * width) - (jj * jj) ) ) ;
					}
					else {
						side = -1 * int (Math.sqrt((width * width) - (jj * jj) ) ) ;

					}
					yy = (ii * width) + jj;
					if (yy + scroll_b <= i.height && yy + scroll_b >= 0 && side != 0) {
						
						for (var kk:int = 0; kk < i.width; kk ++) {
							pixel = bmd_i.getPixel32(kk, yy + scroll_b );
							//if (pixel == 0xff000000) trace("alpha");//pixel = 0xffffffff;
							bmd_o.setPixel32( width + side + kk,yy + scroll_b, pixel);
							//
						}
						//bmd_o.setPixel32( width + side,yy,0x00000000);
					}
				}
			}
			
			//var pt:Point = new Point(0,0);
			//var rect:Rectangle = new Rectangle(0, 0, bmd_o.width, bmd_o.height);
			//var threshold:uint = 0xff000000;
			//var maskcolor:uint = 0x00ffffff;// 0x000000ff;
			//var color:uint = 0x00000000;
			//var bmd_a:BitmapData = new BitmapData(bmd_o.width, bmd_o.height);
			//bmd_a.threshold(bmd_o, rect, pt, "==", threshold, color, maskcolor, true);
					
			
			var a:Bitmap = new Bitmap(bmd_o);
			return a;
		}

	}
	
}
