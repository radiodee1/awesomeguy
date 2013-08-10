package org.davidliebman.flash.awesomeguy {
	
	public class AGSpritePyramid extends AGSprite {

		var toggle:int = 0;
		var ENUM_SHOW:int = 1;
		var ENUM_SINK:int = 2;

		public function AGSpritePyramid( mymode:AGMode, kind:int) {
			super(mymode, kind);
			toggle = ENUM_SHOW;
			// constructor code
		}
		
		public override function updateSprite():void {
			if (toggle == ENUM_SHOW) {
				if(this.quality_0 > 5) {
					this.animate ++;
					this.quality_0 = 0;
				}
			}
			else if (toggle == ENUM_SINK) {
				if (y < (16 * 32) + (8 *16) ) {
					y = y + 3;
					trace("sinking", y);
				}
				else {
					this.active = false;
					this.visible = false;
				}
			}
			
		}
		public function switchPyramid():void {
			toggle = ENUM_SINK;
		}

	}
	
}
