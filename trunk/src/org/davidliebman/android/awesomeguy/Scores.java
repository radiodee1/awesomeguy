package org.davidliebman.android.awesomeguy;

public class Scores {
	
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
	/* Save2 is for cycles */
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
	
	public static class Record {
		public int mLevel;
		public int mScore;
		public int mSave1;
		public int mSave2;
		public int mSave3;
		public String mName = new String();
	}
	
}
