package org.davidliebman.flash.awesomeguy {
	
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
		}

	}
	
}
