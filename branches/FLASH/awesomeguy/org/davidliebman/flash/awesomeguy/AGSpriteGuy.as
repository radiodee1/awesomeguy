package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteGuy  extends AGSprite{


		//var state:int = 0; // use quality_0!!
		// quality_1 for animation.
		
		
		
		public function AGSpriteGuy(mymode:AGMode, kind:int) {
			super(mymode,kind);
			// constructor code
			this.bitmap = myMode.myRes[AGResources.NAME_G_STEPR1_PNG];
		}

		public override function updateSprite():void {
			super.updateSprite();
		
			if (this.timer.timerDone() && this.quality_0 != AGModeGuy.GUY_SHOOT) {
				this.animate ++;
				
				this.timer = new AGTimer(0.1);//0.15
			}
			if (this.timer.timerDone() && this.quality_0 == AGModeGuy.GUY_SHOOT) {
				this.animate = 1;
				//this.timer = new AGTimer(0.1);
			}
			if (this.animate > 8) {
				this.animate = 0;
			}
		}

	}
	
}
