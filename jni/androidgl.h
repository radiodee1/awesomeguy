
#ifndef ANDROIDGL_H
#define ANDROIDGL_H


#include <jni.h>
#include <android/log.h>
#include <stdio.h> 
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <pthread.h>

#ifdef GL2

#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>

#else
#include <GLES/gl.h>
#include <GLES/glext.h>

#endif

// include program libraries
// include loge and logi definitions
 
#define  LOG_TAG              "awesomeguy-jni"
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)
#define RGB565(r, g, b)  (((r) << (5+6)) | ((g) << 6) | (b))
#define RGBA4444(r, g, b, a )  ((( r) << 12) | ((g) << 8) | ((b) << 4) | (a))

#define TRUE 1
#define FALSE 0 

#define TEX_WIDTH   256
#define TEX_HEIGHT  256

#define TEX_DIMENSION	256
#define BOOL int

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
 
static uint16_t tiles_a[128][224];
static uint16_t tiles_b[128][224];
static uint16_t tiles_c[128][224];
static uint16_t tiles_d[128][224];
 
static uint16_t guy_a[16][16];
static uint16_t guy_b[16][16];
static uint16_t guy_c[16][16];
static uint16_t guy_d[16][16];
 
static uint16_t monster_a[16][16];
static uint16_t monster_b[16][16];
static uint16_t monster_c[16][16];
static uint16_t monster_d[16][16];
 
static uint16_t platform_a[8][40];
 
static int map_level [96][96];
static int map_objects[96][96];
 
uint16_t screen [TEX_DIMENSION][TEX_DIMENSION];
// this array is used as the basis for the opengl texture 
// which prints the screen contents to the opengl window.
// it must have dimenstions of powers of 2.

 
static int tilesWidthMeasurement = 32;
static int tilesHeightMeasurement = 32;

////////////////////////////////////

typedef struct {
	int x, y, animate;
	int facingRight, active, visible;
	int leftBB, rightBB, topBB, bottomBB;
} Sprite;
 
Sprite sprite[100];

Sprite guy;



///////////////////////////////////

typedef struct {
	int left, right, top, bottom;
} BoundingBox;

///////////////////////////////////

static int level_h, level_w, lives, scrollx, scrolly, animate , score;

static int endlevel = FALSE;

static int sound_ow = FALSE;
static int sound_prize = FALSE;
static int sound_boom = FALSE;

static int preferences_monsters = FALSE;
static int preferences_collision = FALSE;

static int animate_only = FALSE;

//////////////////////////////////////////////////////
// open gl stuff
//////////////////////////////////////////////////////

static int use_gl2 = FALSE;

//static uint16_t pixbuf[TEX_WIDTH * TEX_HEIGHT] ;
static GLuint 	texture_id;
static int screen_width, screen_height;
static int lastGuy, lastBG;
static int animate_int = 0;
static int newGuy = 0;
static int newBG = 0;

static float vertices[12] ;
static short indices[] = { 0, 1, 2, 0, 2, 3 };
static float tex_coords[8] ; 


//////////////////////////////////////////////////////
// function prototype: awesomeguy.c
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

int collisionHelper(BoundingBox boxA, BoundingBox boxB) ;

void copyArraysExpand_16(jint from[], int size_l,  uint16_t to[GUY_WIDTH][GUY_HEIGHT]) ;

void copyArraysExpand_8_40(jint from[], int size_l, uint16_t to[PLATFORM_WIDTH][PLATFORM_HEIGHT]);

void copyArraysExpand_tileset (jint from[], int size_l, uint16_t to[TILEMAP_HEIGHT][TILEMAP_WIDTH]) ;

void drawSprite_16(uint16_t from[GUY_WIDTH][GUY_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) ;

void drawSprite_40_8(uint16_t from[PLATFORM_WIDTH][PLATFORM_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) ;

void drawTile_8(uint16_t tile[TILE_WIDTH][TILE_HEIGHT], int x, int y, int scroll_x, int scroll_y, int paint_all, uint16_t extra) ;

void cutTile(uint16_t tileset[TILEMAP_WIDTH][TILEMAP_HEIGHT], uint16_t tile[TILE_WIDTH][TILE_HEIGHT], int num) ;

void drawScoreWords() ;

void drawScoreNumbers() ;

void drawMonsters() ;

void drawMovingPlatform() ;

void collisionWithMonsters() ;

void animate_vars();

void drawLevel(int animate_level) ;

//////////////////////////////////////////////////////
// function prototype: androidgl.c
//////////////////////////////////////////////////////

void init() ;

void draw();

void resize(int w, int h);

uint16_t color_pixel(uint16_t temp) ;

#endif
