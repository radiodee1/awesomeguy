package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteInvader1 extends AGSprite {

		public function AGSpriteInvader1(mymode:AGMode, kind:int) {
			super(mymode,kind);
			// constructor code
		}
		
		public override function updateSprite():void {
			this.animate ++;
			if (this.animate > 1) this.animate = 0;
			
			myMode.drawRadarPing(myMode.radar, myMode.radarscreen,
								 this.x, this.y, AGMode.PING_OTHER, 0xff00ff00);
			
			if(myMode.ypos  + AGMode.LASER_GUN  < this.y + 4) {
				this.y = this.y - this.speed;
			}
			else if (myMode.ypos + AGMode.LASER_GUN > this.y + 6) {
				this.y = this.y + this.speed;
			}
		}
		
	}
	
}
