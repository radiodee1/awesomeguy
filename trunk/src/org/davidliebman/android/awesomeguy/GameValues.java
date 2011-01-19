package org.davidliebman.android.awesomeguy;

import java.util.ArrayList;
import java.lang.*;
import android.content.*;
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
	
	/* sprites */
	private ArrayList<SpriteInfo> mSprites = new ArrayList<SpriteInfo>();
	private int mMonsterNum, mMonsterOffset;
	private int mPlatformNum, mPlatformOffset;
	public static final int MONSTER_TOTAL = 15;
	public static final int PLATFORM_TOTAL = 15;
	
	/* xml stuff */
	private boolean mLookForXml = false;
	private int mTotNumRooms = 10;
	private ArrayList<Integer> mXmlLevel = new ArrayList<Integer>();
	private InitBackground.LevelList mLevelList;
	
	
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
		//return mLandscapeButtonPixel;
		if (this.mLandscapeButtonPixelPercent == 0) {
			this.mLandscapeButtonPixelPercent =  LANDSCAPE_BUTTON_PERCENT;
		}
		return (int)(this.mDisplayHeight * this.mLandscapeButtonPixelPercent);
	}
	public void setLandscapeButtonPixelPercent(int mPercent) {
		this.mLandscapeButtonPixelPercent = mPercent;
	}
	
	
}
