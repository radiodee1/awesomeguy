package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class AGBitEffect {

		public function AGBitEffect() {
			// constructor code
		}

		public function swishBits(i:Bitmap, num:int = 0):Bitmap {
			//var a:Bitmap = new Bitmap(new BitmapData(2*i.width, i.height,false, 0xaaaaaa));
			var bmd_i:BitmapData = i.bitmapData;
			var bmd_o:BitmapData = new BitmapData(2* i.width, i.height, false, 0xaaaaaa);
			var a:Bitmap = new Bitmap(bmd_o);
			return a;
		}

	}
	
}
