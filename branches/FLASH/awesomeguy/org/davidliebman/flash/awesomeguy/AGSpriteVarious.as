package org.davidliebman.flash.awesomeguy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class AGSpriteVarious extends AGSprite {

		var goingUp:Boolean = false;

		public function AGSpriteVarious(mymode:AGMode, kind:int) {
			super(mymode, kind);
			// constructor code
		}

		public override  function updateSprite():void {
			switch (this.sprite_type) {
				case AGMode.S_NONE:
				break;
				
				case AGMode.S_GOAL:
					this.bitmap = new Bitmap(new BitmapData(TILE_WIDTH, TILE_HEIGHT,true, 0x00000000));
					
				break;
				case AGMode.S_KEY:
					this.bitmap = myMode.oldCutTile(myMode.myRes[AGResources.NAME_TILES1_PNG],
													AGModeGuy.B_KEY,AGMode.TILE_BOT, 64,64);
				break;
				case AGMode.S_GUN:
					this.bitmap = myMode.oldCutTile(myMode.myRes[AGResources.NAME_TILES1_PNG],
													AGModeGuy.B_GUN,AGMode.TILE_BOT, 64,64);
				break;
				case AGMode.S_XGOAL:
					this.bitmap = myMode.oldCutTile(myMode.myRes[AGResources.NAME_TILES1_PNG],
													AGModeGuy.B_GOAL,AGMode.TILE_BOT, 64,64);
				break;
				
				case AGMode.S_EXIT:
				case AGMode.S_EXIT_KEYLESS:
				case AGMode.S_CONNECT_MAZE:
				case AGMode.S_CONNECT_MAZE_KEYLESS:
				case AGMode.S_DOOR_SPRITE:
					var bits:BitmapData = new BitmapData(64,64*2,false,0x00555555);
					this.bitmap = new Bitmap(bits);

				break;
				
				case AGMode.S_ASTROGATE:
					this.bitmap = myMode.myRes[AGResources.NAME_ASTROGATE_PNG];
				break;
				case AGMode.S_PLATFORM:
					updatePlatform();
				break;
				case AGMode.S_PLUNGER:
					this.updatePlunger();
				break;
				
			}
		}

		public function updatePlatform():void {
			
			
			this.bitmap = new Bitmap( 
									myMode.myRes[AGResources.NAME_PLATFORM_PNG].bitmapData.clone());
			
		
			var i:int;
			var xx:int,yy:int,z:int;
			var move:int = 3 *2;//3
			var markerTest:Boolean = false;
			var hide:Boolean = true;
			var show:Boolean = false;
			var visibility:Boolean = false;
			//int index_num = 0;
			var vert:int = 64;
			var horiz:int = 64;
			var width:int = 2;
			
			
			
			//for each monster...
			if( true) {
				
					//if (i == 5) return;
					if ( true) {
						markerTest = false;//FALSE; 
						
						if (this.active ==true  ) {
							xx = Math.floor(int ( this.x / horiz));
							yy = Math.floor(int ( this.y / vert)) ;
							
							
							// Must move and stop monsters when they hit bricks or
							// markers or the end of the screen/room/level.
							//if (xx < 0 || yy < 0 ) return;
							//if (xx > myHoriz || yy > myVert) return;
							
							if(this.facingRight == true ) {
			
								this.x = this.x + move;
								this.quality_0 = move;
								
								// marker test
								if (xx + 3 < myMode.myHoriz && yy + 2 < myMode.myVert || true ) {
									
									if(myMode.myInvisible[yy][xx+width] + myMode.mapcheat == AGModeGuy.B_BLOCK  ) markerTest = true;//TRUE;
									if(myMode.myInvisible[yy][xx+width] + myMode.mapcheat == AGModeGuy.B_MARKER ) markerTest = true;// TRUE;
									//if(myMode.myInvisible[yy+1][xx+width]  == 0) markerTest = true;//TRUE;
								}
								// turn monster
								if (this.x > myMode.myHoriz * horiz  - (horiz * 2) || markerTest == true ) {
			
									this.facingRight=false;//FALSE;
								}
							}
							else {
			
								this.x = this.x - move;
								this.quality_0 = - move;
								// marker test
								if (xx -1 > 0 && yy + 2 < myMode.myVert || true) {
									if(myMode.myInvisible[yy][xx] + myMode.mapcheat == AGModeGuy.B_BLOCK) markerTest = true;//TRUE;
									if(myMode.myInvisible[yy][xx] + myMode.mapcheat == AGModeGuy.B_MARKER) markerTest =true;// TRUE;
									//if(myMode.myInvisible[yy+1][xx-1] == 0) markerTest = true;//TRUE;
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
							if(this.x > myMode.scrollBGX + 64 * horiz + 32 ) {
								visibility = hide;
							}
							if (this.x < myMode.scrollBGX - 32) {
								visibility = hide;
							}
							if (this.y > myMode.scrollBGY + 48 * vert + 32) {
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
			myMode.drawRadarPing(myMode.radar, 
								 myMode.radarscreen, 
								 this.x, this.y, 
								 AGMode.PING_OTHER, 
								 0xff0000ff);
			
			return;
		
		}
		
		public function updatePlunger():void {
			
			
			this.bitmap = new Bitmap( 
									myMode.myRes[AGResources.NAME_PLATFORM_PNG].bitmapData.clone());
			
		
			var i:int;
			var xx:int,yy:int,z:int;
			var move:int = 3 *2;//3
			var markerTest:Boolean = false;
			var hide:Boolean = true;
			var show:Boolean = false;
			var visibility:Boolean = false;
			//int index_num = 0;
			var vert:int = 64;
			var horiz:int = 64;
			var width:int = 2;
			var height:int = 1;
			
			
			//for each monster...
			if( true) {
				
					//if (i == 5) return;
					if ( !AGModeGuy(this.myMode).animate_only_death) {
						markerTest = false;//FALSE; 
						
						if (this.active ==true  ) {
							xx = Math.floor(int ( this.x / horiz));
							yy = Math.floor(int ( this.y / vert)) ;
							
							
							if(this.goingUp != true ) {
			
								this.y = this.y + move;
								this.quality_0 = move;
								
								// marker test
								if (xx + 3 < myMode.myHoriz && yy + 2 < myMode.myVert || true ) {
									
									if(myMode.myInvisible[yy + height][xx] + myMode.mapcheat == AGModeGuy.B_BLOCK  ) markerTest = true;//TRUE;
									if(myMode.myInvisible[yy + height][xx] + myMode.mapcheat == AGModeGuy.B_PLUNGER_MARKER ) markerTest = true;// TRUE;
									//if(myMode.myInvisible[yy+1][xx+width]  == 0) markerTest = true;//TRUE;
								}
								// turn monster
								if (this.y > myMode.myVert * vert  - (vert * 2) || markerTest == true ) {
			
									this.goingUp=true;
								}
							}
							else {
			
								this.y = this.y - move;
								this.quality_0 = - move;
								// marker test
								if (xx -1 > 0 && yy + 2 < myMode.myVert || true) {
									if(myMode.myInvisible[yy][xx] + myMode.mapcheat == AGModeGuy.B_BLOCK) markerTest = true;//TRUE;
									if(myMode.myInvisible[yy][xx] + myMode.mapcheat == AGModeGuy.B_PLUNGER_MARKER) markerTest =true;// TRUE;
									//if(myMode.myInvisible[yy+1][xx-1] == 0) markerTest = true;//TRUE;
								}
								// turn monster
								if (this.y < 0 || markerTest == true ) {
			
									this.goingUp= false;
								}
							}
			
							//Only show those that are on the screen properly
			
			
							//default is to show monster
							visibility = show;
							//hide monster if...
							if(this.x > myMode.scrollBGX + 64 * horiz + 32 ) {
								visibility = hide;
							}
							if (this.x < myMode.scrollBGX - 32) {
								visibility = hide;
							}
							if (this.y > myMode.scrollBGY + 48 * vert + 32) {
								visibility = hide;
							}
							if ( this.y < myMode.scrollBGY  - 32) {
								visibility = hide;
							}
						}
						
						if (this.visible && visibility == show) this.visible = true;// TRUE;
						
					
					}
					
				
		
			}
			myMode.drawRadarPing(myMode.radar, 
								 myMode.radarscreen, 
								 this.x, this.y, 
								 AGMode.PING_OTHER, 
								 0xff0000ff);
			
			return;
		
		}
	}
	
}
