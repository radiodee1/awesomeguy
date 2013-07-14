package org.davidliebman.flash.awesomeguy  {
	import flash.display.Shape;
	
	public class AGSpriteBubble1 extends AGSprite {

		public function AGSpriteBubble1(mode:AGMode, kind:int) {
			super(mode, kind);
			// constructor code
		}

		public override function updateSprite():void {
			this.shape = new Shape();
			this.shape.graphics.lineStyle(4,this.color,1.0);
			
			var scrollx:int = myMode.scrollBGX;
			var scrolly:int = myMode.scrollBGY;
			var j:int;
			var rad:Number = this.radius;
			// calculate line start and end
			for(j = 0; j < rad; j ++) { // draw bubble on screen
				// calculate line start and end

				var position:Number =  j;
				var angle:Number = Math.asin(position/rad);
				var dist:Number = Math.cos(angle) * rad;
				trace(dist);
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

				if (myMode.scrollBGX < this.x + int (dist)) {
					//drawHorizontal(test.y - j, test.x - (int) dist, test.x + (int) dist, color, solid);
					//drawHorizontal(test.y + j, test.x - (int) dist, test.x + (int) dist, color, solid);
					this.shape.graphics.moveTo(this.x - int(dist) - scrollx, this.y - j - scrolly);
					this.shape.graphics.lineTo(this.x + int(dist) - scrollx, this.y - j - scrolly);

					if (this.x + int (dist) > myMode.myHoriz * 16 ) {
						//drawHorizontal(test.y - j,  (test.x - (int) dist) -( level_w * 8),  (test.x + (int) dist) -(level_w * 8), color, solid);
						//drawHorizontal(test.y + j,  (test.x - (int) dist) - ( level_w * 8),  (test.x + (int) dist) - (level_w * 8), color, solid);
						this.shape.graphics.moveTo(this.x - int(dist) - (myMode.myHoriz * 16) - scrollx, this.y - j - scrolly);
						this.shape.graphics.lineTo(this.x + int(dist) - (myMode.myHoriz * 16) - scrollx, this.y - j - scrolly);
						
					}

				}
				else if (myMode.scrollBGX >= this.x - int (dist )) {
					//drawHorizontal(test.y - j, (level_w * 8) + test.x - (int) dist, (level_w * 8) + test.x + (int) dist, color, solid);
					//drawHorizontal(test.y + j, (level_w * 8) + test.x - (int) dist, (level_w * 8) + test.x + (int) dist, color, solid);
					this.shape.graphics.moveTo(this.x - int(dist) + (myMode.myHoriz * 16) - scrollx, this.y - j - scrolly);
					this.shape.graphics.lineTo(this.x + int(dist) + (myMode.myHoriz * 16) - scrollx, this.y - j - scrolly);

				}


			}
			if (this.radius < this.limit) { // grow bubble on screen
				this.radius = this.radius + this.speed;
			}
			
			
			
		}//function

	}//class
	
}// package
