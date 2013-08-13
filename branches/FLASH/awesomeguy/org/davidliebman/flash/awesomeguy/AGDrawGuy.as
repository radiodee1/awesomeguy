package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.Stage;
	
	public class AGDrawGuy extends AGDraw{

		var cheatx_climb:int = 0;
		var cheaty_climb:int = 0;
		var cheatx_punch:int = 0;
		var cheaty_punch:int = 0;
		var cheatx_step:int = 8;
		var cheaty_step:int = 0;

		public function AGDrawGuy(mode:AGMode, myres:Array, mystage:Stage, mybackground:Bitmap) {
			// constructor code
			
			super(mode,myres,mystage,mybackground);
		}

		public override function drawBasicSprite(sprite:AGSprite, kind:int):void {
			drawRes(sprite, sprite.x, sprite.y, sprite.facingRight, kind, sprite.animate);
		}

		public override function drawRes(sprite:AGSprite, xx:int, yy:int, facingRight:Boolean, kind:int, animate:int):void {
			// all drawing goes here!!
			
			var add:int, add_radar:int, z:int;
			var scrollx:int = myMode.scrollBGX;
			var scrolly:int = myMode.scrollBGY;
			var anim_speed:int = 5;
			var guyx:int, guyy:int;
			
			switch(kind) {
				case AGMode.D_GUY:
					
					switch(sprite.quality_0) {
						case AGModeGuy.GUY_CLIMB:
							if (sprite.animate % 2 == 1) {
								sprite.bitmap = myRes[AGResources.NAME_G_CLIMB1_PNG];
							}
							else {
								sprite.bitmap = myRes[AGResources.NAME_G_CLIMB2_PNG];
							}
						
						break;
						case AGModeGuy.GUY_PUNCH:
							if (sprite.facingRight) {
								if (sprite.animate %2 == 1) {
									sprite.bitmap = myRes[AGResources.NAME_G_PUNCHR1_PNG];
								}
								else {
									sprite.bitmap = myRes[AGResources.NAME_G_PUNCHR2_PNG];
								}
							}
							else {
								if(sprite.animate %2 == 1) {
									sprite.bitmap = myRes[AGResources.NAME_G_PUNCHL1_PNG];
								}
								else {
									sprite.bitmap = myRes[AGResources.NAME_G_PUNCHL2_PNG];
								}
							}
						break;
						case AGModeGuy.GUY_STEP:
							if (sprite.facingRight) {
								if (sprite.animate %2 == 1 ) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR1_PNG];
									guyx = this.cheatx_step;
								}
								else {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPR2_PNG];
								}
							}
							else {
								if (sprite.animate %2 == 1) {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL1_PNG];
									guyx =  this.cheatx_step;
								}
								else {
									sprite.bitmap = myRes[AGResources.NAME_G_STEPL2_PNG];
								}
							}
						break;
						case AGModeGuy.GUY_STILL:
						break;
					}
					
					
					sprite.bitmap.x =  xx - scrollx + guyx;
					sprite.bitmap.y = yy - scrolly + guyy;
					if (sprite.active == true) myStage.addChild(sprite.bitmap);
					myMode.flyersprite = sprite.bitmap;
					
				break;
			}
			
		}

	}
	
}
