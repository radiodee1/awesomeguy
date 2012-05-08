package org.davidliebman.android.awesomeguy;


import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.ShortBuffer;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.opengl.GLSurfaceView;
import android.opengl.GLU;
import android.util.Log;
import android.view.*;
//import android.util.Log;
import android.graphics.*;

public  class Panel  /* extends SurfaceView */ implements /*SurfaceHolder.Callback, */ GLSurfaceView.Renderer {
	private GameValues mGameV;
	private Canvas mCanvas;

	private MovementValues mMovementV;
	private Record mHighScores;
	private int mDisplayViewWidth;
	private Matrix mMatrix;
	
	private int scrollX, scrollY;
	private Bitmap  mMap, mTempJNI;
	private BitmapFactory.Options mOptionsSprite = new BitmapFactory.Options();
	private BitmapFactory.Options mOptionsTile = new BitmapFactory.Options();
	private BitmapFactory.Options mOptionsNum = new BitmapFactory.Options();
	private BitmapFactory.Options mOptionsPlat = new BitmapFactory.Options();

	private SpriteInfo mGuySprite;
	private Paint mP;
	//private float mScale = 2;
	private float mScaleH = 2;
	private float mScaleV = 2;

	
	
	/* -- start 'for scrolling' -- */
	/* for scrolling */
	private final int LR_MARGIN = 80;
	private final int TB_MARGIN = 40;
	//private SpriteInfo mGuySprite;

	/* for scrolling, collision, etc. */
	private boolean canScroll;
	private int oldX;
	private int oldY;
	private int screenX;
	private int screenY;
	private int mapH;
	private int mapV;
	
	private boolean mCanSkip; // for problem spots
	
	private int mScreenW;
	//private int mScreenH;
	
	private int mapX;
	private int mapY;

	private int newMapX;
	private int newMapY;

	private int newX;
	private int newY;

	private int guyWidth; 
	private int guyHeight;

	private int x;
	private int y;

	private boolean keyB = false;
	private int jumptime;

	private double mXMultiplier = 1;
	private double mYMultiplier = 1;

	private boolean ladderTest = false;
	private boolean blockTest = false;
	private boolean boundaryTest = false;
	private boolean boundaryLeft = false;
	private boolean boundaryRight = false;
	private boolean canFall = false;
	private boolean canJump = false;
	
	public static final int END = 1;
	public static final int MIDDLE = 2;
	public static final int START = 3;

	public static final int JNI_TRUE = 1;
	public static final int JNI_FALSE = 0;
	
	/* -- end 'for scrolling' -- */

	/* for monster animation */
	public static final int ANIM_SPEED = 5;


	/* animation vars */
	private static int ANIMATE_SPEED = 0;
	private int animate, newGuy, newBG, lastGuy, lastBG;

	/* test jni */
	int [] screen = new int [192 * 256];
	SoundPoolManager mSounds;
	private boolean mEnableSounds;
	private boolean mAnimationOnly;
	
	public Panel(Context context,  GameValues gameValues, GameStart parent, MovementValues movementValues) {//, Record highScores) {
//		super(context);
//		this.setWillNotDraw(false);
//		
//		this.getHolder().addCallback(this);
		
		mGameV = gameValues;
		mMovementV = movementValues;

		mGameV.setSpriteStart();
		mGuySprite = mGameV.getSpriteStart();

		
		
		/* display width considerations */
    	Display display = ((WindowManager) context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();    	
    	int displayWidth = display.getWidth();
    	int displayHeight = display.getHeight();
		
    	if(mGameV.getScreenOrientation() == GameValues.ORIENTATION_PORTRAIT) {
	    	
			if ( displayWidth < 256 * 2 ) {
				mDisplayViewWidth = mGameV.getDisplayWidth();//displayWidth;
				mScaleH = mGameV.getScaleH();
			}
			else {
				mDisplayViewWidth = 256 * 2;
			}
			
			if (!mGameV.isDoubleScreen()) {
				mScaleH = mGameV.getScaleH();
				mScaleV = 1;
				mDisplayViewWidth = 256;
			}
			
    	}
    	else if(mGameV.getScreenOrientation() == GameValues.ORIENTATION_LANDSCAPE) {
			mScaleH = mGameV.getScaleH();
			mScaleV = mGameV.getScaleV();
			
		}
		
		/* paint options BitmapFactory.Options */
		mOptionsSprite.inScaled = false;
		mOptionsSprite.outHeight = 16;
		mOptionsSprite.outWidth = 16;
		mOptionsSprite.inPreferredConfig = Bitmap.Config.ARGB_8888;
		
		mOptionsTile.inScaled = false;
		mOptionsTile.outHeight = 128;
		mOptionsTile.outWidth = 224;
		mOptionsTile.inDensity = 0;
		mOptionsTile.inTargetDensity = 0;
		mOptionsTile.inPreferredConfig = Bitmap.Config.ARGB_8888;
		
		mOptionsNum.inScaled = false;
		mOptionsNum.outHeight = 16;//16
		mOptionsNum.outWidth = 160;// 160
		mOptionsNum.inDensity = 0;//0
		mOptionsNum.inTargetDensity = 0;//0
		mOptionsNum.inPreferredConfig = Bitmap.Config.ARGB_8888;
		
		mOptionsPlat.inScaled = false;
		mOptionsPlat.outHeight = 16;//16
		mOptionsPlat.outWidth = 160;// 160
		mOptionsPlat.inDensity = 0;//0
		mOptionsPlat.inTargetDensity = 0;//0
		mOptionsPlat.inPreferredConfig = Bitmap.Config.ARGB_8888;
		
		mP = new Paint();
		mP.setAlpha(0xff);
		mMatrix = new Matrix();
		mMatrix.setScale(mScaleH, mScaleV);

		scrollX = mMovementV.getScrollX();
		scrollY = mMovementV.getScrollY();
		
		/*animation vars*/
		animate = 0;
		newGuy = 0;
		lastGuy = 0;
		newBG = 0;
		lastBG = 0;

		mAnimationOnly = false;
		
		mHighScores = mGameV.getGuyScore();//highScores;//mGameV.getGuyScore();
		mSounds = new SoundPoolManager(parent);
		mSounds.init();
		
		/* prepare jni -- load all images into library */
		int [] a = new int[16*16];
		int [] b = new int[16*16];
		int [] c = new int[16*16];
		int [] d = new int[16*16];

		Bitmap mSprite;
		mSprite = BitmapFactory.decodeResource(context.getResources(),R.drawable.guy0, mOptionsSprite);
		mSprite.getPixels(a, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(context.getResources(),R.drawable.guy1, mOptionsSprite);
		mSprite.getPixels(b, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(context.getResources(),R.drawable.guy2, mOptionsSprite);
		mSprite.getPixels(c, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(context.getResources(),R.drawable.guy3, mOptionsSprite);
		mSprite.getPixels(d, 0, 16, 0, 0, 16, 16);
		setGuyData(a, b, c, d);

		mSprite = BitmapFactory.decodeResource(context.getResources(),R.drawable.monster_r0, mOptionsSprite);
		mSprite.getPixels(a, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(context.getResources(),R.drawable.monster_r1, mOptionsSprite);
		mSprite.getPixels(b, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(context.getResources(),R.drawable.monster_l0, mOptionsSprite);
		mSprite.getPixels(c, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(context.getResources(),R.drawable.monster_l1, mOptionsSprite);
		mSprite.getPixels(d, 0, 16, 0, 0, 16, 16);
		setMonsterData(a, b, c, d);

		int [] tiles_a = new int [128 * 224];
		int [] tiles_b = new int [128 * 224];
		int [] tiles_c = new int [128 * 224];
		int [] tiles_d = new int [128 * 224];

		Bitmap mTiles;
		mTiles = BitmapFactory.decodeResource(context.getResources(), R.drawable.tiles1, mOptionsTile);
		mTiles.getPixels(tiles_a, 0, 224, 0, 0, 224, 128);
		mTiles = BitmapFactory.decodeResource(context.getResources(), R.drawable.tiles2, mOptionsTile);
		mTiles.getPixels(tiles_b, 0, 224, 0, 0, 224, 128);
		mTiles = BitmapFactory.decodeResource(context.getResources(), R.drawable.tiles3, mOptionsTile);
		mTiles.getPixels(tiles_c, 0, 224, 0, 0, 224, 128);
		mTiles = BitmapFactory.decodeResource(context.getResources(), R.drawable.tiles4, mOptionsTile);
		mTiles.getPixels(tiles_d, 0, 224, 0, 0, 224, 128);
		this.setTileMapData(tiles_a, tiles_b, tiles_c, tiles_d);
		
		int [] platform_a = new int [8 * 40];
		Bitmap mPlatform;
		mPlatform = BitmapFactory.decodeResource(context.getResources(), R.drawable.concrete, mOptionsPlat);
		mPlatform.getPixels(platform_a, 0, 40, 0, 0, 40, 8);
		this.setMovingPlatformData(platform_a);
		
		/* JNI display size setting */
		setScreenData(mGameV.getScreenTilesHMod(), 24);
		
		/* JNI Monster Collision setting */
		int monsters = 0;
		int collision = 0;
		if(mHighScores.isEnableMonsters()) monsters = 1;
		if(mHighScores.isEnableCollision()) collision = 1;
		setMonsterPreferences(monsters, collision);
		
		this.prepareBitmap();
	}


//	@Override
//	public void onDraw(Canvas canvas) {
//		mCanvas = canvas;
		
//		this.setScoreLives(mGameV.getScore(), mGameV.getLives());

		
//			checkRegularCollisions();
//
//			checkPhysicsAdjustments();
//		
//			scrollBg(); //always call this last!!
	
		/** animate items **/
//		animateItems();

				
		/************** test jni *******************/
//		mMap = Bitmap.createBitmap(drawLevel(newBG + 1), 256, 192, Bitmap.Config.RGB_565);
//		mTempJNI = Bitmap.createBitmap(mMap, 0, 0, 256, 192, mMatrix, false);

//		mCanvas.drawBitmap(mTempJNI, 0, 0, null);

//		playSounds();
		
		
//		/* at end of level */
//		if(getEndLevel() == 1) {
//			mGameV.setEndLevel(true);
//			mGameV.decrementLives();
//			mGameV.setGameDeath(true);
//		}
//		
//		/* changes during level */
//		mHighScores.setLives(getLives());
//		mHighScores.setScore(getScore());
//		mGameV.setScore(getScore());
		
//	}

	public void prepareBitmap() {
		drawLevel(newBG + 1);
		
		//mMap = Bitmap.createBitmap(drawLevel(newBG + 1), 256, 192, Bitmap.Config.RGB_565);
		//mTempJNI = Bitmap.createBitmap(mMap, 0, 0, 256, 192, mMatrix, false);
	}
	
	public void setInitialBackgroundGraphics() {
		/*** set initial scroll positions ***/

		scrollX = mMovementV.getScrollX();
		scrollY = mMovementV.getScrollY();

		/*** Load sprites for level ***/
		mGameV.setSpriteStart();
		mGuySprite = mGameV.getSpriteStart();
		mGameV.adjustSpriteStartPos();

		/* JNI Monster Collision setting */
		int monsters = 0;
		int collision = 0;
		if(mHighScores.isEnableMonsters()) monsters = 1;
		if(mHighScores.isEnableCollision()) collision = 1;
		setMonsterPreferences(monsters, collision);
	}

	public void setReturnBackgroundGraphics() {
		/*** jni lives and score ***/
		
		setScoreLives(mGameV.getScore(), mGameV.getLives());
		mHighScores.setLives(mGameV.getLives());
		mHighScores.setScore(mGameV.getScore());
		
		/*** set initial scroll positions ***/
		scrollX = mGameV.getScrollX();
		scrollY = mGameV.getScrollY();
		setJNIScroll(scrollX, scrollY);
		
		/*** Load sprites for level ***/
		mGuySprite = mGameV.getSpriteStart();

		/*** JNI Monster Collision setting ***/
		int monsters = 0;
		int collision = 0;
		if(mHighScores.isEnableMonsters()) monsters = 1;
		if(mHighScores.isEnableCollision()) collision = 1;
		setMonsterPreferences(monsters, collision);
	}


	public void setGameValues(GameValues g) {
		mGameV = g;

	}
	public GameValues getGameValues() {
		return mGameV;
	}
	
	public void setPanelScroll(int x, int y) {
		scrollX = x;
		scrollY = y;
		mGuySprite = mGameV.getSpriteStart();
		int mGuyX = mGuySprite.getMapPosX();
		int mGuyY = mGuySprite.getMapPosY();
		
		setGuyPosition(mGuyX  , mGuyY , scrollX, scrollY, newGuy);
		

	}

	
	public void animateItems() {

		if (ANIMATE_SPEED != 0) animate ++;
		if (this.mGuySprite.getAnimate() == true) {

			if (animate == ANIMATE_SPEED) {
				newGuy ++;
				newBG ++;
				animate = 0;
			}
			if (newGuy != lastGuy) {
				//setSwapGuy(newGuy);
				lastGuy = newGuy;
				if(newGuy > 3) newGuy = -1;
			}
			//animate tiles
			if (newBG != lastBG) {
				//if (!useJNI) setTilesheet(newBG + 1);
				lastBG = newBG;
				if(newBG > 7) newBG = -1;
			}

		} 


	}
	
	
	
	
	public void checkPhysicsAdjustments() {

		this.readKeys();

		/* All sorts of adjustments go here. ladder, jump, gravity, 
		 * the ground, and solid objects in general.
		 */
		BoundingBox guyBox = BoundingBox.makeSpriteBox(mGuySprite,x,y);//mGuySprite,0,0


		int jumpHeight = 15;

		/* LADDER TEST */
		if (ladderTest) {
			canFall = false;
			//Log.v("ladder test", "canfall = false;");

		}

		else if (y  < 0 && jumptime <= 0){
			y = 0;
			canFall = true;
		}

		
		collisionWithBlocks();

		
		/* PLATFORMS */
		canJump = collisionWithPlatforms( canFall);
		
		
		/* JUMP */
		
		//used to test for jumping
		
		SpriteInfo mSprite = mGameV.getSprite(0);
		int mTestCenterX = mSprite.getMapPosX() + (mSprite.getLeftBB() + mSprite.getRightBB()) /2;
		int mTestBelowY = mSprite.getMapPosY() + mSprite.getBottomBB() + 2;

		if(jumptime <= 0 && y == 0 &&  keyB &&
				(pointToBlockNum(mTestCenterX,mTestBelowY - 16) != mGameV.mBlock && 
				pointToBlockNum(mTestCenterX,mTestBelowY - 8) != mGameV.mBlock) && 
				(pointToBlockNum(mTestCenterX, mTestBelowY) == mGameV.mBlock || 
				ladderTest || guyBox.getBottom() == mGameV.getMapV() * 8 || canJump)) {
			
			jumptime = mMovementV.getVMove() * jumpHeight;
			keyB = false;
		}
		
		
			
		/* 
		 * Here we implement the gravity.
		 */
		if(canFall && !ladderTest && !canJump) {
			y = y + mMovementV.getVMove() ;
		
		}

		/*
		 * handle jumps.
		 */
		if (jumptime > 0) {
			jumptime = jumptime - mMovementV.getVMove() ;
			y =  - mMovementV.getVMove();// * 2 / 3);
			//if(jumptime >  mMovementV.getVMove() * 3) x = 0;
			canFall = false;
			//Log.v("functions","jumping");
		}

		
	}

	public void collisionWithBlocks() {
		boolean mSkip = false;
		SpriteInfo mSprite = mGameV.getSprite(0);
		
		DetectionPattern mPattern = makeDetectionPattern(mGameV.mBlock, mMovementV.getHMove());
		DetectionPattern mPatternFloor = makeDetectionPattern(mGameV.mBlock, 1);
		DetectionPattern mPatternLadder = makeDetectionPattern(mGameV.mLadder,2);
		DetectionPattern mPatternSpace = makeDetectionPattern(mGameV.mSpace, 3);
		
		int mTestBottomY = mSprite.getMapPosY() + mSprite.getBottomBB() - 4;
		int mTestRightSkipX = mSprite.getMapPosX() + mSprite.getRightBB() + (mMovementV.getHMove() + 1);
		int mTestLeftSkipX = mSprite.getMapPosX() + mSprite.getLeftBB() - (mMovementV.getHMove() + 1);
		
		
		//skip RIGHT
		if (x > 0 &&  mCanSkip &&
				mPattern.isLowerRight() &&
				pointToBlockNum(mTestRightSkipX, mTestBottomY - 8) != mGameV.mBlock &&
				pointToBlockNum(mTestRightSkipX, mTestBottomY - 16) != mGameV.mBlock) {
			canFall = false;
			y = - ( mMovementV.getVMove());
			x = x + mMovementV.getHMove();
			mSkip = true;
		}
		
		//skip LEFT
		if ( x < 0 && mCanSkip &&
				mPattern.isLowerLeft() &&
				pointToBlockNum(mTestLeftSkipX, mTestBottomY - 8) != mGameV.mBlock &&
				pointToBlockNum(mTestLeftSkipX, mTestBottomY - 16) != mGameV.mBlock) {
			canFall = false;
			y = -( mMovementV.getVMove());
			x = x - mMovementV.getHMove();
			mSkip = true;
		}
		
		
		//drop when you hit a wall

		if ( !mPatternFloor.isBottom() && !ladderTest && !mSkip &&
				(mPattern.isUpperLeft() || mPattern.isUpperRight() || mPattern.isLowerLeft() || mPattern.isLowerRight())) {
			y = mMovementV.getVMove();

			if (x < 0 && (mPattern.isLowerLeft() || mPattern.isUpperLeft())) {
				x = 0;
				canFall = true;
			}
			if (x > 0 && (mPattern.isLowerRight() || mPattern.isUpperRight())) {
				x = 0;
				canFall = true;
			}
			
			
		}
		
		//stop when you hit a wall
		if (!mSkip) {	
			if (x < 0  && ((mPattern.isLowerLeft() && !mPatternLadder.isBottom()) || 
					mPattern.isUpperLeft()) 
					&& !mPatternSpace.isLowerLeft()) {
				x = 0;
			}
			if (x > 0  && ((mPattern.isLowerRight() && !mPatternLadder.isBottom()) || 
					mPattern.isUpperRight()) 
					&& !mPatternSpace.isLowerRight()) {
				x = 0;
			}
		}
		
		//floor
		if (mPatternFloor.isBottom() ) {
			canFall = false;
			mMovementV.setDirectionKeyDown(0);
			if (y > 0) y = 0;
		}
		
		
		
		//no HANGING
		if (jumptime >=0 && !ladderTest && mPattern.ismTop()) {
			y = mMovementV.getVMove();
			canFall = true;
			jumptime = -1;
		}
		
		return;
	}
	
	
	public boolean collisionWithPlatforms(boolean canFall) {
		int i, j;
		//
		  BoundingBox guyBox, platformBox;
		  boolean temp = this.canJump;
		  guyBox = BoundingBox.makeSpriteBox( mGuySprite,0,0);
		  boolean mFacingRight = true;
		  
		  if (mGameV.getPlatformNum() == -1) return canJump;
		  
		  temp = false;
		  
		  for (i = mGameV.getPlatformOffset() + 1 ; i <=  mGameV.getPlatformNum() ; i ++) {
		    j = i ; // i - 1;
			/* get info from JNI on platform position */
		    SpriteInfo mTempSprite = new SpriteInfo( 0, 8, 0, 40);
		    
		  	mTempSprite.setMapPosX(this.getSpriteX(j));
		  	mTempSprite.setMapPosY(this.getSpriteY(j));
		  	if(this.getSpriteFacingRight(j) == 1) mFacingRight = true;
		  	else mFacingRight = false;
		  	mTempSprite.setFacingRight(mFacingRight);
		  	//Log.e("Platforms", "x="+mTempSprite.getMapPosX() + " y=" + mTempSprite.getMapPosY()	);
		  	
		  	
		  	/* check platform */
		    platformBox = BoundingBox.makeSpriteBox( mTempSprite,0,0);
		    boolean test = BoundingBox.collisionSimple(guyBox, platformBox);
		    
		    if (test) {
		      temp = test;
		      //Log.e("Platforms", "Collision!!");
		      if ( mGuySprite.getMapPosY() < mTempSprite.getMapPosY()) { // stand on platforms
		        canFall = false;
		        if (y > 0) y = 0;
		        if(mTempSprite.getFacingRight()) {
		          x ++;
		        }
		        else {
		          x --;
		        }
		      }
		      if ( mGuySprite.getMapPosY() > mTempSprite.getMapPosY()) { // below platforms
		        canFall = true;
		        y =  mMovementV.getVMove();
		      }
		    }
		  }
		  
		  return temp;
		  
	}

	public void scrollBg() {
		/* scroll registers for background */

		canScroll = true;
		oldX = mMovementV.getScrollX();
		oldY = mMovementV.getScrollY();
		screenX = oldX;
		screenY = oldY;
		mapH = mGameV.getMapH();
		mapV = mGameV.getMapV();

		mapX = mGuySprite.getMapPosX();
		mapY = mGuySprite.getMapPosY();

		newMapX = mapX;
		newMapY = mapY;

		//newX = mGuySprite.getX();
		//newY = mGuySprite.getY();

		guyWidth = (mGuySprite.getRightBB() - mGuySprite.getLeftBB()) + 5; // 12 ?
		guyHeight = mGuySprite.getBottomBB() - mGuySprite.getTopBB();

		int tilesMeasurement;

		if (mGameV.isDoubleScreen()) {
			tilesMeasurement = ((this.mDisplayViewWidth / 2 ) / 8) ;
			if (tilesMeasurement > 32 ) tilesMeasurement = 32;
			this.mScreenW = tilesMeasurement * 8;
			//if (tilesMeasurement * 16 < this.mDisplayWidth) tilesMeasurement ++;
		}
		else {
			this.mScreenW = this.mDisplayViewWidth;
			tilesMeasurement = 32;
		}
		
		/* 
		 * determine position of guy on screen and determine position
		 * of background on screen also... set scrolling, etc. x and y
		 * are set by routine 'readKeys()'
		 */

		if (x > 0) {   

			if (oldX > mapH * 8 ) oldX = -1;

			if (oldX >= ((mapH - tilesMeasurement) * 8 - x)  ) canScroll = false;
			else canScroll = true;
			//move RIGHT?
			
			if ( mapX + x >= mapH * 8  - guyWidth) {
				newMapX = mapH * 8  - guyWidth;
				newX = mScreenW - guyWidth;

			}
			

			if ((mapX + x) >= (oldX + LR_MARGIN) ) {        


				if (canScroll ) {
					screenX += x;
					newMapX += x;
				}
				else if ( mapX <= (mapH ) * 8 - guyWidth ) {
					newX += x;
					newMapX += x;
				}

			}
			else if ((mapX + x) <= (oldX + LR_MARGIN) &&  canScroll) {
				//move sprite?
				newX += x;
				newMapX += x;

			}


		}  

		//////////////////////////////////////
		else if (x < 0) {   
			if (oldX > 8 * mapH + 1) oldX = -1;

			if (oldX <= 0 - x) canScroll = false;
			else canScroll = true;
			//move LEFT?
			if ( mapX + x <= 0) {
				newMapX = 1;
				newX = 1;

			}

			if ((mapX + x) <= (oldX +( (tilesMeasurement) * 8 ) - LR_MARGIN) ) {   //32 * 8     


				if (canScroll) {
					screenX  += x;
					newMapX += x;

				}
				else if ( mapX >= 0 ) {
					newX += x;
					newMapX += x; 

				}

			}
			else if ((mapX + x) >= (oldX + ( (tilesMeasurement) * 8) - LR_MARGIN) &&  canScroll) { // 32 * 8
				//move sprite?
				newX += x;
				newMapX += x;

			}

		}  

		//////////////////////////////////////
		if (y > 0) {   
			if (oldY > mapV * 8) oldY = -1; 

			if (oldY >= ((mapV - 24) * 8 - y) ) canScroll = false;
			else canScroll = true;
			//move DOWN?
			if (mapY + y >= mapV * 8  - guyHeight) {
				newMapY = mapV * 8  - guyHeight;
				newY = 24 * 8 - guyHeight;

			}

			if ((mapY + y) >= (oldY + TB_MARGIN) ) {        


				if (canScroll) {
					screenY += y;
					newMapY += y;
				}
				else if ( mapY <= mapV * 8  - guyHeight ) {
					newY += y;
					newMapY += y;
				}

			}
			else if ((mapY + y) <= (oldY + TB_MARGIN) &&  canScroll) {
				//move sprite?
				newY += y;
				newMapY += y;

			}

		}  
		////////////////////////////////////// 
		else if (y < 0) {   
			if (oldY > mapV * 8) oldY = -1;

			if (oldY < ( 0 - y) ) canScroll = false;
			else canScroll = true;
			//move UP?
			if ( mapY + y <= 0) {
				newMapY = 1;
				newY = 1;

			}

			if ((mapY + y) <= (oldY +( (24 ) * 8 ) - TB_MARGIN) ) { //32 * 8       


				if (canScroll && screenY + y > 0) {
					screenY += y;
					newMapY += y;

				}
				else if ( mapY >= 0 ) {
					newY += y;
					newMapY += y;
				}

			}
			else if ((mapY + y) >= (oldY + ( 24  * 8 ) - TB_MARGIN) &&  canScroll) { //32 * 8
				//move sprite?
				newY += y;
				newMapY += y;

			}

		}
		////////////////////////
		//special test for trouble spot:
		if (x > 0 && !canScroll && mapX + x >= mScreenW ) {
				//turn off skip
				mCanSkip = false;
		}
		else mCanSkip = true;
		////////////////////////
		
		mGuySprite.setMapPosX(newMapX);
		mGuySprite.setMapPosY(newMapY);
		
		mMovementV.setScrollX(screenX);
		mMovementV.setScrollY(screenY);
	}
	public void checkRegularCollisions() {

		/*
		 * Here we create a BoundingBox for the guy character. Then
		 * we check the level for collisions. The object is to record when the 
		 * character comes into contact with various objects.
		 */

		//BoundingBox guyBoxNext = makeSpriteBox(guy, x, y);
		BoundingBox guyBox = BoundingBox.makeSpriteBox(mGuySprite, x, y );

		// set ladderTest to false
		ladderTest = false;
		blockTest = false;
		boundaryTest = false;
		boundaryLeft = false;
		boundaryRight = false;
		canFall = true;

		
		
		int i,j;

		for (j =  mGuySprite.getMapPosX() / 8 -1; j <  mGuySprite.getMapPosX() / 8 + 3; j ++ ) { // x coordinates
			for (i = mGuySprite.getMapPosY() / 8 - 1; i < mGuySprite.getMapPosY() / 8 + 3; i ++ ) { // y coordinates
				if(j >= 0 && j < mGameV.getMapH()  && i >= 0 && i < mGameV.getMapV()) {// indexes OK?

					if (mGameV.getObjectsCell(j,i)  != 0 ) { // I/J or J/I... which one???

						/* save time here by checking the bounding 
						 * box only in the squares immediately surrounding
						 * the character...
						 * Instead of checking the whole field of play.
						 */

						BoundingBox testMe = BoundingBox.makeBlockBox(j,i);
						//bool testNext = collisionSimple(guyBoxNext, testMe);
						boolean test = BoundingBox.collisionSimple(guyBox, testMe);

						/****** tests here ******/

						/*********  block ***************/
						if (test && mGameV.getObjectsCell(j, i) == mGameV.mBlock) {
							blockTest = true;

						}
						/******** ladder **********/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mLadder) {
							ladderTest = true;
							//canFall = false;
						}

						/************ GOAL ****************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mGoal ) {

							mGameV.setEndLevel(true);

							
							mGameV.setObjectsCell(j, i, 0);
							
							
							setObjectsDisplay(j, i, 0);//jni
							this.incrementJniScore(100);
							

							mGameV.incrementScore(100);
							//mmEffect(SFX_GOAL);
							mSounds.playSound(SoundPoolManager.SOUND_GOAL);

						}
						/************ goal ends ****************/
						/************* prizes ******************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mPrize ) {

							
							mGameV.setObjectsCell(j, i, 0);
							
							setObjectsDisplay(j, i, 0);//jni
							this.incrementJniScore(10);
							

							mGameV.incrementScore(10);
							//mmEffect(SFX_PRIZE);
							mSounds.playSound(SoundPoolManager.SOUND_PRIZE);
						}

						/********** prizes end *****************/
						/************* keys   ******************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mKey ) {

							
							mGameV.setObjectsCell(j, i, 0);
							
							setObjectsDisplay(j, i, 0);//jni
							this.incrementJniScore(50);
							

							mGameV.incrementScore(50);
							//mmEffect(SFX_PRIZE);
							mSounds.playSound(SoundPoolManager.SOUND_PRIZE);
							//data[level.usernum].level = level.room;
							//must save this data...
						}

						/**********   keys end *****************/
						/**************** oneup ****************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mOneup ) {

							
							mGameV.setObjectsCell(j, i, 0);
							
							setObjectsDisplay(j, i, 0);//jni
							

							mSounds.playSound(SoundPoolManager.SOUND_GOAL);
							mGameV.incrementLives();
						}
						/*****************end oneup *************/
						/**************** bigprize ****************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mBigprize ) {

							
							mGameV.setObjectsCell(j, i, 0);
							
							setObjectsDisplay(j, i, 0);//jni
							this.incrementJniScore(200);
							

							mGameV.incrementScore(200);
							//mmEffect(SFX_PRIZE);
							mSounds.playSound(SoundPoolManager.SOUND_PRIZE);

						}
						/*****************end bigprize *************/
						/************ death ****************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mDeath && mGameV.isGameDeath() == false) {

							mGameV.setGameDeath(true);
							mGameV.setEndLevel(true);
							mGameV.decrementLives();

							//mmEffect(SFX_OW);
							mSounds.playSound(SoundPoolManager.SOUND_OW);
						}
						/************ death ends ****************/
						/****** end tests  ******/

						//mHighScores.setAll(mGameV, mGameV.getUsernum());
						//mHighScores.setAll(mGameV.getGuyScore());

					}//if block
				} // indexes OK?
				else {

					boundaryTest = true;
					if(j >= mGameV.getMapH() -1) boundaryRight = true;
					if(j <= 1) boundaryLeft = true;
				}
			} // i block
		} // j block

		

	}
	
	
	public void setKeyB(boolean b) {
		keyB = b;
	}



	public boolean isAnimationOnly() {
		return mAnimationOnly;
	}


	public void setAnimationOnly(boolean mAnimationOnly) {
		this.mAnimationOnly = mAnimationOnly;
	}


	/**  used to refresh reference to Guy Sprite before start of level. **/
	public void setGuySprite(SpriteInfo sprite) {
		mGuySprite = sprite;
	}
	
	

	
	public Record getHighScores() {
		return mHighScores;
	}


	public void setHighScores(Record mHighScores) {
		this.mHighScores = mHighScores;
	}
	

	public boolean isEnableSounds() {
		return mEnableSounds;
	}


	public void setEnableSounds(boolean mEnableSounds) {
		this.mEnableSounds = mEnableSounds;
		mSounds.setEnabled(mEnableSounds);
	}


	public   void readKeys(double num) {
		mXMultiplier = num;
		mYMultiplier = num;
		readKeys();
		mXMultiplier = 1;
		mYMultiplier = 1;
	}


	public  void readKeys() {		


		/* set x and y as determined by game pad input */
		x=0;
		y=0;

		//keyB = false;

		//changeX = false;
		//changeY = false;

		if(mMovementV.getDirectionLR() == MovementValues.KEY_RIGHT) {

			x =  (int) + (mMovementV.getHMove() * mXMultiplier);
			//changeX = true;
			//keyB = false;
		}
		if(mMovementV.getDirectionLR() == MovementValues.KEY_LEFT) {
			x =   (int) - (mMovementV.getHMove() * mXMultiplier);
			//changeX = true;
			//keyB = false;
		}
		if(mMovementV.getDirectionUD() == MovementValues.KEY_UP) {
			y =  (int) - (mMovementV.getVMove() * mYMultiplier);
			//changeY = true;
			//keyB = false;
		}
		if(mMovementV.getDirectionUD() == MovementValues.KEY_DOWN) {
			y =  (int) + (mMovementV.getVMove() * mYMultiplier);
			//changeY = true;
			//keyB = false;
		}
		

	}
	
	public int pointToBlockNum(int x, int y) {
		int mNewX, mNewY;
		mNewX = x / 8;
		mNewY = y / 8;
		return mGameV.getObjectsCell(mNewX, mNewY);
	}
	
	@Override
	public void onDrawFrame(GL10 gl) {
		//TODO Auto-generated method stub
		//Log.e("tag", " code " + mGameV.getDisplayHeight());
		//this.JNIcopyToTexture();
		this.JNIdraw();
		
//		gl.glClear(gl.GL_COLOR_BUFFER_BIT | gl.GL_DEPTH_BUFFER_BIT);
//		
//		float vertices[] = {
//			      -1.0f,  1.0f, 0.0f,  // 0, Top Left
//			      -1.0f, -1.0f, 0.0f,  // 1, Bottom Left
//			       1.0f, -1.0f, 0.0f,  // 2, Bottom Right
//			       1.0f,  1.0f, 0.0f,  // 3, Top Right
//			};
//			ByteBuffer vbb = ByteBuffer.allocateDirect(vertices.length * 4	);
//			vbb.order(ByteOrder.nativeOrder());
//			FloatBuffer vertexBuffer = vbb.asFloatBuffer();
//			vertexBuffer.put(vertices);
//			vertexBuffer.position(0);
//			
//			short indices[] = { 0, 1, 2, 0, 2, 3 };
//
//			ByteBuffer ibb = ByteBuffer.allocateDirect(indices.length * 2);
//			ibb.order(ByteOrder.nativeOrder());
//			ShortBuffer indexBuffer = ibb.asShortBuffer();
//			indexBuffer.put(indices);
//			indexBuffer.position(0);
//			
//			gl.glColor4f(0.5f, 0.5f, 1.0f, 1.0f);
//
//			//glVertexPointer(3, GL_FLOAT, 0, vertices);
//			gl.glFrontFace(gl.GL_CCW);
//			gl.glEnable(gl.GL_CULL_FACE);
//			gl.glCullFace(gl.GL_BACK);
//			gl.glEnableClientState(gl.GL_VERTEX_ARRAY);
//			
//			gl.glVertexPointer(3, gl.GL_FLOAT, 0, vertexBuffer);
//			gl.glDrawElements( gl.GL_TRIANGLES, 6, gl.GL_UNSIGNED_SHORT, indexBuffer);
//
//			gl.glDisableClientState(gl.GL_VERTEX_ARRAY);
//			gl.glDisable(gl.GL_CULL_FACE);
//
//			gl.glLoadIdentity();
//			gl.glTranslatef(0, 0, -4);

			
			//gl.glColor4f(0.5f, 0.5f, 1.0f, 1.0f);
			
			//gl.glClearColor(1.0f, 0.0f, 0.0f, 0.0f);
			//gl.glClear(gl.GL_COLOR_BUFFER_BIT);
	}


	@Override
	public void onSurfaceChanged(GL10 gl, int width, int height) {
		//TODO Auto-generated method stub
		//this.JNIdestroy();
		this.JNIresize(width, height);
		//this.JNIinit(width, height);
//		gl.glViewport(0, 0, width, height);
//		gl.glMatrixMode(gl.GL_PROJECTION);
//		gl.glLoadIdentity();
//		GLU.gluPerspective(gl, 45.0f, (float) width/ (float) height, 
//				0.1f, 100.0f);
//		gl.glMatrixMode(gl.GL_MODELVIEW);
//		gl.glLoadIdentity();
	}


	@Override
	public void onSurfaceCreated(GL10 gl, EGLConfig config) {
		//TODO Auto-generated method stub
		this.JNIdestroy();
		this.JNIinit();
		
		if (!mGameV.isUseSavedBundle()) {
			mGameV.getHandler().sendEmptyMessage(GameStart.STARTLEVEL);

		 //mHandler.sendEmptyMessage(GameStart.STARTLEVEL);
	    }
	    else {
	    	mGameV.getHandler().sendEmptyMessage(GameStart.REORIENTATION);
	    }
//		gl.glShadeModel(gl.GL_SMOOTH);
//		gl.glClearDepthf(1.0f);
//		gl.glEnable(gl.GL_DEPTH_TEST);
//		gl.glDepthFunc(gl.GL_LEQUAL);
//		gl.glHint(gl.GL_PERSPECTIVE_CORRECTION_HINT, gl.GL_NICEST);


		
	}


	public DetectionPattern makeDetectionPattern(int type, int cheat){
		DetectionPattern mTemp = new DetectionPattern();
		mTemp.setType(type);
		SpriteInfo mSprite = mGameV.getSprite(0);
		
		int mTestCenterX = mSprite.getMapPosX() + (mSprite.getLeftBB() + mSprite.getRightBB()) / 2;
		int mTestBelowY = mSprite.getMapPosY() + mSprite.getBottomBB() + cheat;
		int mTestAboveY = mSprite.getMapPosY() + mSprite.getTopBB() - cheat;
		
		int mTestLowerY = mSprite.getMapPosY() + mSprite.getBottomBB() - cheat;
		int mTestUpperY = mSprite.getMapPosY() + mSprite.getTopBB() + cheat;
		int mTestRightX = mSprite.getMapPosX() + mSprite.getRightBB() + cheat;
		int mTestLeftX = mSprite.getMapPosX() + mSprite.getLeftBB() - cheat;
		
		if (pointToBlockNum(mTestCenterX, mTestAboveY) == type) mTemp.setTop(true);
		
		if (pointToBlockNum(mTestCenterX - 2, mTestBelowY) == type
			|| pointToBlockNum(mTestCenterX + 2, mTestBelowY) == type) {
			mTemp.setBottom(true);
		}
		
		if (pointToBlockNum(mTestLeftX, mTestUpperY) == type) mTemp.setUpperLeft(true);
		if (pointToBlockNum(mTestLeftX, mTestLowerY) == type) mTemp.setLowerLeft(true);
		
		if (pointToBlockNum(mTestRightX, mTestUpperY) == type) mTemp.setUpperRight(true);
		if (pointToBlockNum(mTestRightX, mTestLowerY) == type) mTemp.setLowerRight(true);
		
		if (type == mGameV.mBlock) {
			
			if (mSprite.getMapPosX() + mSprite.getRightBB() + cheat > mGameV.getMapH() * 8) {
				mTemp.setUpperRight(true);
				mTemp.setLowerRight(true);
			}
			if (mSprite.getMapPosX() + mSprite.getLeftBB() - cheat < 0) {
				mTemp.setLowerLeft(true);
				mTemp.setUpperLeft(true);
			}
			if (mSprite.getMapPosY() + mSprite.getBottomBB() + cheat > mGameV.getMapV() * 8) {
				mTemp.setBottom(true);
				
			}
			if (mSprite.getMapPosY() + mSprite.getTopBB() - cheat < 0 ) {
				mTemp.setTop(true);
			}
			
		}
		
		return mTemp;
	}
	
	/* query the jni for sprite info used for Bundle */
	public void updateSpriteList() {
		for (int x = 0; x < mGameV.getSpriteListSize() - 1; x ++) {
			if(this.getSpriteFacingRight(x) == 1) mGameV.getSprite(x + 1).setFacingRight(true);
			else mGameV.getSprite(x + 1).setFacingRight(false);
		}
	}
	
	/* strictly JNI oriented */
	public void playSounds() {
		if(getSoundOw() == 1) {
			mSounds.playSound(SoundPoolManager.SOUND_OW);
			//Log.e("Play-Sound", "OW");
		}
		if(getSoundPrize() == 1) {
			mSounds.playSound(SoundPoolManager.SOUND_PRIZE);
		}
		if(getSoundBoom() == 1) {
			mSounds.playSound(SoundPoolManager.SOUND_BOOM);
			//Log.e("Play-Sound","BOOM");
		}
	}
	
	
	public void addMonstersJNI() {
		for (int i = mGameV.getMonsterOffset(); i <= mGameV.getMonsterNum()  ; i ++) {
			SpriteInfo temp = mGameV.getSprite(i);
			addMonster(temp.getMapPosX(), temp.getMapPosY(), temp.getAnimIndex());

		}
	}
	
	public void addPlatformsJNI() {
		if (mGameV.getPlatformNum() == -1) return;
		for (int i = mGameV.getPlatformOffset() ; i <=  mGameV.getPlatformNum() ; i ++) {
			SpriteInfo temp = mGameV.getSprite(i);
			addPlatform(temp.getMapPosX(), temp.getMapPosY());

		}
	}
	public native void setLevelData( int [] a_map, int [] b_map,int width, int height);
	public native void setObjectsDisplay(int map_x, int map_y, int value);
	public native void setGuyData(int [] a, int [] b, int [] c, int [] d);
	public native void setMonsterData(int [] a, int [] b, int [] c, int [] d);
	public native void setMovingPlatformData(int []a);
	public native void inactivateMonster(int num);
	public native void setTileMapData( int [] a, int [] b, int [] c, int [] d);
	public native void addMonster(int map_x, int map_y, int animate_index);
	public native void addPlatform(int map_x, int map_y);
	public native void setGuyPosition(int x, int y, int scrollx, int scrolly, int animate);
	public native void setScoreLives(int score, int lives);
    public native void setMonsterPreferences(int monsters, int collision);
    public native void setJNIAnimateOnly(int animate);
    public native void setScreenData(int screenH, int screenV);
	public native void drawLevel(int num);
	public native int getSoundBoom();
	public native int getSoundOw();
	public native int getSoundPrize();
	public native int getEndLevel();
	public native int getScore();
	public native int getLives();
	public native void incrementJniScore(int num);
	public native int getSpriteX(int num);
	public native int getSpriteY(int num);
	public native int getSpriteFacingRight(int num);
	public native int setJNIScroll(int x, int y);
	//opengl native methods
	public native void JNIinit();
	public native void JNIdraw();
	public native void JNIdestroy();
	public native void JNIresize(int w, int h);
	static {
		System.loadLibrary("awesomeguy");
	}
	
	
	
}

class PanelGLSurfaceView extends GLSurfaceView {
	Panel mPanel; // this is our renderer!!
	
    public PanelGLSurfaceView(Context context,  GameValues gameValues, GameStart parent, MovementValues movementValues) {
        super(context);
        mPanel = new Panel(context, gameValues, parent, movementValues);
        setRenderer(mPanel);
    }

    public boolean onTouchEvent(final MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            //nativePause();
        }
        return true;
    }

    public Panel getPanel() {
    	return mPanel;
    }

}