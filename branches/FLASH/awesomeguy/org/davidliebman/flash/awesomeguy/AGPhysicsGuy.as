package org.davidliebman.flash.awesomeguy {
	import flash.geom.*;
	import flash.display.Bitmap;
	import flash.display.Stage;
	
	public class AGPhysicsGuy extends AGPhysics {

		

		public override function AGPhysicsGuy(mystage:Stage, mymode:AGMode) {
			super(mystage, mymode);
			// constructor code
		}
		public override function applyGravityAndLadders(myinvisible:Array, sprite:AGSprite, mydraw:AGDraw, xx:int = 0, yy:int = 0) {
			var xblock:int = 0;
			var yblock:int = 0;
			var mapcheat:int = 0;
			//y += 5;
			var hit_top:Boolean, hit_bottom:Boolean, hit_left:Boolean, hit_right:Boolean , hit_ladder:Boolean;
			
			var hit_platform:Boolean, hit_center:Boolean;
			
			var try_up:Boolean, try_down:Boolean, try_left:Boolean, try_right:Boolean;
			
			if (myinvisible.length < 1 ) return;
			
			
			hit_ladder = this.collisionTile(myinvisible, sprite.x/ 64, sprite.y/ 64,
											sprite.bitmap, 
											sprite.bitmap.x , 
											(sprite.bitmap.y ), AGModeGuy.B_LADDER,( "ladder" ));
			
			
			hit_center = this.collisionTile(myinvisible,  sprite.x/ 64, sprite.y/ 64 +1 ,
											sprite.bitmap, 
											sprite.bitmap.x , 
											(sprite.bitmap.y ), AGModeGuy.B_BLOCK,( "center" ));
			
			
			hit_bottom = this.collisionTile(myinvisible, 
										(sprite.x //+ this.myMode.scrollBGX
										 )/ 64, 
										(sprite.y //+ this.myMode.scrollBGY
										 )/ 64 +1 ,
											sprite.rail_bottom, 
											sprite.rail_bottom.x , 
											(sprite.rail_bottom.y ) ,AGModeGuy.B_BLOCK, "bottom");
											
			hit_top = this.collisionTile(myinvisible, sprite.x/ 64, sprite.y/ 64 - 1,
										 sprite.rail_top, 
										 sprite.rail_top.x , 
										 (sprite.rail_top.y )  , AGModeGuy.B_BLOCK, "top");
										 
			hit_left = this.collisionTile(myinvisible, sprite.x/ 64 -1, sprite.y/ 64,
										  sprite.rail_left, 
										  (sprite.rail_left.x ) , 
										  sprite.rail_left.y , AGModeGuy.B_BLOCK, "left");
										  
			hit_right = this.collisionTile(myinvisible, sprite.x/ 64 + 1, sprite.y/ 64,
										   sprite.rail_right, 
										   sprite.rail_right.x , 
										   sprite.rail_right.y  , AGModeGuy.B_BLOCK, "right");
			hit_platform = false;// hit_bottom;							   
			//hit_center = true;
										
			if (yy > 0) try_down = true;
			else try_down = false;
			if (yy < 0) try_up = true;
			else try_up = false;
			if (xx < 0) try_left = true;
			else try_left = false;
			if (xx > 0) try_right = true;
			else try_right = false;
			
			trace("input:", try_up, try_down, try_left, try_right);

			xblock = 0;
			yblock = 0;
			
			if ( try_left  ) {
				if (!hit_left) xblock = (- AGModeGuy.X_MOVE);
				else if (!hit_right) xblock = int (AGModeGuy.X_MOVE / 1);
				//myGuy.facingRight = false;
				sprite.facingRight = false;
				
			}
			if ( try_right ) {
				if (!hit_right) xblock = + AGModeGuy.X_MOVE;
				else if (!hit_left) xblock = - int (AGModeGuy.X_MOVE / 1);
				//myGuy.facingRight = true;
				sprite.facingRight = true;
				
			}
			
			if (try_down) {
				if (!hit_bottom) yblock = + AGModeGuy.Y_MOVE;
				else if (!hit_top) yblock = - AGModeGuy.Y_MOVE;
				if (hit_ladder && !hit_bottom) {
					yblock =  AGModeGuy.Y_MOVE;
					//if(!hit_bottom) myGuy.quality_0 = AGModeGuy.GUY_CLIMB;
				}
				if (!hit_ladder && hit_bottom) {
					yblock = 0;
					//myGuy.quality_0 = AGModeGuy.GUY_CROUCH;
					
				}
			}
			if (try_up) {
				if (hit_ladder) {
					yblock = - AGModeGuy.Y_MOVE;
					//if(!hit_bottom) myGuy.quality_0 = AGModeGuy.GUY_CLIMB;
				}
			}
			
			
			//////////////// physics here!! /////////////////////
			
			if (!hit_ladder && try_down && hit_bottom) {
				yblock = 0;
			}
			
			if (hit_top && !hit_bottom) {
				
				if (yblock < 0 || yblock == 0) yblock = AGModeGuy.Y_MOVE/2;
			}
			if ( hit_bottom && hit_center &&  !hit_top) {
				yblock =  -6;//(-  AGModeGuy.Y_MOVE);
				trace("-6",- AGModeGuy.Y_MOVE);
						
			}
			
			if (!hit_bottom && !hit_ladder && !hit_center && try_down ){//&& this.jump_count <= 0) {
				yblock = AGModeGuy.Y_MOVE;
				xblock = 0;
				trace(yblock , "down");
			}
			
			/////////////////
			sprite.x += xblock;
			sprite.y += yblock;
			sprite.bitmap.x += xblock;
			sprite.bitmap.y += yblock;
			
		}
		public function collisionTile(myinvisible:Array,coordx:int, coordy:int, a:Bitmap, xx:int, yy:int, blocktype:int = 0, message:String="NONE"):Boolean {
			var mapcheat:int = 0;
			var scrollx:int = this.myMode.scrollBGX;
			var scrolly:int = this.myMode.scrollBGY;
			trace(message,"coords", coordx, coordy);
			if (coordy >= myinvisible.length || coordy < 0 || coordx >= myinvisible[0].length || coordx < 0) {
				trace(message,"bounds false");
				return false;
			}
			var k:int = myinvisible[coordy][coordx];
			if (k == 0 || k + mapcheat != blocktype){
				trace(message,"block-type false", blocktype ,k + mapcheat);
				return false;
			}
			var arect:Rectangle = a.getBounds(this.myMode.myStage);
			var brect:Rectangle =  new Rectangle((xx ),(yy), 64,64);//

			trace(message,arect,brect);
			var res:Boolean = arect.intersects(brect);
			
			trace(message,res);
			return res;
			
		}
		
		

	}
	
}
