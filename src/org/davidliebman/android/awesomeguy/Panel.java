package org.davidliebman.android.awesomeguy;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.view.*;
import android.util.Log;
import android.graphics.*;

public  class Panel  extends SurfaceView  {
	private GameValues mGameV;
	private Canvas mCanvas;

	private TileCutter mTiles;
	private MovementValues mMovementV;
	private Record mHighScores;
	private int mDisplayWidth;
	private Matrix mMatrix;
	
	private int mScore;
	private int mLives;
	//private int message = 0;
	private int scrollX, scrollY;
	private int baseX, baseY;
	private int guyX = 0;
	private int guyY = 0;
	private Bitmap  mMap, mTempJNI;
	private BitmapFactory.Options mOptionsSprite = new BitmapFactory.Options();
	private BitmapFactory.Options mOptionsTile = new BitmapFactory.Options();
	private BitmapFactory.Options mOptionsNum = new BitmapFactory.Options();
	private BitmapFactory.Options mOptionsPlat = new BitmapFactory.Options();

	
	private int mTemp;
	private SpriteInfo mGuySprite;
	private Paint mP;
	private int mMapcheat = 1;
	private boolean useJNI = true;
	private boolean useSpecialCollision = false;
	private int mScale = 2;

	/* for direction checking */
	private boolean changeX = false;
	private boolean changeY = false;

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
	
	public Panel(Context context,  GameValues gameValues, GameStart parent, MovementValues movementValues, Record highScores, int displayWidth) {
		super(context);
		this.setWillNotDraw(false);
		
		mGameV = gameValues;
		mMovementV = movementValues;

		mGameV.setSpriteStart();
		mGuySprite = mGameV.getSpriteStart();

		/* display width considerations */
		if ( displayWidth < 256 * 2 ) {
			mDisplayWidth = displayWidth;
		}
		else {
			mDisplayWidth = 256 * 2;
		}
		
		if (!mGameV.isDoubleScreen()) {
			mScale = 1;
			mDisplayWidth = 256;
		}

		/* paint options BitmapFactory.Options */
		mOptionsSprite.inScaled = false;
		mOptionsSprite.outHeight = 16;
		mOptionsSprite.outWidth = 16;
		
		mOptionsTile.inScaled = false;
		mOptionsTile.outHeight = 128;
		mOptionsTile.outWidth = 224;
		mOptionsTile.inDensity = 0;
		mOptionsTile.inTargetDensity = 0;
		
		mOptionsNum.inScaled = false;
		mOptionsNum.outHeight = 16;//16
		mOptionsNum.outWidth = 160;// 160
		mOptionsNum.inDensity = 0;//0
		mOptionsNum.inTargetDensity = 0;//0
		
		mOptionsPlat.inScaled = false;
		mOptionsPlat.outHeight = 16;//16
		mOptionsPlat.outWidth = 160;// 160
		mOptionsPlat.inDensity = 0;//0
		mOptionsPlat.inTargetDensity = 0;//0
		
		mP = new Paint();
		mP.setAlpha(0xff);
		mMatrix = new Matrix();
		mMatrix.setScale(mScale, mScale);

		scrollX = mMovementV.getScrollX();
		scrollY = mMovementV.getScrollY();
		
		/*animation vars*/
		animate = 0;
		newGuy = 0;
		lastGuy = 0;
		newBG = 0;
		lastBG = 0;

		mHighScores = highScores;//parent.getHighScores();//mGameV.getGuyScore();
		mSounds = new SoundPoolManager(parent);
		mSounds.init();
		
		/* prepare jni -- load all images into library */
		int [] a = new int[16*16];
		int [] b = new int[16*16];
		int [] c = new int[16*16];
		int [] d = new int[16*16];

		Bitmap mSprite;
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy0, mOptionsSprite);
		mSprite.getPixels(a, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy1, mOptionsSprite);
		mSprite.getPixels(b, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy2, mOptionsSprite);
		mSprite.getPixels(c, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy3, mOptionsSprite);
		mSprite.getPixels(d, 0, 16, 0, 0, 16, 16);
		setGuyData(a, b, c, d);

		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_r0, mOptionsSprite);
		mSprite.getPixels(a, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_r1, mOptionsSprite);
		mSprite.getPixels(b, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_l0, mOptionsSprite);
		mSprite.getPixels(c, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_l1, mOptionsSprite);
		mSprite.getPixels(d, 0, 16, 0, 0, 16, 16);
		setMonsterData(a, b, c, d);

		int [] tiles_a = new int [128 * 224];
		int [] tiles_b = new int [128 * 224];
		int [] tiles_c = new int [128 * 224];
		int [] tiles_d = new int [128 * 224];

		Bitmap mTiles;
		mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles1, mOptionsTile);
		mTiles.getPixels(tiles_a, 0, 224, 0, 0, 224, 128);
		mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles2, mOptionsTile);
		mTiles.getPixels(tiles_b, 0, 224, 0, 0, 224, 128);
		mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles3, mOptionsTile);
		mTiles.getPixels(tiles_c, 0, 224, 0, 0, 224, 128);
		mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles4, mOptionsTile);
		mTiles.getPixels(tiles_d, 0, 224, 0, 0, 224, 128);
		this.setTileMapData(tiles_a, tiles_b, tiles_c, tiles_d);
		
		int [] platform_a = new int [8 * 40];
		Bitmap mPlatform;
		mPlatform = BitmapFactory.decodeResource(getResources(), R.drawable.concrete, mOptionsPlat);
		mPlatform.getPixels(platform_a, 0, 40, 0, 0, 40, 8);
		this.setMovingPlatformData(platform_a);
		
		/* JNI display size setting */
		mGameV.setDisplayWidth(mDisplayWidth);
		setScreenData(mGameV.getScreenTilesHMod(), 24);
		
		/* JNI Monster Collision setting */
		int monsters = 0;
		int collision = 0;
		if(mHighScores.isEnableMonsters()) monsters = 1;
		if(mHighScores.isEnableCollision()) collision = 1;
		setMonsterPreferences(monsters, collision);
		
	}


	@Override
	public void onDraw(Canvas canvas) {
		mCanvas = canvas;
		
		this.setScoreLives(mGameV.getScore(), mGameV.getLives());
		
		checkRegularCollisions();

		checkPhysicsAdjustments();
		
		scrollBg(); //always call this last!!

		/** animate items **/
		animateItems();

		/******* draw background  *********/
		mCanvas.drawColor(Color.BLACK);
		
		/************** test jni *******************/
		mMap = Bitmap.createBitmap(drawLevel(newBG + 1), 256, 192, Bitmap.Config.RGB_565);
		mTempJNI = Bitmap.createBitmap(mMap, 0, 0, 256, 192, mMatrix, false);
		canvas.drawBitmap(mTempJNI, 0, 0, null);
		playSounds();
		
		
		
		/* at end of level */
		if(getEndLevel() == 1) {
			mGameV.setEndLevel(true);
			mGameV.decrementLives();
			mGameV.setGameDeath(true);
		}
		
		/* changes during level */
		mHighScores.setLives(getLives());
		mHighScores.setScore(getScore());
		mGameV.setScore(getScore());
		
	}

	public void setInitialBackgroundGraphics() {
		/*** set initial scroll positions ***/

		scrollX = mMovementV.getScrollX();
		scrollY = mMovementV.getScrollY();

		/*** Load sprites for level ***/
		mGameV.setSpriteStart();
		mGuySprite = mGameV.getSpriteStart();
		mGameV.adjustSpriteStartPos();
		guyX = mGuySprite.getMapPosX();
		guyY = mGuySprite.getMapPosY();
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

	
	private void animateItems() {

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
	
	
	
	
	private void checkPhysicsAdjustments() {

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

		
		
		
		
		int center = ((guyBox.getLeft() + guyBox.getRight() ) / 2) /8; 
		int actual = ((guyBox.getLeft() + guyBox.getRight() ) / 2) - (center *8);
		int centerBlock = BoundingBox.getCenterBlock(guyBox);
		//if (center == centerBlock) centerTest = true;


		/* BLOCK TEST */
		if (!this.useSpecialCollision) {
			if (actual > 6) {
				if(!boundaryRight) center ++;
				collisionWithBlocks(   center , END);
			}
			else if (actual < 2) {
				if(!boundaryLeft) center --;
				collisionWithBlocks(   center , START);
			}
			else {
				collisionWithBlocks(   center , MIDDLE);
			}
		}
		
		

		
		/* PLATFORMS */
		canJump = collisionWithPlatforms( canFall);
		
		
		/* JUMP */
		if (keyB) {

			if ( jumptime <= 0 && y == 0 && actual >= 2 && actual <= 6 &&
					(mGameV.getObjectsCellReversed(mapY/8 -1, centerBlock) != mGameV.mBlock  ||
							mGameV.getObjectsCellReversed(mapY/8 - 1, centerBlock) != mGameV.mBlock) && // mapX/8 + 1 
							(mGameV.getObjectsCellReversed(mapY/8 + 2, centerBlock) == mGameV.mBlock || // mapX/8 + 1 
									ladderTest || guyBox.getBottom() == mGameV.getMapV() * 8 || canJump) ) {

				jumptime = mMovementV.getVMove() * jumpHeight;

			} 
			else  if ( jumptime <= 0 && y == 0 && actual > 6 &&
					(mGameV.getObjectsCellReversed(mapY/8 -1,centerBlock + 1) != mGameV.mBlock ||
							mGameV.getObjectsCellReversed(mapY/8 -1,centerBlock + 1) != mGameV.mBlock) && // mapX/8 + 1 
							(mGameV.getObjectsCellReversed(mapY/8 + 2,centerBlock + 1) == mGameV.mBlock || // mapX/8 + 1 
									ladderTest || guyBox.getBottom() == mGameV.getMapV() * 8 || canJump) ) {

				jumptime = mMovementV.getVMove() * jumpHeight;

			} 
			else if ( jumptime <= 0 && y == 0 && actual < 2 &&
					(mGameV.getObjectsCellReversed(mapY/8 -1,centerBlock - 1) != mGameV.mBlock ||
							mGameV.getObjectsCellReversed(mapY/8 -1,centerBlock -1) != mGameV.mBlock) && // mapX/8 + 1 
							(mGameV.getObjectsCellReversed(mapY/8 + 2,centerBlock - 1) == mGameV.mBlock || // mapX/8 + 1 
									ladderTest || guyBox.getBottom() == mGameV.getMapV() * 8 || canJump) ) {

				jumptime = mMovementV.getVMove() * jumpHeight;

			} 
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

	private boolean collisionWithBlocks(  int centerBlock , int boundaryTest) {
		int i;
		int below = 2;
		int mapY = mGuySprite.getMapPosY();
		i = mapY / 8;
		if (mapY - (i *8) > 4) below --;
		boolean keyLeft = false;
		boolean keyRight = false;
		//boolean keyUp = false;
		boolean keyDown = false;

		/* these are shortcuts for commonly used values in this function */
		int centerBlockIm1 = mGameV.getObjectsCellReversed(i-1, centerBlock); // i minus 1
		int centerBlockI = mGameV.getObjectsCellReversed(i, centerBlock);     // i
		int centerBlockIp1 = mGameV.getObjectsCellReversed(i+1, centerBlock); // i plus 1
		int centerBlockIp2 = mGameV.getObjectsCellReversed(i+2, centerBlock); // i plus 2
		int centerBlockIpBelow = mGameV.getObjectsCellReversed(i+below, centerBlock); // i plus below

		if (mMovementV.getDirectionLR() == MovementValues.KEY_LEFT) keyLeft = true;
		if (mMovementV.getDirectionLR() == MovementValues.KEY_RIGHT) keyRight = true;
		if (mMovementV.getDirectionUD() == MovementValues.KEY_DOWN) keyDown = true;
		//if (mMovementV.getDirectionUD() == MovementValues.KEY_UP) keyUp = true;



		//what if centerBlock is on the boundary??
		if(centerBlock == mGameV.getMapH()) {
			//y = 0;
			canFall = false;
			return false;
		}


		if(keyDown ) { // regular falling ... don't adjust y in case of ladders.
			canFall = false;

		}


		if (// boundaryTest == MIDDLE &&
				centerBlockIm1 != mGameV.mLadder && ladderTest == false) { 
			// ladder above?
			if (y > 0 ) y = 0;
			canFall = false;
		}
		if (keyDown && ladderTest && 
				centerBlockIp2 == mGameV.mBlock) { // bottom of ladder?
			// don't go through floor!
			y =0;
			canFall = false;
		}

		if (jumptime > 0 && 
				centerBlockI == mGameV.mBlock ){    // hit block from below
			//y = V_MOVE * 2;
			y = 0;
			canFall = true;
			jumptime =0;
		}

		// wall at RIGHT
		if (keyRight && boundaryTest == END && 
				centerBlockIp2 != mGameV.mBlock &&   // not on ground
				(
						centerBlockI== mGameV.mBlock ||      // one block to the right
						centerBlockIp1== mGameV.mBlock )) {   // or another block to the right
			canFall = true;
			x =  0;

		}
		// wall at RIGHT and hanging
		if (  boundaryTest == END && mGameV.getObjectsCellReversed(i+2,centerBlock-1) != mGameV.mBlock 
				&& !ladderTest &&  // not on ground
				(
						centerBlockI == mGameV.mBlock ||      // one block to the right
						centerBlockIp1 == mGameV.mBlock )) {   // or another block to the right
			canFall = true;
			x =  0;

		}
		// wall at RIGHT on ground
		if (keyRight && boundaryTest == END && 
				centerBlockIp2 == mGameV.mBlock&& // on ground 
				centerBlockI == mGameV.mBlock) {     // block to the right // j + 2
			x = 0;
		}
		
		// wall at LEFT
		if (keyLeft && boundaryTest == START && 
				centerBlockIp2 != mGameV.mBlock && 
				// not on ground
				(
						centerBlockI == mGameV.mBlock ||      // one block to the left
						centerBlockIp1 == mGameV.mBlock)){ // or another block to the left
			canFall = true;
			x = 0;//- H_MOVE;
		}
		// wall at LEFT and hanging
		if (  boundaryTest == START && mGameV.getObjectsCellReversed(i+2,centerBlock+1) != mGameV.mBlock 
				&& !ladderTest &&   // not on ground
				(
						centerBlockI == mGameV.mBlock ||      // one block to the right
						centerBlockIp1 == mGameV.mBlock )) {   // or another block to the right
			canFall = true;
			x =  0;

		}
		// wall at LEFT on ground
		if (keyLeft && boundaryTest == START && 
				centerBlockIp2 == mGameV.mBlock &&  // on ground
				centerBlockI == mGameV.mBlock) {    // block to the left
			x = 0;//- H_MOVE;
		}
		// skip RIGHT
		if(keyRight  && 
				centerBlockIp1 == mGameV.mBlock && 
				centerBlockI != mGameV.mBlock && 
				centerBlockIm1 != mGameV.mBlock ) { //y,x
			canFall = false;
			y = - (8 +  mMovementV.getVMove());
		}
		else if(keyRight && 
				centerBlockIp1 == mGameV.mBlock) { //hit block from side
			x = 0;

		}

		// skip LEFT
		if(keyLeft && 
				centerBlockIp1 == mGameV.mBlock && 
				centerBlockI != mGameV.mBlock &&
				centerBlockIm1 != mGameV.mBlock) {// j-1 j-1
			canFall = false;
			y = - (8 + mMovementV.getVMove());
		}
		else if(keyLeft && 
				centerBlockIp1 == mGameV.mBlock ) { // hit block from side
			x = 0;
		}

		// no hanging
		if( 
				centerBlockIp1 != mGameV.mBlock && 
				centerBlockIp2 != mGameV.mBlock && 
				centerBlockIm1== mGameV.mBlock && !ladderTest) { 
			// no hanging from
			// blocks by accident
			Log.v("functions","no hanging");

			y = mMovementV.getVMove() ;//crucial?

			canFall = true;
			jumptime =0;
		}

		if(keyRight && 
				centerBlockI== mGameV.mBlock && 
				centerBlockIp1 == mGameV.mBlock && 
				!ladderTest && boundaryTest == END) {                                         // hit wall
			// no hanging from
			// blocks by accident
			x = 0 ;
			canFall = true;

		}
		if(keyLeft && 
				centerBlockI == mGameV.mBlock && 
				centerBlockIp1 == mGameV.mBlock && 
				!ladderTest && boundaryTest == START) {                                       // hit wall
			// no hanging from
			// blocks by accident
			x = 0 ;
			canFall = true;

		}

		if (jumptime <= 0 && //boundaryTest == MIDDLE && 
				centerBlockIpBelow == mGameV.mBlock || 
				centerBlockIpBelow == mGameV.mLadder

		) { // i + 2
			// if no space below, then don't fall.
			//y = V_MOVE;
			canFall = false;
		}
		if (jumptime <= 0 // && boundaryTest == MIDDLE 
				&& 
				centerBlockIpBelow != mGameV.mBlock && 
				centerBlockIpBelow != mGameV.mLadder
		){ // i + 2
			// if space below, then fall.
			//y = V_MOVE;
			canFall = true;
		}

		//if no space above and guy is rising
		if ((y < 0 && boundaryTest == MIDDLE && 
				centerBlockIm1 == mGameV.mBlock) || 
				(y < 0 && 
						mGameV.getObjectsCellReversed(i-1,centerBlock+1) == mGameV.mBlock
						&& boundaryTest == MIDDLE)) {

			if (!ladderTest) y = 0;
		}
		//guy shouldn't sink at boundary of level
		if (this.boundaryTest &&  
				centerBlockIp2 == mGameV.mBlock) {
			y = 0;

		}
		//ladders should work - no sliding at top of ladder
		if (ladderTest) {
			canFall = false;
		}
		// if you start to fall, and there's a ladder below you
		// you should stop falling
		if (!keyDown && ladderTest) {
			if(y > 0) y = 0;
		}
		
		
		
		return canFall;
	}
	
	
	private boolean collisionWithPlatforms(boolean canFall) {
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

	private void scrollBg() {
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
			tilesMeasurement = ((this.mDisplayWidth / 2 ) / 8) ;
			this.mScreenW = tilesMeasurement * 8;
			//if (tilesMeasurement * 16 < this.mDisplayWidth) tilesMeasurement ++;
		}
		else {
			this.mScreenW = this.mDisplayWidth;
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
		
		mGuySprite.setMapPosX(newMapX);
		mGuySprite.setMapPosY(newMapY);
		
		mMovementV.setScrollX(screenX);
		mMovementV.setScrollY(screenY);
	}
	private void checkRegularCollisions() {

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
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mDeath ) {

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

		changeX = false;
		changeY = false;

		if(mMovementV.getDirectionLR() == MovementValues.KEY_RIGHT) {

			x =  (int) + (mMovementV.getHMove() * mXMultiplier);
			changeX = true;
			//keyB = false;
		}
		if(mMovementV.getDirectionLR() == MovementValues.KEY_LEFT) {
			x =   (int) - (mMovementV.getHMove() * mXMultiplier);
			changeX = true;
			//keyB = false;
		}
		if(mMovementV.getDirectionUD() == MovementValues.KEY_UP) {
			y =  (int) - (mMovementV.getVMove() * mYMultiplier);
			changeY = true;
			//keyB = false;
		}
		if(mMovementV.getDirectionUD() == MovementValues.KEY_DOWN) {
			y =  (int) + (mMovementV.getVMove() * mYMultiplier);
			changeY = true;
			//keyB = false;
		}
		/*
    	if(mMovementV.getLetterKeyB() == MovementValues.KEY_B) {
    		keyB = true;
    	}
		 */

	}

	/* strictly JNI oriented */
	public void playSounds() {
		if(getSoundOw() == 1) {
			mSounds.playSound(SoundPoolManager.SOUND_OW);
			Log.e("Play-Sound", "OW");
		}
		if(getSoundPrize() == 1) {
			mSounds.playSound(SoundPoolManager.SOUND_PRIZE);
		}
		if(getSoundBoom() == 1) {
			mSounds.playSound(SoundPoolManager.SOUND_BOOM);
			Log.e("Play-Sound","BOOM");
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
    public native void setScreenData(int screenH, int screenV);
	public native int[] drawLevel(int num);
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
	static {
		System.loadLibrary("awesomeguy");
	}
}
