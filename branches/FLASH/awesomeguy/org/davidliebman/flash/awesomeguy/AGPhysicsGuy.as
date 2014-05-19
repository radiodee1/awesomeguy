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
			
			
			//trace(mydraw.rail_bottom.bitmapData.rect, mydraw.rail_bottom.x, mydraw.rail_bottom.y);
			if (myinvisible.length < 1 ) return;
			
			if (yblock +1 >= myinvisible.length || xblock >= myinvisible[0].length || 
				yblock < 0 || xblock < 0) {
					
				sprite.y -= yy;
				sprite.x -= xx;
				trace("exit");
				return;
			}
			if (this.collisionTile(myinvisible, mydraw.rail_bottom, mydraw.rail_bottom.x /64, mydraw.rail_bottom.y/64 ) ){// && 
				//myinvisible[yblock + 1][xblock] == AGModeGuy.B_BLOCK) {
				//trace(myinvisible[yblock][xblock]);
					
				if (yy > 0) {
					sprite.y -= (yy + 3 );
					trace ("up");
				}
				else if (yy == 0){
					sprite.y -= 4;
				}
				else if (yy < 0 ){// && this.collisionTile(sprite.bitmap, xblock, yblock -1 )) {
					sprite.y += Math.abs(yy);
					trace("stop up");
				}
			}
			else  {
				if (yy == 0) {
					sprite.y += 3;
				}
			} 
			if (this.collisionTile(myinvisible,mydraw.rail_top, mydraw.rail_top.x/64, mydraw.rail_top.y/64 )) {
				if (yy > 0) {
					sprite.y += (yy);
					trace ("down");
				}
				else {
					sprite.y += (Math.abs(yy) + 3);
				}
			}
			
		}
		public function collisionTile(myinvisible:Array, a:Bitmap, x:Number, y:Number):Boolean {
			if (y >= myinvisible.length || y < 0 || x >= myinvisible[0].length || x < 0) {
				trace("bounds");
				return false;
			}
			if (myinvisible[int(y)][int(x)] != AGModeGuy.B_BLOCK) {
				trace("block type");
				return false;
			}
			var arect:Rectangle = a.getBounds(this.myMode.myStage);
			var brect:Rectangle =  new Rectangle(int(x ),int(y ), 64,64);//

			var res:Boolean = arect.intersects(brect);
			trace(res);
			return res;
			
		}
		
		public function collisionSprite( a:Bitmap, b:AGSprite ):Boolean {
			
			return false;
			
		}

	}
	
}
