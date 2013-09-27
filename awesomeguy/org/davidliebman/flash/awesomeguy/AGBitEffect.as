package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class AGBitEffect {

		public function AGBitEffect() {
			// constructor code
		}

		public function swishBits(i:Bitmap, num:int = 0):Bitmap {
			
			var bmd_i:BitmapData = i.bitmapData;
			var bmd_o:BitmapData = new BitmapData(2* i.width, i.height, false, 0xaaaaaa);
			
			var width:int = i.width/2;
			var cycle:int = int (i.height / width ) + 1;
			var side:int = 0;
			var yy:int = 0;
			for (var ii:int = 0; ii < cycle; ii ++ ) {
				for (var jj:int = 0; jj < width *2; jj ++) {
					side = int (Math.sqrt((width * width) - (jj * jj) ) ) ;
					
					yy = (ii * width) + jj;
					if (yy <= i.height) {
						bmd_o.setPixel32(side,yy,0x00000000);
					}
				}
			}
			
			var a:Bitmap = new Bitmap(bmd_o);
			return a;
		}

	}
	
}
