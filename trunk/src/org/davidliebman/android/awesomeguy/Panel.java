package org.davidliebman.android.awesomeguy;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.view.*;
import android.util.Log;
import android.graphics.*;

public  class Panel  extends SurfaceView  {
	private GameValues mGameV;
	private Canvas mCanvas;
	
	private TileCutter mTiles;
	private MovementValues mMovementV;
	private Scores.Record mHighScores;
	private GameLoopFunctions mGameFunct;
	
	private int message = 0;
	private int scrollX, scrollY;
	private int baseX, baseY;
	private int guyX = 0;
	private int guyY = 0;
	private Bitmap mBlock, bMap, bMapNum , mGuyBitmap;
	private int mTemp;
	private SpriteInfo mGuySprite;
	private Paint mP;
	private int mMapcheat = 1;
	
	/* animation vars */
	private static int ANIMATE_SPEED = 0;
	private int animate, newGuy, newBG, lastGuy, lastBG;
	
	/* test jni */
	int [] screen = new int [192 * 256];
	SoundPoolManager mSound;
	
	public Panel(Context context,  GameValues gameValues, GameStart parent, MovementValues movementValues) {
		super(context);
		this.setWillNotDraw(false);
		
		mGameV = gameValues;
		mMovementV = movementValues;
		mGameFunct = new GameLoopFunctions(mGameV, parent, mMovementV, this); 
		
		mGameV.setSpriteStart();
    	mGuySprite = mGameV.getSpriteStart();
		mGameFunct.setGuySprite(mGuySprite);

		mP = new Paint();
		mP.setAlpha(0xff);
		
		scrollX = mMovementV.getScrollX();
		scrollY = mMovementV.getScrollY();
		bMap = BitmapFactory.decodeResource(getResources(),R.drawable.tiles1);
		bMapNum = BitmapFactory.decodeResource(getResources(), R.drawable.tiles99alpha);
		
		/*animation vars*/
		animate = 0;
		newGuy = 0;
		lastGuy = 0;
		newBG = 0;
		lastBG = 0;
		
		/* test jni */
		mSound = new SoundPoolManager(parent);
		mSound.init();
		
		int [] a = new int[16*16];
		int [] b = new int[16*16];
		int [] c = new int[16*16];
		int [] d = new int[16*16];
		
		Bitmap mSprite;
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy0);
		mSprite.getPixels(a, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy1);
		mSprite.getPixels(b, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy2);
		mSprite.getPixels(c, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.guy3);
		mSprite.getPixels(d, 0, 16, 0, 0, 16, 16);
        setGuyData(a, b, c, d);
        
        mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_r0);
		mSprite.getPixels(a, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_r1);
		mSprite.getPixels(b, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_l0);
		mSprite.getPixels(c, 0, 16, 0, 0, 16, 16);
		mSprite = BitmapFactory.decodeResource(getResources(),R.drawable.monster_l1);
		mSprite.getPixels(d, 0, 16, 0, 0, 16, 16);
        setMonsterData(a, b, c, d);
        
        int [] tiles_a = new int [128 * 224];
        int [] tiles_b = new int [128 * 224];
        int [] tiles_c = new int [128 * 224];
        int [] tiles_d = new int [128 * 224];
        
        Bitmap mTiles;
        mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles1);
        mTiles.getPixels(tiles_a, 0, 224, 0, 0, 224, 128);
        mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles2);
        mTiles.getPixels(tiles_b, 0, 224, 0, 0, 224, 128);
        mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles3);
        mTiles.getPixels(tiles_c, 0, 224, 0, 0, 224, 128);
        mTiles = BitmapFactory.decodeResource(getResources(), R.drawable.tiles4);
        mTiles.getPixels(tiles_d, 0, 224, 0, 0, 224, 128);
        this.setTileMapData(tiles_a, tiles_b, tiles_c, tiles_d);
        
	}
	

    @Override
    public void onDraw(Canvas canvas) {
    	mCanvas = canvas;
    	
    	if(message != GameStart.SPLASH ) {
    		    		
	    	mGameFunct.checkRegularCollisions();

	    	mGameFunct.physicsAdjustments();
	    	
	    	//mGameFunct.collisionWithMonsters();
	    	
	    	mGameFunct.scrollBg(); //always call this last!!
	    	
    		/** animate items **/
    		animateItems();
    		
    		/******* draw background tiles  *********/
	    	mCanvas.drawColor(Color.BLACK);
	    	mTiles = new TileCutter(bMap);
	        baseX = scrollX/ mTiles.getBlockWidth();
	        baseY = scrollY/ mTiles.getBlockHeight();
    		if (false) {// test jni code <--
	    		for ( int i = baseX; i < baseX + 32 + 1; i ++ ) { //24
	
	    			for (int j = baseY; j < baseY + 24 + 1; j ++) { //32
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
    		}
    		/************** put monsters on screen ***********/
    		
    		if (false) mGameFunct.moveMonsters(mCanvas, this);
    		
    		/************ Put guy on screen **************/
    		if (false) {
    			mGuyBitmap = BitmapFactory.decodeResource(getResources(),mGuySprite.getResourceId());

    			canvas.drawBitmap(mGuyBitmap, guyX - mGuySprite.getLeftBB(), 
    				guyY - mGuySprite.getTopBB(), mP);
    		}
    		/************** test jni *******************/
    		if (true) {
    			this.setScoreLives(mGameV.getScore(), mGameV.getLives());
    			Bitmap mMap = Bitmap.createBitmap(drawLevel(newBG + 1), 256, 192, Bitmap.Config.RGB_565);
    			canvas.drawBitmap(mMap, 0, 0, null);
    			playSounds();
    		}
    		/************ put scores on screen ***********/
    		if (false) {
    			boolean mScoresOnScreen = false;
    			if(mGuySprite.getMapPosY() - mGuySprite.getTopBB() > 16) mScoresOnScreen = true;
    			drawScoreOnMain(canvas, mScoresOnScreen);
    		}
    	}
	    	
    	if(message == GameStart.MOVEMENTVALUES) {
    		// do special drawing for game values
    		// like scrolling
    		
    	}
    	if (message == GameStart.SPLASH) {
    		// draw splash screen on this panel
    		
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
    	//scrollTo(scrollX, scrollY);//jni test <---
		setGuyPosition(guyX -mGuySprite.getLeftBB() , guyY - mGuySprite.getTopBB(), scrollX, scrollY, mGuySprite.getAnimIndex());

    }
    
    public GameValues getGameValues() {
    	return mGameV;
    }
    
    public void setTilesheet(int i) {
    	if (i == 0 || i == 1 || i == 8) {
    		bMap = BitmapFactory.decodeResource(getResources(),R.drawable.tiles1);
    	}
    	else if (i == 2 || i == 4 || i == 6) {
    		bMap = BitmapFactory.decodeResource(getResources(),R.drawable.tiles2);
    	}
    	else if (i == 3 || i == 7) {
    		bMap = BitmapFactory.decodeResource(getResources(),R.drawable.tiles3);
    	}
    	else if (i == 5) {
    		bMap = BitmapFactory.decodeResource(getResources(),R.drawable.tiles4);
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
    	int topScore[] = {374,375,376,377,378,383};

    	int topLives[] = {379,380,381,378,382,383};

    	int scorePos, livesPos;
    	scorePos = 2 ;
    	livesPos = 16  ;
    	mTiles = new TileCutter(bMapNum);

    	if (show) {
    		//print SCORE:
    			for (i = 0; i < 6; i ++) {

    				mBlock = mTiles.getTile(topScore[i]);
    				canvas.drawBitmap(mBlock, (scorePos + i) * mTiles.getBlockWidth() + scrollX, (1)* mTiles.getBlockHeight() + scrollY, mP);
    				mBlock = mTiles.getTile(topScore[i] + 28);
    				canvas.drawBitmap(mBlock, (scorePos + i) * mTiles.getBlockWidth() + scrollX, (2)* mTiles.getBlockHeight() + scrollY, mP);
    			}
    			//print LEVEL:
    			for (i = 0; i < 6; i ++) {
    				mBlock = mTiles.getTile(topLives[i]);
    				canvas.drawBitmap(mBlock, (livesPos + i) * mTiles.getBlockWidth() + scrollX, (1)* mTiles.getBlockHeight() + scrollY, mP);
    				mBlock = mTiles.getTile(topLives[i] + 28);
    				canvas.drawBitmap(mBlock, (livesPos + i) * mTiles.getBlockWidth() + scrollX, (2)* mTiles.getBlockHeight() + scrollY, mP);
    			}

    			//print numbers:
    			numbersOnBg(canvas, scorePos + 6, mHighScores.mScore  , 7); // score
    			numbersOnBg(canvas, livesPos + 6, mHighScores.mSave1 , 7); // lives
    	}
    }
    private void numbersOnBg(Canvas canvas, int pos, int num, int p) { //'num' is a u32
    	int i, a, b, c, placesValue;
    	int places[] = {0,0,0,0,0,0,0,0,0,0};//ten spots
    	int topNumbers[] = {364,365,366, 367, 368, 369, 370, 371, 372, 373};
    	boolean showZeros = false;

    	mTiles = new TileCutter(bMapNum);

    	for (i = 0; i < 10; i ++) {
    		a = num - (num / 10) * 10;
    		places[9 - i] = a;
    		b = (num / 10) * 10;
    		num = b / 10;
    	}
    	c = 0;
    	for(i = 0; i < p; i ++) {
    		placesValue = places[i + (10 - p)];
    		if (showZeros || placesValue != 0) {
    			if(placesValue != 0) showZeros = true;
    			if(showZeros == true && c == 0) {
    				c = p - i;
    			}
    			mBlock = mTiles.getTile(topNumbers [ placesValue ]);
				canvas.drawBitmap(mBlock, (pos + i - p + c) * mTiles.getBlockWidth() + scrollX, (1)* mTiles.getBlockHeight() + scrollY, mP);
				mBlock = mTiles.getTile(topNumbers [ placesValue ] + 28);
				canvas.drawBitmap(mBlock, (pos + i - p + c) * mTiles.getBlockWidth() + scrollX, (2)* mTiles.getBlockHeight() + scrollY, mP);
    		}
    	}
    }

	
	public Scores.Record getHighScores() {
		return mHighScores;
	}


	public void setHighScores(Scores.Record mHighScores) {
		this.mHighScores = mHighScores;
	}
	
	/* chained setters for mGameFunct */
	public void setKeyB(boolean b) {
		this.mGameFunct.setKeyB(b);
	}
	
	public void readKeys() {
		this.mGameFunct.readKeys();
	}
	public void readKeys(double num) {
		this.mGameFunct.readKeys(num);
	}
    public void setGuySprite(SpriteInfo sprite) {
    	this.mGameFunct.setGuySprite(sprite);
    	mGuySprite = sprite;
    	
    }
    public void playSounds() {
    	if(getSoundOw() == 1) {
    		mSound.playSound(SoundPoolManager.SOUND_OW);
    		Log.e("Play-Sound", "OW");
    	}
    	if(getSoundPrize() == 1) {
    		mSound.playSound(SoundPoolManager.SOUND_PRIZE);
    	}
    	if(getSoundBoom() == 1) {
    		mSound.playSound(SoundPoolManager.SOUND_BOOM);
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
    public native int[] drawLevel(int num);
    public native int getSoundBoom();
    public native int getSoundOw();
    public native int getSoundPrize();
    public native int getEndLevel();
    public native int getScore();
    public native int getLives();
    static {
    	System.loadLibrary("awesomeguy");
    }
}
