
#ifndef ANDROIDGL_H
#define ANDROIDGL_H


#include <jni.h>
#include <android/log.h>
#include <stdio.h> 
#include <stdlib.h>
#include <assert.h>
 
#include <GLES/gl.h>
#include <GLES/glext.h>

// include program libraries
// include loge and logi definitions
 
#define  LOG_TAG              "awesomeguy-jni"
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)

#define TRUE 1
#define FALSE 0 

#define VIDEO_WIDTH   320
#define VIDEO_HEIGHT  240


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
 
//uint32_t number_alpha = 0; // moved to awesomeguy.c
 
static int tilesWidthMeasurement = 32;
static int tilesHeightMeasurement = 32;

////////////////////////////////////

typedef struct {
	int x, y, animate;
	int facingRight, active, visible;
	int leftBB, rightBB, topBB, bottomBB;
} Sprite;
 
Sprite sprite[100];

//moved to awesomeguy.c ...
//int sprite_num = 0;
//int monster_num = 0;
//int platform_num = -1;

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
// function prototype
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

#endif
