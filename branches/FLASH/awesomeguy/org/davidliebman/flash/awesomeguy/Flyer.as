/**
 * flyer.c
 * 
 * native android library
 */

#include "androidgl.h"



// some declarations that are used only in this c file...
uint16_t number_alpha = 0;

int sprite_num = 0;
int monster_num = 0;
int platform_num = -1;

int candidate_num = 0;
int challenge_num  = -1;
int current_challenge = -1;

//////////////////////////////////////////////////////
// function definitions
//////////////////////////////////////////////////////



/**
 *	Collects 1D arrays representing the four flyer sprites and passes them 
 *	individually to the functions that store them in 2D arrays for the later
 *	use of the library. Used to basically initializes flyer sprite arrays when 
 *	Panel is created.
 *
 *	@param	a	1D integer array of guy sprite data
 *	@param	b	1D integer array of guy sprite data
 *	@param	c	1D integer array of guy sprite data
 *	@param	d	1D integer array of guy sprite data
 */
void setFlyerData(jint a[], jint b[], jint c[], jint d[] ) {
    int x;
	copyArraysExpand_16_40(a, FLYER_WIDTH * FLYER_HEIGHT, flyer_l0);
	copyArraysExpand_16_40(b, FLYER_WIDTH * FLYER_HEIGHT, flyer_l1);
	copyArraysExpand_16_40(c, FLYER_WIDTH * FLYER_HEIGHT, flyer_r0);
	copyArraysExpand_16_40(d, FLYER_WIDTH * FLYER_HEIGHT, flyer_r1);
	
	flyer.topBB = 1; 
	flyer.bottomBB = 16;
	flyer.leftBB = 1;
	flyer.rightBB = 40;
	flyer.facingRight = TRUE;
	flyer.sprite_type = S_FLYER;
	
	guy.topBB = 1; 
	guy.bottomBB = 16;
	guy.leftBB = 1;
	guy.rightBB = 40;
	guy.facingRight = TRUE;
	guy.sprite_type = S_GUY;

//	torpedo.topBB = 0;
//	torpedo.bottomBB = 1;
//	torpedo.leftBB = 0;
//	torpedo.rightBB = 1;
//	torpedo.facingRight = TRUE;
//	torpedo.sprite_type = S_TORPEDO;

	box.topBB =0;
	box.bottomBB = 7;
	box.leftBB = 0;
	box.rightBB = 7;
	box.facingRight = TRUE;
	box.sprite_type = S_NONE;
	box.x = 0;
	box.y = 0;

	is_blinking = FALSE;
	for(x = 0; x < FLYER_WIDTH * FLYER_HEIGHT; x ++ ) {
		if (a[x] != 0x0000) a[x] = 0xffff;
		if (c[x] != 0x0000) c[x] = 0xffff;
	}
	copyArraysExpand_16_40(a, FLYER_WIDTH * FLYER_HEIGHT, flyer_white_l);
	copyArraysExpand_16_40(c, FLYER_WIDTH * FLYER_HEIGHT, flyer_white_r);

}
 
 
 

/**
 * Used to add challenges to the challenge array
 */

void addChallenges(int rings, int bubble1, int bubble2, int bubble3, int invader1, int invader2, int invader3, int speed) {

	challenge[challenge_num].rings = rings;
	challenge[challenge_num].bubble_1 = bubble1;
	challenge[challenge_num].bubble_2 = bubble2;
	challenge[challenge_num].bubble_3 = bubble3;
	challenge[challenge_num].invader_1 = invader1;
	challenge[challenge_num].invader_2 = invader2;
	challenge[challenge_num].invader_3 = invader3;
	challenge[challenge_num].speed = speed;

	//LOGE("challenge %d, %d", challenge_num, rings);

	challenge_num ++;
}


/**
 * Used to tell the JNI code that all arrays have been populated and
 * that init is done.
 */
void initChallenges() {

	timerStart(0, 3 * 30); // a few seconds
	timerStart(1, 3 ); // 3 refreshes
	timerStart(8, 5); // torpedos
	placeChallengesRings();
	placeChallengesBubble1();
	placeChallengesBubble2();
	placeChallengesInvader1();
	placeChallengesInvader2();

	//radar_set = FALSE;
}




/**
 *	Used for overall collision testing
 */

int collisionSimple(BoundingBox boxA, BoundingBox boxB) {
  int x[4], y[4];
  int i, j;
  int test = FALSE;
  int outsideTest, insideTest;
  
  boxA.left = adjust_x(boxA.left);
  boxA.right = adjust_x(boxA.right);

  boxB.left = adjust_x(boxB.left);
  boxB.right = adjust_x(boxB.right);

  x[0] = boxA.left;
  y[0] = boxA.top;
  
  x[1] = boxA.right;
  y[1] = boxA.top;
  
  x[2] = boxA.left;
  y[2] = boxA.bottom;
  
  x[3] = boxA.right;
  y[3] = boxA.bottom;

  //recursion here
  if (boxA.left > boxA.right ) {
	  BoundingBox boxC, boxD;

	  //boxC = boxA;
	  memcpy( &boxC, &boxA, sizeof(BoundingBox));
	  boxC.right = level_w * 8;

	  //boxD = boxA;
	  memcpy( &boxD, &boxA, sizeof(BoundingBox));
	  boxD.left = 0;

	  if (boxB.left > boxB.right) {
		  BoundingBox boxE, boxF;

		  //boxE = boxB;
		  memcpy( &boxE, &boxB, sizeof(BoundingBox));
		  boxE.right = level_w * 8;

		  //boxF = boxB;
		  memcpy( &boxF, &boxB, sizeof(BoundingBox));
		  boxF.left = 0;
		  if (collisionSimple(boxC, boxE)) test = TRUE;
		  if (collisionSimple(boxD, boxF)) test = TRUE;
		  return test;

	  }
	  else {
		  //LOGE("RECURSION -----------------");

		  if (collisionSimple(boxC, boxB)) test = TRUE;
		  if (collisionSimple(boxD, boxB)) test = TRUE;
		  return test;
	  }
  }

  if (boxB.left > boxB.right) {
	  BoundingBox boxG, boxH;

	  memcpy( &boxG, &boxB, sizeof(BoundingBox));
	  boxG.right = level_w * 8;

	  memcpy( &boxH, &boxB, sizeof(BoundingBox));
	  boxH.left = 0;
	  if (collisionSimple(boxA, boxG)) test = TRUE;
	  if (collisionSimple(boxA, boxH)) test = TRUE;
	  return test;
  }

  for (i = 0; i < 4; i ++) {
    // is one point inside the other bounding box??
    if (x[i] <= boxB.right && x[i] >= boxB.left && y[i] <= boxB.bottom && y[i] >= boxB.top ) {
    	test = TRUE;
    	// are all other points outside the other bounding box??

      outsideTest = FALSE;
      
      for (j = 0; j < 4 ; j ++) {
        if (j != i ) {
          if (!(x[j] <= boxB.right && x[j] >= boxB.left && y[j] <= boxB.bottom && y[j] >= boxB.top) ) {
            outsideTest = TRUE;
            
          }
        }
      }
      if(outsideTest) {
        test = TRUE;
       
      }
      // is a second point inside the bounding box??
      insideTest = FALSE;
      for (j = 0; j < 4 ; j ++) {
        if (j != i ) {
          if ((x[j] <= boxB.right && x[j] >= boxB.left && y[j] <= boxB.bottom && y[j] >= boxB.top) ) {
            insideTest = TRUE;

          }
        }
      }
      if(insideTest) {
        test = TRUE;
       
      }
      
      /////////////////////////
    }
  }

  if (collisionHelperLine (boxA.left, boxA.right, boxA.top, boxB.top, boxB.bottom, boxB.left) ||
		  collisionHelperLine( boxA.left, boxA.right, boxA.bottom, boxB.top, boxB.bottom, boxB.left ) ||
		  collisionHelperLine( boxB.left, boxB.right, boxB.top, boxA.top, boxA.bottom, boxA.left) ||
		  collisionHelperLine( boxB.left, boxB.right, boxB.bottom, boxA.top, boxA.bottom, boxA.left )) {
	  test = TRUE;
  }


  if (!test) return collisionHelper(boxA, boxB);
  else return TRUE;
}

/**
 *	Used for overall collision testing.
 */

int collisionHelper(BoundingBox boxA, BoundingBox boxB) {
  int x[4], y[4];
  int i,j;
  int test = FALSE;
  int outsideTest, insideTest;
  
  x[0] = boxB.left;
  y[0] = boxB.top;
  
  x[1] = boxB.right;
  y[1] = boxB.top;
  
  x[2] = boxB.left;
  y[2] = boxB.bottom;
  
  x[3] = boxB.right;
  y[3] = boxB.bottom;
  for (i = 0; i < 4; i ++) {
    // is one point inside the other bounding box??
    if (x[i] <= boxA.right && x[i] >= boxA.left && y[i] <= boxA.bottom && y[i] >= boxA.top ) {
    	test = TRUE;
    
      // are all other points outside the other bounding box??
      outsideTest = FALSE;
      
      for (j = 0; j < 4 ; j ++) {
        if (j != i ) {
          if (!(x[j] <= boxA.right && x[j] >= boxA.left && y[j] <= boxA.bottom && y[j] >= boxA.top) ) {
            outsideTest = TRUE;
            
          }
        }
      }
      if(outsideTest) {
        test = TRUE;
      
      }
      // is a second point inside the bounding box??
      insideTest = FALSE;
      for (j = 0; j < 4 ; j ++) {
        if (j != i ) {
          if ((x[j] <= boxA.right && x[j] >= boxA.left && y[j] <= boxA.bottom && y[j] >= boxA.top) ) {
            insideTest = TRUE;

          }
        }
      }
      if(insideTest) {
        test = TRUE;

      }
      
      
      //////////////////////////
    }
  }
  
  return test;
}

/**
 *	Used for overall collision line testing.
 */

BOOL collisionHelperLine(int lineAXstart, int lineAXend, int lineAY, int lineBYstart, int lineBYend, int lineBX) {
	BOOL test = FALSE;

	if (lineAXstart < lineBX &&
			lineAXend > lineBX &&
			lineBYstart < lineAY &&
			lineBYend > lineAY) {
		test = TRUE;
	}
	if (lineAXstart > lineAXend ) {
		LOGE("collisionHelperLine - x coord of line");
	}
	if (lineBYstart > lineBYend ) {
		LOGE("collisionHelperLine - y coord of line");
	}

	return test;
}





/**
 *	Used to set animation vars in JNI code.
 */
void animate_vars() {

	int ANIMATE_SPEED = 3;
	
	animate_int ++;
	if (TRUE) {

		if (animate_int >= ANIMATE_SPEED) {
			newGuy ++;
			newBG ++;
			animate_int = 0;
		}
		if(newGuy > 3) newGuy = -1;
		if(newBG > 7) newBG = -1;
		
	}
	//LOGE("animate %d -- %d", newGuy, newBG);
}


/**
 *	Used to draw all the components of the level on the screen.
 *
 *	@param	unused	formerly a number used to decide which version of the tileset
 *							is used, providing animated appearance of rings
 */
void drawLevel(int unused) {
    
    int i,j,k,l,m;
    int baseX, baseY;//, startX, startY;
    int mapcheat = 1;
    int levelcheat = 1;
    uint16_t square[TILE_HEIGHT][TILE_WIDTH];
    
    uint16_t  **  screen = (getScreenPointer(MY_SCREEN_BACK));
    
    //animate = animate_level;
    animate = newBG + 1;
    
    /* clear screen */
    alertOnScreen();
    memset(screen, alert_color, (SCREEN_HEIGHT + LONG_MAP_V)* SCREEN_WIDTH * 2);
    
    /* draw bubbles behind mountains */
    //drawBubbleType0();
    drawBubbleType1();
    drawBubbleType2();
    drawBubbleWithColor();

    /* draw background */
    baseX = scrollx / TILE_WIDTH;
    baseY = scrolly / TILE_HEIGHT;
    
	for ( j = baseX - 1 ; j < baseX + tilesWidthMeasurement + 3; j++) { //32
    	for ( i = baseY - 1 ; i < baseY + tilesHeightMeasurement + 3; i ++ ) { //24
    		
    		
    		if (i >= 0 && j >= 0  && i < LONG_MAP_V && j < LONG_MAP_H) { 
    			//LOGE("map_level %d", map_level[j][i] );
    			if(  map_level[j][i] != 0  && map_level[j][i] != B_GOAL  ) { //is tile blank??
    				cutTile(tiles_a, square, map_level[j][i] - levelcheat);
    				
    				drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    					scrollx , scrolly, PAINT_TRANSPARENT, 0);
			}
			
				// special animated tiles
				k = map_objects[j][i];
				if ( k != B_START && k != B_MONSTER && k != B_DEATH
    				&& k != B_PLATFORM && k != B_MARKER && k != B_BLOCK
    				&& k != B_LADDER  && k != B_SPACE && k != B_GOAL) {
    				
    				
    				if (animate == 0 || animate == 1 || animate == 8) {

    		    		cutTile(tiles_a, square, k - mapcheat);
    				}
    				else if (animate == 2 || animate == 4 || animate == 6) {

    		    		cutTile(tiles_b, square, k - mapcheat);
    				}
    				else if (animate == 3 || animate == 7) {

    		    		cutTile(tiles_c, square, k - mapcheat);
    				}
    				else if (animate == 5) {

    		    		cutTile(tiles_d, square, k - mapcheat);
    				}
    				

    				drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    					scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);


    			
    			}



			} // if i,j > 0, etc...
			
			if (j  >= LONG_MAP_H ) {
				//draw all of level again.
				m =  (LONG_MAP_H  );
				
				
				if(  map_level[j - m][i] != 0 && map_level[j-m][i] != B_GOAL  ) { //is tile blank??
    				cutTile(tiles_a, square, map_level[j-m][i] - levelcheat);
    				
    				drawTile_8(square, j  * TILE_WIDTH, i * TILE_HEIGHT , 
    					scrollx , scrolly, PAINT_TRANSPARENT, 0);
				}
				
				// special animated tiles
				k = map_objects[j-m][i];
				if ( k != B_START && k != B_MONSTER && k != B_DEATH
    				&& k != B_PLATFORM && k != B_MARKER && k != B_BLOCK
    				&& k != B_LADDER  && k != B_SPACE && k != B_GOAL) {
    				
    				
    				if (animate == 0 || animate == 1 || animate == 8) {

    		    		cutTile(tiles_a, square, k - mapcheat);
    				}
    				else if (animate == 2 || animate == 4 || animate == 6) {

    		    		cutTile(tiles_b, square, k - mapcheat);
    				}
    				else if (animate == 3 || animate == 7) {

    		    		cutTile(tiles_c, square, k - mapcheat);
    				}
    				else if (animate == 5) {

    		    		cutTile(tiles_d, square, k - mapcheat);
    				}
    				

    				drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    					scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
				}


			}
		
    	}
    }
    
	drawRadarRock();

    /* draw moving platform */
    drawMovingPlatform();
    
    /* draw score and level */
    drawScoreWords();
    

    /* draw monsters */
    if (preferences_monsters == TRUE) {
        drawMonsters();
    }
    
    if (preferences_monsters == TRUE && preferences_collision == TRUE && animate_only == FALSE) {
        collisionWithMonsters();
    }
    


    if (! animate_only ) {
    	drawInvaderType1();
    	drawInvaderType2();

    }

  	/* draw guy with animation */
    if (! animate_only) {
    	drawFlyer();
    	drawBasicSprite(0, D_FLYER_RINGS);
    }
	

	drawBasicSprite(0, D_EXPLOSION);

	drawSpriteExplosion();

	drawBoundingBox(radar_box, BB_NO_SCROLL, 0xffff);

	drawLasers( );

	drawTorpedo();

	checkRegularCollision();
}


/**
 * Used to check if the body of the flyer has hit anything.
 */
void checkRegularCollision() {

	BoundingBox guyBox = makeSpriteBox(flyer, 0, 0 );

	int i,j;
	is_landing = FALSE;
	//LOGE("here");

	for (j =  (flyer.x / 8) -1; j <  (flyer.x / 8) + 3; j ++ ) { // x coordinates
		for (i = (flyer.y / 8) - 1; i < (flyer.y / 8) + 3; i ++ ) { // y coordinates

			if(j >= 0 && j < LONG_MAP_H  && i >= 0 && i < LONG_MAP_V) {// indexes OK?
				if (map_objects[j][i]  != B_SPACE ) {

					/* save time here by checking the bounding
					 * box only in the squares immediately surrounding
					 * the character...
					 * Instead of checking the whole field of play.
					 */

					BoundingBox testMe = makeSpriteBox(box,j*8 ,i*8 );
					//bool testNext = collisionSimple(guyBoxNext, testMe);
					BOOL test = collisionSimple(guyBox, testMe);
					//LOGE("collision %d", test);
					/****** tests here ******/

					/************* prizes ******************/
					if (test && map_objects[j][i] == B_PRIZE ) {

						map_objects[j][i] = B_SPACE;

						total_held_rings ++;

						//sound_prize = TRUE;
						setSoundPrize();
						score = score + 10;

						sprite[sprite_num].x = j * 8;
						sprite[sprite_num].y = i * 8;
						sprite[sprite_num].sprite_type = S_BUBBLE_0;
						sprite[sprite_num].speed = 1;
						sprite[sprite_num].radius = 8;
						sprite[sprite_num].limit = 150;
						sprite[sprite_num].active = TRUE;
						total_bubble_0 ++;
						sprite_num ++;

						total_rings --;
					}
					/*********** blocks *******************/
					if (test && map_objects[j][i] == B_BLOCK ) {

						if (oldx == flyer.x && oldy - flyer.y < 0 ) {
							is_landing = TRUE;
							flyer.y = flyer.y - 3;
						}

						if(is_moving == FALSE && is_landing == FALSE &&  !animate_only && preferences_mountains == TRUE)  {
							setSoundOw() ;
							animate_only = TRUE;
							//drawFlyerExplosion(flyer.x, flyer.y);
							//endlevel = TRUE;
							//gamedeath = TRUE;
						}
					}
					/**********landing area / goal*****************/
					if (test && map_objects[j][i] == B_GOAL ) {
						score = score + (total_held_rings * 20);
						total_held_rings = 0;
						is_blinking = TRUE;
						timerStart(7, 3 * 30);//blinking timer 7


					}

					/****** end tests  ******/


				}//if block

			} // indexes OK?

		} // i block
	} // j block

	if (timerDone(7)) {
		is_blinking = FALSE;
	}

	// current challenge cleared ???
	if( checkTotalsAllCleared() && current_challenge < challenge_num ) {
		if(timerDone(0)) {
			current_challenge ++;
			setSoundGoal();
			alert_color = 0xff;
			initChallenges();
		}
	}
	// end of entire level ???
	else if (checkTotalsAllCleared() && current_challenge == challenge_num && current_challenge != 0) {
		if(timerDone(0)){
			endlevel = TRUE;
			gamedeath = FALSE;
			if ( endlevel) {
				setSoundGoal();
				timer[0].timer_disable = TRUE;
			}


		}
	}

	oldx = flyer.x;
	oldy = flyer.y;
}

/**
 * Used to check weather or not the flyer is shooting a bubble.
 */
BOOL checkBubbleCollision(int x) {
	int l;
	int rad = abs(sprite[x].radius);
	BOOL test1 = FALSE;
	BOOL test2 = FALSE;
	BOOL test3 = FALSE;
	BOOL debug = FALSE;
	BoundingBox torpedoBox, testBox, flyerBox, invaderBox, box1, box2, box3;
	int rad1, rad2, rad3;

	float position, angle, dist;

	if ( keyB ) {

		testBox = makeBubbleBox(sprite[x].x -  rad, sprite[x].x +  rad, sprite[x].y -  rad , LONG_MAP_V * 8 );

		test1 = collisionTorpedos(testBox);
		//LOGE("numbers %d , %d, %d ", sprite[x].x, sprite[x].y, rad);

		if (test1 == TRUE ) {
			setSoundBoom();
			sprite[x].active = FALSE;

			switch (sprite[x].sprite_type) {
			case S_BUBBLE_0:
				if (total_bubble_0 > 0) total_bubble_0 --;
				score = score + 20;

				break;
			case S_BUBBLE_1:
				if (total_bubble_1 > 0) total_bubble_1 --;
				score = score + 30;

				break;
			case S_BUBBLE_2:
				if (total_bubble_2 > 0) total_bubble_2 --;
				score = score + 40;

				break;
			case S_BUBBLE_3:
				if (total_bubble_3 > 0) total_bubble_3 --;
				// no points
				break;
			}




		}

	}
	// checking collision with the flyer...
	if (!is_moving || TRUE ) { // remove TRUE !!


		if (TRUE) {
			switch(sprite[x].sprite_type) {
			case S_BUBBLE_1:
				break;

			case S_BUBBLE_2:
				//int rad1, rad2, rad3;
				 rad3 = rad;
				 rad2 = rad * 2 / 3;
				 rad1 = rad / 3;


				position = (float) rad2;
				angle = asin(position/rad);
				dist = cos(angle) * rad;
				box1 = makeBubbleBox(sprite[x].x -  dist, sprite[x].x +  dist, (LONG_MAP_V * 8 ) -  rad3 , (LONG_MAP_V * 8) - rad2 );
				drawBoundingBox(box1, debug, 0xffff);


				position = (float) rad1;
				angle = asin(position/rad);
				dist = cos(angle) * rad;
				box2 = makeBubbleBox(sprite[x].x - dist , sprite[x].x + dist, (LONG_MAP_V * 8 ) -  rad2 , (LONG_MAP_V * 8) - rad1 );
				drawBoundingBox(box2, debug, 0xffff);


				position = (float) 0;
				angle = asin(position/rad);
				dist = cos(angle) * rad;
				box3 = makeBubbleBox(sprite[x].x - dist, sprite[x].x + dist, (LONG_MAP_V * 8 ) -  rad1 , (LONG_MAP_V * 8) - 0  );
				drawBoundingBox(box3, debug, 0xffff);


				flyerBox = makeSpriteBox(flyer, 0, 0);
				//testBox = makeBubbleBox(sprite[x].x -  rad, sprite[x].x +  rad, sprite[x].y -  rad , LONG_MAP_V * 8 );
				test1 = collisionSimple(flyerBox, box1);
				test2 = collisionSimple(flyerBox, box2);
				test3 = collisionSimple(flyerBox, box3);

				//drawBoundingBox( testBox , TRUE, 0xffff);


				if ((test1 || test2 || test3 ) && !animate_only) {
					setSoundOw() ;
					animate_only = TRUE;
					//endlevel = TRUE;
					//gamedeath = TRUE;
					//sprite[x].active = FALSE;
				}


				break;
			case S_BUBBLE_3:
				//do nothing
				break;


			}
		}
	}

	return test1;
}

/**
 * Used to check flyer collision with invaders
 */
BOOL checkInvaderCollision(int i) {
	int l;
//	int rad = sprite[x].radius;
	BOOL test1 = FALSE;
	if ( TRUE ) {

		BoundingBox invaderBox = makeSpriteBox(sprite[i], 0, 0);
		BoundingBox testBox = makeSpriteBox(flyer,0,0);
		test1 = collisionSimple(invaderBox, testBox);


		//LOGE("numbers %d , %d, %d ", sprite[x].x, sprite[x].y, rad);

		if (test1 == TRUE && ! animate_only) {
			setSoundOw();
			animate_only = TRUE;
			//endlevel = TRUE;
			//gamedeath = TRUE;

			switch (sprite[i].sprite_type) {


			case S_INVADER_1:

				sprite[i].active = FALSE;
				add_explosion(sprite[i]);
				break;
			case S_INVADER_2:

				break;
			case S_INVADER_3:
				// no points
				break;
			}

		}

	}
	if ( TRUE ) {

			BoundingBox invaderBox = makeSpriteBox(sprite[i], 0, 0);

			test1 = collisionTorpedos(invaderBox);

			//LOGE("sprite box %d", invaderBox.left	);

			//LOGE("numbers %d , %d, %d ", sprite[x].x, sprite[x].y, rad);

			if (test1 == TRUE) {


				switch (sprite[i].sprite_type) {


				case S_INVADER_1:
					setSoundBoom();
					sprite[i].active = FALSE;
					add_explosion(sprite[i]);

					score = score + 50;
					if (total_invader_1 > 0) total_invader_1 --;

					break;
				case S_INVADER_2:
					setSoundBoom();
					sprite[i].active = FALSE;
					add_explosion(sprite[i]);

					score = score + 50;
					if (total_invader_2 > 0) total_invader_2 --;

					break;
				case S_INVADER_3:
					// no points
					break;
				}




			}

		}
}

/**
 * Used to draw sprite explosion on the screen
 */
void drawSpriteExplosion() {
	int i;
	for (i = 0 ; i < 100; i ++ ) {
		if (sprite[i].sprite_type == S_EXPLOSION_SPRITE && sprite[i].active == TRUE) {
			drawBasicSprite(i, D_EXPLOSION_SPRITE );
		}
	}

}

/**
 * Used to draw the flyer on the screen.
 */
void drawFlyer() {
	if (scrollx > oldscrollx && (scrollx - oldscrollx) < (flyer.rightBB - flyer.leftBB)) {
		flyer.facingRight = TRUE;
		is_moving = TRUE;

	}
	else if (scrollx < oldscrollx && (oldscrollx - scrollx) < (flyer.rightBB - flyer.leftBB) ) {
		flyer.facingRight = FALSE;
		is_moving = TRUE;

	}


	if (scrollx == oldscrollx ) {
		is_moving = FALSE;
	}

	changex = abs(oldscrollx - scrollx);

	oldscrollx = scrollx;

	drawBasicSprite(0, D_FLYER);


}


/**
 * Used to draw S_INVADER_1 type objects.
 */

void drawInvaderType1() {

	int i, j, k, l, m;
	BOOL test = FALSE;
	int num_strikes = challenge[current_challenge].invader_1;

	if ( num_strikes > total_placed_invader_1 ) {
		if(timerDone(4)) {
			// create a invader-type object
			setSoundEnter1();

			Sprite temp ;
			temp.x = adjust_x(getRand(scrollx, scrollx + TEX_WIDTH));
			temp.y = 0;

			temp.topBB = 0;
			temp.leftBB = 0;
			temp.bottomBB = 15;
			temp.rightBB = 15;
			temp.sprite_type = S_INVADER_1;
			temp.speed = get_sprite_speed(S_INVADER_1);//1;
			temp.active = TRUE;
			temp.quality_0 = 0;
			temp.quality_1 = 0;
			temp.quality_2 = 0;
			temp.quality_3 = P_NONE;
			// add it to the sprite list
			addSprite(temp);

			total_placed_invader_1 ++;
			total_invader_1 ++;

			// reset timer
			timerStart(4, 30 * 2);
		}
	}
	// draw lines... make bubbles...

	//go through sprites
	for (i = 0; i < 100; i ++ ) {

		if (sprite[i].sprite_type == S_INVADER_1 && sprite[i].active == TRUE ) { // if i is an invader
			// move complex

			if ( sprite[i].quality_3 != P_GOING_LEFT && sprite[i].quality_3 != P_GOING_RIGHT) {
				checkInvaderCollision(i);
			}

			if(flyer.y + LASER_GUN  < sprite[i].y + 10) {
				sprite[i].y = sprite[i].y - sprite[i].speed;
			}
			else if (flyer.y+ LASER_GUN > sprite[i].y + 11) {
				sprite[i].y = sprite[i].y + sprite[i].speed;
			}

			if(sprite[i].quality_3 == P_GOING_RIGHT && ! spriteTimerDone(i) ) {
				sprite[i].x = sprite[i].x + sprite[i].speed;
			}
			if ( sprite[i].quality_3 == P_GOING_LEFT  && ! spriteTimerDone(i) ) {
				sprite[i].x = sprite[i].x - sprite[i].speed;
			}
			if(sprite[i].quality_3 == P_GOING_RIGHT_ARMED && ! spriteTimerDone(i) ) {
				sprite[i].x = sprite[i].x + sprite[i].speed;
			}
			if ( sprite[i].quality_3 == P_GOING_LEFT_ARMED  && ! spriteTimerDone(i) ) {
				sprite[i].x = sprite[i].x - sprite[i].speed;
			}

			// set various paths

			// goingRightIsShortest(sprite[i].x, flyer.x)
			if (goingRightIsShortest(sprite[i].x , flyer.x) && sprite[i].quality_3 == P_NONE) {
				sprite[i].quality_3 = P_GOING_RIGHT;
				sprite[i].facingRight = TRUE;
				spriteTimerStart(i, 30 * 3);

			}
			else if (sprite[i].quality_3 == P_NONE ) {
				sprite[i].quality_3 = P_GOING_LEFT;
				sprite[i].facingRight = FALSE;
				spriteTimerStart(i, 30 * 3);
			}

			if ( sprite[i].quality_3 == P_GOING_RIGHT && spriteTimerDone(i) ) {
				sprite[i].quality_3 = P_GOING_LEFT_ARMED;
				sprite[i].facingRight = FALSE;
				spriteTimerStart(i, 30 * 3);
			}
			if ( sprite[i].quality_3 == P_GOING_LEFT && spriteTimerDone(i) ) {
				sprite[i].quality_3 = P_GOING_RIGHT_ARMED;
				sprite[i].facingRight = TRUE;
				spriteTimerStart(i, 30 * 3);
			}

			if ( (sprite[i].quality_3 == P_GOING_LEFT_ARMED || sprite[i].quality_3 == P_GOING_RIGHT_ARMED)  && spriteTimerDone(i) ) {
				if (!goingRightIsShortest(sprite[i].x , flyer.x) ) {
					sprite[i].quality_3 = P_GOING_LEFT_ARMED;
					sprite[i].facingRight = FALSE;
					spriteTimerStart(i, 30 * 3);

				}
				else  {
					sprite[i].quality_3 = P_GOING_RIGHT_ARMED;
					sprite[i].facingRight = TRUE;
					spriteTimerStart(i, 30 * 3);
				}
			}
			drawBasicSprite(i, D_INVADER_1);
			// draw invader1


		}
	}
}


/**
 * Used to draw S_INVADER_2 type objects.
 */

void drawInvaderType2() {

	int i, j, k, l, m;
	BOOL test = FALSE;
	int num_strikes = challenge[current_challenge].invader_2;

	if ( num_strikes > total_placed_invader_2 ) {
		if(timerDone(6)) {
			// create a rollee-type object
			setSoundEnter2();

			Sprite temp ;
			temp.x = adjust_x(getRand(scrollx, scrollx + TEX_WIDTH));
			temp.y = 0;

			temp.topBB = 0;
			temp.leftBB = 0;
			temp.bottomBB = 8;
			temp.rightBB = 8;
			temp.sprite_type = S_INVADER_2;
			temp.speed = get_sprite_speed(S_INVADER_2);
			temp.active = TRUE;
			temp.quality_0 = 0;

			// add it to the sprite list
			addSprite(temp);

			total_placed_invader_2 ++;
			total_invader_2 ++;

			// reset timer
			timerStart(6, 30 * 2);
		}
	}
	// draw lines... make bubbles...

	//go through sprites
	for (i = 0; i < 100; i ++ ) {

		if (sprite[i].sprite_type == S_INVADER_2 && sprite[i].active == TRUE ) { // if i is an invader
			// move rollee
			checkInvaderCollision(i);

			if(flyer.y + LASER_GUN  < sprite[i].y + 2) {
				sprite[i].y = sprite[i].y - sprite[i].speed;
			}
			else if (flyer.y+ LASER_GUN > sprite[i].y + 3) {
				sprite[i].y = sprite[i].y + sprite[i].speed;
			}

			drawBasicSprite(i, D_INVADER_2);


		}
	}
}


/**
 * Used by bubble code to detect torpedo collision with a part of the
 * bubble.
 */

BoundingBox makeBubbleBox( int start_x, int stop_x, int start_y, int stop_y) {
	BoundingBox value;
	value.left =   adjust_x(start_x) ;//
	value.right =  adjust_x(stop_x);//
	value.top =  start_y ;//
	value.bottom =  stop_y ;//

	return value;
}



/**
 * Used to draw all sprites and centralize sprite drawing code
 */

void drawBasicSprite(int spriteNum, int kind ) {
	int i, x,y,z, wait, add, add_radar;
	int anim_speed = 5;
    uint16_t square[TILE_HEIGHT][TILE_WIDTH];
    int levelcheat = 1;

    int max_rings = 0;

	switch ( kind ) {
	case D_NONE:
		break;
	case D_FLYER:

		add = 0;
		add_radar = 0;

		if(scrollx < flyer.x + PLATFORM_WIDTH) {
			add = 0;
			add_radar = 0;
		}
		else if (scrollx >= flyer.x ) {
			add = level_w * 8;
			add_radar =  (flyer.x - scrollx) - flyer.x ;
		}


		BoundingBox flyerBox = makeSpriteBox(flyer, 0, 0);
		flyerBox.left += add;
		flyerBox.right += add;
		//drawBoundingBox( flyerBox , FALSE, 0xffff);

		drawRadarPing(radar_box, flyer.x + add_radar, flyer.y, PING_FLYER,  0xffff);

		//drawRadarPing(radar_box, 190 *8,16, PING_OTHER,  0xf000);

		if (flyer.facingRight) {
			if (flyer.animate == 0 || flyer.animate == 2) {
				drawSprite_40_16(flyer_r0, flyer.x + add, flyer.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
			}
			else if (!is_blinking){
				drawSprite_40_16(flyer_r1, flyer.x + add, flyer.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
			}
			else {
				drawSprite_40_16(flyer_white_r, flyer.x + add, flyer.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

			}
		}
		else {
			if (flyer.animate == 0 || flyer.animate == 2) {
				drawSprite_40_16(flyer_l0, flyer.x + add, flyer.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
			}
			else if (!is_blinking){
				drawSprite_40_16(flyer_l1, flyer.x + add, flyer.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
			}
			else {
				drawSprite_40_16(flyer_white_l, flyer.x + add, flyer.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

			}
		}

		break;
	case D_EXPLOSION:

		wait = 2;
		y = flyer.y - 32;
		x = flyer.x;

		add = 0;

		if(scrollx < flyer.x + PLATFORM_WIDTH) {
			add = 0;
		}
		else if (scrollx >= flyer.x ) {
			add = level_w * 8;
		}

		if (animate_only == FALSE ) {
			//animate_only = TRUE;
			flyer_explosion = 0;
			timerStart(5, wait);
		}
		else {

			if (timerDone(5)) {

				//LOGE("explosion %d ", flyer_explosion);

				switch (flyer_explosion) {
				case 0:
					drawSprite_64(explosion_a, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

					break;
				case 1:
					drawSprite_64(explosion_b, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

					break;

				case 2:
					drawSprite_64(explosion_c, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

					break;
				case 3:
					drawSprite_64(explosion_d, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

					break;
				case 4:
					drawSprite_64(explosion_e, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

					break;
				case 5:
					drawSprite_64(explosion_f, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

					break;

				case 6:
					drawSprite_64(explosion_g, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

					break;
				case 7:
					drawSprite_64(explosion_h, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

					break;
				}
				if (flyer_explosion > 7) {
					flyer_explosion = -1;
					endlevel = TRUE;
					gamedeath = TRUE;
				}
				flyer_explosion ++;
				timerStart(5, wait);
			}
		}
		break;
	case D_EXPLOSION_SPRITE:
		////////////
		i = spriteNum;

		wait = 2;
		y = sprite[i].y - 32;
		x = sprite[i].x;

		//if (sprite[i].active == FALSE) return;

		add = 0;

		if(scrollx < sprite[i].x + PLATFORM_WIDTH) {
			add = 0;
		}
		else if (scrollx >= sprite[i].x ) {
			add = level_w * 8;
		}


		if (spriteTimerDone(i)) {

			//LOGE("explosion %d ", flyer_explosion);

			switch (sprite[i].quality_3) {
			case 0:
				drawSprite_64(explosion_a, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

				break;
			case 1:
				drawSprite_64(explosion_b, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

				break;

			case 2:
				drawSprite_64(explosion_c, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

				break;
			case 3:
				drawSprite_64(explosion_d, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

				break;
			case 4:
				drawSprite_64(explosion_e, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

				break;
			case 5:
				drawSprite_64(explosion_f, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

				break;

			case 6:
				drawSprite_64(explosion_g, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

				break;
			case 7:
				drawSprite_64(explosion_h, x + add, y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
				//sprite[i].active = FALSE;
				break;
			}
			if (sprite[i].quality_3 > 7) {
				//sprite[i].quality_3 = -1;
				//endlevel = TRUE;
				//gamedeath = TRUE;
				sprite[i].active = FALSE;
				sprite[i].sprite_type = S_NONE;
			}
			sprite[i].quality_3 ++;
			spriteTimerStart(i, wait);
			//}
		}
		///////////
		break;

	case D_CLOUD:
		i = spriteNum;
		 if(scrollx < sprite[i].x + PLATFORM_WIDTH) {
				drawSprite_40_8(platform_a, sprite[i].x, sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
		  }
		  else if (scrollx >= sprite[i].x ) {
				drawSprite_40_8(platform_a, (level_w * 8) + sprite[i].x, sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, 0);

		  }

		break;
	case D_GATOR:
		//
		i = spriteNum;
		sprite[i].animate ++;
		if (sprite[i].animate > anim_speed * 4) sprite[i].animate=0;
		if (sprite[i].animate > anim_speed * 2) z = 1;
		else z = 0;


		if(sprite[i].visible == TRUE ) {
			if (scrollx < sprite[i].x + PLATFORM_WIDTH) {

				if(sprite[i].facingRight == TRUE) {
					if(z == 0) {

						drawSprite_16(monster_a, sprite[i].x, sprite[i].y,
							scrollx, scrolly, PAINT_TRANSPARENT, 0);

					}
					else if (z == 1) {

						drawSprite_16(monster_b, sprite[i].x, sprite[i].y,
							scrollx, scrolly, PAINT_TRANSPARENT, 0);
					}
				}
				else if (!sprite[i].facingRight == TRUE) {
					if(z == 0) {

						drawSprite_16(monster_c, sprite[i].x, sprite[i].y,
							scrollx, scrolly, PAINT_TRANSPARENT, 0);
					}
					else if (z == 1) {

						drawSprite_16(monster_d, sprite[i].x, sprite[i].y,
							scrollx, scrolly, PAINT_TRANSPARENT, 0);
					}
				}
			}
			else if (scrollx >= sprite[i].x ) {
				if(sprite[i].facingRight == TRUE) {
					if(z == 0) {

						drawSprite_16(monster_a,(level_w * 8) + sprite[i].x, sprite[i].y,
							scrollx, scrolly, PAINT_TRANSPARENT, 0);

					}
					else if (z == 1) {

						drawSprite_16(monster_b,(level_w * 8) + sprite[i].x, sprite[i].y,
							scrollx, scrolly, PAINT_TRANSPARENT, 0);
					}
				}
				else if (!sprite[i].facingRight == TRUE) {
					if(z == 0) {

						drawSprite_16(monster_c,(level_w * 8) + sprite[i].x, sprite[i].y,
							scrollx, scrolly, PAINT_TRANSPARENT, 0);
					}
					else if (z == 1) {

						drawSprite_16(monster_d,(level_w * 8) + sprite[i].x, sprite[i].y,
							scrollx, scrolly, PAINT_TRANSPARENT, 0);
					}
				}
			}
		}
		//
		break;
	case D_INVADER_1:
		/////////////
		i = spriteNum;

		drawRadarPing(radar_box, sprite[i].x , sprite[i].y , PING_OTHER,  0xf000);


		if (!sprite[i].facingRight) {
			if ( scrollx + SCREEN_WIDTH > (level_w * 8)&& sprite[i].x < scrollx ) {
				drawSprite_16(invader1_l, sprite[i].x + (level_w * 8), sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, number_alpha);
				//LOGE("INVADER ADJUSTED %d", flyer.animate);

			}
			else {
				drawSprite_16(invader1_l, sprite[i].x , sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, number_alpha);
				//LOGE("INVADER not adjusted");

			}

		}
		else {
			if ( scrollx + SCREEN_WIDTH > (level_w * 8) && sprite[i].x < scrollx ) {
				drawSprite_16(invader1_r, sprite[i].x + (level_w * 8), sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, number_alpha);
			}
			else {
				drawSprite_16(invader1_r, sprite[i].x, sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, number_alpha);
			}

		}
		/////////////
		break;
	case D_INVADER_2:
		///////////////
		// draw rollee
		i = spriteNum;

		drawRadarPing(radar_box, sprite[i].x , sprite[i].y , PING_OTHER,  0x0f00);


		if (flyer.animate == 0 || flyer.animate == 2) {
			if ( scrollx + SCREEN_WIDTH > (level_w * 8) && sprite[i].x < scrollx) {
				drawTile_8(rollee1_a, sprite[i].x + (level_w * 8), sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, 0x0000);
			}
			else {
				drawTile_8(rollee1_a, sprite[i].x , sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, 0x0000);

			}

		}
		else {
			if ( scrollx + SCREEN_WIDTH > (level_w * 8)  && sprite[i].x < scrollx) {
				drawTile_8(rollee1_b, sprite[i].x + (level_w * 8), sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, 0x0000);
			}
			else {
				drawTile_8(rollee1_b, sprite[i].x, sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, 0x0000);

			}

		}
		///////////////

		break;
	case D_INVADER_3:
		break;
	case D_FLYER_RINGS:
		if (animate == 0 || animate == 1 || animate == 8) {

			cutTile(tiles_a, square, B_PRIZE - levelcheat );
		}
		else if (animate == 2 || animate == 4 || animate == 6) {

			cutTile(tiles_b, square, B_PRIZE - levelcheat);
		}
		else if (animate == 3 || animate == 7) {

			cutTile(tiles_c, square, B_PRIZE -levelcheat);
		}
		else if (animate == 5) {

			cutTile(tiles_d, square, B_PRIZE - levelcheat);
		}


		add = 0;

		if(scrollx < flyer.x ) {
			add = 0;
		}
		else if (scrollx >= flyer.x ) {
			add = level_w * 8;
		}

		max_rings = total_held_rings;
		if (max_rings > 3) max_rings = 3;

		for (x = 0; x < max_rings; x ++ ) {
			drawTile_8(square, flyer.x + add + ( x * 9), flyer.y + flyer.bottomBB - 3 ,
					scrollx , scrolly, PAINT_TRANSPARENT, 0);
		}

		break;
	}
}



/**
 * Used by bubble drawing function to draw horizontal lines that make up
 * solid colored bubble.
 */
void drawHorizontal(int y, int start_x, int stop_x, uint16_t color, int type) {

	int i,j;
	uint16_t  *  screen =(void *) (getScreenPointer(MY_SCREEN_BACK));

	i = y;

	if(type == PAINT_SOLID ) {
		for (j = start_x; j <= stop_x; j ++	 ) {

			if ( (i - scrolly) >= 0 && (j -scrollx) >= 0 && (i-scrolly) < SCREEN_HEIGHT  && (j-scrollx) <  SCREEN_WIDTH ) {
				screen[(( i - scrolly ) * SCREEN_WIDTH )  +(j - scrollx ) ] = color;
			}
		}
	}
	else if (type == PAINT_TRANSPARENT ) {
		j = start_x;
		if ( (i - scrolly) >= 0 && (j -scrollx) >= 0 && (i-scrolly) < SCREEN_HEIGHT  && (j-scrollx) <  SCREEN_WIDTH ) {
			screen[(( i - scrolly ) * SCREEN_WIDTH )  +(j - scrollx ) ] = color;

		}
		j = stop_x;
		if ( (i - scrolly) >= 0 && (j -scrollx) >= 0 && (i-scrolly) < SCREEN_HEIGHT  && (j-scrollx) <  SCREEN_WIDTH ) {
			screen[(( i - scrolly ) * SCREEN_WIDTH )  +(j - scrollx ) ] = color;

		}
	}


}



/**
 * used to tint screen during landing alert
 */

void alertOnScreen() {

	if(timerDone(1)) {
		alert_color = 0x0;

	}
}

/**
 * Used to check weather all the challenges on a level have
 * been faced. Returns TRUE if all have been faced.
 *
 * @return	true if level is over.
 */
BOOL checkTotalsAllCleared() {
	int test = TRUE;
	if ( 	total_rings +
			total_bubble_0 +
			total_bubble_1 +
			total_bubble_2 +
			total_bubble_3 +
			total_invader_1 +
			total_invader_2 +
			total_invader_3
			> 0 ||
			total_placed_bubble_1 < challenge[current_challenge].bubble_1 ||
			total_placed_bubble_2 < challenge[current_challenge].bubble_2 ||
			total_placed_invader_1 < challenge[current_challenge].invader_1
			) {
		test = FALSE;
	}
	return test;
}


/**
 * Used to add an explosion instance to the sprite list.
 */
void add_explosion( Sprite sprite ) {
	Sprite new;
	new.x = sprite.x;
	new.y = sprite.y;
	new.sprite_type = S_EXPLOSION_SPRITE;
	new.quality_3 = 0;
	new.quality_0 = 0;
	new.quality_1 = 0;
	new.quality_2 = 0;
	new.active = TRUE;
	addSprite(new);
}



