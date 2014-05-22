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
			var xblock:int = 0;//x / 64;
			var yblock:int = 0;//y / 64;
			var mapcheat:int = 0;
			//y += 5;
			var hit_top:Boolean, hit_bottom:Boolean, hit_left:Boolean, hit_right:Boolean , hit_ladder:Boolean;
			
			var hit_platform:Boolean, hit_center:Boolean;
			
			var try_up:Boolean, try_down:Boolean, try_left:Boolean, try_right:Boolean;
			
			if (myinvisible.length < 1 ) return;
			
			
			
			hit_ladder = false;
			
			hit_center = this.collisionTile(myinvisible, 
											sprite.bitmap, 
											sprite.x /64, 
											(sprite.y /64), AGModeGuy.B_BLOCK,( "center" + AGModeGuy.B_BLOCK));
			
			trace("bottom trace", sprite.rail_bottom.getBounds(mydraw.myStage));
			
			hit_bottom = this.collisionTile(myinvisible, 
											sprite.rail_bottom, 
											sprite.rail_bottom.x /64, 
											sprite.rail_bottom.y/64 ,AGModeGuy.B_BLOCK, "bottom");
											
			hit_top = this.collisionTile(myinvisible, 
										 sprite.rail_top, 
										 sprite.rail_top.x /64, 
										 sprite.rail_top.y/64 , AGModeGuy.B_BLOCK, "top");
										 
			hit_left = this.collisionTile(myinvisible, 
										  sprite.rail_left, 
										  sprite.rail_left.x /64, 
										  sprite.rail_left.y/64 , 0, "left");
										  
			hit_right = this.collisionTile(myinvisible, 
										   sprite.rail_right, 
										   sprite.rail_right.x /64, 
										   sprite.rail_right.y/64 , 0, "right");
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
				if (yblock < 0 || yblock == 0) yy = AGModeGuy.Y_MOVE/2;
			}
			else if ( hit_bottom && hit_center &&  !hit_top) {
				yblock =  -6;//(-  AGModeGuy.Y_MOVE);
				trace("-6", AGModeGuy.Y_MOVE);
						
			}
			//if (hit_platform && hit_center && hit_bottom && !hit_top) {
			//	yy = - 6;
			//}
			else if (!hit_bottom && !hit_ladder && !hit_center  ){//&& this.jump_count <= 0) {
				yblock = AGModeGuy.Y_MOVE;
				xblock = 0;
				trace(yblock , "down");
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
			sprite.bitmap.x += xblock;
			sprite.bitmap.y += yblock;
			
		}
		public function collisionTile(myinvisible:Array, a:Bitmap, xx:int, yy:int, blocktype:int = 0, message:String="NONE"):Boolean {
			var mapcheat:int = 0;
			
			if (yy >= myinvisible.length || yy < 0 || xx >= myinvisible[0].length || xx < 0) {
				trace(message,"bounds false");
				return false;
			}
			var k:int = myinvisible[yy][xx];
			if (k == 0 || k + mapcheat != blocktype){//0){// AGModeGuy.B_BLOCK) {
				trace(message,"block-type false", blocktype ,k + mapcheat);
				return false;
			}
			var arect:Rectangle = a.getBounds(this.myMode.myStage);
			var brect:Rectangle =  new Rectangle(int(xx * 64),int(yy *64), 64,64);//

			trace(message,brect);
			var res:Boolean = arect.intersects(brect);
			
			trace(message,res);
			return res;
			
		}
		
		

	}
	
}
