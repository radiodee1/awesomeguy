
#ifndef ANDROIDGL_H
#define ANDROIDGL_H


#include <jni.h>
#include <android/log.h>
#include <stdio.h> 
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <pthread.h>
#include <time.h>


#include <GLES/gl.h>
#include <GLES/glext.h>

// include program libraries
// include loge and logi definitions
 
#define  LOG_TAG              "awesome-flyer-jni"
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)
#define RGB565(r, g, b)  (((r) << (5+6)) | ((g) << 6) | (b))
#define RGBA4444(r, g, b, a )  ((( r) << 12) | ((g) << 8) | ((b) << 4) | (a))

#define TRUE 1
#define FALSE 0 

#define TEX_WIDTH   256
#define TEX_HEIGHT  256

#define LONG_MAP_H	192
#define LONG_MAP_V	32

#define TEX_DIMENSION	256
#define BOOL int

#define MY_SCREEN_FRONT 0
#define MY_SCREEN_BACK  1

#define TORPEDO_TOTAL 5
#define TORPEDO_FLYING 1
#define TORPEDO_HIT  2
#define TORPEDO_UNUSED 0

/* B is for BLOCK */
static int B_NONE = -1;
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

/* S is for SPRITE */
#define  S_NONE  0
#define  S_GUY  1
#define  S_FLYER  2
#define  S_GATOR  3
#define  S_CLOUD  4
#define  S_TORPEDO  5
#define S_BUBBLE_0  6
#define S_BUBBLE_1  7
#define S_BUBBLE_2  8
#define S_BUBBLE_3  9
#define S_INVADER_1  10
#define S_INVADER_2  11
#define S_INVADER_3  12
#define S_LINE	13
#define S_LINE_2 14
#define S_EXPLOSION_SPRITE 15

/* P is for PATH */
#define P_NONE 0
#define P_GOING_LEFT 1
#define P_GOING_RIGHT 2
#define P_GOING_LEFT_ARMED 3
#define P_GOING_RIGHT_ARMED 4

/* D is for DRAW */
#define D_NONE 0
#define D_FLYER 1
#define D_EXPLOSION 2
#define D_EXPLOSION_SPRITE 3
#define D_CLOUD 4
#define D_GATOR 5
#define D_INVADER_1 6
#define D_INVADER_2 7
#define D_INVADER_3 8
#define D_FLYER_RINGS 9

/* BB is for BoundingBox */
#define BB_NONE  0
#define BB_REGULAR  1
#define BB_NO_SCROLL  2

#define PING_FLYER 0
#define PING_OTHER 1
#define PING_ROCK 2

static int TILEMAP_WIDTH = 224;
static int TILEMAP_HEIGHT = 128;
 
static int TILE_WIDTH = 8;
static int TILE_HEIGHT = 8;
 
static int GUY_WIDTH = 16;
static int GUY_HEIGHT = 16;
static int GUY_CHEAT = 3;

static int FLYER_WIDTH = 40;
static int FLYER_HEIGHT = 16;
 
static int EXPLOSION_WIDTH = 64;
static int EXPLOSION_HEIGHT = 64;

static int MONSTER_WIDTH = 16;
static int MONSTER_HEIGHT = 16;
 
static int PLATFORM_WIDTH = 40;
static int PLATFORM_HEIGHT = 8;
 
static int LASER_WIDTH = 150;
static int LASER_GUN = 12;

static int MAP_WIDTH = LONG_MAP_V; //note: confusion here...
static int MAP_HEIGHT = LONG_MAP_H;
 
static int SCREEN_WIDTH = 256;
static int SCREEN_HEIGHT = (256 * 3 / 4) - 32;
 
static int RADAR_WIDTH = LONG_MAP_H; // this is actually how many tiles
static int RADAR_HEIGHT = LONG_MAP_V; // this is actually how many tiles

static int PAINT_SOLID = 0;
static int PAINT_TRANSPARENT = 1;
 
static uint16_t tiles_a[128][224];
static uint16_t tiles_b[128][224];
static uint16_t tiles_c[128][224];
static uint16_t tiles_d[128][224];
 
static uint16_t rollee1_a[8][8];
static uint16_t rollee1_b[8][8];

static uint16_t guy_a[16][16];
static uint16_t guy_b[16][16];
static uint16_t guy_c[16][16];
static uint16_t guy_d[16][16];

static uint16_t invader1_l[16][16];
static uint16_t invader1_r[16][16];

static uint16_t flyer_l0[16][40];
static uint16_t flyer_l1[16][40];
static uint16_t flyer_r0[16][40];
static uint16_t flyer_r1[16][40];
 
static uint16_t flyer_white_l[16][40];
static uint16_t flyer_white_r[16][40];

static uint16_t explosion_a[64][64];
static uint16_t explosion_b[64][64];
static uint16_t explosion_c[64][64];
static uint16_t explosion_d[64][64];
static uint16_t explosion_e[64][64];
static uint16_t explosion_f[64][64];
static uint16_t explosion_g[64][64];
static uint16_t explosion_h[64][64];

static uint16_t monster_a[16][16];
static uint16_t monster_b[16][16];
static uint16_t monster_c[16][16];
static uint16_t monster_d[16][16];
 
static uint16_t platform_a[8][40];
 
static int map_level [LONG_MAP_H][LONG_MAP_V];
static int map_objects[LONG_MAP_H][LONG_MAP_V];

//////////////////////////////////////////////////////////
// these arrays are used as the basis for the opengl texture
// which prints the screen contents to the opengl window.
// it must have dimenstions of powers of 2.
/////////////////////////////////////////////////////////
static uint16_t screen_0 [TEX_DIMENSION][TEX_DIMENSION];
static uint16_t screen_1 [TEX_DIMENSION][TEX_DIMENSION];

static uint16_t screencounter = 0;
 
static int tilesWidthMeasurement = 32;
static int tilesHeightMeasurement = 32;

static uint8_t alert_color = 0x0;
////////////////////////////////////

typedef struct {
	int x, y, animate;
	int facingRight, active, visible;
	int leftBB, rightBB, topBB, bottomBB;
	int radius, limit, speed, strength, color;
	int sprite_type, sprite_link;
	int endline_x, endline_y;
	int quality_0, quality_1, quality_2, quality_3;
} Sprite;
 
Sprite sprite[100];

Sprite guy;
Sprite flyer;
Sprite box;

Sprite torpedos[TORPEDO_TOTAL];

///////////////////////////////////
typedef struct {
	int rings, invader_1, invader_2, invader_3;
	int bubble_1, bubble_2, bubble_3;
	int speed;

} Challenge;

Challenge challenge[50];
///////////////////////////////////

typedef struct {
	int x,y, type, value;
} Candidate;

Candidate candidate[20];

///////////////////////////////////

typedef struct {
	int left, right, top, bottom;
	int sprite_type, response;
} BoundingBox;

///////////////////////////////////

typedef struct {
	int timer_total, timer_progress, timer_disable;
} Timer;

Timer timer[10];

// 0, 1, 2, 3, 4, 5, 6, 7, 8

///////////////////////////////////
// These are the places for storage of weather or not a certain part
// of a challenge has been cleared so that the next part can be faced.
static int total_rings;
static int total_bubble_0, total_bubble_1, total_bubble_2, total_bubble_3;
static int total_invader_1, total_invader_2, total_invader_3;

static int total_placed_bubble_1, total_placed_bubble_2, total_placed_bubble_3;
static int total_placed_invader_1, total_placed_invader_2, total_placed_invader_3;

static int total_held_rings;

///////////////////////////////////
static int level_h, level_w, lives, scrollx, scrolly, oldscrollx, animate , score;
static int oldx, oldy;
static int is_moving, is_landing, is_blinking;
static int changex;

static int keyB;

static int endlevel = FALSE;
static int gamedeath = FALSE;
static int game_level = 0;

static int sound_ow = FALSE;
static int sound_prize = FALSE;
static int sound_boom = FALSE;
static int sound_goal = FALSE;

static int sound_enter_1 = FALSE;
static int sound_enter_2 = FALSE;
static int sound_enter_3 = FALSE;
static int sound_enter_4 = FALSE;

static int preferences_monsters = FALSE;
static int preferences_collision = FALSE;
static int preferences_mountains = FALSE;

static int animate_only = FALSE;
static int flyer_explosion = 0;

static int blank_screen = FALSE;

static BoundingBox radar_box ;
static int radar_start ;
static int radar_start_scroll;
static BOOL radar_set = FALSE;

//////////////////////////////////////////////////////
// open gl stuff
//////////////////////////////////////////////////////

static int use_gl2 = FALSE;

static GLuint 	texture_id;
static int screen_width, screen_height;
static int lastGuy, lastBG;
static int animate_int = 0;
static int newGuy = 0;
static int newBG =0;

static float vertices[12] ;
static short indices[] = { 0, 1, 2, 0, 2, 3 };
static float tex_coords[8] ; 

static float flip_angle = 0;
static BOOL screen_flip = FALSE;

//////////////////////////////////////////////////////
// function prototype: awesomeguy.c
//////////////////////////////////////////////////////

void setSoundOw() ;

void setSoundPrize() ;

void setSoundBoom() ;

void setSoundGoal();

void setSoundEnter1();

void setSoundEnter2();

void setSoundEnter3();

void setSoundEnter4();

int getSoundOw() ;

int getSoundPrize() ;

int getSoundBoom() ;

int getSoundGoal() ;

int getSoundEnter1();

int getSoundEnter2();

int getSoundEnter3();

int getSoundEnter4();

void setTileMapData(jint a[], jint b[], jint c[], jint d[] ) ;

void setGuyData(jint a[], jint b[], jint c[], jint d[] ) ;

void setInvader1Data(jint a[], jint b[]);

void setInvader2Data(jint a[], jint b[]);

void setFlyerData(jint a[], jint b[], jint c[], jint d[] ) ;

void setMonsterData(jint a[], jint b[], jint c[], jint d[] ) ;

void setExplosionData(jint a[], jint b[], jint c[], jint d[] ,jint e[], jint f[], jint g[], jint h[] ) ;

void setMovingPlatformData(jint a[]);

void setLevelData(int a[MAP_WIDTH * MAP_HEIGHT],  int b[MAP_WIDTH * MAP_HEIGHT]) ;

void addChallenges(int rings, int bubble1, int bubble2, int bubble3, int invader1, int invader2, int invader3, int speed) ;

void initChallenges() ;

void placeChallengesRings() ;

void placeChallengesBubble1();

void placeChallengesBubble2() ;

void placeChallengesInvader1() ;

void placeChallengesInvader2() ;

void setGuyPosition(int guy_x, int guy_y, int scroll_x, int scroll_y, int guy_animate) ;

void setScoreLives(int a_score, int a_lives) ;

void setObjectsDisplay(int map_x, int map_y, int value) ;

void addMonster(int monster_x, int monster_y, int monster_animate) ;

void inactivateMonster(int num) ;

void addSprite(Sprite temp) ;

BoundingBox makeSpriteBox(Sprite sprite, int x, int  y) ;

void addPlatform(int platform_x, int platform_y) ;

void inactivateMonsterView(int num) ;

int collisionSimple(BoundingBox boxA, BoundingBox boxB) ;

int collisionHelper(BoundingBox boxA, BoundingBox boxB) ;

BOOL collisionHelperLine(int lineAXstart, int lineAXend, int lineAY, int lineBYstart, int lineBYend, int lineBX) ;


void copyArraysExpand_8(jint from[], int size_l,  uint16_t to[8][8]) ;

void copyArraysExpand_16(jint from[], int size_l,  uint16_t to[GUY_WIDTH][GUY_HEIGHT]) ;

void drawSprite_64(uint16_t from[EXPLOSION_WIDTH][EXPLOSION_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) ;

void copyArraysExpand_16_40(jint from[], int size_l,  uint16_t to[FLYER_WIDTH][FLYER_HEIGHT]) ;

void copyArraysExpand_8_40(jint from[], int size_l, uint16_t to[PLATFORM_WIDTH][PLATFORM_HEIGHT]);

void copyArraysExpand_64(jint from[], int size_l, uint16_t to[EXPLOSION_WIDTH][EXPLOSION_HEIGHT]);

void copyArraysExpand_tileset (jint from[], int size_l, uint16_t to[TILEMAP_HEIGHT][TILEMAP_WIDTH]) ;

void drawSprite_16(uint16_t from[GUY_WIDTH][GUY_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) ;

void drawSprite_40_8(uint16_t from[PLATFORM_WIDTH][PLATFORM_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) ;

void drawSprite_40_16(uint16_t from[FLYER_WIDTH][FLYER_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) ;

void drawTile_8(uint16_t tile[TILE_WIDTH][TILE_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) ;

void cutTile(uint16_t tileset[TILEMAP_WIDTH][TILEMAP_HEIGHT], uint16_t tile[TILE_WIDTH][TILE_HEIGHT], int num) ;

void drawLasers( ) ;

void drawFlyerExplosion(int x, int y ) ;

Sprite makeTorpedos(int ii, int x, int y) ;

BOOL collisionTorpedos(BoundingBox test) ;

void drawScoreWords() ;

void drawScoreNumbers() ;

void drawMonsters() ;

void drawMovingPlatform() ;

void collisionWithMonsters() ;

void animate_vars();

void drawLevel(int animate_level) ; // note: there were 2 drawLevel() methods.

void checkRegularCollision() ;

BOOL checkBubbleCollision(int x) ;

BOOL checkInvaderCollision(int i) ;

void drawSpriteExplosion();

void drawFlyer() ;

void drawTorpedo() ;

void drawBubbleType0() ;

void drawBubbleType1() ;

void drawBubbleType2() ;

void drawInvaderType1();

void drawInvaderType2();

BOOL goingRightIsShortest( int spritex, int flyerx ) ;

BoundingBox makeBubbleBox( int start_x, int stop_x, int start_y, int stop_y) ;

void drawBubbleWithColor() ;

void drawBasicSprite(int spriteNum, int kind );

void drawHorizontal(int y, int start_x, int stop_x, uint16_t color, int type) ;

void drawPoint(int x, int y, uint16_t color) ;

void drawBoundingBox( BoundingBox box, BOOL special, uint16_t color);

void drawRadarPing( BoundingBox box, int x, int y , int kind,  uint16_t color) ;

void set_radar_start(int x) ;

void drawRadarRock();

void alertOnScreen();

BOOL checkTotalsAllCleared() ;

uint16_t **  getScreenPointer(int screen_enum) ;

void incrementScreenCounter() ;

int getRand(int min, int max) ;

int adjust_x(int x) ;

void add_explosion(Sprite sprite);

int get_sprite_speed ( int spritetype ) ;

BOOL timerDone( int i) ;

void timerStart(int i, int time);

BOOL spriteTimerDone( int i) ;

void spriteTimerStart(int i, int time) ;

void torpedosTimerStart(int i, int time);

BOOL torpedosTimerDone(int i) ;

//////////////////////////////////////////////////////
// function prototype: androidgl.c
//////////////////////////////////////////////////////

void init() ;

void draw();

void resize(int w, int h);

uint16_t color_pixel(uint16_t temp) ;

#endif
