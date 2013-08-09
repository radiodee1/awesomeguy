package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteCloud extends AGSprite{

		public function AGSpriteCloud(myclass:AGMode, kind:int) {
			super(myclass,kind);
			
			
		}

		public override function updateSprite():void {
				var FALSE:Boolean = false;
				var TRUE:Boolean = true;
				var i:int;
			    var xx:int ,yy:int ;
			    var width:int = 5;
			    var cheat:int = 0;// - 5
			    var markerTest:Boolean = FALSE;
			
			    var visibility:Boolean = FALSE;
			    var x_right:int, x_left:int, y_right:int, y_left:int;
			    var map_objects:Array = myMode.myInvisible;
				var level_w:int = myMode.myHoriz;
			
				markerTest = FALSE; 
			
				  
				  yy = this.y / 16;
				  /* Must move and stop platforms when they hit bricks or
				   * markers or the end of the screen/room/level.
				   */
				  if(this.facingRight == TRUE) {
					this.x ++;
					xx = this.x / 16;
					markerTest = FALSE; 
					// marker test
					y_right = yy;
					x_right = xx + width + cheat ;
					if(map_objects[y_right][x_right] + myMode.mapcheat == AGModeFlyer.B_BLOCK ||
							(xx + width > level_w &&
							map_objects[y_right][x_right - level_w]  + myMode.mapcheat == AGModeFlyer.B_BLOCK)) markerTest = TRUE;
					if(map_objects[y_right][x_right]  + myMode.mapcheat == AGModeFlyer.B_MARKER ||
							(xx + width > level_w &&
							map_objects[y_right][x_right - level_w]  + myMode.mapcheat== AGModeFlyer.B_MARKER)) markerTest = TRUE;
			
					// turn platform
					if ( markerTest == TRUE) {
					  this.facingRight = FALSE;
					}
					else if (this.x > level_w * 16 ) {
						this.x = 0;
					}
				  }
				  else {
					this.x --;
					xx = this.x / 16;
					markerTest = FALSE; 
					// marker test
					y_left = yy;
					x_left = xx + cheat ;
					if(map_objects[y_left ][x_left] + myMode.mapcheat == AGModeFlyer.B_BLOCK) markerTest = TRUE;
					if(map_objects[y_left ][x_left] + myMode.mapcheat == AGModeFlyer.B_MARKER) markerTest = TRUE;
			
					// turn platform
					if (markerTest == TRUE) {
					  this.facingRight = TRUE;
					}
					else if (this.x <= 0 ) {
						this.x = (level_w * 16)  - 1;
					}
				  } 
				
			  return;
		}

	}
	
}
