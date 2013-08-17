﻿package org.davidliebman.flash.awesomeguy {
	
	public class AGSpriteXMonster extends AGSpriteMonster {

		public function AGSpriteXMonster(mymode:AGMode, kind:int) {
			super(mymode,kind);
			// constructor code
		}

		public override function updateSprite():void {
			var i:int;
			var xx:int,yy:int,z:int;
			var move:int = 3 *2;//3
			var markerTest:Boolean = false;
			var hide:Boolean = true;
			var show:Boolean = false;
			var visibility:Boolean = false;
			//int index_num = 0;
			
			
			//for each monster...
			if( true) {
				
					//if (i == 5) return;
					if (this.sprite_type == AGMode.S_XMONSTER) {
						markerTest = false;//FALSE; 
						
						if (this.active ==true  ) {
							xx = Math.floor(int ( this.x / 64));
							yy = Math.floor(int ( this.y / 64)) ;
							
							
							// Must move and stop monsters when they hit bricks or
							// markers or the end of the screen/room/level.
							//if (xx < 0 || yy < 0 ) return;
							//if (xx > myHoriz || yy > myVert) return;
							
							if(this.facingRight == true ) {
			
								this.x = this.x + move;
								// marker test
								if (xx + 3 < myMode.myHoriz && yy + 2 < myMode.myVert || true ) {
									
									if(myMode.myInvisible[yy][xx+2] + myMode.mapcheat == AGModeFlyer.B_BLOCK  ) markerTest = true;//TRUE;
									if(myMode.myInvisible[yy][xx+2] + myMode.mapcheat == AGModeFlyer.B_MARKER ) markerTest = true;// TRUE;
									if(myMode.myInvisible[yy+1][xx+2]  == 0) markerTest = true;//TRUE;
								}
								// turn monster
								if (this.x > myMode.myHoriz * 64  - 32 || markerTest == true ) {
			
									this.facingRight=false;//FALSE;
								}
							}
							else {
			
								this.x = this.x - move;
								// marker test
								if (xx -1 > 0 && yy + 2 < myMode.myVert || true) {
									if(myMode.myInvisible[yy][xx] + myMode.mapcheat == AGModeFlyer.B_BLOCK) markerTest = true;//TRUE;
									if(myMode.myInvisible[yy][xx] + myMode.mapcheat == AGModeFlyer.B_MARKER) markerTest =true;// TRUE;
									if(myMode.myInvisible[yy+1][xx-1] == 0) markerTest = true;//TRUE;
								}
								// turn monster
								if (this.x < 0 || markerTest == true ) {
			
									this.facingRight= true;//TRUE;
								}
							}
			
							//Only show monsters that are on the screen properly
			
			
							//default is to show monster
							visibility = show;
							//hide monster if...
							if(this.x > myMode.scrollBGX + 64 * 64 + 32 ) {
								visibility = hide;
							}
							if (this.x < myMode.scrollBGX - 32) {
								visibility = hide;
							}
							if (this.y > myMode.scrollBGY + 48 * 64 + 32) {
								visibility = hide;
							}
							if ( this.y < myMode.scrollBGY  - 32) {
								visibility = hide;
							}
						}
						//visibility = show;
						//swap monsters
						if (this.visible && visibility == show) this.visible = true;// TRUE;
						
						//drawBasicSprite(i, D_GATOR);
					
						//myDraw.drawBasicSprite(mySprite[i], D_GATOR);
					}
					
				
		
			}
			return;
		}

	}
	
}
