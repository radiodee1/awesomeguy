package org.davidliebman.android.awesomeguy;


//import javax.jdo.annotations.*;
//import com.google.appengine.api.datastore.Key;

import java.util.Date;

//import com.google.gwt.user.client.rpc.IsSerializable;

public  class RecordJson  {
	
	public final static int SPEED_SLOW = 	16;
	public final static int SPEED_MEDIUM = 	20;
	public final static int SPEED_FAST = 	24;
	public final static int SPEED_FASTER = 	32;
	public final static int SPEED_SYSTEM = 	40;
	
	public static int RADIO_PLAYERS_TEN = 10;
	public static int RADIO_PLAYERS_FIVE = 5;
	public static int RADIO_PLAYERS_FIFTY = 50;
	

	private String mAndroidAppname;
	private String mEmail;
	private String mName = new String();
	private String mCountry;
	
	private boolean mNewRecord;
	private int mRecordIdNum;
	private int mLevel;
	private int mScore;
	private int mLives;
	private int mCycles;//not used much
	private int mSave1;//not used much
	
	
	private int mGameSpeed;
	private int mNumRecords;
	private boolean mSound;
	private boolean mEnableJNI;
	private boolean mEnableMonsters;
	private boolean mEnableCollision;
	
	private Date mDate;
	private long mKey;
	
	public RecordJson() {
		
		mName = new String("anonymous");
		mEmail = new String("");
		mCountry = new String("");
		mAndroidAppname = new String("");
		
		mNewRecord = false;
		mRecordIdNum = 0;
		
		mLevel = 0;
		mScore = 0;
		mLives = 0;
		mCycles = 0;
		mSave1 = 0;
		mGameSpeed = 0;
		mNumRecords = 0;
		mSound = true;
		mEnableJNI = true;
		mEnableMonsters = true;
		mEnableCollision = true;
		mDate = new Date();
		
	}
	

	public boolean isNewRecord() {
		return mNewRecord;
	}


	public String getAndroidAppname() {
		return mAndroidAppname;
	}

	public void setAndroidAppname(String mAndroidAppname) {
		this.mAndroidAppname = mAndroidAppname;
	}

	
	
	public String getEmail() {
		return mEmail;
	}


	public void setEmail(String mEmail) {
		this.mEmail = mEmail;
	}


	public void setNewRecord(boolean mNewRecord) {
		this.mNewRecord = mNewRecord;
	}
	public boolean getNewRecord() {
		return this.mNewRecord;
	}
	
	public int getLevel() {
		return mLevel;
	}
	public void setLevel(int mLevel) {
		this.mLevel = mLevel;
	}
	public int getScore() {
		return mScore;
	}
	public void setScore(int mScore) {
		this.mScore = mScore;
	}
	
	public int incrementScore(int amount) {
		this.mScore = this.mScore + amount;
		return this.mScore;
	}
	public int getLives() {
		return mLives;
	}
	public void setLives(int mLives) {
		this.mLives = mLives;
	}
	public void incrementLives() {
		this.mLives ++;
	}

	public void decrementLives() {
		this.mLives --;
	}
	public int getCycles() {
		// not used much
		return mCycles;
	}
	public void setCycles(int mCycles) {
		// not used much
		this.mCycles = mCycles;
	}
	public int getSave1() {
		// not used much
		return mSave1;
	}
	public void setSave1(int mSave1) {
		// not used much
		this.mSave1 = mSave1;
	}
	public String getName() {
		return mName;
	}
	public void setName(String mName) {
		this.mName = mName;
	}
	public int getGameSpeed() {
		return mGameSpeed;
	}
	public void setGameSpeed(int mGameSpeed) {
		this.mGameSpeed = mGameSpeed;
	}
	public int getNumRecords() {
		return mNumRecords;
	}
	public void setNumRecords(int mNumRecords) {
		this.mNumRecords = mNumRecords;
	}
	public boolean isSound() {
		return mSound;
	}
	public void setSound(boolean mSound) {
		this.mSound = mSound;
	}
	public boolean isEnableJNI() {
		//return mEnableJNI;
		return true;
	}
	public void setEnableJNI(boolean mEnableJNI) {
		//this.mEnableJNI = mEnableJNI;
		this.mEnableJNI = true;
	}
	public boolean isEnableMonsters() {
		return mEnableMonsters;
	}
	public void setEnableMonsters(boolean mEnableMonsters) {
		this.mEnableMonsters = mEnableMonsters;
	}
	public boolean isEnableCollision() {
		return mEnableCollision;
	}
	public void setEnableCollision(boolean mEnableCollision) {
		this.mEnableCollision = mEnableCollision;
	}
	
	public int getRecordIdNum() {
		return mRecordIdNum;
	}
	public void setRecordIdNum(int mRecordIdNum) {
		this.mRecordIdNum = mRecordIdNum;
	}

	public String getCountry() {
		return mCountry;
	}


	public void setCountry(String mCountry) {
		this.mCountry = mCountry;
	}


	public Date getDate() {
		return mDate;
	}


	public void setDate(Date mDate) {
		this.mDate = mDate;
	}


	public long getKey() {
		return mKey;
	}


	public void setKey(long mKey) {
		this.mKey = mKey;
	}
	
	
	
	


	
	
}