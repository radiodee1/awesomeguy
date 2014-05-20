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
			//var x:int = sprite.x;
			//var y:int = sprite.y;
			//var xblock:int = x / 64;
			//var yblock:int = y / 64;
			var mapcheat:int = 4;
			//y += 5;
			var hit_top:Boolean, hit_bottom:Boolean, hit_left:Boolean, hit_right:Boolean , hit_ladder:Boolean;
			
			var hit_platform:Boolean, hit_center:Boolean;
			
			var try_up:Boolean, try_down:Boolean, try_left:Boolean, try_right:Boolean;
			
			//trace(mydraw.rail_bottom.bitmapData.rect, mydraw.rail_bottom.x, mydraw.rail_bottom.y);
			if (myinvisible.length < 1 ) return;
			
			
			
			hit_ladder = false;
			
			hit_center = this.collisionTile(myinvisible, 
											sprite.bitmap, 
											sprite.x /64, 
											(sprite.y /64)+ 1 );
			
			hit_bottom = this.collisionTile(myinvisible, 
											sprite.rail_bottom, 
											sprite.rail_bottom.x /64, 
											sprite.rail_bottom.y/64 );
											
			hit_top = this.collisionTile(myinvisible, 
										 sprite.rail_top, 
										 sprite.rail_top.x /64, 
										 sprite.rail_top.y/64 );
										 
			hit_left = this.collisionTile(myinvisible, 
										  sprite.rail_left, 
										  sprite.rail_left.x /64, 
										  sprite.rail_left.y/64 );
										  
			hit_right = this.collisionTile(myinvisible, 
										   sprite.rail_right, 
										   sprite.rail_right.x /64, 
										   sprite.rail_right.y/64 );
			hit_platform = false;// hit_bottom;							   
			//hit_center = true;
										
			if (yy > 0) try_down = true;
			if (yy < 0) try_up = true;
			if (xx < 0) try_left = true;
			if (xx > 0) try_right = true;
			
			xx = 0;
			yy = 0;
			/*
			if (try_down) {
				if (!hit_bottom) yy = + AGModeGuy.Y_MOVE;
				else if (!hit_top) yy = - AGModeGuy.Y_MOVE;
				if (hit_ladder && !hit_bottom) {
					yy =  AGModeGuy.Y_MOVE;
					//if(!hit_bottom) myGuy.quality_0 = AGModeGuy.GUY_CLIMB;
				}
				if (!hit_ladder && hit_bottom) {
					yy = 0;
					//myGuy.quality_0 = AGModeGuy.GUY_CROUCH;
					
				}
			}
			if (try_up) {
				if (hit_ladder) {
					yy = - AGModeGuy.Y_MOVE;
					//if(!hit_bottom) myGuy.quality_0 = AGModeGuy.GUY_CLIMB;
				}
			}
			*/
			
			////////////////
			//if (this.shoot_count >= 0) {
			//	this.shoot_count --;
			//}
			if (hit_top && !hit_bottom) {
				//this.jump_count = 0;
				if (yy < 0 || yy == 0) yy = AGModeGuy.Y_MOVE;
			}
			if ( hit_bottom && hit_center &&  !hit_top) {
				yy =  -  6;
				trace("-6");
						
			}
			//if (hit_platform && hit_center && hit_bottom && !hit_top) {
			//	yy = - 6;
			//}
			if (!hit_bottom && !hit_center && !hit_ladder ){//&& this.jump_count <= 0) {
				yy = AGModeGuy.Y_MOVE;
				trace(yy);
			}
			
			/////////////////
			/*
			if (yblock +1 >= myinvisible.length || yblock < 0) {
				yy = - AGModeGuy.Y_MOVE;
				//sprite.y -= yy;
				trace("y exit");
				return;
			}
			if (xblock >= myinvisible[0].length || xblock < 0) {
				//sprite.x -= xx;
				xx = - AGModeGuy.X_MOVE;
				trace("x exit");
				return;
			}
			*/
			sprite.x += xx;
			sprite.y += yy;
			
		}
		public function collisionTile(myinvisible:Array, a:Bitmap, x:Number, y:Number):Boolean {
			var mapcheat:int = 4;
			
			if (y >= myinvisible.length || y < 0 || x >= myinvisible[0].length || x < 0) {
				trace("bounds");
				return false;
			}
			if (myinvisible[int(y)][int(x)]  == 0){// AGModeGuy.B_BLOCK) {
				trace("block type");
				return false;
			}
			var arect:Rectangle = a.getBounds(this.myMode.myStage);
			var brect:Rectangle =  new Rectangle(int(x * 64),int(y *64), 64,64);//

			var res:Boolean = arect.intersects(brect);
			trace(res);
			return res;
			
		}
		
		public function collisionSprite( a:Bitmap, b:AGSprite ):Boolean {
			
			return false;
			
		}

	}
	
}
