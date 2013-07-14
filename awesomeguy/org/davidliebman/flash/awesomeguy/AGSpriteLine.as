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

					this.shape.graphics.lineStyle(4,0x00ffffff,1.0);
					//this.bitmap = new Bitmap();
					var scrollx:int = myMode.scrollBGX;
					var scrolly:int = myMode.scrollBGY;
			
					//for (l = 0; l < this.quality_0 ; l ++) {
						k = ((this.endline_x - this.x ) * l) / ( this.endline_y - this.y) + this.x;
		
						//drawPoint(k,l, 0xffff);
						l = this.quality_0;
							
						if ( myMode.scrollBGX + 512 > (myMode.myHoriz * 16) && k  < 512 ) {
							//drawPoint(k + (myHoriz * 16), l, 0xffff);
							//LOGE("over edge here");
							this.shape.graphics.moveTo(this.x + (myMode.myHoriz * 16) - scrollx, this.y - scrolly);
							this.shape.graphics.lineTo(k + (myMode.myHoriz * 16) - scrollx ,l - scrolly);
						}
						else {
							this.shape.graphics.moveTo(this.x - scrollx, this.y - scrolly);
							this.shape.graphics.lineTo(k - scrollx,l -scrolly);
						}
						
						if (this.quality_0 < this.endline_y) {
							this.quality_0 = this.quality_0 +  this.speed;
							
						}
						else {
							
							var new1:AGSpriteBubble1 = new AGSpriteBubble1(myMode, AGMode.S_BUBBLE_1);
							new1.sprite_type = AGMode.S_BUBBLE_1;
							new1.x = this.endline_x;
							new1.y = this.endline_y;
							new1.limit = 100;
							new1.radius = 8;
							new1.speed = 1;
							new1.active = true;
							//new1.sprite_link = i;
							new1.color = 0xffff0000;
							this.active = false;
		
							myMode.mySprite.push(new1);
							myMode.myChallenge[myMode.myGame.gameChallenge].total_bubble_1 ++;
												
						}
						

//}
		}

	}
	
}
