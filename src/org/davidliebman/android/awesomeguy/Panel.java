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
	private int message = 0;
	private int scrollX, scrollY;
	private int baseX, baseY;
	private int guyX = 0;
	private int guyY = 0;
	private Bitmap mBlock, bMap, bMapNum , mGuyBitmap, mTempGuy, mMap, mTempJNI;
	private BitmapFactory.Options mOptions = new BitmapFactory.Options();
	private int mTemp;
	private SpriteInfo mGuySprite;
	private Paint mP;
	private int mMapcheat = 1;
	private boolean useJNI = true;
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
		
		/* paint options */
		mOptions.inScaled = false;
		mP = new Paint();
		mP.setAlpha(0xff);
		mMatrix = new Matrix();
		mMatrix.setScale(mScale, mScale);

		scrollX = mMovementV.getScrollX();
		scrollY = mMovementV.getScrollY();
		bMap = BitmapFactory.decodeResource(getResources(),R.drawable.tiles1, mOptions);
		bMapNum = BitmapFactory.decodeResource(getResources(), R.drawable.tilesalpha, mOptions);

		/*animation vars*/
		animate = 0;
		newGuy = 0;
		lastGuy = 0;
		newBG = 0;
		lastBG = 0;

		mHighScores = highScores;//parent.getHighScores();//mGameV.getGuyScore();
		mSounds = new SoundPoolManager(parent);
		mSounds.init();
		
		/* test jni */
		if (this.useJNI) {
			int [] a = new int[16*16];
			int [] b = new int[16*16];
			int [] c = new int[16*16];
			int [] d = new int[16*16];
	
			Bitmap mSprite;
			mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy0, mOptions);
			mSprite.getPixels(a, 0, 16, 0, 0, 16, 16);
			mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy1, mOptions);
			mSprite.getPixels(b, 0, 16, 0, 0, 16, 16);
			mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy2, mOptions);
			mSprite.getPixels(c, 0, 16, 0, 0, 16, 16);
			mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy3, mOptions);
			mSprite.getPixels(d, 0, 16, 0, 0, 16, 16);
			setGuyData(a, b, c, d);
	
			mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_r0, mOptions);
			mSprite.getPixels(a, 0, 16, 0, 0, 16, 16);
			mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_r1, mOptions);
			mSprite.getPixels(b, 0, 16, 0, 0, 16, 16);
			mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_l0, mOptions);
			mSprite.getPixels(c, 0, 16, 0, 0, 16, 16);
			mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_l1, mOptions);
			mSprite.getPixels(d, 0, 16, 0, 0, 16, 16);
			setMonsterData(a, b, c, d);
	
			int [] tiles_a = new int [128 * 224];
			int [] tiles_b = new int [128 * 224];
			int [] tiles_c = new int [128 * 224];
			int [] tiles_d = new int [128 * 224];
	
			Bitmap mTiles;
			mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles1, mOptions);
			mTiles.getPixels(tiles_a, 0, 224, 0, 0, 224, 128);
			mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles2, mOptions);
			mTiles.getPixels(tiles_b, 0, 224, 0, 0, 224, 128);
			mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles3, mOptions);
			mTiles.getPixels(tiles_c, 0, 224, 0, 0, 224, 128);
			mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles4, mOptions);
			mTiles.getPixels(tiles_d, 0, 224, 0, 0, 224, 128);
			this.setTileMapData(tiles_a, tiles_b, tiles_c, tiles_d);
			
			
		}
	}


	@Override
	public void onDraw(Canvas canvas) {
		mCanvas = canvas;

		if(message != GameStart.SPLASH ) {
			
			if (useJNI) {
				this.setScoreLives(mGameV.getScore(), mGameV.getLives());
				int monsters = 0;
				int collision = 0;
				if(mHighScores.isEnableMonsters()) monsters = 1;
				if(mHighScores.isEnableCollision()) collision = 1;
				setMonsterPreferences(monsters, collision);
			}

			checkRegularCollisions();

			physicsAdjustments();

			if(!useJNI && mHighScores.isEnableCollision()) collisionWithMonsters();

			scrollBg(); //always call this last!!

			/** animate items **/
			animateItems();

			/******* draw background tiles  *********/
			mCanvas.drawColor(Color.BLACK);
			mTiles = new TileCutter(bMap, mScale);
			baseX = scrollX/ mTiles.getBlockWidth();
			baseY = scrollY/ mTiles.getBlockHeight();
			if (!useJNI) {// test jni code <--
				for ( int i = baseX; i < baseX + 32 + 1; i ++ ) { //24

					for (int j = baseY; j < baseY + 24 + 1; j ++) { //32
						if (mGameV.getLevelCell(i, j) != 0 ) {
							//print visible background
							mTemp = mGameV.getLevelCell(i, j);
							mBlock = mTiles.getTile(mTemp);
							canvas.drawBitmap(mBlock,mScale *  i * mTiles.getBlockWidth(), mScale * j* mTiles.getBlockHeight(), null);
						}
						if (mGameV.getObjectsCell(i, j) != 0) {
							//print special background objects
							mTemp = mGameV.getObjectsCell(i, j);
							if(this.checkPrintableObjects(mTemp)) {
								mBlock = mTiles.getTile(mTemp - mMapcheat);
								canvas.drawBitmap(mBlock, mScale * i * mTiles.getBlockWidth(), mScale * j* mTiles.getBlockHeight(), null);
							}
						}

					}
				}
			}
			/************** put monsters on screen ***********/

			if (!useJNI && mHighScores.isEnableMonsters()) moveMonsters();

			/************ Put guy on screen **************/
			if (!useJNI) {
				
				mTempGuy = BitmapFactory.decodeResource(getResources(),mGuySprite.getResourceId(),mOptions);
				mGuyBitmap = Bitmap.createBitmap(this.mTempGuy, 0,0, 16,16, mMatrix, false);
				canvas.drawBitmap(mGuyBitmap, mScale * ( guyX - mGuySprite.getLeftBB()), 
						mScale * (guyY - mGuySprite.getTopBB()), mP);
			}
			/************** test jni *******************/
			if (useJNI) {
				
				mMap = Bitmap.createBitmap(drawLevel(newBG + 1), 256, 192, Bitmap.Config.RGB_565);
				mTempJNI = Bitmap.createBitmap(mMap, 0, 0, 256, 192, mMatrix, false);
				canvas.drawBitmap(mTempJNI, 0, 0, null);
				playSounds();
			}
			/************ put scores on screen ***********/
			if (!useJNI) {
				boolean mScoresOnScreen = false;
				if(mGuySprite.getMapPosY() - mGuySprite.getTopBB() > 16) mScoresOnScreen = true;
				drawScoreOnMain(canvas, mScoresOnScreen);
			}
			
			if (this.useJNI) {
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
		}

		

	}

	public void setBackgroundGraphics() {
		/*** Load background graphics array ***/

		message = GameStart.STARTLEVEL;
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
		message = GameStart.GAMEVALUES;
		mGameV = g;

	}

	public void setBackgroundShow(int num) {
		message = GameStart.SPLASH;
		int temp = num & 1;

		if(temp == 1)
			this.setBackgroundResource(R.drawable.splash2);
		if(temp == 0)
			this.setBackgroundResource(R.drawable.splash3);
	}

	public void setPanelScroll(int x, int y) {
		scrollX = x;
		scrollY = y;
		mGuySprite = mGameV.getSpriteStart();
		guyX = mGuySprite.getMapPosX();
		guyY = mGuySprite.getMapPosY();
		message = GameStart.MOVEMENTVALUES;
		if(!useJNI) {
			scrollTo( mScale * scrollX , mScale * scrollY);//jni test <---
		}
		else {
			setGuyPosition(guyX  , guyY , scrollX, scrollY, mGuySprite.getAnimIndex());

		}

	}

	public GameValues getGameValues() {
		return mGameV;
	}

	public void setTilesheet(int i) {
		if (i == 0 || i == 1 || i == 8) {
			bMap = BitmapFactory.decodeResource(getResources(),R.drawable.tiles1, mOptions);
		}
		else if (i == 2 || i == 4 || i == 6) {
			bMap = BitmapFactory.decodeResource(getResources(),R.drawable.tiles2, mOptions);
		}
		else if (i == 3 || i == 7) {
			bMap = BitmapFactory.decodeResource(getResources(),R.drawable.tiles3, mOptions);
		}
		else if (i == 5) {
			bMap = BitmapFactory.decodeResource(getResources(),R.drawable.tiles4, mOptions);
		}
	}

	public void setSwapGuy(int num) {
		
		if(num == 0) {
			this.mGuySprite.setResourceId(R.drawable.guy0);
		}
		else if (num == 1) {
			this.mGuySprite.setResourceId(R.drawable.guy1);
		}
		else if (num == 2) {
			this.mGuySprite.setResourceId(R.drawable.guy2);
		}
		else if (num == 3) {
			this.mGuySprite.setResourceId(R.drawable.guy3);
		}
		mGuySprite.setAnimIndex(num);
	}

	public void animateItems() {

		if (ANIMATE_SPEED != 0) animate ++;
		if (this.mGuySprite.getAnimate() == true) {
			//Log.v("Animation", "a " + animate);
			if (animate == ANIMATE_SPEED) {
				newGuy ++;
				newBG ++;
				animate = 0;
			}
			if (newGuy != lastGuy) {
				setSwapGuy(newGuy);
				lastGuy = newGuy;
				if(newGuy > 3) newGuy = -1;
			}
			//animate tiles
			if (newBG != lastBG) {
				setTilesheet(newBG + 1);
				lastBG = newBG;
				if(newBG > 7) newBG = -1;
			}

		} 


	}
	public boolean checkPrintableObjects(int num) {
		boolean temp = false;

		/* these are blocks that are not printed on the screen */
		if(num != mGameV.mStart && num != mGameV.mMonster && num != mGameV.mDeath
				&& num != mGameV.mPlatform && num != mGameV.mMarker && num != mGameV.mBlock
				&& num != mGameV.mLadder) {
			temp = true;
		}

		return temp;
	}
	public void drawScoreOnMain(Canvas canvas, boolean show) {

		int i;
		//int topScore[] = {374,375,376,377,378,383};
		int topScore[] = {10,11,12,13,14,19};
		//                S     c  o   r  e   :
		//int topLives[] = {379,380,381,378,382,383};
		int topLives[] = {15,16,17,14,18,19};
		//                l     i  v   e  s   :
		int scorePos, livesPos, tilesWidth;
		scorePos = 2 ;
		livesPos = 16  ;
		tilesWidth = 20;
		mTiles = new TileCutter(bMapNum, tilesWidth ,2,mScale);

		if (show) {
			//print SCORE:
			for (i = 0; i < 6; i ++) {

				mBlock = mTiles.getTile(topScore[i]);
				canvas.drawBitmap(mBlock,mScale * (scorePos + i) * mTiles.getBlockWidth() + (mScale * scrollX), mScale * (1)* mTiles.getBlockHeight() + (mScale * scrollY), mP);
				mBlock = mTiles.getTile(topScore[i] + tilesWidth);//28
				canvas.drawBitmap(mBlock,mScale * (scorePos + i) * mTiles.getBlockWidth() + (mScale * scrollX), mScale * (2)* mTiles.getBlockHeight() + (mScale * scrollY), mP);
			}
			//print LEVEL:
			for (i = 0; i < 6; i ++) {
				mBlock = mTiles.getTile(topLives[i]);
				canvas.drawBitmap(mBlock,mScale * (livesPos + i) * mTiles.getBlockWidth() + (mScale * scrollX), mScale * (1)* mTiles.getBlockHeight() + (mScale * scrollY), mP);
				mBlock = mTiles.getTile(topLives[i] + tilesWidth);//28
				canvas.drawBitmap(mBlock,mScale * (livesPos + i) * mTiles.getBlockWidth() + (mScale * scrollX), mScale * (2)* mTiles.getBlockHeight() + (mScale * scrollY), mP);
			}

			//print numbers: 
			if (useJNI) {
				numbersOnBg(canvas, scorePos + 6, mHighScores.getScore()   , 7); // score
				numbersOnBg(canvas, livesPos + 6, mHighScores.getLives()   , 7); // lives
			}
			else {
				numbersOnBg(canvas, scorePos + 6, mGameV.getScore()   , 7); // score
				numbersOnBg(canvas, livesPos + 6, mGameV.getLives()   , 7); // lives
			}
		}
	}
	
	private void numbersOnBg(Canvas canvas, int pos, int num, int p) { //'num' is a u32
		int i, a, b, c, placesValue;
		int places[] = {0,0,0,0,0,0,0,0,0,0};//ten spots
		//int topNumbers[] = {364,365,366, 367, 368, 369, 370, 371, 372, 373};
		int topNumbers[] = {0,1,2,3,4,5,6,7,8,9};
		int tilesWidth = 20;
		
		boolean showZeros = false;

		mTiles = new TileCutter(bMapNum, tilesWidth, 2,mScale);

		for (i = 0; i < 10; i ++) {
			a = num - (num / 10) * 10;
			places[9 - i] = a;
			b = (num / 10) * 10;
			num = b / 10;
		}
		c = 0;
		for(i = 0; i < p; i ++) {
			placesValue = places[i + (10 - p)];
			if ((showZeros || placesValue != 0) && placesValue >= 0 && placesValue < 10) {
				if(placesValue != 0) showZeros = true;
				if(showZeros == true && c == 0) {
					c = p - i;
				}
				mBlock = mTiles.getTile(topNumbers [ placesValue ]);
				canvas.drawBitmap(mBlock, mScale * (pos + i - p + c) * mTiles.getBlockWidth() + (mScale * scrollX), mScale * (1)* mTiles.getBlockHeight() + (mScale * scrollY), mP);
				mBlock = mTiles.getTile(topNumbers [ placesValue ] + tilesWidth);//28
				canvas.drawBitmap(mBlock, mScale * (pos + i - p + c) * mTiles.getBlockWidth() + (mScale * scrollX), mScale *(2)* mTiles.getBlockHeight() + ( mScale * scrollY), mP);
			}
		}
	}
	
	public void physicsAdjustments() {



		/* All sorts of adjustments go here. ladder, jump, gravity, 
		 * the ground, and solid objects in general.
		 */
		BoundingBox guyBox = BoundingBox.makeSpriteBox(mGuySprite,0,0);


		int jumpHeight = 15;

		int center = ((guyBox.getLeft() + guyBox.getRight() ) / 2) /8; 
		int actual = ((guyBox.getLeft() + guyBox.getRight() ) / 2) - (center *8);
		int centerBlock = BoundingBox.getCenterBlock(guyBox);
		//if (center == centerBlock) centerTest = true;


		/* LADDER TEST */
		if (ladderTest) {
			canFall = false;
			//Log.v("ladder test", "canfall = false;");

		}

		else if (y  < 0 && jumptime <= 0){
			y = 0;
			canFall = true;
		}





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




		/* BLOCK TEST */

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

		/* PLATFORMS */
		//canJump = collisionWithPlatforms( keys, canFall);

		/*
		 * handle jumps.
		 */
		if (jumptime > 0) {
			jumptime = jumptime - mMovementV.getVMove() ;
			y =  - mMovementV.getVMove();// * 2 / 3);
			//if(jumptime >  mMovementV.getVMove() * 3) x = 0;
			canFall = false;
			Log.v("functions","jumping");
		}

		/* 
		 * Here we implement the gravity.
		 */
		if(canFall && !ladderTest) {
			y = y + mMovementV.getVMove() ;

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
	public void collisionWithMonsters() {

		int i;
		BoundingBox guyBox = BoundingBox.makeSpriteBox( mGameV.getSpriteStart() , 0, 0 );

		/*** CHECK MONSTERS FOR COLLISION WITH CHARACTER ***/
		for (i = mGameV.getMonsterOffset()  ; i < mGameV.getMonsterOffset() + mGameV.getMonsterNum() ; i++) {   
			BoundingBox monsterBox = BoundingBox.makeSpriteBox(mGameV.getSprite(i) , 0, 0 );
			boolean test = guyBox.collisionSimple(monsterBox);// collisionSimple(guyBox, monsterBox);
			if (test && mGameV.getSprite(i).getActive()  == true) {

				if (guyBox.getBottom()  < monsterBox.getBottom()) {
					mGameV.getSprite(i).setActive(false);
					inactivateMonster(i );
					//sprites[i].active = false;
					mGameV.incrementScore(10);
					mSounds.playSound(SoundPoolManager.SOUND_BOOM);
					Log.e("MonsterCollision", "monster dies");


				}
				else {
					mGameV.setEndLevel(true);
					mGameV.setGameDeath(true);
					//level.endLevel = true;
					mGameV.decrementLives();
					mSounds.playSound(SoundPoolManager.SOUND_OW);

				}
			}
		}
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

		newX = mGuySprite.getX();
		newY = mGuySprite.getY();

		guyWidth = mGuySprite.getRightBB() - mGuySprite.getLeftBB(); // 12 ?
		guyHeight = mGuySprite.getBottomBB() - mGuySprite.getTopBB();

		//this.mScreenH = 24 * 8; // not used
		//this.mScreenW = 32 * 8; // 256
		
		int tilesMeasurement;

		if (mGameV.isDoubleScreen()) {
			this.mScreenW = this.mDisplayWidth / 2;
			tilesMeasurement = ((this.mDisplayWidth / 2 ) / 8) ;
			if (tilesMeasurement * 16 < this.mDisplayWidth) tilesMeasurement ++;
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
			if ((mGuySprite.getX() + x) >= (mScreenW - guyWidth) || mapX + x >= mapH * 8  - guyWidth) {
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
			if ((mGuySprite.getX() + x) <= (0) || mapX + x <= 0) {
				newMapX = 1;
				newX = 1;

			}

			if ((mapX + x) <= (oldX +( (32) * 8 ) - LR_MARGIN) ) {   //32 * 8     


				if (canScroll) {
					screenX  += x;
					newMapX += x;

				}
				else if ( mapX >= 0 ) {
					newX += x;
					newMapX += x; 

				}

			}
			else if ((mapX + x) >= (oldX + ( (32) * 8) - LR_MARGIN) &&  canScroll) { // 32 * 8
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
			if ((this.mGuySprite.getY() + y) >= (24 * 8 - guyHeight) || mapY + y >= mapV * 8  - guyHeight) {
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
			if ((this.mGuySprite.getY() + y) <= (0) || mapY + y <= 0) {
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
		mGuySprite.setX(newX);
		mGuySprite.setY(newY);

		mMovementV.setScrollX(screenX);
		mMovementV.setScrollY(screenY);
	}
	public void checkRegularCollisions() {

		/*
		 * Here we create a BoundingBox for the guy character. Then
		 * we check the level for collisions.
		 */

		//BoundingBox guyBoxNext = makeSpriteBox(guy, x, y);
		BoundingBox guyBox = BoundingBox.makeSpriteBox(mGuySprite, 0, 0 );

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
						boolean test = guyBox.collisionSimple( testMe);

						/****** tests here ******/

						/*********  block ***************/
						if (test && mGameV.getObjectsCell(j, i) == mGameV.mBlock) {
							blockTest = true;


						}
						/******** ladder **********/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mLadder) {
							ladderTest = true;
						}

						/************ GOAL ****************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mGoal ) {

							mGameV.setEndLevel(true);

							
							mGameV.setObjectsCell(j, i, 0);
							
							if(this.useJNI) { 
								setObjectsDisplay(j, i, 0);//jni
								this.incrementJniScore(100);
							}

							mGameV.incrementScore(100);
							//mmEffect(SFX_GOAL);
							mSounds.playSound(SoundPoolManager.SOUND_GOAL);

						}
						/************ goal ends ****************/
						/************* prizes ******************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mPrize ) {

							
							mGameV.setObjectsCell(j, i, 0);
							
							if(this.useJNI) {
								setObjectsDisplay(j, i, 0);//jni
								this.incrementJniScore(10);
							}

							mGameV.incrementScore(10);
							//mmEffect(SFX_PRIZE);
							mSounds.playSound(SoundPoolManager.SOUND_PRIZE);
						}

						/********** prizes end *****************/
						/************* keys   ******************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mKey ) {

							
							mGameV.setObjectsCell(j, i, 0);
							
							if (this.useJNI) {
								setObjectsDisplay(j, i, 0);//jni
								this.incrementJniScore(50);
							}

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
							
							if (this.useJNI) {
								setObjectsDisplay(j, i, 0);//jni
							}

							mSounds.playSound(SoundPoolManager.SOUND_GOAL);
							mGameV.incrementLives();
						}
						/*****************end oneup *************/
						/**************** bigprize ****************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mBigprize ) {

							
							mGameV.setObjectsCell(j, i, 0);
							
							if (this.useJNI) {
								setObjectsDisplay(j, i, 0);//jni
								this.incrementJniScore(200);
							}

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
	public void moveMonsters() {
		int i;
		int x,y,z;
		boolean markerTest = false;
		boolean hide = true;
		boolean show = false;
		boolean visibility = false;

		//for each monster...
		for (i =  mGameV.getMonsterOffset() ; i < mGameV.getMonsterOffset() + mGameV.getMonsterNum()  ; i++) {   
			markerTest = false; 
			SpriteInfo sprites = mGameV.getSprite(i);

			if (sprites.getActive() == true ) {
				x = sprites.getMapPosX() / 8;
				y = sprites.getMapPosY() / 8;
				// Must move and stop monsters when they hit bricks or
				// markers or the end of the screen/room/level.

				if(sprites.getFacingRight()) {
					//sprites[i].mapPosX += 1;
					sprites.incrementMapPosX(3);
					// marker test
					if(mGameV.getObjectsCellReversed(y, x+2) == mGameV.mBlock ) markerTest = true;
					if(mGameV.getObjectsCellReversed(y, x+2) == mGameV.mMarker ) markerTest = true;
					if(mGameV.getObjectsCellReversed(y+1, x+2) == 0) markerTest = true;
					// turn monster
					if (sprites.getMapPosX() > mGameV.getMapH() * 8  - 16 || markerTest) {
						//if (sprites[i].mapPosX > 32 * 8 * 2 - 16 || markerTest) {
						//sprites[i].facingRight = false;
						sprites.setFacingRight(false);
					}
				}
				else {
					//sprites[i].mapPosX -= 1;
					sprites.decrementMapPosX(3);
					// marker test
					if(mGameV.getObjectsCellReversed(y, x) == mGameV.mBlock) markerTest = true;
					if(mGameV.getObjectsCellReversed(y, x) == mGameV.mMarker) markerTest = true;
					if(mGameV.getObjectsCellReversed(y+1, x-1) == 0) markerTest = true;
					// turn monster
					if (sprites.getMapPosX() < 0 || markerTest) {
						//sprites[i].facingRight = true;
						sprites.setFacingRight(true);
					}
				}

				//Only show monsters that are on the screen properly


				//default is to show monster
				visibility = show;
				//hide monster
				if(sprites.getMapPosX() > mMovementV.getScrollX() + 32 * 8 + 16 ) {
					visibility = hide;
				}
				if (sprites.getMapPosX() < mMovementV.getScrollX() - 16) {
					visibility = hide;
				}
				if(sprites.getMapPosY() > mMovementV.getScrollY() + 24 * 8 + 16) {
					visibility = hide;
				}
				if ( sprites.getMapPosY() < mMovementV.getScrollY()  - 16) {
					visibility = hide;
				}
			}

			if(sprites.getActive() && visibility == show) {

				Bitmap spriteBitmap = BitmapFactory.decodeResource(this.getResources(),
						sprites.getResourceId());
				Bitmap scaledBitmap = Bitmap.createBitmap(spriteBitmap, 0,0, 16,16, mMatrix, false);

				mCanvas.drawBitmap(
						scaledBitmap, 
						mScale * sprites.getMapPosX(), 
						mScale * sprites.getMapPosY() , mP);

			}

			//swap monsters
			//sprites[i].animIndex = (sprites[i].animIndex + 1 ) ;
			sprites.incrementAnimIndex();
			if (sprites.getAnimIndex() > ANIM_SPEED * 4) sprites.setAnimIndex(0);
			if (sprites.getAnimIndex() > ANIM_SPEED * 2) z = 1;
			else z = 0;
			swapMonster( sprites , z);
		}
		//oamUpdate(&oamMain);

		return;
	}

	public void swapMonster(SpriteInfo sprites, int animationIndex) {

		boolean facingRight = sprites.getFacingRight();

		if(facingRight) {
			if(animationIndex == 0) {
				sprites.setResourceId(R.drawable.monster_r0);

			}
			else if (animationIndex == 1) {
				sprites.setResourceId(R.drawable.monster_r1);

			}
		}
		else if (!facingRight) {
			if(animationIndex == 0) {
				sprites.setResourceId(R.drawable.monster_l0);

			}
			else if (animationIndex == 1) {
				sprites.setResourceId(R.drawable.monster_l1);

			}
		}
		return;                
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
	

	public boolean isUseJNI() {
		return useJNI;
	}


	public void setUseJNI(boolean useJNI) {
		this.useJNI = useJNI;
	}


	public boolean isEnableSounds() {
		return mEnableSounds;
	}


	public void setEnableSounds(boolean mEnableSounds) {
		mEnableSounds = mEnableSounds;
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
			x =  (int) - (mMovementV.getHMove() * mXMultiplier);
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
		for (int i = mGameV.getMonsterOffset(); i < mGameV.getMonsterOffset() + mGameV.getMonsterNum(); i ++) {
			SpriteInfo temp = mGameV.getSprite(i);
			addMonster(temp.getMapPosX(), temp.getMapPosY(), temp.getAnimIndex());

		}
	}
	public native void setLevelData( int [] a_map, int [] b_map,int height, int width);
	public native void setObjectsDisplay(int map_x, int map_y, int value);
	public native void setGuyData(int [] a, int [] b, int [] c, int [] d);
	public native void setMonsterData(int [] a, int [] b, int [] c, int [] d);
	public native void inactivateMonster(int num);
	public native void setTileMapData( int [] a, int [] b, int [] c, int [] d);
	public native void addMonster(int map_x, int map_y, int animate_index);
	public native void setGuyPosition(int x, int y, int scrollx, int scrolly, int animate);
	public native void setScoreLives(int score, int lives);
    public native void setMonsterPreferences(int monsters, int collision);
	public native int[] drawLevel(int num);
	public native int getSoundBoom();
	public native int getSoundOw();
	public native int getSoundPrize();
	public native int getEndLevel();
	public native int getScore();
	public native int getLives();
	public native void incrementJniScore(int num);
	static {
		System.loadLibrary("awesomeguy");
	}
}
