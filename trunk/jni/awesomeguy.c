/**
 * awesomeguy.c
 * --test file--
 * native android library
 */


#include <jni.h>
#include <android/log.h>
#include <stdio.h> 
#include <stdlib.h>
 
// include program libraries
// include loge and logi definitions
 
#define  LOG_TAG              "awesomeguy-jni"
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)

#define TRUE 1
#define FALSE 0 

static int B_START = 5;
static int B_SPACE = 0;
static int B_LADDER = 444;
static int B_BLOCK = 442;
static int B_GOAL = 446;
static int B_KEY = 445; 
static int B_PRIZE =  447;
static int B_MONSTER = 443;
static int B_MARKER = 441; 
static int B_DEATH = 439 ;
static int B_ONEUP = 438 ;
static int B_BIBPRIZE = 440 ;
static int B_PLATFORM = 437 ; 
 
static int TILEMAP_WIDTH = 224;
static int TILEMAP_HEIGHT = 128;
 
static int TILE_WIDTH = 8;
static int TILE_HEIGHT = 8;
 
static int GUY_WIDTH = 16;
static int GUY_HEIGHT = 16;
static int GUY_CHEAT = 3;
 
static int MONSTER_WIDTH = 16;
static int MONSTER_HEIGHT = 16;
 
static int PLATFORM_WIDTH = 40;
static int PLATFORM_HEIGHT = 8;
 
static int MAP_WIDTH = 96;
static int MAP_HEIGHT = 96;
 
static int SCREEN_WIDTH = 256;
static int SCREEN_HEIGHT = 192;
 
static int PAINT_SOLID = 0;
static int PAINT_TRANSPARENT = 1;
 
static uint32_t tiles_a[128][224];
static uint32_t tiles_b[128][224];
static uint32_t tiles_c[128][224];
static uint32_t tiles_d[128][224];
 
static uint32_t guy_a[16][16];
static uint32_t guy_b[16][16];
static uint32_t guy_c[16][16];
static uint32_t guy_d[16][16];
 
static uint32_t monster_a[16][16];
static uint32_t monster_b[16][16];
static uint32_t monster_c[16][16];
static uint32_t monster_d[16][16];
 
static uint32_t platform_a[8][40];
 
static int map_level [96][96];
static int map_objects[96][96];
 
uint32_t screen [192][256];
 
uint32_t number_alpha = 0;
 
static int tilesWidthMeasurement = 32;
static int tilesHeightMeasurement = 32;

////////////////////////////////////

typedef struct {
	int x, y, animate;
	int facingRight, active, visible;
	int leftBB, rightBB, topBB, bottomBB;
} Sprite;
 
Sprite sprite[100];
int sprite_num = 0;
int monster_num = 0;
int platform_num = -1;

Sprite guy;



///////////////////////////////////

typedef struct {
	int left, right, top, bottom;
} BoundingBox;

///////////////////////////////////

static int level_h, level_w, score, lives, scrollx, scrolly, animate;

static int endlevel = FALSE;

static int sound_ow = FALSE;
static int sound_prize = FALSE;
static int sound_boom = FALSE;

static int preferences_monsters = FALSE;
static int preferences_collision = FALSE;

static int animate_only = FALSE;

//////////////////////////////////////////////////////
// function headers
//////////////////////////////////////////////////////

void setSoundOw() ;

void setSoundPrize() ;

void setSoundBoom() ;

int getSoundOw() ;

int getSoundPrize() ;

int getSoundBoom() ;

void setTileMapData(jint a[], jint b[], jint c[], jint d[] ) ;

void setGuyData(jint a[], jint b[], jint c[], jint d[] ) ;

void setMonsterData(jint a[], jint b[], jint c[], jint d[] ) ;

void setMovingPlatformData(jint a[]);

void setLevelData(int a[MAP_WIDTH * MAP_HEIGHT],  int b[MAP_WIDTH * MAP_HEIGHT]) ;

void setGuyPosition(int guy_x, int guy_y, int scroll_x, int scroll_y, int guy_animate) ;

void setScoreLives(int a_score, int a_lives) ;

void setObjectsDisplay(int map_x, int map_y, int value) ;

void addMonster(int monster_x, int monster_y, int monster_animate) ;

void inactivateMonster(int num) ;

void addPlatform(int platform_x, int platform_y) ;

int collisionSimple(BoundingBox boxA, BoundingBox boxB) ;

int collisionSimple2(BoundingBox boxA, BoundingBox boxB) ;

void copyScreenCompress(uint32_t from[SCREEN_WIDTH][SCREEN_HEIGHT],  uint32_t to[]) ;

void copyArraysExpand_16(jint from[], int size_l,  uint32_t to[GUY_WIDTH][GUY_HEIGHT]) ;

void copyArraysExpand_8_40(jint from[], int size_l, uint32_t to[PLATFORM_WIDTH][PLATFORM_HEIGHT]);

void copyArraysExpand_tileset (jint from[], int size_l, uint32_t to[TILEMAP_HEIGHT][TILEMAP_WIDTH]) ;

void drawSprite_16(uint32_t from[GUY_WIDTH][GUY_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint32_t extra) ;

void drawSprite_40_8(uint32_t from[PLATFORM_WIDTH][PLATFORM_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint32_t extra) ;

void drawTile_8(uint32_t tile[TILE_WIDTH][TILE_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint32_t extra) ;

void cutTile(uint32_t tileset[TILEMAP_WIDTH][TILEMAP_HEIGHT], uint32_t tile[TILE_WIDTH][TILE_HEIGHT], int num) ;

void drawScoreWords() ;

void drawScoreNumbers() ;

void drawMonsters() ;

void drawMovingPlatform() ;

void collisionWithMonsters() ;

void drawLevel(int animate_level) ;

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
	
	guy.topBB = 2; 
	guy.bottomBB = 16;
	guy.leftBB = 4;
	guy.rightBB = 10;
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
	
	
	for (i = 0 ; i < MAP_HEIGHT ; i ++ ) {
		for (j = 0; j < MAP_WIDTH ; j ++ ) {
			map_level[i][j] = a[ (i * MAP_WIDTH ) + j] ;
			map_objects[i][j] = b[ (i * MAP_WIDTH ) + j] ;
			//LOGE("level data %i ", map_level[i][j]);
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
	}
	monster_num = 0;
	sprite_num = 0;
	platform_num = -1;
	
	return;
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
 *	Used for monster collision function
 *
 *	@param	sprite	a sprite struct
 *	@param	x		an x offset
 *	@param	y		a y offset
 *	@return			the bounding box for the sprite
 */
BoundingBox makeSpriteBox(Sprite sprite, int x, int  y) {
  BoundingBox temp;
  temp.left = sprite.leftBB + sprite.x + x;
  temp.right = sprite.rightBB + sprite.x + x;
  temp.top = sprite.topBB + sprite.y + y;
  temp.bottom = sprite.bottomBB + sprite.y + y;
  return temp;
}

int collisionSimple(BoundingBox boxA, BoundingBox boxB) {
  int x[4], y[4];
  int i, j;
  int test = FALSE;
  int outsideTest, insideTest;
  
  x[0] = boxA.left;
  y[0] = boxA.top;
  
  x[1] = boxA.right;
  y[1] = boxA.top;
  
  x[2] = boxA.left;
  y[2] = boxA.bottom;
  
  x[3] = boxA.right;
  y[3] = boxA.bottom;
  for (i = 0; i < 4; i ++) {
    // is one point inside the other bounding box??
    if (x[i] <= boxB.right && x[i] >= boxB.left && y[i] <= boxB.bottom && y[i] >= boxB.top ) {
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
  if (!test) return collisionHelper(boxA, boxB);
  else return TRUE;
}


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
 *	Used to copy the library's 2D screen array to the 1D array that will be
 *	returned by the library to the java app.
 *
 *	@param	from	the 2D array of screen data
 *	@param	to		the 1D array of screen data prepared for the java app
 */
void copyScreenCompress(uint32_t from[SCREEN_WIDTH][SCREEN_HEIGHT],  uint32_t to[]) {


      int i,j;
      for (i = 0; i < SCREEN_HEIGHT; i ++ ) {
      	for (j = 0; j < SCREEN_WIDTH; j ++ ) {
      		to [( i * SCREEN_WIDTH) + j ] = from[i][j] ;
      	}
      }
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
void copyArraysExpand_16(jint from[], int size_l, uint32_t to[GUY_WIDTH][GUY_HEIGHT]) {


	int i,j, k;
	for (i = 0; i< GUY_HEIGHT; i ++ ) {
		for (j = 0; j < GUY_WIDTH; j ++ ) {
			k =( i * GUY_WIDTH ) + j;
			if ( k < size_l ) {
				to[i][j] = (uint32_t) from[k];
				//LOGE("many assignments here %i", from[k]);
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
void copyArraysExpand_8_40(jint from[], int size_l, uint32_t to[PLATFORM_HEIGHT][PLATFORM_WIDTH]) {

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
 *	Used to copy tilesheet pixel information from the 1D representation that
 *	is used by the java app to the 2D representation that is used by this 
 *	library
 *
 *	@param	from	1D array of tilesheet data pixels
 *	@param	size_l	size in pixels of 'from' array
 *	@param	to		2D array of tilesheet data used by library
 */
void copyArraysExpand_tileset (jint from[], int size_l, uint32_t to[TILEMAP_HEIGHT][TILEMAP_WIDTH]) {

	int num, n, l;
	int i,j, k;
	for (i = 0; i< TILEMAP_HEIGHT; i ++ ) {
		for (j = 0; j < TILEMAP_WIDTH; j ++ ) {
			k =( i * TILEMAP_WIDTH ) + j;
			if ( k < size_l ) {
				to[i][j] = from[k];
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
void drawSprite_16(uint32_t from[GUY_WIDTH][GUY_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint32_t extra) {




    int i,j,k,l;
    k = x - scroll_x;
    l = y - scroll_y;
    for (i = 0; i < GUY_HEIGHT; i ++ ) {
    	for (j = 0; j < GUY_WIDTH; j ++) {
    		if ( (i + l) >= 0 && (j + k) >= 0 && (j+k) < SCREEN_WIDTH && (i+l) < SCREEN_HEIGHT ) {
    			
    			if (paint_all == PAINT_TRANSPARENT && from[i][j] == extra ) {
    				
    			}
    			else {
	    			screen[i + l][j + k] = from[i][j];

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
void drawSprite_40_8(uint32_t from[PLATFORM_HEIGHT][PLATFORM_WIDTH], int x, int y, int scroll_x, int scroll_y, int paint_all, uint32_t extra) {
	
	int i,j,k,l;
    k = x - scroll_x;
    l = y - scroll_y;
    for (i = 0; i < PLATFORM_HEIGHT; i ++ ) {
    	for (j = 0; j < PLATFORM_WIDTH; j ++) {
    		if ( (i + l) >= 0 && (j + k) >= 0 && (j+k) < SCREEN_WIDTH && (i+l) < SCREEN_HEIGHT ) {
    			
    			if (paint_all == PAINT_TRANSPARENT && from[i][j] == extra ) {
    				
    			}
    			else {
	    			screen[i + l][j + k] = from[i][j];
					//screen[i + k][j + l] = from[i][j];
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
void drawTile_8(uint32_t tile[TILE_WIDTH][TILE_HEIGHT], int screen_x, int screen_y, int scroll_x, int scroll_y, int paint_all, uint32_t extra) {
   
    int i,j,m,n;

	m = (screen_x ) - scroll_x;

	n = (screen_y ) - scroll_y;

    
    for (i = 0; i < TILE_HEIGHT; i ++ ) {
    	for (j = 0; j < TILE_WIDTH; j ++) {
    		if ( (i + n) >= 0 && (j + m) >= 0 && (i+n) < SCREEN_HEIGHT  && (j+m) <  SCREEN_WIDTH ) {
    			if ( paint_all == PAINT_TRANSPARENT && tile[i][j] == extra ) {
    				//
    			}
    			else {
	    			screen[i + n ][j + m] = tile[i][j];
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
void cutTile(uint32_t tileset[TILEMAP_HEIGHT][TILEMAP_WIDTH], uint32_t tile[TILE_HEIGHT][TILE_WIDTH], int num) {


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
 *	Used to draw the words 'score' and 'lives' on the library's screen array.
 */
void drawScoreWords() {


		int i;
    	int topScore[] = {374,375,376,377,378,383};

    	int topLives[] = {379,380,381,378,382,383};

    	int scorePos, livesPos;
    	scorePos = 2 ;
    	livesPos = 16  ;
        uint32_t square[TILE_HEIGHT][TILE_WIDTH];
    	//mTiles = new TileCutter(bMapNum);
		
		
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
        uint32_t square[TILE_HEIGHT][TILE_WIDTH];
    	//mTiles = new TileCutter(bMapNum);

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
			
			sprite[i].animate ++;
			if (sprite[i].animate > anim_speed * 4) sprite[i].animate=0;
			if (sprite[i].animate > anim_speed * 2) z = 1;
			else z = 0;

			
			if(sprite[i].visible == TRUE && visibility == show) {
				
	    		if(sprite[i].facingRight == TRUE) {
					if(z == 0) {
						//(R.drawable.monster_r0);
						drawSprite_16(monster_a, sprite[i].x, sprite[i].y, 
							scrollx, scrolly, PAINT_TRANSPARENT, 0);

					}
					else if (z == 1) {
						//(R.drawable.monster_r1);
						drawSprite_16(monster_b, sprite[i].x, sprite[i].y, 
							scrollx, scrolly, PAINT_TRANSPARENT, 0);
					}
				}
				else if (!sprite[i].facingRight == TRUE) {
					if(z == 0) {
						//(R.drawable.monster_l0);
						drawSprite_16(monster_c, sprite[i].x, sprite[i].y, 
							scrollx, scrolly, PAINT_TRANSPARENT, 0);
					}
					else if (z == 1) {
						//(R.drawable.monster_l1);
						drawSprite_16(monster_d, sprite[i].x, sprite[i].y, 
							scrollx, scrolly, PAINT_TRANSPARENT, 0);
					}
				}
	    		
			}

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
  int hide = TRUE;
  int show = FALSE;
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
        if(map_objects[x_right][y_right] == B_BLOCK) markerTest = TRUE;
        if(map_objects[x_right][y_right] == B_MARKER) markerTest = TRUE;

        // turn platform
        if (sprite[i].x > level_w   * 8   - PLATFORM_WIDTH || markerTest == TRUE) {
          sprite[i].facingRight = FALSE;
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
        if (sprite[i].x <= 0 || markerTest == TRUE) {
          sprite[i].facingRight = TRUE;
        }
      } 
    
      visibility = show;
      //hide platform
      if(sprite[i].x > scrollx + 32 * 8 + (8 * width) ) {
        visibility = hide;
      }
      if (sprite[i].x < scrollx - (8 * width)) {
        visibility = hide;
      }
      //hide platform
      if(sprite[i].y > scrolly + 24 * 8 + (8 * width)) {
        visibility = hide;
      }
      if ( sprite[i].y < scrolly - (8 * width)) {
        visibility = hide;
      }
    
      if(visibility == show) {
      		drawSprite_40_8(platform_a, sprite[i].x, sprite[i].y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
	  }
    
  }

  return;
}

/**
 *	Used to detect collision with monsters
 */
void collisionWithMonsters() {

	int i;
	//int index_num = 0;
	
	//if (sprite_num > monster_num) index_num = sprite_num;
	//else index_num = monster_num;
	
	
		  BoundingBox guyBox = makeSpriteBox( guy , 0, 0 );

		  
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
		    	}
		    	//mGameV.incrementScore(10);
				//mSounds.playSound(SoundPoolManager.SOUND_BOOM);
				setSoundBoom();
		        
		        
		      }
		      else {
				endlevel = TRUE;
				if (preferences_collision == TRUE) inactivateMonster(i);
		    	//level.endLevel = true;
		        lives --;
				//mSounds.playSound(SoundPoolManager.SOUND_OW);
				setSoundOw();
		      }
		    }
		  }

}

/**
 *	Used to draw all the components of the level on the screen.
 *
 *	@param	animate_level	number used to decide which version of the tileset
 *							is used, providing animated appearance of rings
 */
void drawLevel(int animate_level) {
    
    int i,j,k,l;
    int baseX, baseY;//, startX, startY;
    int mapcheat = 1;
    uint32_t square[TILE_HEIGHT][TILE_WIDTH];
    
    animate = animate_level;
    
    /* clear screen */
    for (i = 0 ; i < (SCREEN_HEIGHT ); i ++ ) {
    	for( j = 0; j < SCREEN_WIDTH; j ++ ) {
    	
	    	screen[i][j] = (uint32_t) 0x0000;// = -1;
	    }
    }
    
    /* draw background */
    baseX = scrollx / TILE_WIDTH;
    baseY = scrolly / TILE_HEIGHT;
    
	for ( j = baseX - 1; j <  baseX + tilesWidthMeasurement + 3; j++) { //32
    	for ( i = baseY - 1 ; i < baseY + tilesHeightMeasurement + 3; i ++ ) { //24
    		
    		
    		if (i >= 0 && j >= 0  && i < MAP_HEIGHT && j < MAP_WIDTH) { 
    			if(  map_level[j][i] != 0 ) { //is tile blank??
    				cutTile(tiles_a, square, map_level[j][i]);
    				drawTile_8(square, j * TILE_WIDTH, i * TILE_HEIGHT , 
    					scrollx , scrolly, PAINT_SOLID, 0);
				}
				// special animated tiles
				k = map_objects[j][i];
				if ( k != B_START && k != B_MONSTER && k != B_DEATH
    				&& k != B_PLATFORM && k != B_MARKER && k != B_BLOCK
    				&& k != B_LADDER  && k != B_SPACE) {
    				
    				
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
    
    /* draw guy with animation */
    if (guy.animate == 0) {
	    drawSprite_16(guy_a, guy.x, guy.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
	}
	else if (guy.animate == 1) {
	    drawSprite_16(guy_b, guy.x, guy.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);
	}
	else if (guy.animate == 2) {
	    drawSprite_16(guy_c, guy.x, guy.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);	
	}
	else { // if (guy.animate == 3) {
	    drawSprite_16(guy_d, guy.x, guy.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);	
	}

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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setTileMapData(JNIEnv * env, jobject  obj, jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setGuyData(JNIEnv * env, jobject  obj, jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
{

  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);
  jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);
  jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);
  
  setGuyData(a, b, c, d );
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setMonsterData(JNIEnv * env, jobject  obj, jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
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
 *	Used to establish the platform sprite array at the time of instatiation of 
 *	the Panel constructor.
 *
 *	@param	env			required by all java jni
 *	@param	obj			required by all java jni
 *	@param	a_bitmap	1D platform pixel array
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setMovingPlatformData(JNIEnv * env, jobject  obj, jintArray a_bitmap) 
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_addMonster(JNIEnv * env, jobject  obj, jint monster_mapx, jint monster_mapy,  jint animate_index)
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_addPlatform(JNIEnv * env, jobject  obj, jint platform_mapx, jint platform_mapy)
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_inactivateMonster(JNIEnv * env, jobject  obj, jint monster_num)
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
 *	@param	animate		animate value for background
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setGuyPosition(JNIEnv * env, jobject  obj, jint x_pos, jint y_pos, jint scroll_x, jint scroll_y, jint animate)
{
	setGuyPosition(x_pos, y_pos, scroll_x, scroll_y, animate);	

}

/**
 *	Used to set the 'score' and 'lives' values to be displayed on the screen
 *
 *	@param	env		required by all java jni
 *	@param	obj		required by all java jni
 *	@param	score	the score
 *	@param	lives	the lives
 */
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setScoreLives(JNIEnv * env, jobject  obj, jint score, jint lives)
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setMonsterPreferences(JNIEnv * env, jobject  obj, jint monsters, jint collision)
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setJNIAnimateOnly(JNIEnv * env, jobject  obj, jint animate)
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setScreenData(JNIEnv * env, jobject  obj, jint screenH, jint screenV)
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setLevelData(JNIEnv * env, jobject  obj, jintArray level, jintArray objects, jint width, jint height)
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_setObjectsDisplay(JNIEnv * env, jobject  obj, jint map_x, jint map_y, jint value)
{
	setObjectsDisplay(map_x, map_y, value);	

}

/**
 *	Used to return to the java app the data from the 2D screen array kept by the
 *	library.
 *
 *	@param	env		required by all java jni
 *	@param	obj		required by all java jni
 *	@param	animate	a number to use as an animation index, used mostly for the 
 *					animation of the rings.
 *	@return			the 1D representation of the 2D array of screen data.					
 */
JNIEXPORT jintArray JNICALL Java_org_davidliebman_android_awesomeguy_Panel_drawLevel(JNIEnv * env, jobject  obj, jint animate)
{
	int j,k;
	jint size = SCREEN_WIDTH * SCREEN_HEIGHT;
	jint fill[size]; 
	jintArray graphic;
	drawLevel(animate);
	graphic = (*env)->NewIntArray(env, size);
	if(graphic == NULL) {
		LOGE("ARRAY NOT CREATED");
		return NULL;
	}
	for (j = 0; j < SCREEN_HEIGHT; j++) {
		for (k = 0; k < SCREEN_WIDTH ; k ++ ) {
			fill[ (j * SCREEN_WIDTH) + k ] = (jint) screen[j][k];
		}
	}
	
	
	(*env)->SetIntArrayRegion(env, graphic,0, size, fill);
	return graphic;
}


/**
 *	Used to tell the java program that the sound can be played
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					weather the sound is playable.
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_awesomeguy_Panel_getSoundBoom(JNIEnv * env, jobject  obj)
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
JNIEXPORT int JNICALL Java_org_davidliebman_android_awesomeguy_Panel_getSoundOw(JNIEnv * env, jobject  obj)
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
JNIEXPORT int JNICALL Java_org_davidliebman_android_awesomeguy_Panel_getSoundPrize(JNIEnv * env, jobject  obj)
{
	return getSoundPrize();	

}

/**
 *	Used to tell the java program how many lives are left
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					lives
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_awesomeguy_Panel_getLives(JNIEnv * env, jobject  obj)
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
JNIEXPORT int JNICALL Java_org_davidliebman_android_awesomeguy_Panel_getEndLevel(JNIEnv * env, jobject  obj)
{
	
	int temp = endlevel;
  	endlevel = FALSE;
	return temp;	

}

/**
 *	Used to tell the java program the score
 *
 *	@param	env				required by all java jni
 *	@param	obj				required by all java jni
 *	@return					score
 */
JNIEXPORT int JNICALL Java_org_davidliebman_android_awesomeguy_Panel_getScore(JNIEnv * env, jobject  obj)
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
JNIEXPORT void JNICALL Java_org_davidliebman_android_awesomeguy_Panel_incrementJniScore(JNIEnv * env, jobject  obj, jint num)
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
JNIEXPORT int JNICALL Java_org_davidliebman_android_awesomeguy_Panel_getSpriteX(JNIEnv * env, jobject  obj, jint num)
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
JNIEXPORT int JNICALL Java_org_davidliebman_android_awesomeguy_Panel_getSpriteY(JNIEnv * env, jobject  obj, jint num)
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
JNIEXPORT int JNICALL Java_org_davidliebman_android_awesomeguy_Panel_getSpriteFacingRight(JNIEnv * env, jobject  obj, jint num)
{
	return sprite[num].facingRight;	

}
