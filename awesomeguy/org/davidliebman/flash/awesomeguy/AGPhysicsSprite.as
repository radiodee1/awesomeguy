package org.davidliebman.flash.awesomeguy {
	import flash.geom.*;
	import flash.display.Bitmap;
	import flash.display.Stage;
	
	public class AGPhysicsSprite extends AGPhysics {

		

		public override function AGPhysicsSprite(mystage:Stage, mymode:AGMode) {
			super(mystage, mymode);
			// constructor code
		}
		public override function applyGravityAndLadders(myinvisible:Array, asprite:AGSprite, xx:int = 0, yy:int = 0) {
			var xblock:int = 0;
			var yblock:int = 0;
			var mapcheat:int = 0;
			//y += 5;
			var hit_top:Boolean, 
				hit_bottom:Boolean, 
				hit_left:Boolean, 
				hit_right:Boolean , 
				hit_ladder:Boolean,
				hit_ladder_low:Boolean,
				hit_ladder_right:Boolean,
				hit_ladder_left:Boolean;
			
			var hit_platform:Boolean, 
				hit_center:Boolean,
				hit_bottom_low:Boolean;
				
			var hit_ladder_core:Boolean;
			
			var try_up:Boolean, 
				try_down:Boolean, 
				try_left:Boolean, 
				try_right:Boolean;
			
			if (myinvisible.length < 1 || asprite.bitmap == null) return;
			
			
			hit_ladder = this.collisionTile(myinvisible, asprite.x/ 64, (asprite.y/ 64 ) ,//+1
											asprite.bitmap, 
											asprite.bitmap.x , 
											(asprite.bitmap.y  ),//+ 64), 
											AGModeGuy.B_LADDER, "ladder" );//, 64, 128);
			
			
			
			hit_center = this.collisionTile(myinvisible,  asprite.x/ 64, asprite.y/ 64,// +1 ,
											asprite.bitmap, 
											asprite.bitmap.x , 
											(asprite.bitmap.y ), AGModeGuy.B_BLOCK,( "center" ));
			
			hit_ladder_core = this.collisionTile(myinvisible,  asprite.x/ 64, asprite.y/ 64,// +1 ,
											asprite.rail_center_core, 
											asprite.rail_center_core.x , 
											(asprite.rail_center_core.y ), AGModeGuy.B_LADDER,( "center" ));
			
			
			
			hit_bottom = this.collisionTile(myinvisible, 
										(asprite.x //+ this.myMode.scrollBGX
										 )/ 64, 
										(asprite.y //+ this.myMode.scrollBGY
										 )/ 64 +1 ,
											asprite.rail_bottom, 
											asprite.rail_bottom.x , 
											(asprite.rail_bottom.y ) ,AGModeGuy.B_BLOCK, "bottom");
			
			hit_bottom_low = this.collisionTile(myinvisible, 
										(asprite.x //+ this.myMode.scrollBGX
										 )/ 64, 
										(asprite.y //+ this.myMode.scrollBGY
										 )/ 64 +1 ,
											asprite.rail_low_bottom, 
											asprite.rail_low_bottom.x , 
											(asprite.rail_low_bottom.y ) ,AGModeGuy.B_BLOCK, "bottom");
			
			hit_ladder_low = this.collisionTile(myinvisible, 
										(asprite.x //+ this.myMode.scrollBGX
										 )/ 64, 
										(asprite.y //+ this.myMode.scrollBGY
										 )/ 64 +1 ,
											asprite.rail_bottom, 
											asprite.rail_bottom.x , 
											(asprite.rail_bottom.y ) ,AGModeGuy.B_LADDER, "ladder-bottom");
											
			hit_top = this.collisionTile(myinvisible, asprite.x/ 64, asprite.y/ 64 - 1,
										 asprite.rail_top, 
										 asprite.rail_top.x , 
										 (asprite.rail_top.y )  , AGModeGuy.B_BLOCK, "top");
										 
			hit_left = this.collisionTile(myinvisible, asprite.x/ 64 -1, asprite.y/ 64,
										  asprite.rail_left, 
										  (asprite.rail_left.x ) , 
										  asprite.rail_left.y , AGModeGuy.B_BLOCK, "left");
										  
			hit_right = this.collisionTile(myinvisible, asprite.x/ 64 + 1, asprite.y/ 64,
										   asprite.rail_right, 
										   asprite.rail_right.x , 
										   asprite.rail_right.y  , AGModeGuy.B_BLOCK, "right");
										   
			hit_ladder_left = this.collisionTile(myinvisible, asprite.x/ 64 -1, asprite.y/ 64,
										  asprite.rail_left, 
										  (asprite.rail_left.x ) , 
										  asprite.rail_left.y , AGModeGuy.B_LADDER, "left");
										  
			hit_ladder_right = this.collisionTile(myinvisible, asprite.x/ 64 + 1, asprite.y/ 64,
										   asprite.rail_right, 
										   asprite.rail_right.x , 
										   asprite.rail_right.y  , AGModeGuy.B_LADDER, "right");
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
			
			hit_ladder = hit_ladder_core;
			hit_bottom = hit_bottom_low;
			
			if (hit_ladder_low) hit_bottom = true;

			xblock = 0;
			yblock = 0;
			var q:int = 2;
			
			if ( try_left  ) {
				if (!hit_left) xblock = int (- AGModeGuy.X_MOVE/q);
				//else if (!hit_right) xblock = int (AGModeGuy.X_MOVE / q);
				//myGuy.facingRight = false;
				asprite.facingRight = false;
				
			}
			if ( try_right ) {
				if (!hit_right) xblock = int(+ AGModeGuy.X_MOVE/q);
				//else if (!hit_left) xblock = - int (AGModeGuy.X_MOVE / q);
				//myGuy.facingRight = true;
				asprite.facingRight = true;
				
			}
			
			if (try_down) {
				if (!hit_bottom) yblock = + int(AGModeGuy.Y_MOVE/q);
				else if (!hit_top) yblock = int(- AGModeGuy.Y_MOVE/q);
				if (hit_ladder && !hit_bottom) {
					yblock =  int(AGModeGuy.Y_MOVE/q);
					//if(!hit_bottom) myGuy.quality_0 = AGModeGuy.GUY_CLIMB;
				}
				if (!hit_ladder && hit_bottom) {
					yblock = 0;
					//myGuy.quality_0 = AGModeGuy.GUY_CROUCH;
					
				}
			}
			if (try_up) {
				if (hit_ladder_core || true ){//|| hit_ladder_low ) {
					yblock =  -   AGModeGuy.Y_MOVE/q ;//*2  ;
					trace(yblock, "yblock");
					//xblock = 0;
					//if(!hit_bottom) myGuy.quality_0 = AGModeGuy.GUY_CLIMB;
				}
			}
			
			
			//////////////// physics here!! /////////////////////
			
			if (!hit_ladder && try_down && hit_bottom) {
				yblock = 0;
			}
			
			if (hit_top && !hit_bottom && !hit_ladder) {
				yblock = int( AGModeGuy.Y_MOVE/(q*2));
			}
			if ( hit_bottom && hit_center &&  !hit_top && !hit_ladder) {
				yblock =  -6;//(-  AGModeGuy.Y_MOVE);
				
				//trace("-6",- AGModeGuy.Y_MOVE);
			}
			
			if (!hit_bottom && !hit_ladder && !hit_center ){// && !hit_ladder_low && !try_up){// 
				yblock = int(AGModeGuy.Y_MOVE/q);
				xblock = 0;
				//trace(yblock , "down");
			}
			
			if (!hit_bottom && !hit_ladder && !hit_center && !try_up) {
				yblock = int(AGModeGuy.Y_MOVE/q);
				xblock = 0;
			}
			/*
			if (try_up) {
				if (hit_ladder_core || true ){// || hit_ladder_low ) {
					yblock = int ( -   AGModeGuy.Y_MOVE/q) ;//*2  ;
					xblock = 0;
					//if(!hit_bottom) myGuy.quality_0 = AGModeGuy.GUY_CLIMB;
				}
			}
			*/
			/////////////////
			//trace("physics", xblock, yblock);
			
			asprite.x += xblock;
			asprite.y += yblock;
			asprite.bitmap.x += xblock;
			asprite.bitmap.y += yblock;
			
		}
		public function collisionTile(myinvisible:Array,coordx:int, coordy:int, a:Bitmap, xx:int, yy:int, blocktype:int = 0, message:String="NONE", size:int = 64, sizey:int = 64):Boolean {
			var mapcheat:int = 0;
			var scrollx:int = this.myMode.scrollBGX;
			var scrolly:int = this.myMode.scrollBGY;
			
			if (a == null) {
				//trace("still no bitmap");
				return false;
			}
			//trace(message,"coords", coordx, coordy);
			if (coordy >= myinvisible.length || coordy < 0 || coordx >= myinvisible[0].length || coordx < 0) {
				//trace(message,"bounds false");
				return false;
			}
			var k:int = myinvisible[coordy][coordx];
			if (k == 0 || k + mapcheat != blocktype){
				//trace(message,"block-type false", blocktype ,k + mapcheat);
				return false;
			}
			var arect:Rectangle = a.getBounds(this.myMode.myStage);
			var brect:Rectangle =  new Rectangle((xx ),(yy), size,sizey);//

			//trace(message,arect,brect);
			var res:Boolean = arect.intersects(brect);
			
			//trace(message,res);
			return res;
			
		}
		
		

	}
	
}
