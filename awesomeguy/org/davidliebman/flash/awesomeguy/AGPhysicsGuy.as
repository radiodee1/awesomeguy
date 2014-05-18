package org.davidliebman.flash.awesomeguy {
	import flash.geom.*;
	import flash.display.Bitmap;
	import flash.display.Stage;
	
	public class AGPhysicsGuy extends AGPhysics {

		public override function AGPhysicsGuy(mystage:Stage, mymode:AGMode) {
			super(mystage, mymode);
			// constructor code
		}
		public override function applyGravity(myinvisible:Array, sprite:AGSprite, mydraw:AGDraw, xx:int = 0, yy:int = 0) {
			var x:int = sprite.x;
			var y:int = sprite.y;
			var xblock:int = x / 64;
			var yblock:int = y / 64;
			//y += 5;
			
			
			//trace(mydraw.rail_bottom.bitmapData.rect);
			
			if (yblock +1 >= myinvisible.length || xblock >= myinvisible[0].length || 
				yblock < 0 || xblock < 0) {
				trace("exit");
				return;
			}
			if (this.collisionTile(sprite.bitmap, xblock, yblock +1) ){// && 
				//myinvisible[yblock + 1][xblock] == AGModeGuy.B_BLOCK) {
				trace(myinvisible[yblock][xblock]);
					
				if (yy > 0) {
					sprite.y -= (yy + 3 );
					trace ("up");
				}
				else if (yy == 0){
					sprite.y -= 3;
				}
				else if (yy < 0 ){// && this.collisionTile(sprite.bitmap, xblock, yblock -1 )) {
					sprite.y += Math.abs(yy);
					trace("stop up");
				}
			} else if (this.collisionTile(sprite.bitmap, xblock, yblock -1 )) {
				if (yy > 0) {
					sprite.y += (yy);
					trace ("down");
				}
				else {
					sprite.y += (Math.abs(yy) + 3);
				}
			}
			
		}
		public function collisionTile(a:Bitmap, x:Number, y:Number):Boolean {
			var b:AGSprite = new AGSpriteVarious(myMode,AGMode.S_BLOCK);
			b.x =int( x *64);
			b.y = int (y *64);
			return this.collisionSprite(a, b);//false;
		}
		
		public function collisionSprite( a:Bitmap, b:AGSprite ):Boolean {
			
			if (a == null || b == null ) return false;
			trace ("something");
			var arect:Rectangle = a.getBounds(this.myMode.myStage);
			trace (arect);
			var brect:Rectangle =  new Rectangle(int(b.x ),int(b.y ), 64,64);//b.getBounds(myStage);
			var apt:Point = new Point(a.x, a.y);
			var bpt:Point = new Point(b.x, b.y);
			var res:Boolean = arect.intersects(brect);
			trace(res);
			return res;//arect.intersects(brect);//a.bitmapData.hitTest(apt,0,b.bitmap.bitmapData,bpt,0);
			
		}

	}
	
}
