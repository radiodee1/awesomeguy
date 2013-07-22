package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class AGSpriteVarious extends AGSprite {

		public function AGSpriteVarious(mymode:AGMode, kind:int) {
			super(mymode, kind);
			// constructor code
		}

		public override  function updateSprite():void {
			switch (this.sprite_type) {
				case AGMode.S_NONE:
				break;
				
				case AGMode.S_GOAL:
					this.bitmap = new Bitmap(new BitmapData(TILE_WIDTH, TILE_HEIGHT,true, 0x00000000));
					
				break;
			}
		}

	}
	
}
