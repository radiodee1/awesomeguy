package org.davidliebman.android.awesomeguy;

import android.os.Parcel;
import android.os.Parcelable;
import android.util.Log;


public class Scores {
	/*
	
	private int mPlayerIndex = 4;
	
	private Record[] rec = new Record[5];
	
	public Scores() {
		for (int i = 0; i < 5; i ++) {
			rec[i] = new Record();
			rec[i].mScore = 10;
			rec[i].mLevel = 1;
			rec[i].mSave1 = 3;
			rec[i].mSave2 = 0;
			rec[i].mSave3 = 0;
			rec[i].mName = new String("new");
		}
		
	}
	
	
	public String getName(int index) {
		return rec[index].mName;
	}
	public void setName(String nName, int index) {
		this.rec[index].mName = nName;
	}
	public int getScore( int index) {
		return rec[index].mScore;
	}
	public void setScore(int mScore, int index) {
		this.rec[index].mScore = mScore;
	}
	public int getLevel( int index) {
		return rec[index].mLevel;
	}
	public void setLevel(int mLevel, int index) {
		this.rec[index].mLevel = mLevel;
	}
	public int getSave1( int index) {
		return rec[index].mSave1;
	}
	public void setSave1(int mSave1, int index) {
		this.rec[index].mSave1 = mSave1;
	}
	public int getSave2( int index) {
		return rec[index].mSave2;
	}
	public void setSave2(int mSave2, int index) {
		this.rec[index].mSave2 = mSave2;
	}
	*/
	
	/* Save2 is for cycles */
	/*
	public void incrementSave2(int index) {
		this.rec[index].mSave2 ++;
	}
	public int getSave3( int index) {
		return rec[index].mSave3;
	}
	public void setSave3(int mSave3, int index) {
		this.rec[index].mSave3 = mSave3;
	}


	public void setPlayerIndex(int mPlayerIndex) {
		this.mPlayerIndex = mPlayerIndex;
	}


	public int getPlayerIndex() {
		return mPlayerIndex; // same as userNum
	}
	
	
	public void setAll(GameValues mGameV, int index) {
		mPlayerIndex = index;
		this.rec[index].mLevel = mGameV.getRoomNo();
		this.rec[index].mScore = mGameV.getScore();
		this.rec[index].mSave1 = mGameV.getLives();
		this.rec[index].mSave2 = 0; //cycles
		this.rec[index].mSave3 = 0;
		this.rec[index].mName = new String();
	}
	
	public void setAll(Scores.Record mG, int index) {
		mPlayerIndex = index;
		this.rec[index].mLevel = mG.mLevel;
		this.rec[index].mScore = mG.mScore;
		this.rec[index].mSave1 = mG.mSave1;
		this.rec[index].mSave2 = mG.mSave2; //cycles
		this.rec[index].mSave3 = mG.mSave3;
		this.rec[index].mName = mG.mName;
	}
	
	public void setAll(Scores.Record mG) {
		int index = mPlayerIndex ;
		this.rec[index].mLevel = mG.mLevel;
		this.rec[index].mScore = mG.mScore;
		this.rec[index].mSave1 = mG.mSave1;
		this.rec[index].mSave2 = mG.mSave2; //cycles
		this.rec[index].mSave3 = mG.mSave3;
		this.rec[index].mName = mG.mName;
	}
	*/
	/*
	public static class Record implements Parcelable {
		private boolean mNewRecord;
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
			mLevel = 1;
			mScore = 10;
			mLives = 3;
			mCycles = 0;
			mSave1 = 0;
			mGameSpeed = 16;
			mNumRecords = 5;
			mSound = true;
			mEnableJNI = false;
			mEnableMonsters = true;
			mEnableCollision = true;
		}
		/////////// parcelable start
		@Override
		public int describeContents() {
	         return 0;
	     }

		@Override
	     public void writeToParcel(Parcel out, int flags) {
			
			out.writeString(new Boolean(mNewRecord).toString());
	    	 out.writeString(mName);
	         out.writeInt(mLevel);
	         out.writeInt(mScore);
	         out.writeInt(mLives);
	         out.writeInt(mCycles);
	         out.writeInt(mSave1);
	         out.writeInt(mGameSpeed);
	         out.writeInt(mNumRecords);
	         out.writeString(new Boolean(mSound).toString());
	         out.writeString(new Boolean(mEnableJNI).toString());
	         out.writeString(new Boolean(mEnableMonsters).toString());
	         out.writeString(new Boolean(mEnableCollision).toString());
	         
	         
	     }

	     public static final Parcelable.Creator<Record> CREATOR
	             = new Parcelable.Creator<Record>() {
	         public Record createFromParcel(Parcel in) {
	             return new Record(in);
	         }

	         public Record[] newArray(int size) {
	             return new Record[size];
	         }
	     };
	     
	     private Record(Parcel in) {
	    	 mNewRecord = new Boolean(in.readString()).booleanValue();
	    	 mName = in.readString();
	         mLevel = in.readInt();
	         mScore = in.readInt();
	         mLives = in.readInt();
	         mCycles = in.readInt();
	         mSave1 = in.readInt();
	         mGameSpeed = in.readInt();
	         mNumRecords= in.readInt();
	         mSound = new Boolean(in.readString()).booleanValue();
	         mEnableJNI = new Boolean(in.readString()).booleanValue();
	         mEnableMonsters = new Boolean(in.readString()).booleanValue();
	         mEnableCollision = new Boolean(in.readString()).booleanValue();
	         mNewRecord = false;
	     }

	    /////  parcelable stuff end

	     public void listInLog() {
			Log.i("Record", "Is New Record " + new Boolean(mNewRecord).toString());
			Log.i("Record", "Player Name " + mName);
			Log.i("Record", "Player Level "+ mLevel);
			Log.i("Record", "Player Score " + mScore);
			Log.i("Record", "Player Lives " + mLives);
			Log.i("Record", "Player Cycles " + mCycles);
			Log.i("Record", "Player Save1 " + mSave1);
			Log.i("Record", "Game Speed " + mGameSpeed);
			Log.i("Record", "High Score Number " + mNumRecords);
			Log.i("Record", "Sound Enabled " + new Boolean(mSound).toString());
			Log.i("Record", "JNI Enabled " + new Boolean(mEnableJNI).toString());
			Log.i("Record", "Monsters Enabled " + new Boolean(mEnableMonsters).toString());
			Log.i("Record", "Collision Enabled " + new Boolean(mEnableCollision).toString());
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
	}
	*/
}
