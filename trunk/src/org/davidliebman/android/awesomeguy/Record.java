package org.davidliebman.android.awesomeguy;


import android.os.Parcel;
import android.os.Parcelable;
import android.util.Log;
import android.content.*;

public  class Record  {
	

	
	private boolean mNewRecord;
	private int mRecordIdNum;
	private int mLevel;
	private int mScore;
	private int mLives;
	private int mCycles;//not used much
	private int mSave1;//not used much
	private String mName = new String();
	
	private int mGameSpeed;
	private int mNumRecords;
	private boolean mSound;
	private boolean mEnableJNI;
	private boolean mEnableMonsters;
	private boolean mEnableCollision;
	
	
	Record() {
		
		mName = new String("none");
		
		mNewRecord = true;
		mRecordIdNum = 0;
		
		mLevel = 1;
		mScore = 10;
		mLives = 3;
		mCycles = 0;
		mSave1 = 0;
		mGameSpeed = 16;
		mNumRecords = 50;
		mSound = true;
		mEnableJNI = true;
		mEnableMonsters = true;
		mEnableCollision = true;
	}
	

     public void addToPreferences( SharedPreferences preferences) {
    	 SharedPreferences.Editor out = preferences.edit();
    	 out.putString("mNewRecord",new Boolean(mNewRecord).toString());
    	 out.putInt("mRecordIdNum", mRecordIdNum);
    	 out.putString("mName",mName);
         out.putInt("mLevel",mLevel);
         out.putInt("mScore",mScore);
         out.putInt("mLives",mLives);
         out.putInt("mCycles",mCycles);
         out.putInt("mSave1",mSave1);
         out.putInt("mGameSpeed",mGameSpeed);
         out.putInt("mNumRecords",mNumRecords);
         out.putString("mSound",new Boolean(mSound).toString());
         out.putString("mEnableJNI",new Boolean(mEnableJNI).toString());
         out.putString("mEnableMonsters",new Boolean(mEnableMonsters).toString());
         out.putString("mEnableCollision",new Boolean(mEnableCollision).toString());
         out.commit();
     }
     
     public void getFromPreferences(SharedPreferences in) {
    	 mNewRecord = new Boolean(in.getString("mNewRecord","")).booleanValue();
    	 mRecordIdNum = in.getInt("mRecordIdNum", 0);
    	 mName = in.getString("mName","none");
         mLevel = in.getInt("mLevel",1);
         mScore = in.getInt("mScore",10);
         mLives = in.getInt("mLives",3);
         mCycles = in.getInt("mCycles",0);
         mSave1 = in.getInt("mSave1",0);
         mGameSpeed = in.getInt("mGameSpeed",16);
         mNumRecords= in.getInt("mNumRecords",5);
         mSound = new Boolean(in.getString("mSound","")).booleanValue();
         mEnableJNI = new Boolean(in.getString("mEnableJNI","")).booleanValue();
         mEnableMonsters = new Boolean(in.getString("mEnableMonsters","")).booleanValue();
         mEnableCollision = new Boolean(in.getString("mEnableCollision","")).booleanValue();
     }
     
     public void listInLog() {
		Log.i("Record", "Is New Record " + new Boolean(mNewRecord).toString());
		Log.i("Record", "Record Database Num : "+ mRecordIdNum);
		Log.i("Record", "Player Name : " + mName);
		Log.i("Record", "Player Level : "+ mLevel);
		Log.i("Record", "Player Score : " + mScore);
		Log.i("Record", "Player Lives : " + mLives);
		Log.i("Record", "Player Cycles : " + mCycles);
		Log.i("Record", "Player Save1 : " + mSave1);
		Log.i("Record", "Game Speed : " + mGameSpeed);
		Log.i("Record", "High Score Number : " + mNumRecords);
		Log.i("Record", "Sound Enabled : " + new Boolean(mSound).toString());
		Log.i("Record", "JNI Enabled : " + new Boolean(mEnableJNI).toString());
		Log.i("Record", "Monsters Enabled : " + new Boolean(mEnableMonsters).toString());
		Log.i("Record", "Collision Enabled : " + new Boolean(mEnableCollision).toString());
	}
     

    
	
	
    
	public boolean isNewRecord() {
		return mNewRecord;
	}
	public void setNewRecord(boolean mNewRecord) {
		this.mNewRecord = mNewRecord;
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
		return mEnableJNI;
	}
	public void setEnableJNI(boolean mEnableJNI) {
		this.mEnableJNI = mEnableJNI;
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


	


	
	
}