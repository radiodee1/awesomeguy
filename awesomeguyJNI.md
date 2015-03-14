# Introduction #

Here we'll go through a method by method explanation of the 'awesomeguy.c' file, as well as talk a little about how we might have implemented Awesomeguy's graphics in java. First, though, we'll repeat some information from another wiki that describes Awesomeguy's graphics.



# Overview #

The format of the Awesomeguy game is that of a simple platform game, in some ways like the original “Donkey Kong” or “Super Mario Brothers”. The Nintendo DS version has two screens of 192x256 pixels each. During gameplay one of the screens was generally used as a splash screen. The game also makes use of four directional keys and two special keys -- one of which is the 'jump' key.

The android phone that the game was developed for had no "D-pad". For the android version, two separate View objects were required during regular game play. One View was for display of the game screen, the equivalent of the main screen from the Nintendo game, and the other View was the emulated "D-pad". The "D-pad" was emulated using TouchButtons? on the touch screen and also an alternative where movement instructions were taken from the trackball. The DS version of the game uses several large int arrays for keeping track of the appearance of each level in the game. In order to port the levels to the android version, the same sort of array was used in the android code. In this way the android version can use the exact same level definition info. The android version also uses an ArrayList? to keep track of sprite data, though sprites are not hardware supported in java. One ArrayList? is used for all types of sprites. The DS version makes use of a set of four tiles that are used to paint the levels from the predefined level array on the game screen. The same tile set was used in the android version, but software was used to emulate the DS's hardware tiling system. For these reasons the android version of the game is slower to play than the homebrew DS version.  [top](awesomeguyJNI#Introduction.md)

### Tilesheets ###

Tilesheets are very important to the Awesomeguy game. Tilesheets do not exist natively in the Java language, so they must be simulated for the Android phone using code. The basic concept behind tilesheets is complex. A tilesheet is made up of many 8x8 squares. Each square is referred to as a tile. The tilesheet itself can contain many hundreds of tiles. The game uses the tilesheet to draw the background that the user sees as they play the game. Rather than paint a different background for each level, a map is used. The map is a matrix, and each number in this 2D matrix represents an 8x8 tile from the tilesheet.

This cuts down on memory usage. Rather than save to a file the entire drawing of the background of some level, the programmer saves the matrix, or map, which is smaller but represents the same picture. The game system on which the Awesomeguy game was developed used a tilesheet/map system similar to the one described, only it was implemented on the hardware level. In order to make Awesomeguy look exactly like the original, the tilesheets from the original game were copied and imported to the Android app, and the tiling system was emulated in software.

Awesomeguy uses two map arrays for each level, and it uses four tile sheets. The tilesheets are shared by all levels of the game, and they are nearly identical.

The first map array holds a definition for the background of the level that is much the same as the one discussed above. This is a map of the visible background of the level that's being played. The second map array is identical in size to the first one. It holds information about what each picture in the other map means to the program and the character. Where the first map shows a solid wall, the second map holds a number that tells the program that the character may not pass through it. Walls in the first array can be many colors and patterns as chosen from the tilesheet, but in the second array, just one number corresponds to all wall objects. The first array is visible while the second array is never seen. The first array is referred to as the 'level' or 'tile' array, and the second array is referred to as the 'objects' array. Remember, the two arrays are always the same size.

The way the four tilesheets work is relatively simple. They are identical in size and content except for the images imbedded in the tilesheet of the rings. The rings are prizes in the game and when you get one you get points. There are four tilesheets so that the rings can be animated and made to look like they are turning. The difference in the ring images is the only difference in the four tilesheets. To make the rings look like they are moving the tilesheets are swapped during game play. This swapping happens in the JNI functions.   [top](awesomeguyJNI#Introduction.md)

### Tilemaps ###

Another important component in the Awesomeguy game is the set of map arrays collectively known as tilemaps. These large 2 dimensional arrays contain the data that is used to decide what gets painted on the background screen and where it gets painted. The tilesheets are divided up into 8x8 squares. Every square gets a number, and those numbers populate the tilemaps. One of the tilemap's indexes represents the x axis, and another represents the y axis. The matrix then can cover a 2D plane with values. If the programmer wants to put a ladder in the upper left hand corner, he or she takes a 8x8 square representing a ladder from the tilesheet and places it in the tilemap at the location with the 0,0 indexes. The screen is defined this way, so that the upper-right has high x values and low y values, the lower-left has high y values and low x values, and the lower-right has both high x and y values. This reflects the numbering of pixels on a computer screen, but in this model each pixel is a complete tile from the tilesheet.

Tilesheets are not numbered with two indexes. Tilesheet 8x8 squares are numbered with a single index. For this reason it's difficult to change the size of a tilesheet once it has been established. A tilesheet containing 8x8 squares in a pattern of 3 tiles by 5 tiles would have tiles numbered 0 to 14. A tilemap element contains one of these numbers. One number typically represents 'nothing' or 'no contents', while another number might represent a solid object (like a wall) and another number might symbolize the tile that contains the image for a ladder.

For Awesomeguy there are two identical tilemaps. One holds all the information mentioned above. It holds designations for where to place tiles that show images of walls and ladders and floors. The second tilemap holds extra information that the game needs. This info includes the starting location of the main character, the starting location of each monster, further information about the location of walls and floors, the location of floating platforms, and the location of all the rings and prizes on the level. It holds the code for the checkpoint character and the level goal character and also the code for a special tile that causes instant death when it is touched. The two tilemaps are called the 'level' tilemap and the 'object' tilemap. They are exactly the same size, and an element at a certain x/y location on one map refers to the same spot on the screen as that x/y location on the other map. The two maps can be laid on top of each other.

The reason for two maps is so that one map, the 'level' map, can be responsible for drawing the image of the background, while the other map, the 'object' map, is responsible for telling the program how to treat that particular set of elements. Only some of the 'object' map elements result in an actual object being drawn on the screen. Rings, for example, are drawn on the screen until the player gets them. Similarly, not all 'level' objects are solid objects. Some, like some of the pillars, are only for outward appearances.   [top](awesomeguyJNI#Introduction.md)

### Sprites ###

Aside from the tilesheets and tilemaps described above, the game uses several sprite images. For these images small 'png' files were used. There are four images of the main character and two images of the monster for each direction. That means four monster images in total, two left and two right. The multiple images are used to animate the main character and the monsters. Each of the 'png' images has an alpha channel (a transparent area) and is indexed to a 256 color palette. The size of the images is unimportant on the android phone, but for the Nintendo DS it was dictated by the hardware. For this reason the monster sprite uses only the top half of the png image, which is 16 pixels by 16 pixels. The main character is also 16 x 16, but it uses the space more evenly.   [top](awesomeguyJNI#Introduction.md)

### Software Tools ###

Several pieces of software were used when making Awesomeguy. Awesomeguy was programmed on a Linux computer. The graphic images in the game were all edited on Gimp, the Gnome Image Manipulation Program. The source code for Awesomeguy was edited using the Eclipse IDE for java. The C library used for the Awesomeguy Java Native Interface (JNI) was edited using Gedit, a Gnome text editor. The tilemaps, the large arrays that define the appearance of each level, were edited first using a Windows program called 'Mappy', and then further edited using Gedit and the command line tool 'sed'. The Wine (Wine Is Not An Emulator) program loader was employed to allow Mappy to work on a Linux platform. Instructions for using Mappy to create level definitions will accompany this document.   [top](awesomeguyJNI#Introduction.md)

# Java #

The game was actually programmed somewhat successfully in java before a JNI library was added. The graphics for the game all appeared in its correct position on the screen in a version that ran on the emulator. The main problem was that the java version of the game was slow.   [top](awesomeguyJNI#Introduction.md)

### Tilesheets ###

Tilesheets are not supported by java. In order to implement them in java a special class was added to the android project. The TileCutter class took the raw tilesheet and cut the image into smaller pieces that were applied to the screen one at a time as tiles.  [top](awesomeguyJNI#Introduction.md)

### TileCutter java ###

The first thing we do in TileCutter is define some variables.
```
	private int mTilesHeight = 128;
	private int mTilesWidth = 224;
	private int mBlockHeight = 8;
	private int mBlockWidth = 8;
	private int mNumTiles = 0;
	private int mWidthInTiles = mTilesWidth/ mBlockWidth;
	private int mHeightInTiles = mTilesHeight/ mBlockHeight;
	
	private Matrix mMatrix = new Matrix();
	private Bitmap mTileMap;
	private int mScale;
	private int mTileAdjustment = 1;
```
The variables 'mTilesHeight' and 'mTilesWidth' are constants that describe the dimensions of the tilesheet image. There are four tilesheet images, but they're almost identical. Their dimensions have to be the same. The four sheets are 128 pixels high and 224 pixels wide. Also, a block or tile is 8 pixels high and 8 pixels wide. The variables 'mWidthInTiles' and 'mHeightInTiles' are easily computed.   [top](awesomeguyJNI#Introduction.md)

The ultimate goal is for us to be able to pass a method in the class a number that is associated with an individual tile, and for the method to return the tile that we specify. We achieve this goal by ultimately using simple calculations. We take one parameter and do some simple math, and feed the results into the 'Bitmap.createBitmap(...)' method, returning the Bitmap of the tile that we're interested in. Below are listings.  [top](awesomeguyJNI#Introduction.md)

```
public Bitmap getTile(int i) {
	//i = i + mTileAdjustment;
	int row = i / mWidthInTiles;
	int col = i - (mWidthInTiles * row) ;
	
	if (row > this.mHeightInTiles || row < 0) row = 0;
	if (col > this.mWidthInTiles || col < 0) col = 0;
	
	int height = this.mBlockHeight;
	int width = this.mBlockWidth;

	Bitmap temp = Bitmap.createBitmap(mTileMap, col * width,row * height, width , height ,null,false);
	if (mScale != 1) {
		mMatrix.setScale(mScale, mScale);
		return Bitmap.createBitmap(temp, 0,0, width , height ,mMatrix,false);
	}
	else {
		return temp;
	}
}
```
Essentially we need the row and column values, and we get those by manipulating the 'mWidthInTiles' variable. Extra code is added for scaling the images. If we want to double the images size for larger screens we can do this with the 'mMatrix' object. The value of 'mScale' is set using a regular java setter method.  [top](awesomeguyJNI#Introduction.md)

### Panel java ###

Then we need to use the TileCutter in the 'onDraw(...)' method of the Panel.java class. We do this using two for() loops and the TileCutter object.
```
	    	mCanvas.drawColor(Color.BLACK);
	    	mTiles = new TileCutter(bMap);
	        baseX = scrollX/ mTiles.getBlockWidth();
	        baseY = scrollY/ mTiles.getBlockHeight();
    		
	    		for ( int i = baseX; i < baseX + 32 + 1; i ++ ) { 
	
	    			for (int j = baseY; j < baseY + 24 + 1; j ++) { 
	    				if (mGameV.getLevelCell(i, j) != 0 ) {
	    					//print visible background
	    					mTemp = mGameV.getLevelCell(i, j);
	    					mBlock = mTiles.getTile(mTemp);
	    					canvas.drawBitmap(mBlock, i * mTiles.getBlockWidth(), j* mTiles.getBlockHeight(), null);
	    				}
	    				if (mGameV.getObjectsCell(i, j) != 0) {
	    					//print special background objects
	    					mTemp = mGameV.getObjectsCell(i, j);
	    					if(this.checkPrintableObjects(mTemp)) {
	    						mBlock = mTiles.getTile(mTemp - mMapcheat);
	    						canvas.drawBitmap(mBlock, i * mTiles.getBlockWidth(), j* mTiles.getBlockHeight(), null);
	    					}
	    				}
	    				
	    			}
	    		}
    		
```
The indexes for these two loops are the most complicated part. We know that we are going to scroll the screen, and that the level graphics themselves are bigger than the area that is being shown on the screen. What we want to do is paint tiles where the screen is going to be, and not concern ourselves with other parts of the screen. The variables scrollX and scrollY represent the top left of the screen that is going to be displayed. They are pixel values, so we translate them to multiples of 8. This is what baseX and baseY represent, and they are the starting points for the two loops. Then we set the ending point of the loops as the size in tiles of the screen that's being shown. For the original game this was 32 tiles wide and 24 tiles high. (Note that a single tile is added to the 32 and 24 so that there was no chance that the screen would be blank at any point)

The indexes of the two loops are used by the method calls 'mGameV.getLevelCell(i,j)' and 'mGameV.getObjectsCell(i,j)'. These functions return tile numbers, which are used by the TileCutter class and various other parts of the program.

In the 'canvas.drawBitmap(...)' function the indexes from the loops (i and j) are multiplied by 8 to translate the tile position into actual pixels.

We accomplish drawing the background on the screen this way using tiles instead of, for example, a large bitmap that fills the whole screen. What we have to do then is use the built in scroll function of the View class (remember the Panel.java class extends the android View). Every View has a scrolling mechanism, and it's simple to use. We scroll the upper left hand corner of the window that the user sees to the coordinates of scrollX and scrollY.
```
scrollTo(scrollX, scrollY);
```

The process of using the TileCutter and the loops described above is time consuming, so a JNI library was used.  [top](awesomeguyJNI#Introduction.md)

# JNI Setup #

JNI stands for 'Java Native Interface' and NDK stands for 'Native Development Kit'. To program JNI for the android platform you must download and configure the 'android-ndk-[r4](https://code.google.com/p/awesomeguy/source/detail?r=4)' package, which can be found on the Android developers site at the following address. See: http://developer.android.com/sdk/ndk/index.html . Download and install the package that is appropriate for your operating system. Installing this software is beyond the scope of this wiki. The documentation that accompanies the ndk software is very helpful.   [top](awesomeguyJNI#Introduction.md)

### Names ###

The name of the file that's compiled into the awesomeguy JNI library is 'awesomeguy.c', and the actual compiled library is called 'libawesomeguy.so'. The Android NDK package takes care of naming the actual library for us, so we only have to concern ourselves with writing the awesomeguy.c file. To compile a Android JNI library, we create a folder in the Eclipse project called 'jni'. We place the c file in this folder. There is a non trivial step of creating the android 'Android.mk' file, which is the library's 'make' file. Then we use tools from the Android NDK package to compile the file.

The NDK tools create the actual library for us and place the library in a specially created folder in the Eclipse project. When Eclipse creates the app file it includes the library automatically. We have to 'Refresh' the project manually every time we re-compile the library, but that's the only tricky part. To refresh the project, press the F5 button.  [top](awesomeguyJNI#Introduction.md)

### Awesomeguy in c ###

Both c and c++ can be used for Android JNI. Awesomeguy uses c. The c programming language is very complex, and is not explained in any depth here. Some c concepts are touched upon, though. The Awesomeguy JNI library is somewhat lengthy, but relatively simple in concept. It's important to remember that with awesomeguy.c we are building a library, not a running program, so there is no 'main()' method. Another thing to remember is that for the JNI in Awesomeguy we want a single source file (awesomeguy.c) and a single library file (libawesomeguy.so). This requirement is so that the program remains simple enough to be easily maintained. It also means that there are no separate header files for the library. If your library is complex enough, header files might be necessary.

There is no boolean data type in c. Instead you must use integers. Awesomeguy uses a pair of `#define` statements to create 'TRUE' and 'FALSE' values that correspond to integer values of '1' and '0'. For this reason when the awesomeguy library is asked by the java code to return a true or false it returns an integer which must be translated somehow for the java code. Java does use a separate boolean data type.

The awesomeguy JNI library is meant to operate within the context of the Panel.java class. JNI code will only be called from that class. This simplifies the awesomeguy.c file slightly.  [top](awesomeguyJNI#Introduction.md)

### include ###

There are four `#include` statements at the beginning of the awesomeguy.c file.
```
#include <jni.h>
#include <android/log.h>
#include <stdio.h> 
#include <stdlib.h>
```
The first two are specific to android JNI programming. They allow the project to interface with the java code, and allow our program to print log messages to the Dalvik Debugger. This is important for development and debugging. Once the c library is working correctly the line `#include <android/log.h>` could be removed.

The second two `#include` statements are standard c libraries that any c programmer might use in their program. You can `#include` many c libraries, and also several libraries that are provided by google for programming the Android device.  [top](awesomeguyJNI#Introduction.md)

### define ###

The first set of `#define` statements is used to set up logging. The lines of code here set up methods or macros that can be used to print messages to the debugger's log. These are not strictly necessary for the operation of the awesomeguy JNI library.

```
#define  LOG_TAG              "awesomeguy-jni"
#define  LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)
```

Next the constants for 'TRUE' and 'FALSE' are defined.

```
#define TRUE 1
#define FALSE 0 
```

> [top](awesomeguyJNI#Introduction.md)

### constants ###

The next thing we do is define some constants that will be used by the program. First among these variables is the definition of various tile numbers. For example throughout the game solid objects are represented by the number 442. Each different kind of object that can be placed on the screen is represented by a different number.
```
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
```

Then there are various other constants, some of which are self explanatory.
```
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
```

TILEMAP\_WIDTH and TILEMAP\_HEIGHT refer to the pixel dimensions of the tilesheet. MAP\_WIDTH and MAP\_HEIGHT refer to the array that represents the way the background should be drawn. This is slightly misleading, as in this documentation (up till now) TILEMAP would refer to the 96x96 object, and TILESHEET would be the appropriate term for the graphics that are cut apart and used as individual tiles. Unfortunately the awesomeguy.c file was written without regard to these conventions, so discussion of the variables may remain somewhat ambiguous.

This section is followed by more variables that are used by the library. These two variables are used by the functions that copy sprites and tiles to the screen array. They are flags and will be discussed later.
```
static int PAINT_SOLID = 0;
static int PAINT_TRANSPARENT = 1;
```

> [top](awesomeguyJNI#Introduction.md)

### Scope ###

These variables are all declared outside any method body, so they have global scope. Up until now the variables declared have been constants, but many of the variables, like the 2D array 'screen' have contents that change over time. This is because 'screen' is rewritten every time the Panel redraws itself. This is OK for our library. The contents of 'screen' are persistent over many calls to the library, and are also changeable over many calls to the library.  [top](awesomeguyJNI#Introduction.md)

### Unsigned Integers ###

The thirteen arrays below are used to hold the data that makes up several Bitmap images. These images are loaded when the Panel.java file is initialized. They are not loaded and reloaded every time the Panel.java file draws an image to the screen. Arrays in c are really made of two things. Firstly the memory for the array is allocated, and secondly a pointer is created to the beginning of the array. The data type used here is `uint32_t`, which is an unsigned integer of 32 bits. This is the data type I use for all graphical information. Graphical elements, or pixels, are going to be stored in these arrays.
```
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
```

> [top](awesomeguyJNI#Introduction.md)

### Map Arrays ###

These are the two arrays that the JNI use as maps for the background elements. Elsewhere in this documentation the maps were called 'tilemaps'. Each element is a number representing an 8x8 square. In the Java code these arrays are located in the GameValues class, and are called the 'level' and 'objects' arrays. They are duplicated in the JNI because JNI functions are responsible for drawing the screen just as the Java was. The 'map\_level' array holds just visual information, and the 'map\_objects' array holds info on (usually) non visible information.

```
static int map_level [96][96];

static int map_objects[96][96];
```

> [top](awesomeguyJNI#Introduction.md)

### Screen ###

There is an array in the variable definition section of the JNI file that represents the information that will ultimately be displayed on the screen. It is intended to hold graphical information, pixels, and it is the size of the maximum that the screen is allowed to be, (192x256). This is the array that is returned to the java code by the 'drawLevel()' function. This may be the most important array in the program.
```
uint32_t screen [192][256];
```

> [top](awesomeguyJNI#Introduction.md)

### Alpha ###

A single graphic pixel is created to hold the value that is used by the JNI library as the 'transparent' color. In ping images this would be the 'alpha' color. It is set when the library is loading the tilesheet images. It's used in the 'drawScoreWords()' and 'drawScoreNumbers()' methods.

```
uint32_t number_alpha = 0;
```

> [top](awesomeguyJNI#Introduction.md)

### Tile Loops ###

The next two variables are used by the loop mechanism that prints tiles on the 'screen' array. Their definition is mostly unimportant to the operation of the game, but should be mentioned at this point. The two variables value refers to the number of tiles that could be printed on the screen.

```
static int tilesWidthMeasurement = 32;
static int tilesHeightMeasurement = 32;
```

> [top](awesomeguyJNI#Introduction.md)

### Sprite Structs ###

This code defines the struct that is used to hold sprite info. Because Sprites themselves are not supported in hardware on the Android phone, The Sprite mechanism is emulated here in software.

```
typedef struct {
	int x, y, animate;
	int facingRight, active, visible;
	int leftBB, rightBB, topBB, bottomBB;
} Sprite;
 
```
The variables 'facingRight', 'active', and 'visible' are all true/false values, and are treated like bool values.

The listing above defines the sprite Struct. Then below, the first line `Sprite sprite[100]` defines an array of 100 of the previously mentioned structs. After that we have three variables that help us keep track of the various sprites that we store on the list.

First on the list are monster sprites. They are all on the list together. The `monster_num` variable keeps track of how many monster sprites we have. Then the platforms are placed on the list, if there are any. The `platform_num` variable keeps track of how many platforms are on the list (and therefore on the level). The variable `sprite_num` keeps track of how many sprites are on the list all together.
```
Sprite sprite[100];
int sprite_num = 0;
int monster_num = 0;
int platform_num = -1;

Sprite guy;
```
There is also one sprite that we keep track of that's not on the list. This is the sprite for the main character. This sprite we call 'guy'. In the java version of the graphical display code there is one list and the guy sprite is always on the list at position '0'. Because of the slight difference between the java and the JNI, the indexes of sprite objects on the list are not the same between the two parts of the program. Special care has to be taken when referring to the sprite objects.  [top](awesomeguyJNI#Introduction.md)

### Bounding Box ###

Another object used by the program is the bounding box. The struct for the bounding box is next in the variable declaration section of the JNI and is listed below:

```
typedef struct {
	int left, right, top, bottom;
} BoundingBox;
```

The integers 'left', 'right', 'top', and 'bottom' are all screen positions for the boundaries of a sprite's drawable region. In Awesomeguy we use a simple box for collision detection, where as in other games a more complex shape like an outline might be used. In Awesomeguy the sprites are so small that a simple box seems to work best.  [top](awesomeguyJNI#Introduction.md)

### Various Variables ###

Next a group of integers is defined that are used in different sections of the library.
```
static int level_h, level_w, score, lives, scrollx, scrolly, animate;
```
The variables 'level\_h' and 'level\_w' are the dimensions of the map, in tiles, that the current level actually uses. As noted, the map can be 96x96 tiles, but a given level may only use a smaller portion of that map. These two variables define the _used_ map area. This saves room in the awesomeguy.xml file, where level definition information is stored, as an array of 96x96 tiles is not necessarily stored. Instead, if for example 'level\_h' is 32 and 'level\_w' is 64, an array of 32x64 tiles is stored.

The variables 'score' and 'lives' carry the numbers that are to be printed on the screen that are associated with those values. The 'score' and 'lives' values can also change in the JNI. These changes would be detected by the java code as the Panel redraws.

The variables 'scrollx' and 'scrolly' are values passed to the JNI by the Panel.java code. They tell the JNI how to draw the screen.

The variable 'animate' is used to animate the rings that appear on many of the levels. It is a integer value between 0 and 4.

```
static int endlevel = FALSE;

static int sound_ow = FALSE;
static int sound_prize = FALSE;
static int sound_boom = FALSE;

static int preferences_monsters = FALSE;
static int preferences_collision = FALSE;
```

The remaining global variables are all boolean. The first four are used as a notification system between the JNI and the java. The variables 'endlevel', 'sound\_ow', 'sound\_prize' and 'sound\_boom' are used to tell the java that a collision has happened that requires the Panel.java class to end game play (in the case of 'endlevel') or play a certain sound (in the case of 'sound\_ow', 'sound\_prize', and 'sound\_boom'). Every time the Panel is redrawn these variables are checked. If their value changes from FALSE to TRUE then the java knows it has to do something.

The variables 'preferences\_monsters' and 'preferences\_collision' are used as notification to the JNI from the java of the Panel class. They tell the JNI weather or not monsters should appear on the screen, and weather or not those monsters can interact with the main character. This second preference, 'preferences\_collision' allows the main character to travel through the levels without fear of dying from monsters.  [top](awesomeguyJNI#Introduction.md)

### Function Headers ###

Functions in the awesomeguy JNI library are divided into two groups. The first group is the standard function that is internal to the library and may be called anywhere in the library. The second group is the group of functions that is meant to be called by the Panel.java class. This second group of functions is all located at the end of the file. The method signature for these functions is somewhat complex. Meanwhile the first group of functions has simple signatures. For this group function headers were included in the library.

The code of the library is so straightforward that function headers might not have been strictly necessary, but they are included because the library has no header files (the library is composed of a single source c file). Though the headers appear in the file, they will not be duplicated here.  [top](awesomeguyJNI#Introduction.md)

# JNI Methods #

I will attempt to go through all the methods in the file, occasionally grouping methods together that function in exactly the same way.   [top](awesomeguyJNI#Introduction.md)

### Method Overview ###

The library is basically designed to produce an array that gets printed on the screen like a Bitmap image. The library takes, when it's set up, a group of arrays that are in fact Bitmaps themselves. For most of these bitmaps the methods in the library simply copy information from one array, the source bitmap, to the other array, the output screen bitmap. This is the most common scenario, and the methods that do this work are generally called 'drawSprite(..)' methods. There is some variation in the names.

Sometimes, as in the case with tilesheets, the source bitmap is altered before it's copied. When the tilesheet is the source material, the program first cuts out one of the tiles, using a method called 'cutTile(...)'. The material from this tile is copied to a local array that's the size of just one tile (8x8). Then the local array is passed to a function that operates in a manner similar to that described above - it takes a source array and copies it to the output array. This method is called 'drawTile(...)'.

The only thing left to do is make sure everything goes where it's supposed to on the screen. The locations that all these 'draw' methods use are determined in the 'drawLevel(...)' method, where the entire 'screen' array is managed and populated.

A lot of other methods are included in the library. Some draw words and numbers on the screen, like the words 'score' and 'level'. They use tiles, so they can use the 'cutTile(...)' and the 'drawTile(...)' methods.

Some methods determine weather a collision has taken place. This would be important for the display of the 'monster' sprites. In that case the level needs to be stopped when the main character comes into contact with a monster. Collision detection is an exception to the notion that the library operates to display images only.

There are also methods in the library that turn 1 dimensional arrays into 2 dimensional array, and at least one method that turns 2 dimensional arrays into 1 dimensional arrays. This is necessary because internally the library uses 2 dimensional arrays, while the java code that passes Bitmaps to the library uses 1 dimensional arrays. Also the method that turns the 'screen' array into a Bitmap for java expects a 1 dimensional array, while the 'screen' array itself is 2 dimensional. The methods for turning 1D to 2D are all called 'copyArraysExpand(...)' or some variation on that name. The method for turning the 'screen' array into a 1D array is called 'copyScreenCompress(...)'.  [top](awesomeguyJNI#Introduction.md)

### Sound Setters ###

These methods set the variables 'sound\_ow', 'sound\_boom', and 'sound\_prize'. They're fairly simple. Their signatures are listed here.

```
void setSoundOw() ;
void setSoundPrize() ;
void setSoundBoom() ;
```

The actual listing of 'setSoundOw()' is here.
```
void setSoundOw() {
	sound_ow = TRUE;
}
```
All three methods operate the same way.  [top](awesomeguyJNI#Introduction.md)

### Sound Getters ###

These methods are also fairly simple. Their signatures are listed here.
```
int getSoundOw() ;
int getSoundPrize() ;
int getSoundBoom() ;
```
The listing of 'getSoundOw()' is below.
```
int getSoundOw() {
	int temp = sound_ow;
	sound_ow = FALSE;
	return temp;
}
```
It's slightly more complex than the 'setSoundOw()' method, because it not only returns the value of the 'sound\_ow' variable, but it resets it to FALSE. The method is used by the java code to tell if an event has transpired in the last display of the 'screen' bitmap that would call for the 'ow' sound to be played. This would be when the main character comes in contact with a monster, for example. This method is closely related to the collision detection methods of the library.  [top](awesomeguyJNI#Introduction.md)

### Loading Graphic Data ###

Several steps are incorporated to load the graphics data from the java code into the JNI code. This data is used to assemble the 'screen' array, which is returned to the java code and turned into a Bitmap.   [top](awesomeguyJNI#Introduction.md)

#### setTileMapData() ####

This function, like 'setGuyData()' and 'setMonsterData()' takes four arrays as its parameters. These arrays are 1 dimensional. The method simply passes the four arrays off to another function that rearranges their data into 2 dimensional arrays. These 2 dimensional arrays are the permanent holding area for this graphical data. The three methods are called at the time of the Panel.java class's initialization, not during the subsequent drawing of the screen. The signature for the three methods is below.
```
void setTileMapData(jint a[], jint b[], jint c[], jint d[] ) ;

void setGuyData(jint a[], jint b[], jint c[], jint d[] ) ;

void setMonsterData(jint a[], jint b[], jint c[], jint d[] ) ;
```
The contents of the 'setTileMapData(...)' method are below.
```
void setTileMapData(jint a[], jint b[], jint c[], jint d[] ) {


	copyArraysExpand_tileset(a, TILEMAP_WIDTH * TILEMAP_HEIGHT, tiles_a);
	copyArraysExpand_tileset(b, TILEMAP_WIDTH * TILEMAP_HEIGHT, tiles_b);
	copyArraysExpand_tileset(c, TILEMAP_WIDTH * TILEMAP_HEIGHT, tiles_c);
	copyArraysExpand_tileset(d, TILEMAP_WIDTH * TILEMAP_HEIGHT, tiles_d);
	
}
```
The four arrays, 'a', 'b', 'c', and 'd', are each separate tile sheets. They are nearly identical, except for the animation of the rings that the main character collects for points. The method 'copyArraysExpand\_tileset(...)' will be explained later. The arrays 'tiles\_a', 'tiles\_b', 'tiles\_c', and 'tiles\_d' are 2 dimensional arrays that are declared as global in the library.   [top](awesomeguyJNI#Introduction.md)

#### setGuyData() ####

The code for 'setGuyData(...)' is below. This method uses the 'copyArraysExpand\_16(...)' function. This function is made for 16 x 16 sprites. Since both the main character and also the monsters are 16 x 16, we can reuse this code in both 'setGuyData(...)' and 'setMonsterData(...)'. Here we also set the bounding box for the main character's sprite.
```
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
```

> [top](awesomeguyJNI#Introduction.md)

#### setMonsterData() ####

The code for 'setMonsterData(...)' is below. Since the monster sprite is 16 x 16 we can reuse the 'copyArraysExpand\_16(...)' method.
```
void setMonsterData(jint a[], jint b[], jint c[], jint d[] ) {

	copyArraysExpand_16(a, MONSTER_WIDTH * MONSTER_HEIGHT, monster_a);
	copyArraysExpand_16(b, MONSTER_WIDTH * MONSTER_HEIGHT, monster_b);
	copyArraysExpand_16(c, MONSTER_WIDTH * MONSTER_HEIGHT, monster_c);
	copyArraysExpand_16(d, MONSTER_WIDTH * MONSTER_HEIGHT, monster_d);
}
```

> [top](awesomeguyJNI#Introduction.md)

#### setMovingPlatformData() ####

This method is very much like 'setTileMapData(...)' except that there is only one image for the moving platforms. The platforms have different dimensions then the other sprites, so they must have their own methods. Below is a listing of the 'setMovingPlatformData()' code.
```
void setMovingPlatformData(jint a[]) {
	copyArraysExpand_8_40( a, PLATFORM_WIDTH * PLATFORM_HEIGHT, platform_a);
}
```

> [top](awesomeguyJNI#Introduction.md)

#### copyArraysExpand tileset() ####

There are three methods with signatures similar to this. They all begin 'copyArraysExpand'. They all take a 1 dimensional array and convert it to a 2 dimensional array. This one also has a second part, used for setting the 'number\_alpha' variable to a value that can be used to deal with transparency when numbers are displayed on the screen. The code for the method is below.

```
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
```
There are three parameters to the method. One is the 1 dimensional array called 'from'. Next is the integer that holds the size of the array, called 'size\_l'. Lastly is the 2 dimensional array called 'to'.

In the section used to set the 'number\_alpha' variable, a specific pixel is copied to 'number\_alpha' from the tilesheet. The value is the upper left hand pixel from tile number 374. This is one of the number tiles. The upper left hand pixel from this tile is simply a black pixel.

It's worth noting that the calculation of 'number\_alpha' happens four times. This is not ideal, but since it's convenient it's left the way that it is.   [top](awesomeguyJNI#Introduction.md)

#### copyArraysExpand 16() ####

This method is very similar to 'copyArraysExpand\_tileset(...)'. The principle differences are that the size of the 2D array are different, and there is no section for setting 'number\_alpha'. Both the monster sprite and the main character sprite have an alpha channel of their own in the original bitmap image.
```
void copyArraysExpand_16(jint from[], int size_l, uint32_t to[GUY_WIDTH][GUY_HEIGHT]) {


	int i,j, k;
	for (i = 0; i< GUY_HEIGHT; i ++ ) {
		for (j = 0; j < GUY_WIDTH; j ++ ) {
			k =( i * GUY_WIDTH ) + j;
			if ( k < size_l ) {
				to[i][j] = (uint32_t) from[k];

			}
		}
	}
	return;
}
```

> [top](awesomeguyJNI#Introduction.md)

#### copyArraysExpand 8 40() ####

This method is similar to the other 'copyArraysExpand' methods. It takes different sized arrays as input and output, though. It's used for the moving platform. It's also only used once, as there is only one image for the moving platform.
```
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
```

> [top](awesomeguyJNI#Introduction.md)

### Loading Map Data ###

For every level we need to load all the necessary map data. This data tells the library how to print the background, and also where to put things like monsters and rings. The map arrays that the JNI library uses are 96 x 96. Sometimes the java code is dealing with smaller arrays that it later copies into the 96 x 96 element arrays. The JNI library is not interested in the smaller arrays except to know what size they are. The size _is_ used by the library, and when that size is smaller than 96 x 96 the array is partly empty. The java code always passes data to the JNI library in the form of 1 dimensional arrays.   [top](awesomeguyJNI#Introduction.md)

#### setLevelData() ####

In this function we convert the two 1 dimensional arrays that we need into two 2 dimensional arrays. One of the arrays is then called 'map\_level' and one of them is called 'map\_objects'.
```
void setLevelData(int a[MAP_HEIGHT * MAP_WIDTH],  int b[MAP_HEIGHT * MAP_WIDTH]) {

	int i,j;
	
	for (i = 0 ; i < MAP_HEIGHT ; i ++ ) {
		for (j = 0; j < MAP_WIDTH ; j ++ ) {
			map_level[i][j] = a[ (i * MAP_WIDTH ) + j] ;
			map_objects[i][j] = b[ (i * MAP_WIDTH ) + j] ;

		}
	}
	monster_num = 0;
	sprite_num = 0;
	platform_num = -1;
	
	return;
}
```
Since we set the 'map\_objects' and 'map\_level' arrays at the beginning of each level, this function is a good place to initialize some variables that are used to keep track of Sprite struct objects on the 'sprite' list. This is what we're doing when we set 'monster\_num', 'sprite\_num', and 'platform\_num'.

> [top](awesomeguyJNI#Introduction.md)

### Loading Sprites ###

There are three types of sprites that could use the Sprite struct. They are the main character sprite, the monster sprite, and the moving platform sprite. The main character sprite uses a Sprite struct that is specially created for it, and exists separate from the other sprites. The remaining objects on the screen that need sprites are handled by an array of Sprite structs. This array can handle up to 100 sprites. The array is used as a list. On the list first go all of the monster sprites. Then on the list goes all of the floating platforms that might be on the level. The list is re-initialized at the beginning of each level. The variables 'monster\_num', 'sprite\_num', and 'platform\_num' are used to manage the list.

The lists of monsters and platforms could be initialized entirely within the JNI library, as the library has a copy of the 'map\_objects' array, but it could also be initialized from the java code, and that is the way it is implemented.

> [top](awesomeguyJNI#Introduction.md)

#### addMonster() ####

The signature of the 'addMonster(...)' method calls for the monster's x and y position, and the starting animation index for the sprite. The body of the method sets the bounding box values and adjusts the 'sprite\_num' and 'monster\_num' integers. The code is listed below.
```
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
```
The function 'addMonster(...)' must be called once for every monster on the level, and before any other platform sprite is added to the sprite list. This way all the monsters are together, and the first monster sprite starts at index zero.

> [top](awesomeguyJNI#Introduction.md)

#### addPlatform() ####

The method for adding a platform is similar to the method for adding a monster except that there is only one image for the platform, so no starting animation index is saved. The code for 'addPlatform(...)' is below.
```
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
```
The bounding box info is totally different, and the 'platform\_num' variable is set instead of the 'monster\_num' variable. Note that 'platform\_num' is _not_ the 'number of platforms' as you might guess the name means. Instead the 'platform\_num' is the index in the sprite list at which the last platform resides.  [top](awesomeguyJNI#Introduction.md)

### More Setters ###

These are functions that are used to set variables that are part of the JNI library, usually from the java Panel class. They are called, for the most part, with every refresh of the screen.  [top](awesomeguyJNI#Introduction.md)

#### setGuyPosition() ####

This function could have easily been called something else. It not only sets the main character's position but it also informs the library of the settings for the 'scrollx' and the 'scrolly' variables. It also sets the animation index for the main character. The code is listed below.
```
void setGuyPosition(int guy_x, int guy_y, int scroll_x, int scroll_y, int guy_animate) {

	guy.x = guy_x;
	guy.y = guy_y;
	guy.animate = guy_animate;
	animate = guy_animate;
	scrollx = scroll_x;
	scrolly = scroll_y;
}
```

> [top](awesomeguyJNI#Introduction.md)

#### setScoreLives() ####

This method sets the 'score' and 'lives' variables in the JNI library so that they can be printed on the screen. It is called every time the Panel.java class refreshes the screen.
```
void setScoreLives(int a_score, int a_lives) {

    score = a_score;
    lives = a_lives;
}
```

> [top](awesomeguyJNI#Introduction.md)

### Object Setters ###

These functions can be used at any time. They change the state of the 'map\_objects' array, or possibly the value associated with a certain sprite.  [top](awesomeguyJNI#Introduction.md)

#### setObjectsDisplay() ####

This function identifies a single element in the 'map\_objects' array and changes its value. It is used to change rings to empty space most frequently. In that case, 'map\_x' and 'map\_y' would be the location of the ring, and the 'value' integer would be zero.
```
void setObjectsDisplay(int map_x, int map_y, int value) {
	map_objects[map_x][ map_y ] = value;
}
```

> [top](awesomeguyJNI#Introduction.md)

#### inactivateMonster() ####

This function can be called at any time. It sets the given 'active' flag for a sprite with a certian index to FALSE.
```
void inactivateMonster(int num) {
	if (num < sprite_num) {
		sprite[num].active = FALSE;
	}
}
```

> [top](awesomeguyJNI#Introduction.md)

#### inactivateMonsterView() ####

This sets the 'visible' property to FALSE. The code is listed below.
```
void inactivateMonsterView(int num) {
	if (num < sprite_num) {
		sprite[num].visible = FALSE;
	}
}
```

> [top](awesomeguyJNI#Introduction.md)

### Drawing The Screen ###

A single method is responsible for drawing the screen, but it calls many other methods. Here is a breakdown of the 'drawLevel(...)' method. The method itself is comparatively long so it will be listed in parts.  [top](awesomeguyJNI#Introduction.md)

#### drawLevel() ####

This is the method signature line and some of the variable declarations. Because most of the things that you would expect to find as input to the method are actually global arrays in the JNI library, the method only has one parameter. The 'animate\_level' parameter helps to animate the moving rings that populate some of the game's levels.
```
void drawLevel(int animate_level) {
    
    int i,j,k,l;
    int baseX, baseY;
    int mapcheat = 1;
    uint32_t square[TILE_HEIGHT][TILE_WIDTH];
    
    animate = animate_level;
```
The method has no return value because it stores it's output in another global variable array, the 2 dimensional 'screen' array.

The variables internal to the method are fairly simple. The single letter variables are used as loop indexes. The variables 'baseX' and 'baseY' are for when the background is being printed on the screen and the code has to determine which tiles to actually draw. The variable 'mapcheat' is used to make sure that the proper tile index is used when we're drawing picture tiles on the screen. The 2D array 'square' is used as a temporary holding place for each tile before its data is copied to the 'screen' array of pixels. The 'square' array is exactly 8 pixels by 8 pixels.  [top](awesomeguyJNI#Introduction.md)

#### Clear Screen ####

This code simply clears the screen.
```
    /* clear screen */
    for (i = 0 ; i < (SCREEN_HEIGHT ); i ++ ) {
    	for( j = 0; j < SCREEN_WIDTH; j ++ ) {
    	
	    	screen[i][j] = (uint32_t) 0x0000;// = -1;
	    }
    }
```

> [top](awesomeguyJNI#Introduction.md)

#### Draw Background ####

This is essentially a series of loops which does some comparisons and then calls two functions in succession. The two functions are 'cutTile(...)' and 'drawTile\_8(...)'. We'll discuss the functions in depth later in the document, but for now know that the 'cutTile(...)' function isolates a single tile's graphical data in the 'square' array that's declared above. Then the 'drawTile\_8(...)' method copies data from the 'square' array onto the 'screen' array, in the desired location of the screen.

```
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
    					scrollx , scrolly, PAINT_TRANSPARENT, 0);
    			
    			}
		}
			
    	}
    }
```
The background image for any one of the game's levels is larger than the screen that we use to display it. This means that the display scrolls around, following the main character as it visits different parts of the level. To manage this situation we have two very important variables for the x and y scroll position of the screen. These variables are called 'scrollx' and 'scrolly' in the JNI code, and they're never changed in this code. The scroll settings are only changed in the java code in the Panel.java file.

The background is painted by following a large map, which can contain up to 96 x 96 elements. Each element represents an 8 x 8 square. What we have to do is figure out what part of the map is on screen and just paint that part. That's what 'baseX' and 'baseY' help us do. The 'scrollx' and 'scrolly' variables represent the top left coordinate for the visible screen. The 'baseX' and 'baseY' variables are the top left map coordinate for the visible screen, and we get them by taking 'scrollx' and 'scrolly' and dividing by 8, or the size of one tile.

Then we set up our loops. The loops go through the visible part of the map and print that part to the screen. The loops start at the extreme top and left and continue to the bottom right, counting in 8 pixel units. On the emulator the screen is 32 map units wide and 24 map units high (this can change with different hardware).

Then we make sure that our loop indexes are within the limits of our program. The indexes, 'i' and 'j', cannot be greater than the height or width of the maps. Then we print the visible tiles to the screen.

For the 'map\_level' array we print all the tiles except the ones that are represented by a zero. We use the 'cutTile(...)' and 'drawTile\_8(...)' methods here.

For the 'map\_objects' array we only print some of the tiles. The list of non printing tiles is below.

  * B\_START - the starting position of the main character
  * B\_MONSTER - the starting position of a monster
  * B\_DEATH - a block that causes death of the main character on contact
  * B\_PLATFORM - the starting position of a floating platform
  * B\_MARKER - a marker that a monster or platform cannot pass
  * B\_BLOCK - a solid wall or floor
  * B\_LADDER - a ladder

As long as the block in question is not one of those listed above the block can be printed. Here we must print the block from the right tile sheet, since tile sheets are animated. The animation is key for the ring tiles.

The 'cutTile(...)' and 'drawTile\_8(...)' method pair is broken up here. We use if/else blocks to task the 'cutTile(...)' method with cutting the right tilesheet, 'tiles\_a', 'tiles\_b', 'tiles\_c', or 'tiles\_d'. Then when all of the logic concerning which tile to cut is done we call 'drawTile\_8(...)' on the 'square' array.  [top](awesomeguyJNI#Introduction.md)

#### Platforms And Score ####

Next we call two functions responsible for drawing floating platforms on the screen and drawing the player's score on the screen. These two functions are complex and will be covered later, but for now it should be noted that they both use specialized versions of 'drawTile\_8(...)' to ultimately show their images on the 'screen' array. All these functions based on 'drawTile\_8(...)' essentially just copy the data from some source array to the 'screen' array.
```
    /* draw moving platform */
    drawMovingPlatform();
    
    /* draw score and lives */
    drawScoreWords();
```
As noted above, the 'drawMovingPlatform()' method and thhe 'drawScoreWords()' method are complex and deserve their own section.  [top](awesomeguyJNI#Introduction.md)

#### Monsters ####

The next sections draw the monsters on the screen and also check weather any of the monsters have collided with the main character. Drawing on the screen is normal for the JNI library, but checking for collisions is special and almost contrary to the stated goals of the 'awesomeguy.c' file. The advantage to checking for collisions here is that it limits the amount of interplay that must happen between the JNI library and the Panel.java class. We chose not to follow this model when we implemented the 'collision-with-platforms' code. In that case we use the java code to handle collision detection.
```
    /* draw monsters */
    if (preferences_monsters == TRUE) {
        drawMonsters();
    }
    
    if (preferences_monsters == TRUE && preferences_collision == TRUE) {
        collisionWithMonsters();
    }
```
The last thing to note is that the 'drawMonsters()' and the 'collisionWithMonsters()' code is only executed if the 'preferences\_monsters' and the 'preferences\_collision' variables are set appropriately.  [top](awesomeguyJNI#Introduction.md)

#### Main Character ####

The last sections in the 'drawLevel(...)' function draw the main character. They use the function 'drawSprite\_16(...)'.
```
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
	else { 
	    drawSprite_16(guy_d, guy.x, guy.y, scrollx, scrolly, PAINT_TRANSPARENT, 0);	
	}
```
The 'drawSprite\_16(...)' method is based on the 'drawTile\_8(...)' method. They both do essentially the same thing, and they accomplish it in the same way. Their difference is in the size of the image that they use as their source material. The 'drawTile\_8(...)' method uses a 8 x 8 array as it's source. The 'drawSprite\_16(...)' method uses a 16 x 16 array as it's source. The 'drawSprite\_16(...)' method is used by the 'drawMonster()' code also because the monster sprite is 16 x 16.

The if/else construction that the 'drawSprite\_16(...)' methods reside in is used to animate the main character. The methods must use one of the four main character sprites, called 'guy\_a', 'guy\_b', 'guy\_c', or 'guy\_d'.  [top](awesomeguyJNI#Introduction.md)

### Copy Tiles Sprites Platforms ###

There is an intended similarity to the functions that copy tiles, sprites, and platforms to the 'screen' array. They all work the same way. Their difference is in their array sizes, and therefore the starting and ending points of their loops. The functions could have been written as one function having many more parameters when it was called, but for simplicity separate methods were written. The 'drawTiles\_8(...)' method will be discussed in the greatest detail here.   [top](awesomeguyJNI#Introduction.md)

#### drawTiles\_8() ####

The code for the method is included here.
```
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

	    		}
    		} 
    	}
    }
    return;
}
```
The most important parameters of the method are 'tile', 'screen\_x', 'screen\_y', 'scroll\_x', and 'scroll\_y'. The 2D array 'tile' is the 8 x 8 tile that needs to be printed on the 'screen' array. It is assumed that 'tile' is prepared by the 'cutTile(...)' method. Variables 'screen\_x' and 'screen\_y' are the position on the screen, as measured in pixels, where the 'tile' array is to be copied. Variables 'scroll\_x' and 'scroll\_y' are obviously the scroll position of the rectangle that is displayed on the Panel, that we are calling the 'screen' array. The scroll properties are essentially the coordinates of the upper left hand corner of the displayed area as measured in pixels.

The map arrays can acomidate a game play area that's larger than what we see on the phone's display. We need to figure out what is going to be shown on the screen and where it's going to be shown. What we try to do is subtract the scroll\_x and scroll\_y variables from the screen\_x and screen\_y. This gives us their position on the _visible_ screen. Then we cycle through the 'tile' array, copying it's contents to the visible screen area. What's left to worry about is what happens if the tile is on the edge of the screen, with one part visible and one part invisible. This would be bad and would probably cause an 'array out of bounds' type error. We take care of this with a simple 'if()' statement. It checks before each pixel is copied weather or not the resulting activity will result in 'array out of bounds'.

The two loops are defined by the size of the 'tile' array. Only inside the loop do we add the offsets 'm' and 'n' to the indexes from the loops ('i' and 'j').

There are two parameters from the 'drawTile\_8(...)' method that we haven't covered. They are the integer 'paint\_all' and the unsigned integer 'extra'. Variable 'extra' holds a single pixel value. Variable 'paint\_all' can hold one of two values that tells the 'drawTile\_8(...)' method what to do with 'extra'. The possible values for 'paint\_all' are 'PAINT\_TRANSPARENT' and 'PAINT\_SOLID'. If 'PAINT\_TRANSPARENT' is chosen then the routine checks each value from 'tile' before copying it to 'screen'. If the 'tile' value matches the 'extra' value, no operation is performed. This is equivalent to making a transparent area inside of 'tile'. This method is useful for printing numbers to the screen that need to have a transparent background, even if the source image has no alpha channel.  [top](awesomeguyJNI#Introduction.md)

#### drawSprite\_16() ####

Below is the code for 'drawSprite\_16(...)'.
```
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
```
The method is identical to 'drawTile\_8(...)' except for the names of some of the variables.  [top](awesomeguyJNI#Introduction.md)

#### drawSprite\_40\_8() ####

The code for this method is here.
```
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

	    		}

    		}
    	}
    }
    return;
}
```
This method is also almost identical.  [top](awesomeguyJNI#Introduction.md)

### Score and Lives ###

As you play the game, the score and lives that the main player has are printed on the screen. There is no special bitmap resource for this 'score' and 'lives'. Instead a group of the 'tiles' bitmap has been modified to print the letters in the words 'score' and 'lives'. These are regular tiles that have been manipulated with a graphics program. The functions that print the words 'score' and 'lives' and all the numbers from 0 to 9 are hard coded with the tile numbers in the 'tile' bitmap that will produce the correct display on the screen.

The 'tile' bitmaps do not contain tiles for every letter of the alphabet. They just contain the images for 0 through 9 and the words 'score' and 'lives'. Also, each letter or number is two tiles high. This means that the functions that print the text to the screen have to know that the letters come in two parts.

If you look at any of the four tilesheets you can see the letters and numbers in the bitmap image. They are blue with a red outline on a black background.  [top](awesomeguyJNI#Introduction.md)

#### drawScoreWords() ####

This method just draws the words 'score' and 'lives' on the screen. Then it calls another method which is designed to draw numbers on the screen, 'drawScoreNumbers()'. Though both functions use tiles to print their characters, the characters never scroll. It isn't necessary that the numbers and letters ever move around, but the background is moving, so 'scrollx' and 'scrolly' are considered when we pass values to 'drawTile\_8(...)'. The method is also concerned with weather or not the main character is going to be obscured by the letters if they are printed. That's why the method checks weather the value of 'guy.y' is greater than 16 before printing anything.
```
void drawScoreWords() {


	int i;
    	int topScore[] = {374,375,376,377,378,383};

    	int topLives[] = {379,380,381,378,382,383};

    	int scorePos, livesPos;
    	scorePos = 2 ;
    	livesPos = 16  ;
        uint32_t square[TILE_HEIGHT][TILE_WIDTH];
		
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
    			//print LIVES:
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
```

The array 'topScore[.md](.md)' is the location of the fixed data that will allow the method to print the word 'score' on the screen. The numbers in the 'topScore[.md](.md)' array hold the tile numbers for the top half of each of the letters 's', 'c', 'o', 'r', and 'e'. The tile numbers for the bottom half of each of these letters is obtained by adding 28 to the number from the array.

The array 'topLives[.md](.md)' is similarly the tile numbers for each of the letters 'l', 'i', 'v', 'e', and 's'. Again, 28 is added to the tile number for each printable letter to find the number for its bottom half. The combination of 'cutTile(...)' and 'drawTile\_8(...)' is called once for the top half of each letter, and then again for the bottom half of each letter. Also, 'number\_alpha' is used in the 'drawTile\_8(...)' method. It is used successfully at other times in the library as well.

At the very end of the function, the 'drawScoreNumbers(...)' method is called twice. This method prints the numbers for both the 'score' and the 'lives' display.  [top](awesomeguyJNI#Introduction.md)

#### drawScoreNumbers() ####

This method is called twice, once to print the numbers associated with how high the player's score is, and once to print how many lives the player has. In the method signature, 'pos' is the position of the text, 'num' is the actual number to be displayed, and 'p' is the number of places that the method can use to print the number to the screen. The value 'p' exists so that the numbers from 'score' don't print over the letters from 'lives'.

```
void drawScoreNumbers( int pos, int num, int p) {
 
    	int i, a, b, c, placesValue;
    	int places[] = {0,0,0,0,0,0,0,0,0,0};//ten spots
    	int topNumbers[] = {364,365,366, 367, 368, 369, 370, 371, 372, 373};
    	int showZeros = 0;
        uint32_t square[TILE_HEIGHT][TILE_WIDTH];


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
```
There are two for() loops in this function. The first one breaks the actual number that needs to be printed into pieces and puts those pieces in an array called 'places'. The array holds the number broken down so that in each element of the array a single decimal place from the original 'num' is held. With this information we can spell out the number. For example, 99 would be broken down into '9' and '9'. The number 155 would be broken down into the array '1', '5', and '5'.

The second for() loop takes the 'places' array and uses the 'cutTile(...)' and 'drawTile\_8(...)' methods to put the number on the screen. The numbers are left justified and leading zeroes are not printed.  [top](awesomeguyJNI#Introduction.md)

### Drawing Monsters ###

The 'monster' bitmap has an alpha color and is 16 pixels by 16 pixels, but only the top half of the image is used. The bottom half is entirely filled with the 'alpha' color. There are four bitmaps. Two bitmaps represent the monster facing right and two bitmaps represent the monster facing left. For each direction a bitmap exists to show the monster with it's mouth open or closed. The two images are used to animate the monster sprite.

The JNI code has two functions oriented to dealing with monsters. They are 'drawMonsters()' and 'collisionWithMonsters()'. The 'collisionWithMonsters()' method is something of a departure from the other methods in the library, as it deals with more than just _displaying_ graphics on the screen, but also determining what to do when those graphical elements come into contact.  [top](awesomeguyJNI#Introduction.md)

#### drawMonsters() ####

This method goes through the list of sprite records and determines how to print the appearance of the 'monster' sprite. The first major part of the method is the for() loop.
```
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
```
The for() loop checks to see that only 'monster' structs are examined. To do this it uses the 'monster\_num' variable as one of it's boundaries. From that point on the loop addresses each of the sprite structs individually. Inside the loop it checks to see if the given sprite is active. Only then does it proceed with the rest of the code.

Then it converts the sprite's x and y coordinates into their map position. This is to say that it divides the pixel coordinates by 8, yielding a measurement that can be used when comparing things to the 'map\_objects' array. The monster only stops when it comes to the end of a platform, or when it comes to one of the invisible markers specially made for this purpose. The location of these elements are all recorded in the 'map\_objects' array.

The method determines weather the sprite is facing right or facing left. It does this by checking the 'facingRight' property of the sprite. Then it concerns itself with moving the sprite to the right if that's the way it's facing, or moving the sprite to the left. Code in the 'facingRight' section is similar to code in the 'facingLeft' section.

Inside the 'facingRight' section the code first moves the sprite a certain distance to the right, then it checks for the presence of certain conditions at that location. These conditions are: 1) if a block stands in the way of the monster's movement 2) if a special marker stands in the way of the monster's movement 3) if the floor that the monster is on has come to an end. If any one of these conditions is true, the status of the 'facingRight' element of the sprite is changed from TRUE to FALSE, or FALSE to TRUE. In other words the direction of the monster is reversed.

The code in the section for if the monster is facing left is similar to the code for 'facingRight'. Since facing left is the opposite to facing right there is only one flag for direction in the sprite struct, and it's called 'facingRight'. Similarly in the code there is no line that says '`if(sprite[i].facingLeft == TRUE)`', instead we simply use the 'else' block associated with '`if(sprite[i].facingRight == TRUE)`' for all the facing-left code. Lines in the facing left section of the code mimic lines in the previous section. First the sprite is moved to the left, then the 'map\_objects' array is checked for conditions that would cause the monster to turn.

The next section, listed below, deals mostly with weather or not a 'monster' sprite is in the area visible to the player.
```
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
```
The constant 32 represents how many tiles wide the average screen is, and the constant 24 represents the height of the average screen. The constant 16 is used as a safety margin so that sprites do not suddenly appear or disappear as they come close to the edges of the screen.

The next section takes care of animating the 'monster' sprite, and the last section prints the monster on the screen, with special regard to weather or not the sprite is facing right or left, weather it is visible, and what state it's animation index is in.  [top](awesomeguyJNI#Introduction.md)

#### collisionWithMonsters() ####

This code draws on the methods 'makeSpriteBox(...)' and 'collisionSimple()', but otherwise is vary simple.

```
void collisionWithMonsters() {

	int i;
	
	BoundingBox guyBox = makeSpriteBox( guy , 0, 0 );
	  
	for (i = 0  ; i < monster_num ; i++) {   
		BoundingBox monsterBox = makeSpriteBox(sprite[i] , 0, 0 );
		int test =  collisionSimple(guyBox, monsterBox);
		if (test && sprite[i].active   == TRUE) {
		    
			if (guyBox.bottom  < monsterBox.bottom ) {

		    		score = score + 10;
		    	
		    		if (preferences_collision == TRUE) {
		    			inactivateMonsterView(i);
		    			inactivateMonster(i);
		    		}


				setSoundBoom();
		        
		        
			}
			else {
				endlevel = TRUE;
				if (preferences_collision == TRUE) inactivateMonster(i);

				lives --;

				setSoundOw();
			}
		}
	}

}
```
The function starts by setting up a for() loop that goes through all the monsters on the level. Then it checks to see if a monster has come in contact with the main character. This is done in the line 'int test = collisionSimple(guyBox, monsterBox)'. In this line the bounding boxes of the monster in question and the main character are checked, and if they overlap then the 'test' variable is set to TRUE.

The next part of the function tests to see if the guy is above the monster. If the monster is higher, the guy dies. If the guy is higher, the monster dies. When the 'monster' dies we increase the score and play a sound. We also inactivate the monster so that it appears to have vanished. When the main character dies we set 'endlevel' to TRUE and decrease the 'lives'. We also play a sound and inactivate the monster so that it does not interact with other items on the screen.

In the JNI code we have now killed the main character. The java code must be notified, so the java code gets the value of 'endlevel' once in every display of the Panel view. Panel.java knows this method as 'getEndLevel()' and it returns an integer value of 0 or 1. In this way the JNI and the java coordinate things like the end of the level and the playback of sounds. Score changes are handled this way also.  [top](awesomeguyJNI#Introduction.md)

### Function cutTile() ###

This method deserves a section to itself. The code for 'cutTile(...)' is below.
```
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
    		
    	}
    }
}
```
The function is passed two arrays. The 'tileset' array is the source material, and the 'tile' array is the destination for the data. The integer 'num' tells us which tile to copy. Inside the function the 'num' variable is used to calculate what data to copy, then a pair of for() loops does the actual copying. For the sake of readability some commenting has been added to show the meanings of the variables 'm', 'n', 'k', and 'l'. This method is simple but it's fairly crucial to the operation of the game.  [top](awesomeguyJNI#Introduction.md)

### Collision Functions ###

There are a group of functions that allow for the detection of collisions in the 'collisionWithMonsters()' code. The functions are general enough that they could be used to detect other types of collision if the role of the JNI library were expanded in the Awesomeguy app. They could be used, for example, for detecting collision with platforms or collision with solid objects in general, as they're modeled on the collision detection routines that are already used in the java code. They all rely on a single struct, the 'BoundingBox' struct. The definition of the struct is shown below.
```
typedef struct {
	int left, right, top, bottom;
} BoundingBox;
```
The 'BoundingBox' is very simple. It does not hold the pixel offset of a sprite's outline in its elements. Instead it holds the pixel screen position of the sprite's outline in the context of the entire coordinate system. The BoundingBox item 'left' is the distance the left of the sprite is from the origin with respect to the whole screen. The 'left' that reflects the sprite's left border with respect to the bitmap that represents the sprite (the picture of the 'monster' or 'platform' or running 'guy') is stored in the Sprite struct.

Two separate types of information have to be saved. One, the boundaries of an object on the screen, is saved in the BoundingBox struct. Another, the boundaries of an object within it's own Bitmap image, is stored in the Sprite struct. The Sprite struct info does not change for a given bitmap, but the BoundingBox struct changes for every change in an object's position on the screen. This info is refreshed constantly where collision between objects is concerned. The terminology is somewhat arbitrary, so a distinction is being made.

It is true, though, that the information that goes into creating a BoundingBox struct is dependent on the information in the Sprite struct. Therefore the Sprite struct is one of the parameters in the method that constructs a BoundingBox. The method that is used for constructing a BoundingBox is 'makeSpriteBox(...)'. There is a second method in the java code called 'makeBlockBox(...)' but it was not needed in the JNI library. Another method in the JNI library that's based on a java method is 'collisionSimple(...)'. Finally, a third method that can be found in the JNI code is 'collisionHelper(...)', but this method is just a helper method for 'collisionSimple(...)'.  [top](awesomeguyJNI#Introduction.md)

#### makeSpriteBox() ####

This simple function is used to create a 'BoundingBox' for another collision detection function. It's called every time that collision is being checked, because to use an old 'BoundingBox' produces errors, since the elements on the screen are always changing. The code for 'makeSpriteBox(...)' is below.
```
BoundingBox makeSpriteBox(Sprite sprite, int x, int  y) {
  BoundingBox temp;
  temp.left = sprite.leftBB + sprite.x + x;
  temp.right = sprite.rightBB + sprite.x + x;
  temp.top = sprite.topBB + sprite.y + y;
  temp.bottom = sprite.bottomBB + sprite.y + y;
  return temp;
}
```
The function takes the x and y position of the sprite and combines it with the sprite's definition of its borders. Then it adds in the optional arguments representing the movement that the sprite is expected to make.

Since the JNI library doesn't currently calculate the main character's movement (the java code currently does this for all aspects of the game except the movement of monsters) the optional arguments to 'makeSpriteBox(...)' are always set to zero.  [top](awesomeguyJNI#Introduction.md)

#### collisionSimple() ####

The basic concept we're using is that we have two rectangles and we want to see if they overlap. To do this we take the corners of one rectangle and check if they're inside all four sides of the other rectangle. We do this for all four corners. The code for 'collisionSimple(...)' is below.
```
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

```

> [top](awesomeguyJNI#Introduction.md)

#### collisionHelper() ####

The method 'collsionHelper(...)' is much like 'collisionSimple(...)' except the two rectangles are reversed, and the corners of the second rectangle are checked to see if they reside inside the first. This method is only used by 'collisionSimple(...)' and it's only called if the 'collisionSimple(...)' method returns false (i.e. no collision detected). The code for 'collisionHelper(...)' is below.
```
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
```

> [top](awesomeguyJNI#Introduction.md)

### Function drawMovingPlatform() ###

The code for moving platforms is almost identical to the code for 'drawMonsters()'. The code for 'drawMovingPlatform()' is different in two major ways. There is only one image for a moving platform. This means, firstly, that there is no section at the end of the method for manipulating the animation index of the platform, and, second, that there's no section for determining which bitmap to display. The section for determining which bitmap to display is a set of if/else blocks that check both the 'facingRight' attribute of the Sprite struct, and also the 'animate' attribute. The code for moving platforms is below.

```
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
```

> [top](awesomeguyJNI#Introduction.md)

# Java Native Functions #

This is the group of functions that can actually be called by the java code. They can also return values to the java code. In most cases in Awesomeguy, these methods are empty except for a single line that calls another method from the JNI library. This is not the case with every one of these methods. In a few cases these methods perform tasks like converting a 1D array to a 2D array, etc. There are about 25 java native functions in the JNI library.  [top](awesomeguyJNI#Introduction.md)

### Naming Functions ###

The naming conventions for these methods are fairly complex, so they'll be discussed here briefly and then discussed in another part of this wiki at greater depth.

Methods will be discussed here by using their java names. The average JNI native function name is unwieldy and looks something like this:
```
JNIEXPORT void JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_someFunction(JNIEnv * env, jobject  obj)
{}
```

In this example the method body is empty. The java native method 'someFunction()' would call the c function above. The name for this c function can be broken down into parts. The first part is the information before the method name. This is listed below.
  1. the macro JNIEXPORT
  1. the return type for the method ('void' in this example)
  1. the macro JNICALL

After that comes the actual name of the method. The name can be broken down into parts. They are listed below.
  1. the text '`Java_`'
  1. the text for the package name of the Android app, with the periods replaced by underscores
  1. the name of the class that the function will be part of
  1. the name of the function

This is followed by the two mandatory parameters '`JNIEnv * env`' and '`jobject obj`'. Other parameters for the function could have followed the mandatory ones listed above.  [top](awesomeguyJNI#Introduction.md)

### Java Declaration ###

There are two parts to the java declaration for the example code that we are using for this explanation. One part loads the library, and another part makes reference to the method so that the other java code in the app can call it. The declaration looks like the code below.
```
static {
	System.loadLibrary("awesomeguy");
}
```
This code has to be included in the Java class where the JNI is to be used. The second part of the java listing would look as follows.
```
public native void someFunction();
```
This line of code is like a java method declaration _witout_ the body. This function is also 'public' so it can be called by methods of other classes if they have an instantiated version of the class 'Panel'.

You should note that the c method declaration is different from the java declaration, but you need both, and the c version must include the package name and the java class name.  [top](awesomeguyJNI#Introduction.md)

### Individual Functions ###

This is an explanation of some of the functions in the JNI library that can actually be called by java.  [top](awesomeguyJNI#Introduction.md)

#### Native setTileMapData() ####

This function is used to copy four tilesheet bitmaps to the arrays in the JNI library where they will be stored before they are used to print the background of the game to the screen. This method uses an object called a 'jintArray'. The 'jintArray' needs to be converted to a c style array using the method '`GetIntArrayElements(...)`'. Then the c style array is simply passed to the 'setTileMapData(...)' method that we wrote. We know the exact size of the four bitmaps that we're starting with, so there's no reason to try to find out their size at runtime.
```
JNIEXPORT void JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_setTileMapData(JNIEnv * env, jobject  obj,
jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
{

  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);

  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);

  jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);

  jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);
  setTileMapData(a, b, c, d );
}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native setGuyData() ####

This function is similar to the one above only it calls 'setGuyData()' instead of 'setTileMapData()' when it's done translating the java arrays into pointers.
```
JNIEXPORT void JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_setGuyData(JNIEnv * env, jobject  obj,
jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
{

  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);
  jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);
  jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);
  
  setGuyData(a, b, c, d );
}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native setMonsterData() ####

This is another method that's similar to 'setTileMapData()'. It follows the exact same pattern, only it calls 'setMonsterData()' when it's done translating the java arrays into c pointers. As in all of these methods, the size of the original array is known, so we are not interested in finding out the size of the array at runtime.

```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_setMonsterData(JNIEnv * env, jobject  obj,
jintArray a_bitmap, jintArray b_bitmap, jintArray c_bitmap, jintArray d_bitmap)
{

  jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);

  jint *b = (*env)->GetIntArrayElements(env, b_bitmap, 0);

  jint *c = (*env)->GetIntArrayElements(env, c_bitmap, 0);

  jint *d = (*env)->GetIntArrayElements(env, d_bitmap, 0);
  setMonsterData(a, b, c, d );
}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native setMovingPlatformData() ####

Whereas there are four images for the main character's sprite, the monster sprite, and four images for the tilesheet, there is only one image for the moving platform. This method copies the moving platform bitmap to a c style array by calling the c function 'setMovingPlatformData()'.
```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_setMovingPlatformData(JNIEnv * env,
jobject  obj, jintArray a_bitmap) 
{

	jint *a = (*env)->GetIntArrayElements(env, a_bitmap, 0);
	
	setMovingPlatformData(a) ;

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native addMonster() ####

This method calls the c method 'addMonster(...)'. It basically passes three 'jint' java integer values to the JNI library. This method is called several times at the beginning of each level to initialize the monster structs on the 'Sprite' struct array. It's called before game play actually starts.

```
JNIEXPORT void JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_addMonster(JNIEnv * env, jobject  obj,
jint monster_mapx, jint monster_mapy,  jint animate_index)
{
	addMonster(monster_mapx, monster_mapy,  animate_index);	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native addPlatform() ####

This method is also used for populating the array of 'Sprite' structs. After all the monsters for a particular level are put on the array another java loop calls this method once for every floating platform that is to appear on the level. Like 'addMonster(...)' it does no computation. This function simply calls the JNI c library's 'addPlatform(...)' method.

```
JNIEXPORT void JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_addPlatform(JNIEnv * env, jobject  obj,
jint platform_mapx, jint platform_mapy)
{
	addPlatform(platform_mapx, platform_mapy);	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native inactivateMonster() ####

This method is called by the java code if and when it needs to make a monster invisible. This happens when the guy character jumps on a monster and kills it. It was originally used by the java code for detecting collision with monsters that was located in the Panel.java class. It doesn't do any calculation, it just passes the value that the java code gives it to the c code 'inactivateMonster(...)'. The parameter that it passes is the index number for the monster sprite on the 'Sprite' array of structs.
```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_inactivateMonster(JNIEnv * env, 
jobject  obj, jint monster_num)
{
	inactivateMonster(monster_num);	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native setGuyPosition() ####

This method passes five values to the JNI library. They are the x and y position of the guy on the background, the x and y scroll coordinates, and the value of the animation index for the level.
```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_setGuyPosition(JNIEnv * env, jobject  obj,
jint x_pos, jint y_pos, jint scroll_x, jint scroll_y, jint animate)
{
	setGuyPosition(x_pos, y_pos, scroll_x, scroll_y, animate);	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native setScoreLives() ####

This method passes two values to the JNI library. One is the current score and the other is the current number of lives the main character has. They are displayed on the screen during game play.
```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_setScoreLives(JNIEnv * env, jobject  obj,
jint score, jint lives)
{
	setScoreLives(score,lives);	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native setMonsterPreferences() ####

In the Awesomeguy Options.java activity there are two options which have to do with the interaction between the main character and the monsters seen on the screen. There are two preferences that can be set. One option is for displaying monsters on the screen at all. Another option is for weather or not the monster collision code is enabled. This second preference makes it so that the monster can be seen on the screen, but it cannot be killed and it cannot kill you. These two options need to be passed along to the JNI library so that it can enable and disable the monster code as is necessary.
```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_setMonsterPreferences(JNIEnv * env,
jobject  obj, jint monsters, jint collision)
{
	preferences_monsters = monsters;
	preferences_collision = collision;

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native setJNIAnimateOnly() ####

Though unimplemented, some provision for an animation of the main character has been added to the JNI library. The concept is that when the 'animate\_only' variable is set to true, the screen should be redrawn, but no collision should be recorded. This way, if a special method for animating the main character were called, it wouldn't have to worry about collision with monsters, etc. The animation could be employed to show that the main character has died or finished a level, or both separately.

```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_setJNIAnimateOnly(JNIEnv * env, jobject
obj, jint animate)
{

	animate_only = animate;

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native setScreenData() ####

This method is used to inform the JNI library what the dimensions of the screen area are (measured in tiles).
```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_setScreenData(JNIEnv * env, jobject  obj,
jint screenH, jint screenV)
{
	tilesWidthMeasurement = screenH;
	tilesHeightMeasurement = screenV;

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native setLevelData() ####

This method passes the 1D 'level' and 'object' arrays to the function 'setLevelData(...)' which converts them to the 2D arrays 'map\_level' and 'map\_objects'. It also passes the size of the arrays.
```
JNIEXPORT void JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_setLevelData(JNIEnv * env, jobject  obj,
jintArray level, jintArray objects, jint width, jint height)
{
	
	jint *a = (*env)->GetIntArrayElements(env, level, 0); 
  	jint *b = (*env)->GetIntArrayElements(env, objects, 0);
  	
  	level_h = height;
  	level_w = width;
  	
  	sprite_num = 0;
  	
	setLevelData(a,b);	
	
}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native setObjectsDisplay() ####

This method is used during game play to allow the java code to change a value in the JNI's  'map\_objects' array. This is used, for example, when the java notices that the main character has hit a ring. In this case, the character needs to be given points, and the ring has to be made to disappear. This function allows the java to make the JNI ring disappear.
```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_setObjectsDisplay(JNIEnv * env, jobject
obj, jint map_x, jint map_y, jint value)
{
	setObjectsDisplay(map_x, map_y, value);	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native drawLevel() ####

This method returns to the java code the contents of the 'screen' array. Before it returns these contents it must first convert them to a 1D array, and then put them into the 'jintArray'. The 'jintArray' is the java version of the integer array.
```
JNIEXPORT jintArray JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_drawLevel(JNIEnv * env, jobject  obj, 
jint animate)
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
```
The four lines of code that are most important in this method are:
  1. `jintArray graphic;`
  1. `graphic = (*env)->NewIntArray(env, size);`
  1. `(*env)->SetIntArrayRegion(env, graphic,0, size, fill);`
  1. `return graphic;`
Parts 1 and 2 set up the int array that we want to return. Part 3 fills the int array with the data from the regular array 'fill'. Part 4 returns the filled int array. In the java code the array is used to create a bitmap.  [top](awesomeguyJNI#Introduction.md)

#### Native getSoundBoom() ####

This method returns an integer value of 0 or 1 representing weather or not the java code should play the 'boom' sound.
```
JNIEXPORT int JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_getSoundBoom(JNIEnv * env, jobject  obj)
{
	return getSoundBoom();	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native getSoundOw() ####

This method returns an integer value of 0 or 1 representing weather or not the java code should play the 'ow' sound.
```
JNIEXPORT int JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_getSoundOw(JNIEnv * env, jobject  obj)
{
	return getSoundOw();	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native getSoundPrize() ####

This method returns an integer value of 0 or 1 representing weather or not the java code should play the 'prize' sound.
```
JNIEXPORT int JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_getSoundPrize(JNIEnv * env, jobject  obj)
{
	return getSoundPrize();	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native getLives() ####

This method returns the number of lives that the JNI library says the main character should have.
```
JNIEXPORT int JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_getLives(JNIEnv * env, jobject  obj)
{
	return lives;	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native getEndLevel() ####

This method returns the values 0 or 1 for weather or not the variable 'endlevel' is set. At the same time it resets 'endlevel' to false.
```
JNIEXPORT int JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_getEndLevel(JNIEnv * env, jobject  obj)
{
	
	int temp = endlevel;
  	endlevel = FALSE;
	return temp;	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native getScore() ####

This method returns to the java code the value of the JNI variable 'score'.
```
JNIEXPORT int JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_getScore(JNIEnv * env, jobject  obj)
{
	return score;	
}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native incrementJniScore() ####

This method increments the JNI variable 'score' by a certain amount.
```
JNIEXPORT void JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_incrementJniScore(JNIEnv * env, 
jobject  obj, jint num)
{
	score = score + num;	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native getSpriteX() ####

One of three methods that return the value associated with a given sprite on the array of sprite structs. This method takes a array index and returns a sprite's x coordinate.

```
JNIEXPORT int JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_getSpriteX(JNIEnv * env, jobject  obj,
jint num)
{
	return sprite[num].x;	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native getSpriteY() ####

One of three methods that return the value associated with a given sprite on the array of sprite structs. This method takes a array index and returns a sprite's y coordinate.

```
JNIEXPORT int JNICALL 
Java_org_davidliebman_android_awesomeguy_Panel_getSpriteY(JNIEnv * env, jobject  obj,
jint num)
{
	return sprite[num].y;	

}
```

> [top](awesomeguyJNI#Introduction.md)

#### Native getSpriteFacingRight() ####

One of three methods that return the value associated with a given sprite on the array of sprite structs. This method takes a array index and returns a sprite's 'facingRight' property.
```
JNIEXPORT int JNICALL
Java_org_davidliebman_android_awesomeguy_Panel_getSpriteFacingRight(JNIEnv * env,
jobject  obj, jint num)
{
	return sprite[num].facingRight;	

}
```

> [top](awesomeguyJNI#Introduction.md)