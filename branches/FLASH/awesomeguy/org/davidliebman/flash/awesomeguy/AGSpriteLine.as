package org.davidliebman.flash.awesomeguy {
	import flash.display.Shape;
	import flash.display.Bitmap;
	
	public class AGSpriteLine extends AGSprite {

		//var shape:Shape;

		public function AGSpriteLine(mode:AGMode, kind:int) {
			super(mode,kind);
			// constructor code
		}

		public override function updateSprite():void {
			
					var k:int, l:int;//, m;
					this.shape = new Shape();
					//var myShape:Shape = new Shape();
					this.shape.graphics.lineStyle(4,0xffffffff,1.0);
					//this.bitmap = new Bitmap();
					
			
					for (l = 0; l < this.quality_0 ; l ++) {
						k = ((this.endline_x - this.x ) * l) / ( this.endline_y - this.y) + this.x;
		
						//drawPoint(k,l, 0xffff);
							this.shape.graphics.moveTo(this.x, this.y);
							this.shape.graphics.lineTo(k,l);
							
						if ( myMode.scrollBGX + 512 > (myMode.myHoriz * 16) && k  < 512 ) {
							//drawPoint(k + (myHoriz * 16), l, 0xffff);
							//LOGE("over edge here");
							this.shape.graphics.moveTo(this.x + (myMode.myHoriz * 16), this.y);
							this.shape.graphics.lineTo(k + (myMode.myHoriz * 16) ,l);
						}
		
					}
		}

	}
	
}
