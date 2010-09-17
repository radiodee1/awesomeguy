package org.davidliebman.android.awesomeguy;

import java.util.ArrayList;
import java.lang.*;
import android.content.*;
import android.util.Log;


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
	private int mDisplayWidth;
	
	/* game progress */
	private Record mGuyScore = new Record();
	private int mRoom = 1;
	private boolean mEndLevel = false;
	private boolean mEndGame = false;
	private boolean mGameDeath = false;
	private int mUsernum = 4;
	//public static int NUM_ROOMS = 10;
	private int mOldGuyScore;
	
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
	
	
	public boolean isDoubleScreen() {
		return mDoubleScreen;
	}
	public void setDoubleScreen(boolean mDoubleScreen) {
		this.mDoubleScreen = mDoubleScreen;
	}
	
	public int getDisplayWidth() {
		return mDisplayWidth;
	}
	public void setDisplayWidth(int mDisplayWidth) {
		this.mDisplayWidth = mDisplayWidth;
	}
	public int getScreenTilesHMod() {
		if (isDoubleScreen()) {
			this.mScreenTilesHMod = ((this.mDisplayWidth / 2 ) / 8) ;

			if (this.mScreenTilesHMod * 16 < this.mDisplayWidth) this.mScreenTilesHMod ++;
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
		if(mSprites.size() < 1) Log.e("GameValues", "no 'first' sprite yet");
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
			Log.v("GameValues","bad sprite number");
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
	/*
	public ArrayList<Integer> getXmlLevel() {
		return mXmlLevel;
	}
	public void setXmlLevel(ArrayList<Integer> mXmlLevel) {
		this.mXmlLevel = mXmlLevel;
	}
	*/
	
}
