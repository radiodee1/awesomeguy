package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AGBitEffect {

		private var scroll:int = 0;
		private var neg:int = 1;


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
			if (scroll > 16) { 
				scroll = 0;
				neg = neg * -1;
			}
			
			var scroll_b:int = 0;
			
			var bmd_i:BitmapData = i.bitmapData;
			var bmd_o:BitmapData = new BitmapData(2* i.width, i.height, true, 0x000000);
			
			var pixel:uint = 0x0;
			
			var width:int = i.width/4;
			var cycle:int = int (i.height / width ) + 1;
			var side:int = 0;
			var yy:int = 0;
			var mm:int = 0;
			var jj:int = 0;
			var kk:int = 0;
			
			scroll_b = scroll * width * 4/ 16;
			
			//scroll_b = 0;
			for (var ii:int =  -1 ; ii < cycle; ii ++ ) {
				
				
				if (ii % 4 == 0) {
					for ( jj = 0; jj < width * 2;  jj ++) {
						
						
						side = neg * int (Math.sqrt((width * width) - (jj * jj) ) ) ;
							
							
						
						yy = ((ii + 1) * width ) - jj;
						if (yy + scroll_b <= i.height && yy + scroll_b >= 0 && side != 0) {
							
							for ( kk = 0; kk < i.width; kk ++) {
								pixel = bmd_i.getPixel32(kk, yy + scroll_b );
								//pixel = 0xff0000ff;
								bmd_o.setPixel32(( width * 1) + side + kk,yy + scroll_b, pixel);
								//
							}// for kk
							
						}// if yy
					}// for jj
				}// if ii %4
				
				if (ii % 4 == 1) {
					for (jj =0  ; jj < width*2; jj ++) {
						
						
						side = neg * int (Math.sqrt((width * width) - (jj * jj) ) ) ;
							
							
						
						yy = (ii * width) + jj;
						if (yy + scroll_b <= i.height && yy + scroll_b >= 0 && side != 0) {
							
							for ( kk = 0; kk < i.width; kk ++) {
								pixel = bmd_i.getPixel32(kk, yy + scroll_b );
								//if (pixel == 0xff000000) trace("alpha");//pixel = 0xffffffff;
								bmd_o.setPixel32(( width * 1) + side + kk,yy + scroll_b, pixel);
								//
							}// for kk
							
						}// if yy
					}// for jj
				}// if ii %4
				if (ii % 4 == 2) {
					for (jj = width * 2; jj >=0; jj --) {
						
						
						side =   - neg * int (Math.sqrt((width * width) - (jj * jj) ) ) ;
							
							
						
						yy = ((ii + 1 )* width) - jj;
						if (yy + scroll_b <= i.height && yy + scroll_b >= 0 && side != 0) {
							
							for (kk = 0; kk < i.width; kk ++) {
								pixel = bmd_i.getPixel32(kk, yy + scroll_b );
								//if (pixel == 0xff000000) trace("alpha");//pixel = 0xffffffff;
								bmd_o.setPixel32(( width * 1) + side + kk,yy + scroll_b, pixel);
								//
							}// for kk
							
						}// if yy
					}// for jj
				}// if ii %4
				if (ii % 4 == 3) {
					for ( jj = 0; jj < width *2; jj ++) {
						
						
						side =   - neg * int (Math.sqrt((width * width) - (jj * jj) ) ) ;
							
							
						
						yy = (ii * width) + jj;
						if (yy + scroll_b <= i.height && yy + scroll_b >= 0 && side != 0) {
							
							for (kk = 0; kk < i.width; kk ++) {
								pixel = bmd_i.getPixel32(kk, yy + scroll_b );
								//if (pixel == 0xff000000) trace("alpha");//pixel = 0xffffffff;
								bmd_o.setPixel32(( width * 1) + side + kk,yy + scroll_b, pixel);
								//
							}// for kk
							
						}// if yy
					}// for jj
				}// if ii %4
			}
			
			
			
			var a:Bitmap = new Bitmap(bmd_o);
			return a;
		}

	}
	
}
