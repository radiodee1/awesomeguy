package org.davidliebman.flash.awesomeguy {
	import flash.xml.XMLDocument;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class AGModeFlyer extends AGMode{

		public var total_rings:int;
		public var total_bubble_0:int, total_bubble_1:int, total_bubble_2:int, total_bubble_3:int;
		public var total_invader_1:int, total_invader_2:int, total_invader_3:int;

		public var total_placed_bubble_1:int, total_placed_bubble_2:int, total_placed_bubble_3:int;
		public var total_placed_invader_1:int, total_placed_invader_2:int, total_placed_invader_3:int;

		public var total_held_rings:int;
		
		public function AGModeFlyer() {
			// constructor code
		}
		
		public override function componentsInOrder():void {
			//
			super.componentsInOrder();
			var screenframe:Bitmap = new Bitmap (new BitmapData (SCREEN_WIDTH, 64, false, 0x66666666));
			radarscreen = new Bitmap( new BitmapData(SCREEN_WIDTH - 128, 64,
										false, 0x00000000));
			
			drawLevelTiles();
			drawRadarRock();

			drawBasicSprite(0, AGMode.S_FLYER);
			screenframe.x = 0;
			screenframe.y = SCREEN_HEIGHT;
			myStage.addChild(screenframe);
			
			
			drawRadarPing(radar, radarscreen ,xpos,ypos,AGMode.PING_FLYER,0xffffffff);
			
			radarscreen.x = 64;
			radarscreen.y = SCREEN_HEIGHT;
			myStage.addChild(radarscreen);
		}
		
		public override function doOnce():void {
			initAGSprite();
			initChallenges();// this just creates the array!!
			initAGTimer();
			//myStage.addChild(myRes[AGResources.NAME_FLYER_L0_PNG]);

			fillChallenges();
			
			prepTiles() ;
			prepRings() ;
			
			radar_start = xpos - scrollBGX;
			radar_start_scroll =  scrollBGX;
			//trace (radar_start + " scroll:" + scrollBGX);
			//myRes[AGResources.NAME_EXPLOSION_MP3].play();
		}
		
		public override function prepTiles():void {
			var tempArray:Array = new Array();
			var smallArray:Array = new Array();
			var visibleArray:Array = new Array();
			var invisibleArray:Array = new Array();
			
			var stringVisible:String;
			var stringInvisible:String;
			var myXML:XMLDocument = myRes[AGResources.NAME_AWESOMEGUY_XML];
			
			var tree:XML = new XML(myXML);
			//trace (tree.planet[myGame.gamePlanet].horizontal);
			
			myHoriz = int (tree.planet[myGame.gamePlanet].horizontal.toString());
			myVert = int (tree.planet[myGame.gamePlanet].vertical.toString());
			

			stringVisible = tree.planet[myGame.gamePlanet].horizon.visible.toString();
			stringInvisible = tree.planet[myGame.gamePlanet].horizon.invisible.toString();

			var i:int = 0;
			var j:int = 0;
			
			myVisible = new Array();
			tempArray = new Array();
			tempArray = stringVisible.split(",");
			for (i = 0; i < myVert; i ++ ) {
				smallArray = new Array();
				for (j = 0 ; j < myHoriz; j ++ ) {
					smallArray.push(int (tempArray[ (i * myHoriz) + j ] ) );
				}
				myVisible.push(smallArray);
			}
			
			myInvisible = new Array();
			tempArray = new Array();
			tempArray = stringInvisible.split(",");
			for (i = 0; i < myVert; i ++ ) {
				smallArray = new Array();
				for (j = 0 ; j < myHoriz; j ++ ) {
					smallArray.push(int (tempArray[ (i * myHoriz) + j ] ) );
				}
				myInvisible.push(smallArray);
			}
			
			//trace(myInvisible);
		}
		
		public function fillChallenges():void {
			var challengeBody:String = new String();
			var challengeLength:int = 0;
			var ii:int, jj:int;
			var tree:XML = new XML(new XMLDocument(myRes[AGResources.NAME_AWESOMEGUY_XML]));
			challengeLength = tree.planet[myGame.gamePlanet].challenges.invaders.length();

			myChallenge = new Array();
			
			var tempArray:Array ;
			for (ii = 0; ii < challengeLength; ii ++ ) {
				challengeBody = new String();
			
				challengeBody = tree.planet[myGame.gamePlanet].challenges.invaders[ii].toString();

				tempArray = new Array();
				tempArray = challengeBody.split(",");

				var ch:AGChallenge = new AGChallenge();
				ch.rings = int (tempArray[0]);
				ch.bubble_1 = int (tempArray[1]);
				ch.bubble_2 = int (tempArray[2]);
				ch.bubble_3 = int (tempArray[3]);
				ch.invader_1 = int (tempArray[4]);
				ch.invader_2 = int (tempArray[5]);
				ch.invader_3 = int (tempArray[6]);
				ch.speed = int (tempArray[tempArray.length - 1]);
				
				myChallenge.push(ch);
			}
		}
		
		public function prepRings():void {
			var candidate:Array = new Array();
			
			var candidate_num:int = 0;
			var i:int, j:int, k:int, cheat:int;
			
			for (i = 0 ; i < myVert ; i ++ ) {
				for (j = 0; j < myHoriz ; j ++ ) {
					
					

					if (myInvisible[i][j] - mapcheat == B_PRIZE) {
						var myCandidate:Candidate = new Candidate();
						
						myCandidate.x = j;
						myCandidate.y = i;
						myCandidate.value = B_SPACE ;
						myCandidate.type = B_PRIZE ;
						myInvisible[i][j] = myCandidate.value;
						candidate.push(myCandidate);
						candidate_num ++;
					}
				}
			}
			////////////////////////////
			
			//int i,j, k;
			var num_rings:int, num_spaces:int;
		
			total_held_rings = 0;
			
			//the first challenges to place are the rings.
			num_rings = myChallenge[myGame.gameChallenge].rings;
			num_spaces = candidate_num;
		
			for (i = 0; i < num_rings; i ++ ) {
		
				j = getRand(0, num_spaces - ( i ) );
		
				
				for (k = 0; k <= j; k ++) {
		
					while (candidate[k].value != B_SPACE ) {
						k ++;
					}
					if ( candidate[k ].value == B_SPACE && k == j ){//-1) {
						candidate[k].value = B_PRIZE;
		
					}
		
					else if (candidate[k ].value != B_SPACE && k == j ){
						while (candidate[k].value != B_SPACE ) {
							k++;
		
						}
						if ( candidate[k ].value == B_SPACE  ){//-1) {
							candidate[k].value = B_PRIZE;
		
						}
						//LOGE("else condition");
					}
				}
			}
			for (i = 0; i< num_spaces; i ++ ) {
				
				if (candidate[i].value != B_SPACE ) cheat = levelcheat +2;
				else cheat = 0;
				myInvisible[candidate[i].y][candidate[i].x] = candidate[i].value - cheat;
				if (candidate[i].value == B_PRIZE) total_rings ++;
			}
			
			candidate = null;
			/////////////////////////////
		}
				
		
		///////////////////////////////////////////
		public function drawLevelTiles():void {
			var  i:int,j:int,k:int,l:int,m:int, zz:int;
			
			var baseX:int, baseY:int;//, startX, startY;
			var mapcheat:int = -3;
			var levelcheat:int = -3;
			var TILE_WIDTH:int = 16;
			var TILE_HEIGHT:int = 16;
			
			var tilesWidthMeasurement:int = 32;
			var tilesHeightMeasurement:int = 24;//32;
			//uint16_t square[TILE_HEIGHT][TILE_WIDTH];
			
			//uint16_t  **  screen = (getScreenPointer(MY_SCREEN_BACK));
			//var map_level:Array = myVisible;
			//var map_objects:Array = myInvisible;
			var LONG_MAP_H:int =	192;
			var LONG_MAP_V:int =	32;
			//animate = newBG + 1;
			//var animate:int = 0;
					
			
			var square:Bitmap;
		
			/* clear screen */
			//alertOnScreen();
			//memset(screen, alert_color, (SCREEN_HEIGHT + LONG_MAP_V)* SCREEN_WIDTH * 2);
			
			/* draw bubbles behind mountains */
			//drawBubbleType0();
			//drawBubbleType1();
			//drawBubbleType2();
			//drawBubbleWithColor();
		
			/* draw background */
			baseX = scrollBGX / TILE_WIDTH;
			baseY = scrollBGY / TILE_HEIGHT;
			
			for ( j = baseX - 1 ; j < baseX + tilesWidthMeasurement + 3; j++) { //32
				for ( i = baseY - 1 ; i < baseY + tilesHeightMeasurement + 3; i ++ ) { //24
					
					if (i >= 0 && j >= 0  && i < LONG_MAP_V && j < LONG_MAP_H) { 
					//trace("i"+i+" j" + j + " = " + myVisible[i][j]);
						
						//LOGE("map_level %d", map_level[j][i] );
						if(  myVisible[i][j] != 0  && myVisible[i][j] != AGMode.B_GOAL  ) { //is tile blank??
							//trace(myVisible);
							square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
									myVisible[i][j] - levelcheat,
									AGMode.TILE_TOP);
							
							square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
							square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
							myStage.addChild(square);
							//drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
							//	scrollx , scrolly, PAINT_TRANSPARENT, 0);
							
						}
						
						// special animated tiles
						k = myInvisible[i][j] ;
						zz = k - mapcheat;
						if ( zz != AGMode.B_START && zz != AGMode.B_MONSTER && zz != AGMode.B_DEATH
							&& zz != AGMode.B_PLATFORM && zz != AGMode.B_MARKER && zz != AGMode.B_BLOCK
							&& zz != AGMode.B_LADDER  && k != AGMode.B_SPACE  && zz != AGMode.B_GOAL) {
							
							
							if (animate == 0 || animate == 1 || animate == 8) {
		
								//cutTile(tiles_a, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
									myInvisible[i][j] - levelcheat,
									AGMode.TILE_TOP);
							}
							else if (animate == 2 || animate == 4 || animate == 6) {
		
								//cutTile(tiles_b, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES2_PNG], 
									myInvisible[i][j] - levelcheat,
									AGMode.TILE_TOP);
							}
							else if (animate == 3 || animate == 7) {
		
								//cutTile(tiles_c, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES3_PNG], 
									myInvisible[i][j] - levelcheat,
									AGMode.TILE_TOP);
							}
							else if (animate == 5) {
		
								//cutTile(tiles_d, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES4_PNG], 
									myInvisible[i][j] - levelcheat,
									AGMode.TILE_TOP);
							}
							
							square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
							square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
							myStage.addChild(square);
		
							//drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
							//	scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
						}
						
		
		
					} // if i,j > 0, etc...
				
					//////////////////////////////////////////
					if (j  >= LONG_MAP_H || true) {
						//draw all of level again.
						m =  (LONG_MAP_H  );
						
						
						if (i >= 0 && j-m >= 0  && i < LONG_MAP_V && j-m < LONG_MAP_H) { 
						if(  myVisible[i][j-m] != 0 && myVisible[i][j-m] != B_GOAL  ) { //is tile blank??
							//cutTile(tiles_a, square, map_level[j-m][i] - levelcheat);
							square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
									myVisible[i][j-m] - levelcheat,
									AGMode.TILE_TOP);
							//drawTile_8(square, j  * TILE_WIDTH, i * TILE_HEIGHT , 
							//	scrollx , scrolly, PAINT_TRANSPARENT, 0);
							square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
							square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
							myStage.addChild(square);
						}
						
						// special animated tiles
						k = myInvisible[i][ j-m] ;//- levelcheat;
						zz = k - mapcheat;
						if ( zz != B_START && zz != B_MONSTER && zz != B_DEATH
							&& zz != B_PLATFORM && zz != B_MARKER && zz != B_BLOCK
							&& zz != B_LADDER  && k != B_SPACE && zz != B_GOAL) {
							
							
							if (animate == 0 || animate == 1 || animate == 8) {
		
								//cutTile(tiles_a, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
									k - levelcheat,
									AGMode.TILE_TOP);
							}
							else if (animate == 2 || animate == 4 || animate == 6) {
		
								//cutTile(tiles_b, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES2_PNG], 
									k - levelcheat,
									AGMode.TILE_TOP);
							}
							else if (animate == 3 || animate == 7) {
		
								//cutTile(tiles_c, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES3_PNG], 
									k - levelcheat,
									AGMode.TILE_TOP);
							}
							else if (animate == 5) {
		
								//cutTile(tiles_d, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES4_PNG], 
									k - levelcheat,
									AGMode.TILE_TOP);
							}
							
		
							//drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
							//	scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
							square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
							square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
							myStage.addChild(square);
						}
						
					}// if j-m > 0 etc.
		
					}
					
					if (j < 0 ) {
					m =  (LONG_MAP_H  );
					
					if (i >= 0 && j+m >= 0  && i < LONG_MAP_V && j+m < LONG_MAP_H) {
					if(  myVisible[i][j+m] != 0 && myVisible[i][j+m] != B_GOAL  ) { //is tile blank??
							//cutTile(tiles_a, square, map_level[j-m][i] - levelcheat);
							square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
									myVisible[i][j+m] - levelcheat,
									AGMode.TILE_TOP);
							//drawTile_8(square, j  * TILE_WIDTH, i * TILE_HEIGHT , 
							//	scrollx , scrolly, PAINT_TRANSPARENT, 0);
							square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
							square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
							myStage.addChild(square);
						}
						
						/////////////////////////////////////////////
							// special animated tiles
						k = myInvisible[i][ j+m] ;//- levelcheat;
						zz = k - mapcheat;
						if ( zz != B_START && zz != B_MONSTER && zz != B_DEATH
							&& zz != B_PLATFORM && zz != B_MARKER && zz != B_BLOCK
							&& zz != B_LADDER  && k != B_SPACE && zz != B_GOAL) {
							
							
							if (animate == 0 || animate == 1 || animate == 8) {
		
								//cutTile(tiles_a, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES1_PNG], 
									k - levelcheat,
									AGMode.TILE_TOP);
							}
							else if (animate == 2 || animate == 4 || animate == 6) {
		
								//cutTile(tiles_b, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES2_PNG], 
									k - levelcheat,
									AGMode.TILE_TOP);
							}
							else if (animate == 3 || animate == 7) {
		
								//cutTile(tiles_c, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES3_PNG], 
									k - levelcheat,
									AGMode.TILE_TOP);
							}
							else if (animate == 5) {
		
								//cutTile(tiles_d, square, k - mapcheat);
								square = cutTile(  myRes[AGResources.NAME_TILES4_PNG], 
									k - levelcheat,
									AGMode.TILE_TOP);
							}
							
		
							//drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
							//	scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
							square.x = new Number ((j * TILE_WIDTH ) - scrollBGX);
							square.y = new Number ((i * TILE_HEIGHT) - scrollBGY);
							myStage.addChild(square);
						}
						
					}
				
					}
					
				}
			}
			
			//drawRadarRock();
		
			/* draw moving platform */
			//drawMovingPlatform();
			
			/* draw score and level */
			//drawScoreWords();
			
		
			/* draw monsters */
			//if (preferences_monsters == TRUE) {
			//    drawMonsters();
			//}
			
			//if (preferences_monsters == TRUE && preferences_collision == TRUE && animate_only == FALSE) {
			//    collisionWithMonsters();
			//}
			
		
		
			//if (! animate_only ) {
			//	drawInvaderType1();
			//	drawInvaderType2();
			//}
		
			/* draw guy with animation */
			//if (! animate_only) {
			//	drawFlyer();
			//	drawBasicSprite(0, D_FLYER_RINGS);
			//}
			
		
			//drawBasicSprite(0, D_EXPLOSION);
		
			//drawSpriteExplosion();
		
			//drawBoundingBox(radar_box, BB_NO_SCROLL, 0xffff);
		
			//drawLasers( );
		
			//drawTorpedo();
		
			//checkRegularCollision();
			
			return ;
		}
		///////////////////////////////////////////
		public override function physicsAdjustments():void {
			if (yy < 0) flyerGrounded = false;
			
			if (flyerGrounded) return;
			
			if (xx + yy == 0 ) {
				//ypos = ypos + 
				yy = (Y_MOVE / 2);
				if (facingRight) {
					//xpos = xpos + 
					xx = (X_MOVE / 2);
				}
				else {
					//xpos = xpos 
					xx = - (X_MOVE / 2);
				}
			}
		}
	

		public function drawRadarRock():void {

			var xxx:int,yyy:int;
			for (xxx = 0; xxx < myHoriz; xxx ++ ) {
				for(yyy = 0; yyy < myVert; yyy ++ ) {
		
					if (myInvisible[yyy][xxx] - mapcheat == B_BLOCK) {
						
						drawRadarPing(radar, radarscreen, xxx * TILE_WIDTH, yyy * TILE_HEIGHT, PING_ROCK, 0xffffffff);
					}
					else if (myVisible[yyy][xxx]  != B_SPACE) {
						drawRadarPing(radar, radarscreen, xxx * TILE_WIDTH, yyy * TILE_HEIGHT, PING_ROCK, 0xff903590);//0xff889be7);
						
					}
					if (myInvisible[yyy][xxx] - levelcheat == B_PRIZE) {
						drawRadarPing(radar, radarscreen, xxx * TILE_WIDTH, yyy * TILE_HEIGHT, PING_OTHER, 0xf0000000);
						
					}
				}
			}
		}
		
	}
	
}
