﻿package org.davidliebman.flash.awesomeguy {
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
				case AGMode.S_KEY:
					this.bitmap = myMode.oldCutTile(myMode.myRes[AGResources.NAME_TILES1_PNG],
													AGModeGuy.B_KEY,AGMode.TILE_BOT, 64,64);
				break;
				case AGMode.S_GUN:
					this.bitmap = myMode.oldCutTile(myMode.myRes[AGResources.NAME_TILES1_PNG],
													AGModeGuy.B_GUN,AGMode.TILE_BOT, 64,64);
				break;
				case AGMode.S_XGOAL:
					this.bitmap = myMode.oldCutTile(myMode.myRes[AGResources.NAME_TILES1_PNG],
													AGModeGuy.B_GOAL,AGMode.TILE_BOT, 64,64);
				break;
				
				case AGMode.S_EXIT:
				case AGMode.S_EXIT_KEYLESS:
				case AGMode.S_CONNECT_MAZE:
				case AGMode.S_CONNECT_MAZE_KEYLESS:
					var bits:BitmapData = new BitmapData(64,64*2,false,0x00555555);
					this.bitmap = new Bitmap(bits);

				break;
				
				case AGMode.S_ASTROGATE:
					this.bitmap = myMode.myRes[AGResources.NAME_ASTROGATE_PNG];
				break;
				
			}
		}

	}
	
}
