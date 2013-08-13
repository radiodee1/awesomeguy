package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.Stage;
	
	public class AGDrawGuy extends AGDraw{

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
			
			switch(kind) {
				case AGMode.D_GUY:
					//var guysprite:AGSpriteGuy = AGSpriteGuy(sprite);
					sprite.bitmap = myRes[AGResources.NAME_G_STEPR1_PNG];
					sprite.bitmap.x =  xx - scrollx;
					sprite.bitmap.y = yy - scrolly;
					if (sprite.active == true) myStage.addChild(sprite.bitmap);
					myMode.flyersprite = sprite.bitmap;
					
				break;
			}
			
		}

	}
	
}
