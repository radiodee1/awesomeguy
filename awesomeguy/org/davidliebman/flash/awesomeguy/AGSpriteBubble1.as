package org.davidliebman.flash.awesomeguy  {
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class AGSpriteBubble1 extends AGSprite {

		public function AGSpriteBubble1(mode:AGMode, kind:int) {
			super(mode, kind);
			myMode.myChallenge[myMode.myGame.gameChallenge].total_bubble_1 ++;
			myMode.myChallenge[myMode.myGame.gameChallenge].total_placed_bubble_1 ++;

			// constructor code
		}

		public override function updateSprite():void {
			
			this.shape = new Shape();
			this.shape.graphics.lineStyle(4,this.color,1.0);
			//var shape2:Shape = new Shape();
			//shape2.graphics.lineStyle(4, this.color, 1);
			
			var scrollx:int = myMode.scrollBGX;
			var scrolly:int = myMode.scrollBGY;
			var j:int;
			var rad:Number = this.radius * 2;
			var newlimit:int = this.limit * 2;
			this.bitmap = new Bitmap(new BitmapData(newlimit * 2 , newlimit,true,0x00000000));
									 
			// calculate line start and end
			for(j = 0; j < rad; j ++) { // draw bubble on screen
				// calculate line start and end

				var position:Number =  j;
				var angle:Number = Math.asin(position/rad);
				var dist:Number = Math.cos(angle) * rad;
				
				//drawRadarPing(radar_box, adjust_x(test.x - (int) dist ), test.y - j, PING_ROCK, color);
				//drawRadarPing(radar_box, adjust_x(test.x + (int) dist ), test.y - j, PING_ROCK, color);
				myMode.drawRadarPing( myMode.radar,
									 myMode.radarscreen,
									 myMode.adjust_x(this.x - int(dist))
									 ,this.y -j, 
									 AGMode.PING_ROCK, 
									 this.color);
									 
				myMode.drawRadarPing( myMode.radar,
									 myMode.radarscreen,
									 myMode.adjust_x(this.x + int(dist))
									 ,this.y -j, 
									 AGMode.PING_ROCK, 
									 this.color);

				
				if (this.sprite_type == AGMode.S_BUBBLE_3) {
					this.shape.graphics.moveTo( newlimit - int(dist) , newlimit - j );
					this.shape.graphics.lineTo( newlimit - int (dist) + 2, newlimit - j);
					this.shape.graphics.moveTo( (newlimit - int (dist) ) + (2 * int(dist)) - 2, newlimit - j );
					this.shape.graphics.lineTo( (newlimit - int (dist) ) + (2 * int(dist)), newlimit - j );
					//outline only
					
				}
				else {
					this.shape.graphics.moveTo( newlimit - int(dist) , newlimit - j );
					this.shape.graphics.lineTo( (newlimit - int (dist) ) + (2 * int(dist)), newlimit - j );
				}
			}
			this.bitmap.bitmapData.draw(this.shape);
			
			if (this.radius < this.limit && this.active) { // grow bubble on screen
				this.radius = this.radius + this.speed;
			}
			
			
		}//function

	}//class
	
}// package
