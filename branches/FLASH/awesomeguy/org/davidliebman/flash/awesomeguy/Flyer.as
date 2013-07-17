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



/* SOUND MANAGEMENT */

/**
 *	Sets a flag that is responsible for reporting to the Java code that the
 *	'ow' sound needs to be played.
 */
void setSoundOw() {
	sound_ow = TRUE;
}

/**
 *	Sets a flag that is responsible for reporting to the Java code that the
 *	'prize' sound needs to be played.
 */
void setSoundPrize() {
	sound_prize = TRUE;
}

/**
 *	Sets a flag that is responsible for reporting to the Java code that the
 *	'boom' sound needs to be played.
 */
void setSoundBoom() {
	sound_boom = TRUE;
}

/**
 *  Sets a flag so that the 'goal' sound is played.
 */
void setSoundGoal() {
	sound_goal = TRUE;
}

/**
 *  Sets a flag so that the 'enter_1' sound is played.
 */
void setSoundEnter1() {
	sound_enter_1 = TRUE;
}

/**
 *  Sets a flag so that the 'enter_2' sound is played.
 */
void setSoundEnter2() {
	sound_enter_2 = TRUE;
}
/**
 *  Sets a flag so that the 'enter_3' sound is played.
 */
void setSoundEnter3() {
	sound_enter_3 = TRUE;
}
/**
 *  Sets a flag so that the 'enter_4' sound is played.
 */
void setSoundEnter4() {
	sound_enter_4 = TRUE;
}
/**
 *	Returns the flag that is responsible for reporting to the Java code that the
 *	'ow' sound needs to be played.
 *
 *	@return		int ow sound flag
 */
int getSoundOw() {
	int temp = sound_ow;
	sound_ow = FALSE;
	return temp;
}

/**
 *	Returns the flag that is responsible for reporting to the Java code that the
 *	'prize' sound needs to be played.
 *
 *	@return		int prize sound flag
 */
int getSoundPrize() {
	int temp = sound_prize;
	sound_prize = FALSE;
	return temp;
}

/**
 *	Returns the flag that is responsible for reporting to the Java code that the
 *	'boom' sound needs to be played.
 *
 *	@return		int boom sound flag
 */
int getSoundBoom() {
	int temp = sound_boom;
	sound_boom = FALSE;
	return temp;
}

/**
 * Returns flag to java so that the 'goal' sound is played.
 */
int getSoundGoal() {
	int temp = sound_goal;
	sound_goal = FALSE;
	return temp;
}

/**
 * Returns flag to java so that the 'enter_1' sound is played.
 */
int getSoundEnter1() {
	int temp = sound_enter_1;
	sound_enter_1 = FALSE;
	return temp;
}

/**
 * Returns flag to java so that the 'enter_2' sound is played.
 */
int getSoundEnter2() {
	int temp = sound_enter_2;
	sound_enter_2 = FALSE;
	return temp;
}

/**
 * Returns flag to java so that the 'enter_3' sound is played.
 */
int getSoundEnter3() {
	int temp = sound_enter_3;
	sound_enter_3 = FALSE;
	return temp;
}

/**
 * Returns flag to java so that the 'enter_4' sound is played.
 */
int getSoundEnter4() {
	int temp = sound_enter_4;
	sound_enter_4 = FALSE;
	return temp;
}


/* NEED INTERFACE WITH JAVA */

/**
 *	Collects 1D arrays representing the four tile maps and passes them 
 *	individually to the functions that store them in 2D arrays for the later
 *	use of the library. Used to basically initializes tilemap arrays when Panel
 *	is created.
 *
 *	@param	a	1D integer array of tile map data
 *	@param	b	1D integer array of tile map data
 *	@param	c	1D integer array of tile map data
 *	@param	d	1D integer array of tile map data
 */
void setTileMapData(jint a[], jint b[], jint c[], jint d[] ) {


	copyArraysExpand_tileset(a, TILEMAP_WIDTH * TILEMAP_HEIGHT, tiles_a);
	copyArraysExpand_tileset(b, TILEMAP_WIDTH * TILEMAP_HEIGHT, tiles_b);
	copyArraysExpand_tileset(c, TILEMAP_WIDTH * TILEMAP_HEIGHT, tiles_c);
	copyArraysExpand_tileset(d, TILEMAP_WIDTH * TILEMAP_HEIGHT, tiles_d);
	
}
 
/**
 *	Collects 1D arrays representing the four guy sprites and passes them 
 *	individually to the functions that store them in 2D arrays for the later
 *	use of the library. Used to basically initializes guy sprite arrays when 
 *	Panel is created.
 *
 *	@param	a	1D integer array of guy sprite data
 *	@param	b	1D integer array of guy sprite data
 *	@param	c	1D integer array of guy sprite data
 *	@param	d	1D integer array of guy sprite data
 */
void setGuyData(jint a[], jint b[], jint c[], jint d[] ) {
            
	copyArraysExpand_16(a, GUY_WIDTH * GUY_HEIGHT, guy_a);
	copyArraysExpand_16(b, GUY_WIDTH * GUY_HEIGHT, guy_b);
	copyArraysExpand_16(c, GUY_WIDTH * GUY_HEIGHT, guy_c);
	copyArraysExpand_16(d, GUY_WIDTH * GUY_HEIGHT, guy_d);
	
}
 
/**
 * Collects 1D arrays representing the two invader1 sprites and passes them
 * individually to the functions that store them in 2D arrays for the later
 * use of the library.
 *
 * @param	a	1D integer array of invader sprite data
 * @param	b	1D integer array of invader sprite data
 *
 */
void setInvader1Data(jint a[], jint b[]){

	copyArraysExpand_16(a, GUY_WIDTH * GUY_HEIGHT, invader1_l);
	copyArraysExpand_16(b, GUY_WIDTH * GUY_HEIGHT, invader1_r);
}

/**
 * Collects 1D arrays representing the two invader2 sprites and passes them
 * individually to the functions that store them in 2D arrays for the later
 * use of the library.
 *
 * @param	a	1D integer array of invader sprite data
 * @param	b	1D integer array of invader sprite data
 *
 */
void setInvader2Data(jint a[], jint b[]){

	copyArraysExpand_8(a, 8 * 8, rollee1_a);
	copyArraysExpand_8(b, 8 * 8, rollee1_b);
}

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
 *	Collects 1D arrays representing the four monster sprites and passes them 
 *	individually to the functions that store them in 2D arrays for the later
 *	use of the library. Used to basically initializes monster sprite arrays 
 *	when Panel is created.
 *
 *	@param	a	1D integer array of monster sprite data
 *	@param	b	1D integer array of monster sprite data
 *	@param	c	1D integer array of monster sprite data
 *	@param	d	1D integer array of monster sprite data
 */ 
 
void setMonsterData(jint a[], jint b[], jint c[], jint d[] ) {


	copyArraysExpand_16(a, MONSTER_WIDTH * MONSTER_HEIGHT, monster_a);
	copyArraysExpand_16(b, MONSTER_WIDTH * MONSTER_HEIGHT, monster_b);
	copyArraysExpand_16(c, MONSTER_WIDTH * MONSTER_HEIGHT, monster_c);
	copyArraysExpand_16(d, MONSTER_WIDTH * MONSTER_HEIGHT, monster_d);
}
 
/**
 *	Collects 1D arrays representing the eight explosion sprites and passes them
 *	individually to the functions that store them in 2D arrays for the later
 *	use of the library. Used to basically initializes monster sprite arrays
 *	when Panel is created.
 *
 *	@param	a	1D integer array of explosion sprite data
 *	@param	b	1D integer array of explosion sprite data
 *	@param	c	1D integer array of explosion sprite data
 *	@param	d	1D integer array of explosion sprite data
 *	@param	e	1D integer array of explosion sprite data
 *	@param	f	1D integer array of explosion sprite data
 *	@param	g	1D integer array of explosion sprite data
 *	@param	h	1D integer array of explosion sprite data
 */
void setExplosionData(jint a[], jint b[], jint c[], jint d[] ,jint e[], jint f[], jint g[], jint h[] ) {

	copyArraysExpand_64(a, EXPLOSION_WIDTH * EXPLOSION_HEIGHT, explosion_a);
	copyArraysExpand_64(b, EXPLOSION_WIDTH * EXPLOSION_HEIGHT, explosion_b);
	copyArraysExpand_64(c, EXPLOSION_WIDTH * EXPLOSION_HEIGHT, explosion_c);
	copyArraysExpand_64(d, EXPLOSION_WIDTH * EXPLOSION_HEIGHT, explosion_d);
	copyArraysExpand_64(e, EXPLOSION_WIDTH * EXPLOSION_HEIGHT, explosion_e);
	copyArraysExpand_64(f, EXPLOSION_WIDTH * EXPLOSION_HEIGHT, explosion_f);
	copyArraysExpand_64(g, EXPLOSION_WIDTH * EXPLOSION_HEIGHT, explosion_g);
	copyArraysExpand_64(h, EXPLOSION_WIDTH * EXPLOSION_HEIGHT, explosion_h);
}


/**
 *	Collects 1D array representing the floating platform sprite and passes it 
 *	individually to the function that stores it in 2D arrays for the later
 *	use of the library. Used to basically initialize platform sprite arrays 
 *	when Panel is created.
 *
 *	@param	a	1D integer array of monster sprite data
 */ 
void setMovingPlatformData(jint a[]) {
	copyArraysExpand_8_40( a, PLATFORM_WIDTH * PLATFORM_HEIGHT, platform_a);
}

/**
 *	Collects 1D arrays representing the two level definition arrays and converts 
 *	them individually to 2D arrays for the later use of the library. Used to 
 *	basically initializes the two background arrays when the Panel is created.
 *
 *	@param	a	1D integer array of background definition level data
 *	@param	b	1D integer array of background definition objects data
 */ 
void setLevelData(int a[MAP_HEIGHT * MAP_WIDTH],  int b[MAP_HEIGHT * MAP_WIDTH]) {


	int i,j;
	game_level ++;
	candidate_num = 0;
	challenge_num = 0;
	current_challenge = 0;
	is_landing = FALSE;
	
	srand(time(NULL));

	for (i = 0 ; i < LONG_MAP_V ; i ++ ) {
		for (j = 0; j < LONG_MAP_H ; j ++ ) {
			map_level[j][i] = a[ (j * LONG_MAP_V ) + i] ;
			map_objects[j][i] = b[ (j * LONG_MAP_V ) + i] ;
			//LOGE("level data %i ", map_level[i][j]);

			if (map_objects[j][i] == B_PRIZE) {
				candidate[candidate_num].x = j;
				candidate[candidate_num].y = i;
				candidate[candidate_num].value = B_SPACE;
				candidate[candidate_num].type = B_PRIZE;
				map_objects[j][i] = candidate[candidate_num].value;
				candidate_num ++;
			}
		}
	}
	
	for (i = 0; i< 100; i ++) {
		sprite[i].x = 0;
		sprite[i].y = 0;
		sprite[i].animate = 0;
		sprite[i].facingRight = FALSE;
		sprite[i].active = FALSE;
		sprite[i].visible = FALSE;
		sprite[i].leftBB = 0;
		sprite[i].rightBB = 0;
		sprite[i].topBB = 0;
		sprite[i].bottomBB = 0;
		sprite[i].sprite_type = S_NONE;
		sprite[i].quality_0 = 0;
		sprite[i].quality_1 = 0;
		sprite[i].quality_2 = 0;
		sprite[i].radius = 0;
	}
	monster_num = 0;
	sprite_num = 0;
	platform_num = -1;
	
	//some bogus challenge data:
	challenge_num = 0;
	current_challenge = 0;
	endlevel = FALSE;
	gamedeath = FALSE;
	//addChallenges(3,0,0,0, 0,0,0,1);

	//clear the total_stuff variables
	total_rings = 0;
	total_bubble_0 = 0;
	total_bubble_1 = 0;
	total_bubble_2 = 0;
	total_bubble_3 = 0;
	total_invader_1 = 0;
	total_invader_2 = 0;
	total_invader_3 = 0;


	radar_box.left =(256 - LONG_MAP_H)/ 2 ;
	radar_box.right = ((256 - LONG_MAP_H) / 2) + LONG_MAP_H;
	radar_box.top = (256 * 3 / 4) - LONG_MAP_V ;
	radar_box.bottom = (256 * 3 / 4) - 1;

	radar_set = FALSE;

	for (i = 0; i < TORPEDO_TOTAL; i ++ ) {
		torpedos[i].active = FALSE;
		torpedos[i].visible = FALSE;
		torpedos[i].sprite_type = TORPEDO_UNUSED;
	}

	return;
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
 * used to place challenges at the beginning of a level (or part of a level)
 */

void placeChallengesRings() {
	int i,j, k;
	int num_rings, num_spaces;

	total_held_rings = 0;

	//the first challenges to place are the rings.
	num_rings = challenge[current_challenge].rings;
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
		map_objects[candidate[i].x][candidate[i].y] = candidate[i].value;
		if (candidate[i].value == B_PRIZE) total_rings ++;
	}
	for( i = 0; i < 20; i ++ ) {

		candidate[i].value = B_SPACE;
		candidate[i].type = B_PRIZE;
	}


	// DO THIS LAST
	//current_challenge ++;
}

/**
 *  Used to place lightning strikes. These strikes cause bubble1 circles to be
 *  drawn to the screen.
 */
void placeChallengesBubble1() {
	total_placed_bubble_1 = 0;
	timerStart(2, 30 * 1); // about a second
}

/**
 * Cause bubble2 circles to be drawn to the screen.
 */
void placeChallengesBubble2() {
	total_placed_bubble_2 = 0;
	timerStart(3, 30 * 2);
}

/**
 * Cause invader1 sprites to be drawn on screen.
 */
void placeChallengesInvader1() {
	total_placed_invader_1 = 0;
	timerStart(4, 30 * 2);
}


/**
 * Cause invader2 sprites to be drawn on screen.
 */
void placeChallengesInvader2() {
	total_placed_invader_2 = 0;
	timerStart(6, 30 * 2);
}


/**
 *	Used repeatedly by the Panel to set the position of the guy sprite and to
 *	set the scrollx and scrolly values for the background. The value of the
 *	guy sprite's animation index is also set.
 *
 *	@param	guy_x		x position of the guy sprite in pixels
 *	@param	guy_y		y position of the guy sprite in pixels
 *	@param	scroll_x	x scroll position of the background in pixels
 *	@param	scroll_y	y scroll position of the background in pixels
 *	@param	guy_animate	guy sprite animation index
 */ 
void setGuyPosition(int guy_x, int guy_y, int scroll_x, int scroll_y, int guy_animate) {


	guy.x = guy_x;
	guy.y = guy_y;
	guy.animate = guy_animate;
	animate = guy_animate;
	scrollx = scroll_x;
	scrolly = scroll_y;
	
	flyer.x = guy_x;
	flyer.y = guy_y;
	flyer.animate = guy_animate;
	
	set_radar_start(flyer.x);

}
 
/**
 *	Used repeatedly by the Panel to set the score and number of lives to be 
 *	displayed on the screen
 *
 *	@param	a_score	score to be displayed on screen
 *	@param	a_lives	lives to be displayed on screen
 */ 
void setScoreLives(int a_score, int a_lives) {

    score = a_score;
    lives = a_lives;
}


/**
 *	Used repeatedly by the Panel to set a single background objects cell to a 
 *	desired value. Used to remove objects from level when the character takes 
 *	them
 *
 *	@param	map_x	x position of the cell to change
 *	@param	map_y	y position of the cell to change
 *	@param	value	value to assign to cell
 */ 
void setObjectsDisplay(int map_x, int map_y, int value) {
	map_objects[map_x][ map_y ] = value;
} 

/**
 *	Used by the Panel to initialize a monster's sprite object in a list
 *	of sprites at the beginning of each level. All sprites for monsters 
 *	must be added together before sprites for moving platforms.
 *
 *	@param	monster_x		x position of the monster sprite in pixels
 *	@param	monster_y		y position of the monster sprite in pixels
 *	@param	monster_animate	monster sprite animation index
 */ 
void addMonster(int monster_x, int monster_y, int monster_animate) {



    sprite[sprite_num].x = monster_x ;
    sprite[sprite_num].y = monster_y ;
    sprite[sprite_num].animate = monster_animate;
    sprite[sprite_num].facingRight = TRUE;
    sprite[sprite_num].active = TRUE;
    sprite[sprite_num].visible = TRUE;
      
    sprite[sprite_num].topBB = 3; 
	sprite[sprite_num].bottomBB = 8;
	sprite[sprite_num].leftBB = 0;
	sprite[sprite_num].rightBB = 16;

	sprite[sprite_num].sprite_type = S_GATOR;
      
    sprite_num ++;
    monster_num = sprite_num;
    platform_num = 0;
}
 
 
/**
 *	Used repeatedly by the Panel to inactivate a monster sprite object.
 *
 *	@param	num	index for the monster to inactivate
 */  
void inactivateMonster(int num) {
	if (num < sprite_num) {
		sprite[num].active = FALSE;
	}
} 

/**

 *	Used by the Panel to initialize a platform's sprite object in a list
 *	of sprites at the beginning of each level. All sprites for monsters 
 *	must be added together before sprites for moving platforms.
 *
 *	@param	platform_x		x position of the monster sprite in pixels
 *	@param	platform_y		y position of the monster sprite in pixels
 */ 
void addPlatform(int platform_x, int platform_y) {



    sprite[sprite_num].x = platform_x ;
    sprite[sprite_num].y = platform_y ;
    sprite[sprite_num].animate = 0;
    sprite[sprite_num].facingRight = TRUE;
    sprite[sprite_num].active = TRUE;
    sprite[sprite_num].visible = TRUE;
      
    sprite[sprite_num].topBB = 0; 
	sprite[sprite_num].bottomBB = 8;
	sprite[sprite_num].leftBB = 0;
	sprite[sprite_num].rightBB = 40;

	sprite[sprite_num].sprite_type = S_CLOUD;
      
    sprite_num ++;
    platform_num = sprite_num;
}

/* INTERNAL USE ONLY */

/**
 *	Used by monster code to make monsters at once visible, but not active.
 *
 *	@param	number 	index for the monster to make invisible
 */
void inactivateMonsterView(int num) {
	if (num < sprite_num) {
		sprite[num].visible = FALSE;
	}
}

/**
 * used to add sprite to sprite list
 */
void addSprite(Sprite temp) {

	memcpy( &sprite[sprite_num], &temp, sizeof(Sprite));

	//sprite[sprite_num] = temp;
	sprite_num ++;
}

/**
 *	Used for monster collision function
 *
 *	@param	sprite	a sprite struct
 *	@param	x		an x offset
 *	@param	y		a y offset
 *	@return			the bounding box for the sprite
 */
BoundingBox makeSpriteBox(Sprite sprite, int x, int  y) {
  x = adjust_x (x);
  BoundingBox temp;
  temp.left = adjust_x(sprite.leftBB + sprite.x + x);
  temp.right = adjust_x(sprite.rightBB + sprite.x + x);
  temp.top = sprite.topBB + sprite.y + y;
  temp.bottom = sprite.bottomBB + sprite.y + y;


  return temp;
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
 *	Used to copy 16x16 pixel sprite information from the 1D representation that
 *	is used by the java app to the 2D representation that is used by this
 *	library
 *
 *	@param	from	1D array of sprite data pixels
 *	@param	size_l	size in pixels of 'from' array
 *	@param	to		2D array of sprite data used by library
 */
void copyArraysExpand_8(jint from[], int size_l, uint16_t to[8][8]) {


	int i,j, k;
	for (i = 0; i< 8; i ++ ) {
		for (j = 0; j < 8; j ++ ) {
			k =( i * 8 ) + j;
			if ( k < size_l ) {
				to[i][j] = (uint16_t) from[k];
				//LOGE("many assignments here %i", from[k]);
			}
		}
	}
	return;
}


/**
 *	Used to copy 16x16 pixel sprite information from the 1D representation that
 *	is used by the java app to the 2D representation that is used by this 
 *	library
 *
 *	@param	from	1D array of sprite data pixels
 *	@param	size_l	size in pixels of 'from' array
 *	@param	to		2D array of sprite data used by library
 */
void copyArraysExpand_16(jint from[], int size_l, uint16_t to[GUY_WIDTH][GUY_HEIGHT]) {


	int i,j, k;
	for (i = 0; i< GUY_HEIGHT; i ++ ) {
		for (j = 0; j < GUY_WIDTH; j ++ ) {
			k =( i * GUY_WIDTH ) + j;
			if ( k < size_l ) {
				to[i][j] = (uint16_t) from[k];
				//LOGE("many assignments here %i", from[k]);
			}
		}
	}
	return;
}

/**
 *	Used to copy 16x40 pixel sprite information from the 1D representation that
 *	is used by the java app to the 2D representation that is used by this 
 *	library
 *
 *	@param	from	1D array of sprite data pixels
 *	@param	size_l	size in pixels of 'from' array
 *	@param	to		2D array of sprite data used by library
 */
void copyArraysExpand_16_40(jint from[], int size_l, uint16_t to[FLYER_WIDTH][FLYER_HEIGHT]) {

	uint16_t color;
	int i,j, k;
	for (i = 0; i< FLYER_WIDTH; i ++ ) {
		for (j = 0; j < FLYER_HEIGHT; j ++ ) {
			k =( i * FLYER_HEIGHT ) + j;
			if ( k < size_l ) {
				//to[i][j] = (uint16_t) from[k];//i,j
				//LOGE("many assignments here %i", from[k]);

				color = color_pixel(from[k]);
				if (color != 0xfff0 && color < 0x9000 && color != 0x0000) { // if not white, black or some kind of red
					color = 0x00f0; // must be blue
				}

				to[i][j] = color;

			}
		}
	}
	return;
}

/**
 *	Used to copy 40x8 pixel sprite information from the 1D representation that
 *	is used by the java app to the 2D representation that is used by this 
 *	library
 *
 *	@param	from	1D array of sprite data pixels
 *	@param	size_l	size in pixels of 'from' array
 *	@param	to		2D array of sprite data used by library
 */
void copyArraysExpand_8_40(jint from[], int size_l, uint16_t to[PLATFORM_HEIGHT][PLATFORM_WIDTH]) {

	int i,j, k;
	for (i = 0; i< PLATFORM_HEIGHT; i ++ ) {
		for (j = 0; j < PLATFORM_WIDTH; j ++ ) {
			k =( i * PLATFORM_WIDTH ) + j;
			if ( k < size_l ) {
				to[i][j] = from[k];
			}
		}
	}
	return;

}
/**
 *	Used to copy 64x64 pixel sprite information from the 1D representation that
 *	is used by the java app to the 2D representation that is used by this
 *	library
 *
 *	@param	from	1D array of sprite data pixels
 *	@param	size_l	size in pixels of 'from' array
 *	@param	to		2D array of sprite data used by library
 */
void copyArraysExpand_64(jint from[], int size_l, uint16_t to[EXPLOSION_HEIGHT][EXPLOSION_WIDTH]) {

	int i,j, k;
	for (i = 0; i< EXPLOSION_HEIGHT; i ++ ) {
		for (j = 0; j < EXPLOSION_WIDTH; j ++ ) {
			k =( i * EXPLOSION_WIDTH ) + j;
			if ( k < size_l ) {
				to[i][j] = from[k];
			}
		}
	}
	return;

}
/**
 *	Used to copy tilesheet pixel information from the 1D representation that
 *	is used by the java app to the 2D representation that is used by this 
 *	library
 *
 *	@param	from	1D array of tilesheet data pixels
 *	@param	size_l	size in pixels of 'from' array
 *	@param	to		2D array of tilesheet data used by library
 */
void copyArraysExpand_tileset (jint from[], int size_l, uint16_t to[TILEMAP_HEIGHT][TILEMAP_WIDTH]) {

	int num, n, l;
	int i,j, k;
	for (i = 0; i< TILEMAP_HEIGHT; i ++ ) {
		for (j = 0; j < TILEMAP_WIDTH; j ++ ) {
			k =( i * TILEMAP_WIDTH ) + j;
			if ( k < size_l ) {
			
			uint16_t temp = from[k];
			uint16_t a = (temp & 0xf000) >> 12;
			uint16_t r = (temp & 0x0f00) >> 8;
			uint16_t g = (temp & 0x00f0) >> 4;
			uint16_t b = (temp & 0x000f) ;
			
			to[i][j] = RGBA4444(b,a,r,g);
			//to[i][j] =  from[k];
			}
		}
	}
	n = TILEMAP_WIDTH / TILE_HEIGHT; // 224/8 = 28
	num = 374;
	k = (num / n); // y pos 
	l = num - (k * n); // x pos
	number_alpha = to[k * 8][l * 8];
	return;
}

/**
 *	Used to draw a 16x16 sprite on the library's 2D screen array at a certian
 *	position, given a certian scroll adjustment. If 'paint_all' is used, the 
 *	color in 'extra' is skipped during drawing.
 *
 *	@param	from		16x16, 2D sprite pixel data to be drawn
 *	@param	x			x position of the 2D sprite on the screen array
 *	@param	y			y position of the 2D sprite on the screen array
 *	@param	scroll_x	x scroll adjustment for the 2D screen array
 *	@param	scroll_y	y scroll adjustment for the 2D screen array
 *	@param	paint_all	integer constant to determine if entire sprite should be
 *						painted
 *	@param	extra		color value to skip if 'paint_all' function is used
 */
void drawSprite_16(uint16_t from[GUY_WIDTH][GUY_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) {


    	uint16_t  * screen =(void *) getScreenPointer(MY_SCREEN_BACK);

    	uint16_t color;
    int i,j,k,l;
    k = x - scroll_x;
    l = y - scroll_y;
    for (i = 0; i < GUY_HEIGHT; i ++ ) {
    	for (j = 0; j < GUY_WIDTH; j ++) {
    		if ( (i + l) >= 0 && (j + k) >= 0 && (j+k) < SCREEN_WIDTH && (i+l) < SCREEN_HEIGHT ) {
    			
    			if (paint_all == PAINT_TRANSPARENT && from[i][j] == extra ) {
    				
    			}
    			else {

    				screen[((l + i) * SCREEN_WIDTH )  +(j +k ) ] = color_pixel(from[i][j]);
    				//screen[((l + i) * SCREEN_WIDTH )  +(j +k ) ] = (from[i][j]);
//    				color = color_pixel(from[i][j]);
//					if (color != 0xfff0 && color < 0x9000 && color != 0x0000) { // if not white or black
//						color = 0x00f0; // must be blue
//					}
//
//    				screen[((l + i) * SCREEN_WIDTH )  +(j +k ) ] = (color);
    			}

    		}
    	}
    }
    return;
}
 
 
/**
 *	Used to draw a 64x64 sprite on the library's 2D screen array at a certain
 *	position, given a certain scroll adjustment. If 'paint_all' is used, the
 *	color in 'extra' is skipped during drawing.
 *
 *	@param	from		64x64, 2D sprite pixel data to be drawn
 *	@param	x			x position of the 2D sprite on the screen array
 *	@param	y			y position of the 2D sprite on the screen array
 *	@param	scroll_x	x scroll adjustment for the 2D screen array
 *	@param	scroll_y	y scroll adjustment for the 2D screen array
 *	@param	paint_all	integer constant to determine if entire sprite should be
 *						painted
 *	@param	extra		color value to skip if 'paint_all' function is used
 */
void drawSprite_64(uint16_t from[EXPLOSION_WIDTH][EXPLOSION_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) {


    uint16_t  * screen =(void *) getScreenPointer(MY_SCREEN_BACK);


    int i,j,k,l;
    k = x - scroll_x;
    l = y - scroll_y;
    for (i = 0; i < EXPLOSION_HEIGHT; i ++ ) {
    	for (j = 0; j < EXPLOSION_WIDTH; j ++) {
    		if ( (i + l) >= 0 && (j + k) >= 0 && (j+k) < SCREEN_WIDTH && (i+l) < SCREEN_HEIGHT ) {

    			if (paint_all == PAINT_TRANSPARENT && from[i][j] == extra ) {

    			}
    			else {
	    			//screen[i + l][j + k] = color_pixel( from[i][j]);
    				//LOGE("print explosion");
    				screen[((l + i) * SCREEN_WIDTH )  +(j +k ) ] = color_pixel(from[i][j]);
	    		}

    		}
    	}
    }
    return;
}

/**
 *	Used to draw a 40x8 sprite on the library's 2D screen array at a certian
 *	position, given a certian scroll adjustment. If 'paint_all' is used, the 
 *	color in 'extra' is skipped during drawing.
 *
 *	@param	from		40x8, 2D sprite pixel data to be drawn
 *	@param	x			x position of the 2D sprite on the screen array
 *	@param	y			y position of the 2D sprite on the screen array
 *	@param	scroll_x	x scroll adjustment for the 2D screen array
 *	@param	scroll_y	y scroll adjustment for the 2D screen array
 *	@param	paint_all	integer constant to determine if entire sprite should be
 *						painted
 *	@param	extra		color value to skip if 'paint_all' function is used
 */
void drawSprite_40_8(uint16_t from[PLATFORM_HEIGHT][PLATFORM_WIDTH], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) {
	
	int i,j,k,l;
    	uint16_t  * screen =(void *) getScreenPointer(MY_SCREEN_BACK);
	
    k = x - scroll_x;
    l = y - scroll_y;
    for (i = 0; i < PLATFORM_HEIGHT; i ++ ) {
    	for (j = 0; j < PLATFORM_WIDTH; j ++) {
    		if ( (i + l) >= 0 && (j + k) >= 0 && (j+k) < SCREEN_WIDTH && (i+l) < SCREEN_HEIGHT ) {
    			
    			if (paint_all == PAINT_TRANSPARENT && from[i][j] == extra ) {
    				
    			}
    			else {
	    			//screen[i + l][j + k] =color_pixel( from[i][j]);
				screen[((l + i) * SCREEN_WIDTH )  +(j +k ) ] = color_pixel(from[i][j]);
	    		}

    		}
    	}
    }
    return;
}
 
/**
 *	Used to draw a 40x16 sprite on the library's 2D screen array at a certain
 *	position, given a certain scroll adjustment. If 'paint_all' is used, the
 *	color in 'extra' is skipped during drawing.
 *
 *	@param	from		40x16, 2D sprite pixel data to be drawn
 *	@param	x			x position of the 2D sprite on the screen array
 *	@param	y			y position of the 2D sprite on the screen array
 *	@param	scroll_x	x scroll adjustment for the 2D screen array
 *	@param	scroll_y	y scroll adjustment for the 2D screen array
 *	@param	paint_all	integer constant to determine if entire sprite should be
 *						painted
 *	@param	extra		color value to skip if 'paint_all' function is used
 */
void drawSprite_40_16(uint16_t from[FLYER_HEIGHT][FLYER_WIDTH], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) {
	
	int i,j,k,l;
    	uint16_t  * screen =(void *) getScreenPointer(MY_SCREEN_BACK);
    	uint16_t color;

    k = x - scroll_x;
    l = y - scroll_y;
    for (i = 0; i < FLYER_HEIGHT; i ++ ) {
    	for (j = 0; j < FLYER_WIDTH; j ++) {
    		if ( (i + l) >= 0 && (j + k) >= 0 && (j+k) < SCREEN_WIDTH && (i+l) < SCREEN_HEIGHT ) {
    			
    			if (paint_all == PAINT_TRANSPARENT && from[i][j] == extra ) {
    				//do nothing...
    			}
    			else {


    				screen[((l + i) * SCREEN_WIDTH )  +(j +k ) ] = from[i][j];// i, j
	    		}

    		}
    	}
    }
    return;
}
 
/**
 *	Used to draw a 8x8 tile on the library's 2D screen array at a certian
 *	position, given a certian scroll adjustment. If 'paint_all' is used, the 
 *	color in 'extra' is skipped during drawing.
 *
 *	@param	tile		8x8, 2D sprite pixel data to be drawn
 *	@param	x			x position of the 2D sprite on the screen array
 *	@param	y			y position of the 2D sprite on the screen array
 *	@param	scroll_x	x scroll adjustment for the 2D screen array
 *	@param	scroll_y	y scroll adjustment for the 2D screen array
 *	@param	paint_all	integer constant to determine if entire tile should be
 *						painted
 *	@param	extra		color value to skip if 'paint_all' function is used
 */
void drawTile_8(uint16_t tile[TILE_WIDTH][TILE_HEIGHT], int screen_x, int screen_y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) {
   
    int i,j,m,n;
    uint16_t  *  screen =(void *) (getScreenPointer(MY_SCREEN_BACK));
    
	m = (screen_x ) - scroll_x;

	n = (screen_y ) - scroll_y;

    
    for (i = 0; i < TILE_HEIGHT; i ++ ) {
    	for (j = 0; j < TILE_WIDTH; j ++) {
    		if ( (i + n) >= 0 && (j + m) >= 0 && (i+n) < SCREEN_HEIGHT  && (j+m) <  SCREEN_WIDTH ) {
    			if ( paint_all == PAINT_TRANSPARENT && tile[i][j] == extra ) {
    				//
    			}
    			else {
    			
	    			//screen[i + n ][j + m] = tile[i][j];
	    			//screen[i + n ][j + m] = color_pixel( tile[i][j]);
				screen[((n + i) * SCREEN_WIDTH )  +(j +m ) ] = color_pixel(tile[i][j]);
	    			//LOGE("drawing tile %i", tile[i][j]);
	    		}
    		} 
    	}
    }
    return;
}
/**
 *	Used to isolate a specific 8x8 tile from the tileset array so that it can
 *	be printed on the screen as part of the game's background.
 *
 *	@param	tileset	2D array of tileset pixels
 *	@param	tile	2D array to use as the destination for the 8x8 tile that was
 *					copied
 *	@param	num		the number that indicates which tile to copy from the 
 *					tileset image
 */
void cutTile(uint16_t tileset[TILEMAP_HEIGHT][TILEMAP_WIDTH], uint16_t tile[TILE_HEIGHT][TILE_WIDTH], int num) {


    int i,j,k,l,m,n, p;

    m = TILEMAP_HEIGHT / TILE_HEIGHT; // 128/8 = 16
    n = TILEMAP_WIDTH / TILE_HEIGHT; // 224/8 = 28
    
  
    
    k = (num / n); // y pos 
    l = num - (k * n); // x pos
    for ( i = 0 ; i < TILE_HEIGHT; i ++ ) {
    	for (j = 0; j < TILE_WIDTH; j ++) {
    		p = tileset[i + (k * TILE_WIDTH)][j+(l* TILE_HEIGHT)];

    		tile[i][j] = p;
    		//LOGE("cutting tile %i", tile[i][j]);
    		
    	}
    }
}

/**
 * Used to draw lasers on screen when fire button is pressed.
 */
void drawLasers( ) {


	    uint16_t  *  screen =(void *) (getScreenPointer(MY_SCREEN_BACK));

		///////////////////////////// space out shots, create new shots
		int ii, jj, kk, ll, flag, add;
		flag = FALSE;
		jj = LASER_WIDTH / 4;
		if (keyB) {
			if (timerDone(8)) {

				ii = 0;
				while (ii  < TORPEDO_TOTAL  && flag == FALSE) {

					if (torpedos[ii].active == FALSE && torpedos[ii].sprite_type == TORPEDO_UNUSED) {

						makeTorpedos(ii, flyer.x, flyer.y );
						flag = TRUE;
					} // if active
					ii ++;
				}// while ii
				if (flag == TRUE) timerStart(8, 10);
			}// if timer done


		}// if key B
		//////////////////////////// remove old torpedos
		for (ii = 0; ii < TORPEDO_TOTAL; ii ++) {
			if (torpedosTimerDone(ii)) {
				torpedos[ii].active = FALSE;
				torpedos[ii].visible = FALSE;
				torpedos[ii].sprite_type = TORPEDO_UNUSED;
			}
		}
		//////////////////////////// draw torpedos, etc.
		if (! animate_only ) {
			for (ii = 0; ii < TORPEDO_TOTAL; ii ++ ) {
				if (torpedos[ii].active == TRUE && torpedos[ii].sprite_type == TORPEDO_FLYING) {
					torpedos[ii].limit = torpedos[ii].limit + jj;
				}
				if (torpedos[ii].limit > LASER_WIDTH) {
					torpedos[ii].active = FALSE;
					torpedos[ii].sprite_type = TORPEDO_UNUSED;
				}
				//draw torpedo
				if (torpedos[ii].facingRight && torpedos[ii].active ) { // --- facing right
					for ( kk = torpedos[ii].x ; kk < torpedos[ii].x + torpedos[ii].limit; kk ++) {
						torpedos[ii].rightBB = kk - torpedos[ii].x;
						add = 0;

						if(scrollx < kk ) {
							add = 0;
						}
						else if (scrollx >= kk ) {
							add = level_w * 8;
							//add = scrollx;
						}

						if ( ((torpedos[ii].y - scrolly) >= 0 &&
								(kk -scrollx) >= 0 &&
								(torpedos[ii].y - scrolly) < SCREEN_HEIGHT  &&
								(kk - scrollx) <  SCREEN_WIDTH) ||
								(add != 0 &&  kk- scrollx + add < SCREEN_WIDTH)
								//kk > flyer.x
								)
						{




							//LOGE("lasers %d", add);

							ll = ((torpedos[ii].y - scrolly )* SCREEN_WIDTH )+  kk   - scrollx + add ;
							if (screen[ll] == 0x0000) {
								screen[ll] = 0xffff;
							}

						}
					}
				}
				else if (torpedos[ii].active ) { // --- facing left
					for (kk = torpedos[ii].x; kk > - torpedos[ii].limit + torpedos[ii].x; kk --) {
						torpedos[ii].rightBB = kk - torpedos[ii].x;// right?

						add = 0;

						if(scrollx < kk ) {
							add = 0;
						}
						else if (scrollx >= kk ) {
							add = level_w * 8;
						}

						if ( ( (torpedos[ii].y - scrolly) >= 0 &&
								(kk -scrollx) >= 0 &&
								(torpedos[ii].y - scrolly) < SCREEN_HEIGHT  &&
								(kk - scrollx) <  SCREEN_WIDTH ) ||//&&
								(add != 0 && kk - scrollx + add > 0)
								//kk < flyer.x
								)
						{



							ll = ((torpedos[ii].y - scrolly )* SCREEN_WIDTH )+ kk - scrollx + add;
							if (screen[ll] == 0x0000) {
								screen[ll] = 0xffff;
							}

						}
					}
				}
			}
		}
	    return;
}



/**
 * Used to detect what the laser hits if it hits something
 */

Sprite makeTorpedos(int ii, int x, int y) {

	int change = 0;

	if (is_moving) {
		change = changex;
	}

	if (flyer.facingRight) {
		torpedos[ii].x = adjust_x(x + flyer.rightBB  + change);


	}
	else {
		torpedos[ii].x = adjust_x(x - change);


	}
	torpedos[ii].y = y + LASER_GUN - 1;
	torpedos[ii].leftBB = 0;//torpedos[ii].x ;
	torpedos[ii].rightBB = 1;// was 1
	torpedos[ii].topBB = 0;
	torpedos[ii].bottomBB =  4;//2;
	torpedos[ii].facingRight = flyer.facingRight;
	torpedos[ii].active = TRUE;
	torpedos[ii].visible = TRUE;
	torpedos[ii].sprite_type = TORPEDO_FLYING;
	torpedos[ii].limit = 0;
	torpedosTimerStart(ii, 20);
	//LOGE("torpedo %d", torpedo.x);
	return torpedos[ii];
}

/**
 * Used to detect collision with one of the torpedos.
 */

BOOL collisionTorpedos(BoundingBox test) {
	int ii, flag, jj;
	flag = FALSE;
	for (ii = 0; ii < TORPEDO_TOTAL; ii ++ ) {
		if (torpedos[ii].facingRight ) {
			jj = torpedos[ii].limit;
		}
		else {
			jj = - torpedos[ii].limit;
		}

		if ( (collisionSimple(test, makeSpriteBox(torpedos[ii], 0, 0 ) ) ||
				collisionSimple(makeSpriteBox(torpedos[ii], 0, 0 ) , test)) &&
				torpedos[ii].active){
			flag = TRUE;
			torpedos[ii].sprite_type = TORPEDO_UNUSED;
			torpedos[ii].active = FALSE;
			LOGE("lasers");
		}

	}
	return flag;
}


/**
 *	Used to draw the words 'score' and 'lives' on the library's screen array.
 */
void drawScoreWords() {


		int i;
    	int topScore[] = {374,375,376,377,378,383};

    	int topLives[] = {379,380,381,378,382,383};

    	int scorePos, livesPos;
    	scorePos = 2 ;
    	livesPos = 16  ;
        uint16_t square[TILE_HEIGHT][TILE_WIDTH];
		
		
    	if (guy.y > 16) {
    			//print SCORE:
    			for (i = 0; i < 6; i ++) {
       				cutTile(tiles_a, square, topScore[i]);

    				drawTile_8(square, (scorePos + i) * TILE_WIDTH + scrollx, (1) * TILE_HEIGHT + scrolly, 
    					scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);

       				cutTile(tiles_a, square, topScore[i] +28);

    				drawTile_8(square, (scorePos + i) * TILE_WIDTH  + scrollx, (2) * TILE_HEIGHT + scrolly, 
    					scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
    				

    			}
    			//print LEVEL:
    			for (i = 0; i < 6; i ++) {
    				
    				cutTile(tiles_a, square, topLives[i]);

    				drawTile_8(square, (livesPos + i) * TILE_WIDTH + scrollx, (1) * TILE_HEIGHT + scrolly, 
    					scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);

       				cutTile(tiles_a, square, topLives[i] +28);

    				drawTile_8(square, (livesPos + i) * TILE_WIDTH +scrollx , (2) * TILE_HEIGHT + scrolly , 
    					scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
    				
    				
    			}

    			//print numbers:
    			drawScoreNumbers( scorePos + 6, score  , 7); // score
    			drawScoreNumbers( livesPos + 6, lives , 7); // lives
    	}
    }
 
/**
 *	Used to draw the numbers that represent the player's score and lives next to
 *	the words 'score' and 'lives' on the game's graphics screen.
 *
 *	@param	pos	position of the number on the screen with relation to the word
 *				'lives' or the word 'score'
 *	@param	num	actual numerical value to be used as the score or lives number
 *	@param	p	maximum number of decimal places of 'num'	
 */
void drawScoreNumbers( int pos, int num, int p) {


    
    int i, a, b, c, placesValue;
    	int places[] = {0,0,0,0,0,0,0,0,0,0};//ten spots
    	int topNumbers[] = {364,365,366, 367, 368, 369, 370, 371, 372, 373};
    	int showZeros = 0;
        uint16_t square[TILE_HEIGHT][TILE_WIDTH];

    	for (i = 0; i < 10; i ++) {
    		a = num - (num / 10) * 10;
    		places[9 - i] = a;
    		b = (num / 10) * 10;
    		num = b / 10;
    	}
    	c = 0;
    	for(i = 0; i < p; i ++) {
    		placesValue = places[i + (10 - p)];
    		if (showZeros == 1 || placesValue != 0) {
    			if(placesValue != 0) showZeros = 1;
    			if(showZeros == 1 && c == 0) {
    				c = p - i;
    			}
    			
					cutTile(tiles_a, square, topNumbers[placesValue]);

    				drawTile_8(square, (pos + i - p + c) * TILE_WIDTH + scrollx, (1) * TILE_HEIGHT +
    					scrolly, scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);

       				cutTile(tiles_a, square, topNumbers[placesValue] +28);

    				drawTile_8(square, (pos + i - p + c) * TILE_WIDTH +scrollx , (2) * TILE_HEIGHT +
    					scrolly , scrollx , scrolly, PAINT_TRANSPARENT, number_alpha);
    				
    		}

    	}
}

/**
 * Used to draw monsters on screen.
 */
void drawMonsters() {
	//draw all monsters
	int anim_speed = 5;
	int i;
	int x,y,z;
	int move = 3;//3
	int markerTest = FALSE;
	int hide = TRUE;
	int show = FALSE;
	int visibility = FALSE;
	//int index_num = 0;
	
	//if (sprite_num >= monster_num) index_num = sprite_num;
	//else index_num = monster_num;
	
	//for each monster...
	if(monster_num > 0) {
		for (i =  0 ; i < monster_num   ; i++) {   
			markerTest = FALSE; 

			
			if (sprite[i].active == TRUE ) {
				x = sprite[i].x / 8;
				y = sprite[i].y / 8;
				// Must move and stop monsters when they hit bricks or
				// markers or the end of the screen/room/level.

				if(sprite[i].facingRight == TRUE) {

					sprite[i].x = sprite[i].x + move;
					// marker test
					if( map_objects[x+2][y] == B_BLOCK  ) markerTest = TRUE;
					if( map_objects[x+2][y] == B_MARKER ) markerTest = TRUE;
					if( map_objects[ x+2][y+1] == 0) markerTest = TRUE;
					// turn monster
					if (sprite[i].x > level_w * 8  - 16 || markerTest == TRUE) {

						sprite[i].facingRight=FALSE;
					}
				}
				else {

					sprite[i].x = sprite[i].x - move;
					// marker test
					if(map_objects[x][y] == B_BLOCK) markerTest = TRUE;
					if(map_objects[x][y] == B_MARKER) markerTest = TRUE;
					if(map_objects[x-1][y+1] == 0) markerTest = TRUE;
					// turn monster
					if (sprite[i].x < 0 || markerTest == TRUE) {

						sprite[i].facingRight=TRUE;
					}
				}

				//Only show monsters that are on the screen properly


				//default is to show monster
				visibility = show;
				//hide monster if...
				if(sprite[i].x > scrollx + 32 * 8 + 16 ) {
					visibility = hide;
				}
				if (sprite[i].x < scrollx - 16) {
					visibility = hide;
				}
				if (sprite[i].y > scrolly + 24 * 8 + 16) {
					visibility = hide;
				}
				if ( sprite[i].y < scrolly  - 16) {
					visibility = hide;
				}
			}
	    	
			//swap monsters
			if (sprite[i].visible && visibility == show) sprite[i].visible = TRUE;
			
			drawBasicSprite(i, D_GATOR);


		}

	}
	return;
	
	
}

/**
 *	Used to draw moving platforms on screen
 */
void drawMovingPlatform() {
	int i;
  int x,y;
  int width = 5;
  int cheat = 0;// - 5
  int markerTest = FALSE;

  int visibility = FALSE;
  int x_right, x_left, y_right, y_left;
    
  if(platform_num == -1) return;
    
  for (i = monster_num + 1 ; i < platform_num ; i++) {
    markerTest = FALSE; 

      //x = sprite[i].x / 8;
      y = sprite[i].y / 8;
      /* Must move and stop platforms when they hit bricks or
       * markers or the end of the screen/room/level.
       */
      if(sprite[i].facingRight == TRUE) {
        sprite[i].x ++;
        x = sprite[i].x / 8;
        markerTest = FALSE; 
        // marker test
        y_right = y;
        x_right = x + width + cheat ;
        if(map_objects[x_right][y_right] == B_BLOCK ||
        		(x + width > level_w &&
        		map_objects[x_right - level_w][y_right] == B_BLOCK)) markerTest = TRUE;
        if(map_objects[x_right][y_right] == B_MARKER ||
        		(x + width > level_w &&
        		map_objects[x_right - level_w][y_right] == B_MARKER)) markerTest = TRUE;

        // turn platform
        if ( markerTest == TRUE) {
          sprite[i].facingRight = FALSE;
        }
        else if (sprite[i].x > level_w * 8 ) {
        	sprite[i].x = 0;
        }
      }
      else {
        sprite[i].x --;
        x = sprite[i].x / 8;
        markerTest = FALSE; 
        // marker test
        y_left = y;
        x_left = x + cheat ;
        if(map_objects[x_left][y_left ] == B_BLOCK) markerTest = TRUE;
        if(map_objects[x_left][y_left ] == B_MARKER) markerTest = TRUE;

        // turn platform
        if (markerTest == TRUE) {
          sprite[i].facingRight = TRUE;
        }
        else if (sprite[i].x <= 0 ) {
        	sprite[i].x = (level_w * 8)  - 1;
        }
      } 
    

      drawBasicSprite(i, D_CLOUD);


    
  }

  return;
}

/**
 *	Used to detect collision with monsters
 */
void collisionWithMonsters() {

	int i;
	
	
		  BoundingBox guyBox = makeSpriteBox( flyer , 0, 0 );

		  
		  for (i = 0  ; i < monster_num ; i++) {   
		    BoundingBox monsterBox = makeSpriteBox(sprite[i] , 0, 0 );
		    int test =  collisionSimple(guyBox, monsterBox);
		    if (test && sprite[i].active   == TRUE) {
		    
		      if (guyBox.bottom  < monsterBox.bottom ) {
		    	//mGameV.getSprite(i).setActive(false);
		    	//mPanel.inactivateMonster(i );
		    	//sprite[i].active = FALSE;
		    	score = score + 10;
		    	
		    	if (preferences_collision == TRUE) {
		    		inactivateMonsterView(i);
		    		inactivateMonster(i);
		    		setSoundBoom();
		    	}


				//setSoundBoom();
		        
		        
		      }
		      else {
				//endlevel = TRUE;
				if (preferences_collision == TRUE) {
					inactivateMonster(i);
					animate_only = TRUE;
					setSoundOw();
				}

		        //lives --;

		      }
		    }
		  }

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
 * used to draw the torpedo when firing
 */
void drawTorpedo() {
	int i, ii;
	BoundingBox test;
	for (ii = 0; ii < TORPEDO_TOTAL; ii ++ ) {
		if (torpedos[ii].active) {
			if (torpedos[ii].facingRight == TRUE) {
				test = makeSpriteBox(torpedos[ii], torpedos[ii].limit, 0);
			}
			else {
				test = makeSpriteBox(torpedos[ii], - torpedos[ii].limit, 0);
			}
			//BoundingBox test = makeSpriteBox(torpedo, 0, 0);
			for (i = test.top; i < test.bottom; i ++) {
				drawHorizontal(i , test.left, test.right, 0x00f0, PAINT_SOLID) ; // blue
			}
		}
	}
}

/**
 * Used to draw S_BUBBLE_0 type bubbles.
 */

void drawBubbleType0() {

}

/**
 * Used to draw S_BUBBLE_1 type bubbles.
 */

void drawBubbleType1() {

	int i, j, k, l, m;
	BOOL test = FALSE;
	int num_strikes = challenge[current_challenge].bubble_1;

	if ( num_strikes > total_placed_bubble_1 ) {
		if(timerDone(2)) {
			// create a line-type object
			Sprite temp ;
			temp.x = getRand(scrollx, scrollx + TEX_WIDTH);
			temp.y = 0;
			int angle = getRand( 80, 180 - 80) ;
			float value = ((float) LONG_MAP_V * 8)/ (float) tan(angle) ;
			temp.endline_x = abs ((( (int) value ) + temp.x) % (LONG_MAP_H * 8));

			temp.endline_y = LONG_MAP_V * 8;
			temp.sprite_type = S_LINE;
			temp.speed = 2;
			temp.active = TRUE;
			temp.quality_0 = 0;

			// add it to the sprite list
			addSprite(temp);

			// increment total_placed_bubble_1
			total_placed_bubble_1 ++;
			//total_bubble_1 ++;

			// reset timer
			timerStart(2, 30 * 1);
		}
	}
	// draw lines... make bubbles...

	//go through sprites
	for (i = 0; i < 100; i ++ ) {

		if (sprite[i].sprite_type == S_LINE && sprite[i].active == TRUE ) { // if i is a line

			if(sprite[i].quality_0 <= sprite[i].endline_y ) {
				sprite[i].quality_0 = sprite[i].quality_0 + sprite[i].speed;
			}
			else {//if (total_bubble_1 < num_strikes)  {
				// make bubble


				////
				if (TRUE ) {
					Sprite new;
					new.sprite_type = S_BUBBLE_1;
					new.x = sprite[i].endline_x;
					new.y = sprite[i].endline_y;
					new.limit = 100;
					new.radius = 8;
					new.speed = 1;
					new.active = TRUE;
					new.sprite_link = i;

					sprite[i].active = FALSE;

					addSprite(new);
					total_bubble_1 ++;
				}
				////

			}
			// draw lines ...
			for (l = 0; l < sprite[i].quality_0 ; l ++) {
				k = ((sprite[i].endline_x - sprite[i].x ) * l) / ( sprite[i].endline_y - sprite[i].y) + sprite[i].x;

				drawPoint(k,l, 0xffff);

				if ( scrollx + SCREEN_WIDTH > (level_w * 8) && k  < SCREEN_WIDTH ) {
					drawPoint(k + (level_w * 8), l, 0xffff);
					//LOGE("over edge here");
				}

			}


		}
	}
}

/**
 * Used to draw S_BUBBLE_2 type bubbles.
 */

void drawBubbleType2() {

	int i, j, k, l, m, n;
	BOOL test = FALSE;
	int num_strikes = challenge[current_challenge].bubble_2;

	if ( num_strikes > total_placed_bubble_2 ) {
		if(timerDone(3)) {
			// create a line-type object
			Sprite temp ;
			temp.x = getRand(scrollx, scrollx + TEX_WIDTH);
			temp.y = 0;
			int angle = getRand( 80, 180 - 80) ;
			float value = ((float) LONG_MAP_V * 8)/ (float) tan(angle) ;
			temp.endline_x = abs ((( (int) value ) + temp.x) % (LONG_MAP_H * 8));

			temp.endline_y = LONG_MAP_V * 8;
			temp.sprite_type = S_LINE_2;
			temp.speed = 5;
			temp.active = TRUE;
			temp.quality_0 = 0;

			// add it to the sprite list
			addSprite(temp);

			// increment total_placed_bubble_2
			total_placed_bubble_2 ++;
			//total_bubble_1 ++;

			// reset timer
			timerStart(3, 30 * 2);
		}
	}
	// draw lines... make bubbles...

	//go through sprites
	for (i = 0; i < 100; i ++ ) {

		if (sprite[i].sprite_type == S_LINE_2 && sprite[i].active == TRUE ) { // if i is a line

			if(sprite[i].quality_0 <= sprite[i].endline_y ) {
				sprite[i].quality_0 = sprite[i].quality_0 + sprite[i].speed;
			}
			else {//if (total_bubble_1 < num_strikes)  {
				// make bubble


				////
				if (TRUE ) {
					Sprite new;
					new.sprite_type = S_BUBBLE_2;
					new.x = sprite[i].endline_x;
					new.y = sprite[i].endline_y;
					new.limit = 120;
					new.radius = 8;
					new.speed = 2;
					new.active = TRUE;
					new.sprite_link = i;

					sprite[i].active = FALSE;

					addSprite(new);
					total_bubble_2 ++;

					Sprite new2;
					new2.sprite_type = S_BUBBLE_3;
					new2.x = sprite[i].endline_x;
					new2.y = sprite[i].endline_y;
					new2.limit = 130;
					new2.radius = 8;
					new2.speed = 2;
					new2.active = TRUE;
					new2.sprite_link = -1;

					addSprite(new2);
				}
				////

			}
			// draw lines ...
			for (l = 0; l < sprite[i].quality_0 ; l ++) {
				k = ((sprite[i].endline_x - sprite[i].x ) * l) / ( sprite[i].endline_y - sprite[i].y) + sprite[i].x;

				for (n = 0; n < 8; n ++ ) {
					drawPoint((k + n) - 4 ,l, 0x0f00);
				}

				//drawPoint(k,l, 0xffff);

				if ( scrollx + SCREEN_WIDTH > (level_w * 8) && k  < SCREEN_WIDTH ) {
					for (n = 0; n < 8; n ++ ) {
						drawPoint((k + n + (level_w * 8)) - 4, l, 0x0f00);
					}
					//drawPoint(k + (level_w * 8), l, 0xffff);
					//LOGE("over edge here");
				}

			}


		}
	}
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
			// move rollee

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
 * Used by drawInvaderType1() to direct invader.
 */
BOOL goingRightIsShortest( int spritex, int flyerx ) {
	BOOL test = FALSE;

	if (abs(flyerx - spritex) < (level_w * 8)/2 && spritex < flyerx) {
		test = TRUE;
	}
	else if (abs(flyerx - spritex ) > (level_w *8 )/2) {
		test = TRUE;
	}
	return test;
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
 * Re-use bubble drawing code...
 */
void drawBubbleWithColor() {
	int i,j, solid;
	float position, angle, rad, dist;
	BoundingBox testBox, torpedoBox;
	uint16_t color = 0xf000;

	for (i = 0; i < 100; i ++ ) { //detect torpedo hit on bubble
		if((sprite[i].sprite_type == S_BUBBLE_0 ||
				sprite[i].sprite_type == S_BUBBLE_1 ||
				sprite[i].sprite_type == S_BUBBLE_2 ||
				sprite[i].sprite_type == S_BUBBLE_3)
				&& sprite[i].active == TRUE) {

			checkBubbleCollision(i);

			switch (sprite[i].sprite_type) {
			case S_BUBBLE_0 :
				color = 0xf000;
				solid = PAINT_SOLID;
				drawRadarPing(radar_box, sprite[i].x, sprite[i].y - 8, PING_OTHER, color);
				break;
			case S_BUBBLE_1 :
				color = 0x00f0;
				solid = PAINT_SOLID;
				drawRadarPing(radar_box, sprite[i].x, sprite[i].y - 32, PING_OTHER, color);
				break;
			case S_BUBBLE_2 :
				color = 0x0f00;
				solid = PAINT_SOLID;
				drawRadarPing(radar_box, sprite[i].x, sprite[i].y - 16, PING_OTHER, color);
				break;
			case S_BUBBLE_3 :
				color = 0x00f0;
				solid = PAINT_TRANSPARENT;
				drawRadarPing(radar_box, sprite[i].x, sprite[i].y - 32, PING_OTHER, color);

			}

			Sprite test = sprite[i];
			rad = test.radius;

			//drawRadarPing(radar_box, test.x, test.y - 24, PING_OTHER,  color);

			for(j = 0; j < rad; j ++) { // draw bubble on screen
				// calculate line start and end

				var position:Number =  j;
				var angle:Number = Math.asin(position/rad);
				var dist:Number = Math.cos(angle) * rad;

				//drawRadarPing(radar_box, adjust_x(test.x - (int) dist ), test.y - j, PING_ROCK, color);
				//drawRadarPing(radar_box, adjust_x(test.x + (int) dist ), test.y - j, PING_ROCK, color);

				if (scrollBGX < this.x + int (dist)) {
					//drawHorizontal(test.y - j, test.x - (int) dist, test.x + (int) dist, color, solid);
					//drawHorizontal(test.y + j, test.x - (int) dist, test.x + (int) dist, color, solid);


					if (this.x + int (dist) > myMode.myHoriz * 16 ) {
						//drawHorizontal(test.y - j,  (test.x - (int) dist) -( level_w * 8),  (test.x + (int) dist) -(level_w * 8), color, solid);
						//drawHorizontal(test.y + j,  (test.x - (int) dist) - ( level_w * 8),  (test.x + (int) dist) - (level_w * 8), color, solid);
					}

				}
				else if (scrollBGX >= this.x - int (dist )) {
					//drawHorizontal(test.y - j, (level_w * 8) + test.x - (int) dist, (level_w * 8) + test.x + (int) dist, color, solid);
					//drawHorizontal(test.y + j, (level_w * 8) + test.x - (int) dist, (level_w * 8) + test.x + (int) dist, color, solid);


				}






			}
			if (this.radius < this.limit) { // grow bubble on screen
				this.radius = this.radius + this.speed;
			}
		}
	}
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
 * used to draw a single point on the screen.
 */
void drawPoint(int x, int y, uint16_t color) {

	uint16_t  *  screen =(void *) (getScreenPointer(MY_SCREEN_BACK));

	if ( (y - scrolly) >= 0 && (x -scrollx) >= 0 && (y-scrolly) < SCREEN_HEIGHT  && (x-scrollx) <  SCREEN_WIDTH ) {
		screen[(( y - scrolly ) * SCREEN_WIDTH )  +(x - scrollx ) ] = color;

	}
}

/**
 * Used to draw squares and rectangles on the screen based on the Bounding
 * Box struct.
 */
void drawBoundingBox( BoundingBox box, BOOL special, uint16_t color) {
	uint16_t  *  screen =(void *) (getScreenPointer(MY_SCREEN_BACK));

	int x = 0;
	int y = 0;

	int scroll_y = 0;
	int scroll_x = 0;

	if (special == BB_NONE) return;

	if (special == BB_REGULAR) {
		scroll_y = scrolly;
		scroll_x = scrollx;
	}

	for (x = box.left; x <= box.right; x ++ ) {
		y = box.top;
		if ( (y - scroll_y) >= 0 && (x -scroll_x) >= 0 && (y-scroll_y) < SCREEN_HEIGHT + RADAR_HEIGHT && (x-scroll_x) <  SCREEN_WIDTH ) {
			screen[(( y - scroll_y ) * SCREEN_WIDTH )  +(x - scroll_x ) ] = color;

		}
		y = box.bottom;
		if ( (y - scroll_y) >= 0 && (x -scroll_x) >= 0 && (y-scroll_y) < SCREEN_HEIGHT + RADAR_HEIGHT && (x-scroll_x) <  SCREEN_WIDTH ) {
			screen[(( y - scroll_y ) * SCREEN_WIDTH )  +(x - scroll_x ) ] = color;

		}

	}

	for (y = box.top; y <= box.bottom; y ++ ) {
		x = box.left;
		if ( (y - scroll_y) >= 0 && (x -scroll_x) >= 0 && (y-scroll_y) < SCREEN_HEIGHT + RADAR_HEIGHT && (x-scroll_x) <  SCREEN_WIDTH ) {
			screen[(( y - scroll_y ) * SCREEN_WIDTH )  +(x - scroll_x ) ] = color;

		}
		x = box.right;
		if ( (y - scroll_y) >= 0 && (x -scroll_x) >= 0 && (y-scroll_y) < SCREEN_HEIGHT + RADAR_HEIGHT && (x-scroll_x) <  SCREEN_WIDTH ) {
			screen[(( y - scroll_y ) * SCREEN_WIDTH )  +(x - scroll_x ) ] = color;

		}

	}
}


void drawRadarPing( BoundingBox box, int x, int y , int kind,  uint16_t color) {
	uint16_t  *  screen =(void *) (getScreenPointer(MY_SCREEN_BACK));

	//LOGE("RADAR_BOX %d", box.left);

	int xx = 0;
	int yy = 0;
	int ii = 0;
	int jj = 0;

	ii =  radar_start_scroll;
	jj = adjust_x (radar_start);
	yy = y;

	if ( x  > scrollx  && kind == PING_FLYER ) {
		xx = x - scrollx  - (  ii);
		if (xx < 0) xx = xx % (LONG_MAP_H * 8);

	}
	else if (x  < scrollx && kind == PING_FLYER ) {
		xx = x - ii + (LONG_MAP_H * 8);

	}
	else  {
		xx = (x - scrollx + (LONG_MAP_H * 4)  + ii) % (LONG_MAP_H * 8 );// this might be OK...
		xx = adjust_x(xx);
	}


		screen[(( (yy/8) + box.top   ) * SCREEN_WIDTH )  +
		       (  ( (xx /8) + box.left  ) ) ] = color;

	if (kind == PING_ROCK) return;

		screen[(( (yy/8) + box.top  + 1 ) * SCREEN_WIDTH )  +
		       (  ( (xx /8) + box.left  ) ) ] = color;

		screen[(( (yy/8) + box.top   ) * SCREEN_WIDTH )  +
		       (  ( (xx /8) + box.left + 1 ) ) ] = color;

		screen[(( (yy/8) + box.top + 1  ) * SCREEN_WIDTH )  +
		       (  ( (xx /8) + box.left + 1 ) ) ] = color;

	if (kind != PING_OTHER) return;

		screen[(( (yy/8) + box.top - 2 ) * SCREEN_WIDTH )  +
			   (  ( (xx /8) + box.left  ) ) ] = color;

		screen[(( (yy/8) + box.top  - 2 ) * SCREEN_WIDTH )  +
			   (  ( (xx /8) + box.left  + 1) ) ] = color;

		screen[(( (yy/8) + box.top  - 1 ) * SCREEN_WIDTH )  +
			   (  ( (xx /8) + box.left  ) ) ] = color;

		screen[(( (yy/8) + box.top  - 1 ) * SCREEN_WIDTH )  +
			   (  ( (xx /8) + box.left  + 1) ) ] = color;

}

/**
 * Used to find starting position of flyer
 */

void set_radar_start(int x) {
	if (radar_set == FALSE ) {
		radar_start = x - scrollx;
		radar_start_scroll = scrollx;
		radar_set = TRUE;

		//LOGE("radar_start called scroll %d", scrollx / 8);

		//LOGE("radar_start %d", radar_start);
	}
}

void drawRadarRock() {

	int x,y;
	for (x = 0; x < LONG_MAP_H; x ++ ) {
		for(y = 0; y < LONG_MAP_V; y ++ ) {

			if (map_objects[x][y] == B_BLOCK) {
				drawRadarPing(radar_box, x * TILE_WIDTH, y * TILE_HEIGHT, PING_ROCK, 0xffff);
			}
			else if (map_level[x][y] != B_SPACE) {
				drawRadarPing(radar_box, x * TILE_WIDTH, y * TILE_HEIGHT, PING_ROCK, 0xa6a6);

			}
			if (map_objects[x][y] == B_PRIZE) {
				drawRadarPing(radar_box, x * TILE_WIDTH, y * TILE_HEIGHT, PING_OTHER, 0xf000);
			}
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
 * pointer returning function for double buffering
 */

uint16_t **  getScreenPointer(int screen_enum) {

	/////// BLANK OUT SCREEN ///////
	if (blank_screen == TRUE  && screen_enum == MY_SCREEN_FRONT) {
		return (uint16_t **) screen_0;
	}
	if (blank_screen == TRUE && screen_enum == MY_SCREEN_BACK) {
		return (uint16_t **) screen_1;
	}

	//////// BUFFER SCREEN PART I ///////////////////
	int local_index = 0;
	if (screen_enum == MY_SCREEN_FRONT) {
		local_index = screencounter;
	}
	else if (screen_enum == MY_SCREEN_BACK) {
		local_index = (screencounter + 1) &1;
	}
	///////// BUFFER SCREEN PART II /////////////////
	if (local_index) {
		return (uint16_t **) screen_0;
	}
	else {
		return (uint16_t **) screen_1;
	}
}

/**
 * Used to increment the screen counter for double buffering
 */

void incrementScreenCounter() {
	screencounter = (screencounter + 1)& 1;
	//LOGE("screencounter %d",screencounter);
}


/**
 * used to create a random number... presupposes that srand() is already
 * called.
 */
int getRand(int min, int max) {
	int rc = (rand() % (max - min + 1) + min);
	return rc;
}

/**
 * Used to adjust x so that it doesn't go above or below certain bounds
 */
int adjust_x( int x ) {
	if (x > level_w * 8 ) {
		//x = 0;
		x = x - (level_w * 8);
	}
	if (x < 0 ) {
		x = x + (level_w * 8);
	}
	return x;
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

/**
 * used to set sprite speed.
 */
int get_sprite_speed ( int spritetype ) {
	int value = 1;
	if (getRand(0,2) != 1) return value;

	switch (spritetype) {
	case S_INVADER_1:
	case S_INVADER_2:
		if (game_level <=3 ) {
			value = game_level;
		}
		else {
			value = 3;
		}
		break;
	case S_INVADER_3:
		break;
	}
	return value;
}


/**
 * used to tell if the timer is done. NOTE: these are
 * game-wide timers.
 */
BOOL timerDone(int i) {
	BOOL done = FALSE;
	if (! timer[i].timer_disable && blank_screen == FALSE) {
		timer[i].timer_progress ++;
		if (timer[i].timer_progress > timer[i].timer_total) {
			done = TRUE;
			timer[i].timer_progress = 0;
		}
	}
	return done;
}

/**
 * used to setup the timer so that it operates on a given time
 * period. NOTE: these are game-wide timers.
 */
void timerStart(int i, int time){
	timer[i].timer_total = time;
	timer[i].timer_progress = 0;
	timer[i].timer_disable = FALSE;
}

/**
 * used to tell if the sprite timer is done. NOTE: these are
 * timers for individual sprites.
 */
BOOL spriteTimerDone(int i) {
	BOOL done = FALSE;
	if (! sprite[i].quality_2 && blank_screen == FALSE) { //timer_disable
		sprite[i].quality_1 ++;//timer_progress ++;
		if (sprite[i].quality_1 > sprite[i].quality_0 ) { // timer_progress > timer_total
			done = TRUE;
			sprite[i].quality_1 = 0; //timer_progress = 0;
		}
	}
	return done;
}

/**
 * used to setup the sprite timer so that it operates on a given time
 * period. NOTE: these are timers for individual sprites.
 */
void torpedosTimerStart(int i, int time){
	torpedos[i].quality_0 = time;	//timer_total = time;
	torpedos[i].quality_1 = 0;	//timer_progress = 0;
	torpedos[i].quality_2 = FALSE;//timer_disable = FALSE;
}

/**
 * used to tell if the sprite timer is done. NOTE: these are
 * timers for individual sprites.
 */
BOOL torpedosTimerDone(int i) {
	BOOL done = FALSE;
	if (! torpedos[i].quality_2 && blank_screen == FALSE) { //timer_disable
		torpedos[i].quality_1 ++;//timer_progress ++;
		if (torpedos[i].quality_1 > torpedos[i].quality_0 ) { // timer_progress > timer_total
			done = TRUE;
			torpedos[i].quality_1 = 0; //timer_progress = 0;
		}
	}
	return done;
}

/**
 * used to setup the sprite timer so that it operates on a given time
 * period. NOTE: these are timers for individual sprites.
 */
void spriteTimerStart(int i, int time){
	sprite[i].quality_0 = time;	//timer_total = time;
	sprite[i].quality_1 = 0;	//timer_progress = 0;
	sprite[i].quality_2 = FALSE;//timer_disable = FALSE;
}

////////////////////////////////////////
// Java interfaces here
////////////////////////////////////////

/**
 *	Used to establish all tileset map arrays at the time of instatiation of the 
 *	Panel constructor.
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	a_bitmap	1D tileset pixel array
 *	@param	b_bitmap	1D tileset pixel array
 *	@param	c_bitmap	1D tileset pixel array
 *	@param	d_bitmap	1D tileset pixel array
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setTileMapData(JNIEnv * env, jobject  obj, jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
{
  //jsize a_len = (*env)->GetArrayLength(env, a_bitmap);
  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
  //jsize b_len = (*env)->GetArrayLength(env, b_bitmap);
  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);
  //jsize c_len = (*env)->GetArrayLength(env, c_bitmap);
  jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);
  //jsize d_len = (*env)->GetArrayLength(env, d_bitmap);
  jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);
  setTileMapData(a, b, c, d );
}

/**
 *	Used to establish all character sprite arrays at the time of instatiation of
 *	the Panel constructor.
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	a_bitmap	1D sprite pixel array
 *	@param	b_bitmap	1D sprite pixel array
 *	@param	c_bitmap	1D sprite pixel array
 *	@param	d_bitmap	1D sprite pixel array
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setGuyData(JNIEnv * env, jobject  obj, jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
{

  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);
  jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);
  jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);
  
  setGuyData(a, b, c, d );
}


/**
 *	Used to establish all invader1 sprite arrays at the time of instatiation of
 *	the Panel constructor.
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	a_bitmap	1D sprite pixel array
 *	@param	b_bitmap	1D sprite pixel array
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setInvader1Data(JNIEnv * env, jobject  obj, jintArray a_bitmap, jintArray b_bitmap)
{

  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);
  //jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);
  //jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);

  setInvader1Data(a, b );
}

/**
 *	Used to establish all invader1 sprite arrays at the time of instatiation of
 *	the Panel constructor.
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	a_bitmap	1D sprite pixel array
 *	@param	b_bitmap	1D sprite pixel array
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setInvader2Data(JNIEnv * env, jobject  obj, jintArray a_bitmap, jintArray b_bitmap)
{

  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);
  //jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);
  //jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);

  setInvader2Data(a, b );
}

/**
 *	Used to establish all character sprite arrays at the time of instatiation of
 *	the Panel constructor.
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	a_bitmap	1D sprite pixel array
 *	@param	b_bitmap	1D sprite pixel array
 *	@param	c_bitmap	1D sprite pixel array
 *	@param	d_bitmap	1D sprite pixel array
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setFlyerData(JNIEnv * env, jobject  obj, jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
{

  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);
  jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);
  jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);
  
  setFlyerData(a, b, c, d );
}
 
/**
 *	Used to establish all monster sprite arrays at the time of instatiation of 
 *	the Panel constructor.
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	a_bitmap	1D monster pixel array
 *	@param	b_bitmap	1D monster pixel array
 *	@param	c_bitmap	1D monster pixel array
 *	@param	d_bitmap	1D monster pixel array
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setMonsterData(JNIEnv * env, jobject  obj, jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
{
  //jsize a_len = (*env)->GetArrayLength(env, a_bitmap);
  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
  //jsize b_len = (*env)->GetArrayLength(env, b_bitmap);
  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);
  //jsize c_len = (*env)->GetArrayLength(env, c_bitmap);
  jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);
  //jsize d_len = (*env)->GetArrayLength(env, d_bitmap);
  jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);
  setMonsterData(a, b, c, d );
}

/**
 *	Used to establish all 8 explosion sprite arrays at the time of instatiation of
 *	the Panel constructor.
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	a_bitmap	1D explosion pixel array
 *	@param	b_bitmap	1D explosion pixel array
 *	@param	c_bitmap	1D explosion pixel array
 *	@param	d_bitmap	1D explosion pixel array
 *	@param	e_bitmap	1D explosion pixel array
 *	@param	f_bitmap	1D explosion pixel array
 *	@param	g_bitmap	1D explosion pixel array
 *	@param	h_bitmap	1D explosion pixel array
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setExplosionData
(JNIEnv * env, jobject  obj, jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap,
		jintArray e_bitmap, jintArray f_bitmap, jintArray g_bitmap, jintArray h_bitmap)
{
	//jsize a_len = (*env)->GetArrayLength(env, a_bitmap);
	jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
	//jsize b_len = (*env)->GetArrayLength(env, b_bitmap);
	jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);
	//jsize c_len = (*env)->GetArrayLength(env, c_bitmap);
	jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);
	//jsize d_len = (*env)->GetArrayLength(env, d_bitmap);
	jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);
	//jsize a_len = (*env)->GetArrayLength(env, a_bitmap);
	jint *e = (*env)->GetIntArrayElements(env, e_bitmap, 0);
	//jsize b_len = (*env)->GetArrayLength(env, b_bitmap);
	jint *f = (*env)->GetIntArrayElements(env, f_bitmap, 0);
	//jsize c_len = (*env)->GetArrayLength(env, c_bitmap);
	jint *g = (*env)->GetIntArrayElements(env, g_bitmap, 0);
	//jsize d_len = (*env)->GetArrayLength(env, d_bitmap);
	jint *h = (*env)->GetIntArrayElements(env, h_bitmap, 0);
	setExplosionData(a, b, c, d, e, f, g, h );
}

/**
 *	Used to establish the platform sprite array at the time of instatiation of 
 *	the Panel constructor.
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	a_bitmap	1D platform pixel array
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setMovingPlatformData(JNIEnv * env, jobject  obj, jintArray a_bitmap) 
{

	jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
	
	setMovingPlatformData(a) ;

}
/**

 *	used to add a monster's sprite record to the list of monster sprite records
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	monster_mapx	the x map coordinates of the monster's starting 
 *							point.
 *	@param	monster_mapy	the y map coordinates of the monster's starting
 *							point.
 *	@param	animate_index	starting animation index of monster.

 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_addMonster(JNIEnv * env, jobject  obj, jint monster_mapx, jint monster_mapy,  jint animate_index)
{
	addMonster(monster_mapx, monster_mapy,  animate_index);	

}

/**
 *	used to add a platform's sprite record to the list of sprite records
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	platform_mapx	the x map coordinates of the platform's starting 
 *							point.
 *	@param	platform_mapy	the y map coordinates of the platform's starting
 *							point.
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_addPlatform(JNIEnv * env, jobject  obj, jint platform_mapx, jint platform_mapy)
{
	addPlatform(platform_mapx, platform_mapy);	

}

/**
 *	used to inactivate a monster's sprite record in the list of monster sprite 
 *	records
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	monster_num		the x monster's index num
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_inactivateMonster(JNIEnv * env, jobject  obj, jint monster_num)
{
	inactivateMonster(monster_num);	

}

/**
 *	Used to set x and y screen postions for the 'guy' sprite, as well as set the
 *	scrollx and scrolly of the screen and the animate index for the background
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	x_pos		x position of the 'guy' sprite
 *	@param	y_pos		y position of the 'guy' sprite
 *	@param	scroll_x	x scroll of background
 *	@param	scroll_y	y scroll of background
 *	@param	local_keyB	weather fire button is pressed
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setGuyPosition(JNIEnv * env, jobject  obj, jint x_pos, jint y_pos, jint scroll_x, jint scroll_y, jint local_keyB)
{
	setGuyPosition(x_pos, y_pos, scroll_x, scroll_y, newGuy);	
	keyB = local_keyB;
}

/**
 *	Used to set the 'score' and 'lives' values to be displayed on the screen
 *
 *	@param	env		required by all java jni
 *	@param	obj		required by all java jni
 *	@param	score	the score
 *	@param	lives	the lives
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setScoreLives(JNIEnv * env, jobject  obj, jint score, jint lives)
{
	setScoreLives(score,lives);	

}

/**
 *	Used to set the 'score' and 'lives' values to be displayed on the screen
 *
 *	@param	env		required by all java jni
 *	@param	obj		required by all java jni
 *	@param	monsters 	weather monsters will be shown on the level
 *	@param	collision	weather collision with monsters will affect game play
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setMonsterPreferences(JNIEnv * env, jobject  obj, jint monsters, jint collision)
{
	preferences_monsters = monsters;
	preferences_collision = collision;

}

/**
 *	Used to set the animate_only boolean value
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	animate 	weather animate_only is set
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setJNIAnimateOnly(JNIEnv * env, jobject  obj, jint animate)
{

	animate_only = animate;

}

/**
 *	Used to set the useable screen size for the program
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	screenH 	screen horizontal tile measurement
 *	@param	screenV		screen vertical tile measurement
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setScreenData(JNIEnv * env, jobject  obj, jint screenH, jint screenV)
{
	tilesWidthMeasurement = screenH;
	tilesHeightMeasurement = screenV;

}

/**
 *	Used to copy the 'level' and 'ojects' arrays to the library at the time of
 *	Panel instantiation. Also copy width and height of the two arrays.
 *
 *	@param	env		required by all java jni
 *	@param	obj		required by all java jni
 *	@param	level	1D array of level data
 *	@param	objects	1D array of objects data
 *	@param	width	value representing the arrays' 2D width
 *	@param	height	value representing the arrays' 2D height
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setLevelData(JNIEnv * env, jobject  obj, jintArray level, jintArray objects, jint width, jint height)
{
	
	jint *a = (*env)->GetIntArrayElements(env, level, 0); // zero??
  	jint *b = (*env)->GetIntArrayElements(env, objects, 0);
  	
  	level_h = height;
  	level_w = width;
  	
  	sprite_num = 0;
  	
	setLevelData(a,b);	
	//LOGE("level data",0);
}

/**
 *	Used to set a single 'objects' array cell value during game play.
 *
 *	@param	env		required by all java jni
 *	@param	obj		required by all java jni
 *	@param	map_x	x map coordinates to be changed
 *	@param	map_y	y map coordinated to be changed
 *	@param	value	value used for replacement
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setObjectsDisplay(JNIEnv * env, jobject  obj, jint map_x, jint map_y, jint value)
{
	setObjectsDisplay(map_x, map_y, value);	

}

/**
 *	Used to return to the java app the data from the 2D screen array kept by the
 *	library.
 *
 *	@param	env		required by all java jni
 *	@param	obj		required by all java jni				
 */
 
/*
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_drawLevel(JNIEnv * env, jobject  obj)
{
	animate_vars();
	
	drawLevel(newBG + 1);
	
}
*/

/**
 *	Used to tell the java program that the sound can be played
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					weather the sound is playable.
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSoundBoom(JNIEnv * env, jobject  obj)
{
	return getSoundBoom();	

}

/**
 *	Used to tell the java program that the sound can be played
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					weather the sound is playable.
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSoundOw(JNIEnv * env, jobject  obj)
{
	return getSoundOw();	

}

/**
 *	Used to tell the java program that the sound can be played
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					weather the sound is playable.
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSoundPrize(JNIEnv * env, jobject  obj)
{
	return getSoundPrize();	

}

/**
 *	Used to tell the java program that the sound can be played
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					weather the sound is playable.
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSoundGoal(JNIEnv * env, jobject  obj)
{
	return getSoundGoal();

}

/**
 *	Used to tell the java program that the sound can be played
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					weather the sound is playable.
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSoundEnter1(JNIEnv * env, jobject  obj)
{
	return getSoundEnter1();

}

/**
 *	Used to tell the java program that the sound can be played
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					weather the sound is playable.
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSoundEnter2(JNIEnv * env, jobject  obj)
{
	return getSoundEnter2();

}
/**
 *	Used to tell the java program that the sound can be played
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					weather the sound is playable.
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSoundEnter3(JNIEnv * env, jobject  obj)
{
	return getSoundEnter3();

}

/**
 *	Used to tell the java program that the sound can be played
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					weather the sound is playable.
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSoundEnter4(JNIEnv * env, jobject  obj)
{
	return getSoundEnter4();

}

/**
 *	Used to tell the java program how many lives are left
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					lives
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getLives(JNIEnv * env, jobject  obj)
{
	return lives;	

}

/**
 *	Used to tell the java program that the level is over
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					endlevel flag
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getEndLevel(JNIEnv * env, jobject  obj)
{
	
	int temp = endlevel;
  	endlevel = FALSE;
	return temp;	

}

/**
 *	Used to tell the java program that the level is over
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					endlevel flag
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getGameDeath(JNIEnv * env, jobject  obj)
{

	int temp = gamedeath;
  	gamedeath = FALSE;
	return temp;

}

/**
 *	Used to tell the java program the score
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					score
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getScore(JNIEnv * env, jobject  obj)
{
	return score;	



}

/**
 *	Used to increment the score in the JNI variable
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	num 			amount to increase score by
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_incrementJniScore(JNIEnv * env, jobject  obj, jint num)
{
	score = score + num;	

}

/**
 *	Used to tell the java program the x coordinates of a sprite
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	num 			index of desired sprite
 *	@return					X coordinate
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSpriteX(JNIEnv * env, jobject  obj, jint num)
{
	return sprite[num].x;	

}

/**
 *	Used to tell the java program the y coordinates of a sprite
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	num 			index of desired sprite
 *	@return					Y coordinate
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSpriteY(JNIEnv * env, jobject  obj, jint num)
{
	return sprite[num].y;	

}

/**
 *	Used to tell the java program the 'facingRight' status of a sprite
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	num 			index of desired sprite
 *	@return					facingRight
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_getSpriteFacingRight(JNIEnv * env, jobject  obj, jint num)
{
	return sprite[num].facingRight;	

}

/**
 * Used to add challenges to the challenges array from the java program.
 *
 * @param rings		number of rings in this challenge
 * @param bubble1	number of bubble type 1 in this challenge
 * @param bubble2	etc...
 * @param bubble3
 * @param invader1
 * @param invader2
 * @param invader3
 *
 */

JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_JNIaddChallenges(JNIEnv * env, jobject  obj,
jint rings, jint bubble1, jint bubble2, jint bubble3, jint invader1, jint invader2, jint invader3, jint speed)
{
	addChallenges(rings, bubble1, bubble2, bubble3, invader1, invader2, invader3, speed);
}

/**
 *	Used to set the scroll registers in the JNI library
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	x	 			scroll_x
 *  @param	y				scroll_y
 *	@return					void
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_setJNIScroll(JNIEnv * env, jobject  obj, jint x , jint y)
{
	scrollx = x;
	scrolly = y;
	

}

/**
 *	Used to set the 'show screen' registers in the JNI library
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@param	blank	 		boolean for weather to show screen
 *	@return					void
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_JNIblankScreen(JNIEnv * env, jobject  obj, jint blank )
{

	blank_screen = blank;

	if (blank == TRUE) {
		uint16_t  **  screen = (getScreenPointer(MY_SCREEN_FRONT));
		/* clear screen */
		memset(screen, 0x0, SCREEN_HEIGHT * SCREEN_WIDTH * 2);
		screen = (getScreenPointer(MY_SCREEN_BACK));
		memset(screen, 0x0, SCREEN_HEIGHT * SCREEN_WIDTH * 2);
	}
	//LOGE("blank screen");

}

/**
 *	Used to tell the jni that init of the arrays is complete
 *
 *	@param	env		required by all java jni
 *	@param	obj		required by all java jni
 */


JNIEXPORT void JNICALL Java_org_davidliebman_android_flyer_Panel_JNIfinishInit(JNIEnv * env, jobject  obj)
{
	initChallenges();

}

/**
 *	Used to tell the jni that init of the arrays is complete
 *
 *	@param	env		required by all java jni
 *	@param	obj		required by all java jni
 */


JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_JNIisLanding(JNIEnv * env, jobject  obj)
{
	return is_landing;

}

/**
 *	Used to tell the jni that init of the arrays is complete
 *
 *	@param	env		required by all java jni
 *	@param	obj		required by all java jni
 */


JNIEXPORT int JNICALL Java_org_davidliebman_android_flyer_Panel_JNIisAnimateOnly(JNIEnv * env, jobject  obj)
{
	return animate_only;

}
