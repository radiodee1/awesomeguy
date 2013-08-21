package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class AGSpritePyramid extends AGSprite {

		var toggle:int = 0;
		var ENUM_SHOW:int = 1;
		var ENUM_SINK:int = 2;
		var ENUM_AFTER:int = 3;
		

		public function AGSpritePyramid( mymode:AGMode, kind:int) {
			super(mymode, kind);
			toggle = ENUM_SHOW;
			// constructor code
		}
		
		public override function updateSprite():void {
			if (this.sprite_type == AGMode.S_BUNKER) {
				
				this.bitmap = new Bitmap( 
									myMode.myRes[AGResources.NAME_BUNKER_PNG].bitmapData.clone());
			}
			
			
			if (toggle == ENUM_SHOW) {
				if(this.quality_0 > 5) {
					this.animate ++;
					this.quality_0 = 0;
				}
			}
			else if (toggle == ENUM_SINK) {
				if (y < (16*32) +  this.bitmap.height ) {//(16 * 32) + (8 *16) ) {
					y = y + 3;
					
				}
				else {
					this.active = false;
					this.visible = false;
					this.myMode.maze_entrances --;
				}
			}
			else if (toggle == ENUM_AFTER) {
				
			}
			
		}
		public function switchPyramid():void {
			toggle = ENUM_SINK;
		}

	}
	
}
