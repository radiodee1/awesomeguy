package org.davidliebman.android.awesomeguy;

import java.util.ArrayList;
import java.lang.*;
import android.content.*;
import android.os.Bundle;
//import android.util.Log;


public class GameValues {
	
	/* screen dimensions in tiles */
	public static final int SCREEN_TILES_H = 32;
	public static final int SCREEN_TILES_V = 24;
	
	/* max for mapH and mapV is 96 */
	private int mMapH = 0;
	private int mMapV = 0;
	
	private int mLevel1 [][] = new int[96][96];
	private int mObjects [][] = new int [96][96];
	
	/* Special screen objects */
	public int mStart = 5;
	public int mSpace = 0;
	public int mLadder = 444;// + mapCheat;
	public int mBlock = 442;// + mapCheat;
	public int mGoal = 446;// + mapCheat;
	public int mKey = 445; // + mapCheat;
	public int mPrize =  447;// + mapCheat;
	public int mMonster = 443;// + mapCheat;
	public int mMarker = 441; // + mapCheat;
	public int mDeath = 439 ;//+ mapCheat;
	public int mOneup = 438 ;//+ mapCheat;
	public int mBigprize = 440 ;//+ mapCheat;
	public int mPlatform = 437 ; //+ mapCheat;
	
	/* screen size */
	private boolean mDoubleScreen = false;
	private int mScreenTilesHMod = this.SCREEN_TILES_H;
	private int mDisplayWidth, mDisplayHeight, mMeasuredWidth, mMeasuredHeight;
	private int mViewH, mViewW;
	
	/* screen orientation */
	public static final int ORIENTATION_LANDSCAPE = 1;
	public static final int ORIENTATION_PORTRAIT = 2;
	
	private int mScreenOrientation;
	private boolean mPutGameKeys = false;
	private float mScaleH = 1; 
	private float mScaleV = 1;
	private int mScreenTitle = 20;
	private float mLandscapeButtonPixelPercent;
	public static final float LANDSCAPE_BUTTON_PERCENT = (float).15;
	
	/* game progress */
	private Record mGuyScore = new Record();
	private int mRoom = 1;
	private boolean mEndLevel = false;
	private boolean mEndGame = false;
	private boolean mGameDeath = false;
	private int mUsernum = 4;
	//public static int NUM_ROOMS = 10;
	private int mOldGuyScore;
	//private boolean mLevelLoading;
	private int mScrollX, mScrollY;
	
	/* sprites */
	private ArrayList<SpriteInfo> mSprites = new ArrayList<SpriteInfo>();
	private int mMonsterNum, mMonsterOffset;
	private int mPlatformNum, mPlatformOffset;
	private int mBossmonsterNum, mBossmonsterOffset;
	public static final int MONSTER_TOTAL = 15;
	public static final int PLATFORM_TOTAL = 15;
	
	/* xml stuff */
	private boolean mLookForXml = false;
	private int mTotNumRooms = 10;
	private ArrayList<Integer> mXmlLevel = new ArrayList<Integer>();
	private InitBackground.LevelList mLevelList;
	private int mXmlMode = XML_USE_BOTH;
	
	/* Bundle stuff */
	public static final String BUNDLE_NUM_OF_SPRITES = new String("sprites");
	public static final String BUNDLE_SPRITES_X_ARRAY = new String("sprites_x_array");
	public static final String BUNDLE_SPRITES_Y_ARRAY = new String("sprites_y_array");
	public static final String BUNDLE_MAP_H = new String("map_h");
	public static final String BUNDLE_MAP_V = new String("map_v");
	public static final String BUNDLE_MAP_ARRAY = new String("map_array");
	public static final String BUNDLE_MONSTER_NUMBER = new String("monster_num");
	public static final String BUNDLE_MONSTER_OFFSET = new String("monster_offset");
	public static final String BUNDLE_PLATFORM_NUMBER = new String("platform_num");
	public static final String BUNDLE_PLATFORM_OFFSET = new String("platform_offset");
	public static final String BUNDLE_BOSSMONSTER_NUMBER = new String("bossmonster_num");
	public static final String BUNDLE_BOSSMONSTER_OFFSET = new String("bossmonster_offset");
	public static final String BUNDLE_INITIAL = new String("initial");
	public static final String BUNDLE_SCROLL_X = new String("scroll_x");
	public static final String BUNDLE_SCROLL_Y = new String("scroll_y");
	public static final String BUNDLE_SCORE = new String("score");
	public static final String BUNDLE_LIVES = new String("lives");
	public static final String BUNDLE_LAST_ORIENTATION = new String("orientation");
	public static final String BUNDLE_SPRITES_FACINGRIGHT_ARRAY = new String("sprites_facing_right_array");
	private Bundle mBundle = new Bundle();
	
	public static final int XML_USE_LEVEL = 0;
	public static final int XML_USE_OBJECTS = 1;
	public static final int XML_USE_BOTH = 2;
	
	/* first part of screen size and orientation stuff */
	
	public int getMeasuredWidth() {
		return mMeasuredWidth;
	}
	public void setMeasuredWidth(int mMeasuredWidth) {
		this.mMeasuredWidth = mMeasuredWidth;
	}
	public int getMeasuredHeight() {
		return mMeasuredHeight;
	}
	public void setMeasuredHeight(int mMeasuredHeight) {
		this.mMeasuredHeight = mMeasuredHeight;
	}
	public void setDoubleScreen(boolean mDoubleScreen) {
		this.mDoubleScreen = mDoubleScreen;
	}
	public boolean isDoubleScreen() {
		return mDoubleScreen;
	}
	public int getDisplayWidth() {
		return mDisplayWidth;
	}
	public void setDisplayWidth(int mDisplayWidth) {
		this.mDisplayWidth = mDisplayWidth;
	}
	
	public int getDisplayHeight() {
		return mDisplayHeight;
	}
	public void setDisplayHeight(int mDisplayHeight) {
		this.mDisplayHeight = mDisplayHeight;
	}
	public int getScreenTilesHMod() {
		if (isDoubleScreen()) {
			this.mScreenTilesHMod = ((this.mDisplayWidth / 2 ) / 8) ;

			if (this.mScreenTilesHMod * 16 < this.mDisplayWidth) this.mScreenTilesHMod ++;
			if (this.mScreenTilesHMod > 33) this.mScreenTilesHMod = 32;
		}
		else {
			this.mScreenTilesHMod = 32;
		}
		return mScreenTilesHMod;
	}
	
	public void setScreenTilesHMod(int mScreenTilesHMod) {
		this.mScreenTilesHMod = mScreenTilesHMod;
	}
	
	
	/* mapH and mapV */
	public void setMapH(int i) {
		mMapH = i;
	}
	public int getMapH() {
		return mMapH;
	}
	public void setMapV(int i) {
		mMapV = i;
	}
	public int getMapV() {
		return mMapV;
	}
	
	/* inserting level and object data in map */
	
	public int getLevelCell(int x, int y) {
		return mLevel1[x][y];
	}
	public int getObjectsCell(int x, int y) {
		if (x<0 || y<0) return 0;
		return mObjects[x][y];
	}
	public int getObjectsCellReversed(int y, int x) {
		if (x<0 || y<0) return 0;
		return mObjects[x][y];
	}
	public void setLevelCell(int x, int y, int num) {
		mLevel1[x][y] = num;
	}
	public void setObjectsCell(int x, int y, int num) {
		mObjects[x][y] = num;
	}
	
	public void initializeArrays() {
		for(int i = 0; i < 96; i ++) {
			for(int j = 0; j < 96; j++ ) {
				mLevel1[i][j] = 0;
				mObjects[i][j] = 0;
			}
		}
	}
	
	public int[] getLevelArray() {
		int a[] = new int [96 * 96];
		for (int i = 0; i < 96; i ++) {
			for (int j = 0 ; j < 96; j ++) {
				a[(i * 96 )+ j] = mLevel1[i][j];
			}
		}
		return a;
	}
	public int[] getObjectsArray() {
		int a[] = new int [96 * 96];
		for (int i = 0; i < 96; i ++) {
			for (int j = 0 ; j < 96; j ++) {
				a[(i * 96 )+ j] = mObjects[i][j];
			}
		}
		return a;
		
	}
	
	
	
	/* Game progress set-ers and get-ers */
	public void setRoomNo(int num) {
		mRoom = num;
	}
	public int getRoomNo() {
		return mRoom;
	}
	public void incrementRoomNo() {
		mRoom ++;
	}
	
	public int getScore() {
		return mGuyScore.getScore();
	}

	public void setScore(int mScore) {
		this.mGuyScore.setScore(mScore);
	}
	
	public int incrementScore(int amount) {
		return mGuyScore.incrementScore(amount);
	}
	
	public boolean isEndLevel() {
		return mEndLevel;
	}

	public void setEndLevel(boolean mEndLevel) {
		this.mEndLevel = mEndLevel;
	}

	public int getLives() {
		return mGuyScore.getLives();
	}

	public void setLives(int mLives) {
		this.mGuyScore.setLives(mLives);
	}
	
	public void incrementLives() {
		this.mGuyScore.incrementLives();
	}
	
	public void decrementLives() {
		this.mGuyScore.decrementLives();
	}
	
	public boolean isEndGame() {
		return mEndGame;
	}

	public void setEndGame(boolean mEndGame) {
		this.mEndGame = mEndGame;
	}

	public boolean isGameDeath() {
		return mGameDeath;
	}
	public void setGameDeath(boolean mGameDeath) {
		this.mGameDeath = mGameDeath;
	}
	public int getUsernum() {
		return mUsernum;
	}

	public void setUsernum(int mUsernum) {
		this.mUsernum = mUsernum;
	}
	
	public int getOldGuyScore() {
		return mOldGuyScore;
	}
	public void setOldGuyScore(int mOldGuyScore) {
		this.mOldGuyScore = mOldGuyScore;
	}
	
	
	/* screen scroll */
	
	public int getScrollX() {
		return mScrollX;
	}
	public void setScrollX(int mScrollX) {
		this.mScrollX = mScrollX;
	}
	public int getScrollY() {
		return mScrollY;
	}
	public void setScrollY(int mScrollY) {
		this.mScrollY = mScrollY;
	}
	
	
	/** work with sprite list **/
	public void setSpriteStart() {
		//mSprites = new ArrayList<SpriteInfo>();
		if (mSprites.size() == 0) {
			SpriteInfo guy = new SpriteInfo(R.drawable.guy0, 2, 16, 4 , 10);
			guy.setAnimate(true);
			mSprites.add(guy);
		}
	}

	public void adjustSpriteStartPos() {
		
		for(int i = 0; i < mMapH; i ++) { // x
			for(int j = 0; j < mMapV; j++ ) { // y
				if(mObjects[i][j] == this.mStart) {
					mSprites.get(0).setMapPosX(i);
					mSprites.get(0).setMapPosY(j);
				}
			}
		}
	}
	
	public SpriteInfo getSpriteStart() {
		//if(mSprites.size() < 1) Log.e("GameValues", "no 'first' sprite yet");
		return mSprites.get(0);
	}
	
	public void addSprite(SpriteInfo sprite) {
		mSprites.add(sprite);
	}
	
	public SpriteInfo getSprite(int num) {
		SpriteInfo temp;
		if(mSprites.size() > num) {
			temp = mSprites.get(num);
		}
		else {
			temp = new SpriteInfo();
			//Log.v("GameValues","bad sprite number");
		}
		return temp;
	}
	public void clearSpriteList() {
		mSprites = new ArrayList<SpriteInfo>();
	}
	public int getSpriteListSize() {
		return mSprites.size();
	}
	
	/** set and get sprite index markers **/
	public int getMonsterNum() {
		return mMonsterNum;
	}
	public void setMonsterNum(int mMonsterNum) {
		this.mMonsterNum = mMonsterNum;
	}
	public int getMonsterOffset() {
		return mMonsterOffset;
	}
	public void setMonsterOffset(int mMonsterOffset) {
		this.mMonsterOffset = mMonsterOffset;
	}
	public int getPlatformNum() {
		return mPlatformNum;
	}
	public void setPlatformNum(int mPlatformNum) {
		this.mPlatformNum = mPlatformNum;
	}
	public int getPlatformOffset() {
		return mPlatformOffset;
	}
	public void setPlatformOffset(int mPlatformOffset) {
		this.mPlatformOffset = mPlatformOffset;
	}
	
	/* xml stuff */
	public boolean isLookForXml() {
		return mLookForXml;
	}
	public void setLookForXml(boolean mLookForXml) {
		this.mLookForXml = mLookForXml;
	}
	public int getTotNumRooms() {
		return mTotNumRooms;
	}
	public void setTotNumRooms(int mTotNumRooms) {
		this.mTotNumRooms = mTotNumRooms;
	}
	public InitBackground.LevelList getLevelList() {
		return mLevelList;
	}
	public void setLevelList(InitBackground.LevelList mLevelList) {
		this.mLevelList = mLevelList;
	}
	public int getXmlMode() {
		return mXmlMode;
	}
	public void setXmlMode(int mXmlMode) {
		this.mXmlMode = mXmlMode;
	}
	/*  screen orientation */
	public int getScreenOrientation() {
		return mScreenOrientation;
	}
	public void setScreenOrientation(int mScreenOrientation) {
		this.mScreenOrientation = mScreenOrientation;
	}
	public int getViewH() {
		return mViewH;
	}
	public void setViewH(int mViewH) {
		this.mViewH = mViewH;
	}
	public int getViewW() {
		return mViewW;
	}
	public void setViewW(int mViewW) {
		this.mViewW = mViewW;
	}
	public boolean isPutGameKeys() {
		return mPutGameKeys;
	}
	public void setPutGameKeys(boolean mPutGameKeys) {
		this.mPutGameKeys = mPutGameKeys;
	}
	public float getScaleH() {
		if (this.isDoubleScreen() && 
				this.getScreenOrientation() == ORIENTATION_PORTRAIT) {
			mScaleH = 2;
		}
		else {
			mScaleH = (float)this.mDisplayWidth/256;
		}
		return mScaleH;
	}
	public void setScaleH(int mScaleH) {
		this.mScaleH = mScaleH;
	}
	public float getScaleV() {
		if (this.isDoubleScreen() && 
				this.getScreenOrientation() == ORIENTATION_PORTRAIT) {
			mScaleV = 2;
		}
		else if (this.getScreenOrientation() == ORIENTATION_PORTRAIT) {
			mScaleV = 1;
			//mScaleV = getScaleH();
		}
		else if (this.isPutGameKeys()) {
			//mScaleV = (float)(this.mDisplayHeight - (mScreenTitle + LANDSCAPE_BUTTON_PIXEL))/192;
			mScaleV = (float)(this.mDisplayHeight - (mScreenTitle + this.getLandscapeButtonPixel()))/192;

		}
		else if (!this.isPutGameKeys()) {
			mScaleV = (float)(this.mDisplayHeight - mScreenTitle)/192;
		}
		return mScaleV;
	}
	public void setScaleV(int mScaleV) {
		this.mScaleV = mScaleV;
	}
	public int getScreenTitle() {
		return mScreenTitle;
	}
	public void setScreenTitle(int mScreenTitle) {
		this.mScreenTitle = mScreenTitle;
	}
	public int getLandscapeButtonPixel() {

		if (this.mLandscapeButtonPixelPercent == 0) {
			this.mLandscapeButtonPixelPercent =  LANDSCAPE_BUTTON_PERCENT;
		}
		return (int)(this.mDisplayHeight * this.mLandscapeButtonPixelPercent);
	}
	public void setLandscapeButtonPixelPercent(int mPercent) {
		this.mLandscapeButtonPixelPercent = mPercent;
	}
	
	/* --------------Make and use Bundle -----------------*/
	public void addToBundle(Bundle bundle, MovementValues mMovementV) {
		mBundle = bundle;
		//mBundle = new Bundle(10);
		this.setScrollX(mMovementV.getScrollX());
		this.setScrollY(mMovementV.getScrollY());
		
		mBundle.putBoolean(BUNDLE_INITIAL, false);

		mBundle.putInt(BUNDLE_NUM_OF_SPRITES, this.mSprites.size());
		int [] mXvalues = new int [mSprites.size()];
		int [] mYvalues = new int [mSprites.size()];
		boolean [] mFacingRight = new boolean [mSprites.size()];
		
		for (int i = 0; i < mSprites.size(); i ++) {
			mXvalues [i] = mSprites.get(i).getMapPosX();
			mYvalues [i] = mSprites.get(i).getMapPosY();
			mFacingRight [i] = mSprites.get(i).getFacingRight();
		}
		mBundle.putIntArray(BUNDLE_SPRITES_X_ARRAY, mXvalues);
		mBundle.putIntArray(BUNDLE_SPRITES_Y_ARRAY, mYvalues);
		mBundle.putBooleanArray(BUNDLE_SPRITES_FACINGRIGHT_ARRAY, mFacingRight);
		
		mBundle.putInt(BUNDLE_MONSTER_NUMBER, mMonsterNum);
		mBundle.putInt(BUNDLE_MONSTER_OFFSET, mMonsterOffset);
		
		mBundle.putInt(BUNDLE_PLATFORM_NUMBER, mPlatformNum);
		mBundle.putInt(BUNDLE_PLATFORM_OFFSET, mPlatformOffset);
		
		mBundle.putInt(BUNDLE_BOSSMONSTER_NUMBER, mBossmonsterNum);
		mBundle.putInt(BUNDLE_BOSSMONSTER_OFFSET, mBossmonsterOffset);
		
		mBundle.putInt(BUNDLE_MAP_H, mMapH);
		mBundle.putInt(BUNDLE_MAP_V, mMapV);
		
		int [] mObjectsArray = new int [96 * 96];
		for (int y = 0; y < 96; y ++) {
			for(int x = 0; x < 96; x ++ ) {
				mObjectsArray[(y * 96) + x] = this.mObjects[y][x];
			}
		}
		mBundle.putIntArray(BUNDLE_MAP_ARRAY, mObjectsArray);
		
		mBundle.putInt(BUNDLE_SCROLL_X, mScrollX);
		mBundle.putInt(BUNDLE_SCROLL_Y, mScrollY);
		
		mBundle.putInt(BUNDLE_SCORE, this.getScore());
		mBundle.putInt(BUNDLE_LIVES, this.getLives());
		
		mBundle.putInt(BUNDLE_LAST_ORIENTATION, this.getScreenOrientation());
	}
	public Bundle getBundle() {
		return mBundle;
	}
	public void useBundleInfo(Bundle bundle, MovementValues mMovementV) {
		mBundle = bundle;
		
		this.mXmlMode = XML_USE_LEVEL;
		
		int mSpritesSize = mBundle.getInt(BUNDLE_NUM_OF_SPRITES);
		this.mMonsterNum = mBundle.getInt(BUNDLE_MONSTER_NUMBER);
		this.mMonsterOffset = mBundle.getInt(BUNDLE_MONSTER_OFFSET);
		this.mPlatformNum = mBundle.getInt(BUNDLE_PLATFORM_NUMBER);
		this.mPlatformOffset = mBundle.getInt(BUNDLE_PLATFORM_OFFSET);
		this.mBossmonsterNum = mBundle.getInt(BUNDLE_BOSSMONSTER_NUMBER);
		this.mBossmonsterOffset = mBundle.getInt(BUNDLE_BOSSMONSTER_OFFSET);
		
		this.mMapH = mBundle.getInt(BUNDLE_MAP_H);
		this.mMapV = mBundle.getInt(BUNDLE_MAP_V);
		
		int mSpritesX [] = new int[mSpritesSize];
		int mSpritesY [] = new int[mSpritesSize];
		boolean mSpritesFacingRight [] = new boolean [mSpritesSize];
		
		mSpritesX = mBundle.getIntArray(BUNDLE_SPRITES_X_ARRAY);
		mSpritesY = mBundle.getIntArray(BUNDLE_SPRITES_Y_ARRAY);
		mSpritesFacingRight = mBundle.getBooleanArray(BUNDLE_SPRITES_FACINGRIGHT_ARRAY);
		
		mSprites.clear();
		
		for (int i = 0; i < mSpritesSize ; i ++) {
			SpriteInfo mTempSprite = new SpriteInfo();
			if (i == 0) {
				mTempSprite = new SpriteInfo(R.drawable.guy0);
			}
			else if (i > mMonsterOffset && i <  mMonsterNum) {
				mTempSprite = new SpriteInfo(R.drawable.monster_l0);
			}
			else if (i > mPlatformOffset && i <  mPlatformNum) 
			{
				mTempSprite = new SpriteInfo(R.drawable.concrete);
			}
			
			
			//TODO: fill in other info like boss monster sprite info
			mTempSprite.setMapPosX(mSpritesX[i]);
			mTempSprite.setMapPosY(mSpritesY[i]);
			mTempSprite.setFacingRight(mSpritesFacingRight[i]);
			
			this.mSprites.add(mTempSprite);
		}
		
		int [] mObjectsArray = new int [96 * 96];
		mObjectsArray = mBundle.getIntArray(BUNDLE_MAP_ARRAY);
		
		for (int y = 0; y < 96; y ++) {
			for (int x = 0; x < 96; x ++ ) {
				//this.setObjectsCell(x, y, mObjectsArray[(y * 96) + x]);
				//Log.e("GameValues","objects "+ mObjectsArray[(y * mMapH) + x]);
				this.mObjects[y][x] = mObjectsArray[(y * 96) + x];
			}
		}
		
		this.mScrollX = mBundle.getInt(BUNDLE_SCROLL_X);
		this.mScrollY = mBundle.getInt(BUNDLE_SCROLL_Y);
		
		mMovementV.setScrollX(mScrollX);
		mMovementV.setScrollY(mScrollY);
		
		this.setScore(mBundle.getInt(BUNDLE_SCORE));
		this.setLives(mBundle.getInt(BUNDLE_LIVES));
		//Log.e("GameValues","scroll x " + mScrollX + " num of sprites " + mSpritesSize);
		// end of restoring GameValues from Bundle. //
	}
	public Bundle getInitialBundle() {
		Bundle mInitial = new Bundle();
		mInitial.putBoolean(BUNDLE_INITIAL, true);
		return mInitial;
	}
}
