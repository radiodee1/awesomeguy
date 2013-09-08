package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	
	public class AGSpritePyramid extends AGSprite {

		var toggle:int = 0;
		var ENUM_SHOW:int = 1;
		var ENUM_SINK:int = 2;
		var ENUM_AFTER:int = 3;
		var startingy:int = 0;

		public function AGSpritePyramid( mymode:AGMode, kind:int) {
			super(mymode, kind);
			toggle = ENUM_SHOW;
			// constructor code
			startingy = this.y;
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
				if (y < startingy + this.bitmap.height){//(16*32) +  this.bitmap.height ) {
					y = y + 3;
					for (var i:int = 0; i < y - startingy; i ++) {
						var rect:Rectangle = new Rectangle(0, this.bitmap.height - i, this.bitmap.width, i );
						var ct:ColorTransform = new ColorTransform();
						ct.alphaMultiplier = 0xff;
						ct.alphaOffset = 0xff;
						ct.redMultiplier =1;
						ct.greenMultiplier = 1;
						ct.blueMultiplier = 1;
						this.bitmap.bitmapData.colorTransform(rect,ct);
						
					}
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
			startingy = this.y;
			toggle = ENUM_SINK;
		}

	}
	
}
