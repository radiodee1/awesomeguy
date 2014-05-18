package org.davidliebman.flash.awesomeguy {
	import flash.geom.*;
	import flash.display.Bitmap;
	import flash.display.Stage;
	
	public class AGPhysicsGuy extends AGPhysics {

		public override function AGPhysicsGuy(mystage:Stage, mymode:AGMode) {
			super(mystage, mymode);
			// constructor code
		}
		public override function applyGravity(myinvisible:Array, sprite:AGSprite, mydraw:AGDraw) {
			var x:int = sprite.x;
			var y:int = sprite.y;
			var xblock:int = x / 64;
			var yblock:int = y / 64;
			
			
		}
		public function collisionTile(a:Bitmap, x:int, y:int):Boolean {
			var b:AGSprite = new AGSprite(myMode,AGMode.S_BLOCK);
			b.x = x;
			b.y = y;
			return this.collisionSprite(a, b);//false;
		}
		
		public function collisionSprite( a:Bitmap, b:AGSprite ):Boolean {
			
			if (a == null || b == null) return false;
			var arect:Rectangle = a.getBounds(myStage);
			var brect:Rectangle =  new Rectangle(b.x,b.y, 64,64);//b.getBounds(myStage);
			var apt:Point = new Point(a.x, a.y);
			var bpt:Point = new Point(b.x, b.y);
			return a.bitmapData.hitTest(apt,0,b.bitmap.bitmapData,bpt,0);
			
		}

	}
	
}
