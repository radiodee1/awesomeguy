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
			
			
			this.quality_1 ++;
			if (this.quality_1 > 5 ) {
				this.animate ++;
				this.quality_1 = 0;
			}
			if (this.animate > 8) {
				this.animate = 0;
			}
		}

	}
	
}
