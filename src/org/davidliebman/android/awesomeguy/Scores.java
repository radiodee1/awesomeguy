package org.davidliebman.android.awesomeguy;


import android.content.Context;
import android.content.ContentValues;
//import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
//import android.database.sqlite.SQLiteStatement;
//import android.util.Log;
import android.util.Log;
import java.util.*;

public class Scores {
	private static final String DATABASE_NAME = "AwesomeeguyScores.db";
	private static final int DATABASE_VERSION = 20;
	private static final String TABLE_SCORES_NAME = "scores";
	private static final String TABLE_HIGHS_NAME = "highs";
	
	private SQLiteDatabase mDatabase;
	private ScoreOpenHelper mOpenHelper;
	public Context mContext;
	public Record mHighScores;
	public Cursor mPlayerListC;
	public Cursor mIfRanksC;
	public Cursor mNumOfRecordsC;
	public Cursor mUpdateOptionsC;
	public Cursor mPruneScoresC;
	public Cursor mGameHighC;
	public Cursor mHighInTableC;
	public Cursor mPruneHighC;
	
	public Scores (Context context, Record highScores) {
		mContext = context;
		mOpenHelper = new ScoreOpenHelper(mContext);
		mHighScores = highScores;
	}
	public void setHighScores(Record highScores) {
		mHighScores = highScores;
	}
	
	public void closeAll() {
		mDatabase.close();
		
		mPlayerListC.close();
		mIfRanksC.close();
		mNumOfRecordsC.close();
		mUpdateOptionsC.close();
		mPruneScoresC.close();
		mGameHighC.close();
		mHighInTableC.close();
		mPruneHighC.close();
		
	}
	
	public ArrayList<Record> getHighScorePlayerList(int num) {
		// NOTE: if 'num' is negative, all records are returned
		ArrayList<Record> mList = new ArrayList<Record>();
		mOpenHelper = new ScoreOpenHelper(mContext);
		
		try {
			if (!mPlayerListC.isClosed()) {
				mPlayerListC.close();
			}
			
			if (mDatabase.isOpen()) {
				mDatabase.close();
			}
			
    	}
    	catch (NullPointerException e) {
    		//Log.e("Awesomeguy", "Null Pointer mDatabase");
    	}
		
		mDatabase = mOpenHelper.getReadableDatabase();
		//Cursor c;
		if (num < 0 ) {
			mPlayerListC = mDatabase.rawQuery(this.getSelectAllRecordsString(), null);
		}
		else {
			mPlayerListC = mDatabase.rawQuery(this.getSelectNumOfRecordsString(num), null);
		}
		if (mPlayerListC.getCount() == 0) return mList;
		mPlayerListC.moveToFirst();
		for (int i = 0; i < mPlayerListC.getCount(); i ++ ) {
			//Log.d("Scores","_id" + c.getColumnIndex("_id"));
			//Log.d("Scores","id" + c.getColumnIndex("id"));
			Record mTempRec = new Record();
			mTempRec.setRecordIdNum(mPlayerListC.getInt(mPlayerListC.getColumnIndex("id")));
			mTempRec.setNewRecord(new Boolean(mPlayerListC.getString(mPlayerListC.getColumnIndex("new_record"))).booleanValue());//TODO: should I change this to 'false'??
			mTempRec.setName(mPlayerListC.getString(mPlayerListC.getColumnIndex("name")));
			mTempRec.setLevel(mPlayerListC.getInt(mPlayerListC.getColumnIndex("level")));
			mTempRec.setScore(mPlayerListC.getInt(mPlayerListC.getColumnIndex("score")));
			mTempRec.setLives(mPlayerListC.getInt(mPlayerListC.getColumnIndex("lives")));
			mTempRec.setCycles(mPlayerListC.getInt(mPlayerListC.getColumnIndex("cycles")));
			mTempRec.setSave1(mPlayerListC.getInt(mPlayerListC.getColumnIndex("save")));
			mTempRec.setGameSpeed(mPlayerListC.getInt(mPlayerListC.getColumnIndex("game_speed")));
			mTempRec.setNumRecords(mPlayerListC.getInt(mPlayerListC.getColumnIndex("num_records")));
			mTempRec.setSound(new Boolean(mPlayerListC.getString(mPlayerListC.getColumnIndex("sound"))).booleanValue());
			mTempRec.setEnableJNI(new Boolean(mPlayerListC.getString(mPlayerListC.getColumnIndex("enable_jni"))).booleanValue());
			mTempRec.setEnableMonsters(new Boolean(mPlayerListC.getString(mPlayerListC.getColumnIndex("enable_monsters"))).booleanValue());
			mTempRec.setEnableCollision(new Boolean(mPlayerListC.getString(mPlayerListC.getColumnIndex("enable_collision"))).booleanValue());
			mList.add(mTempRec);
			mPlayerListC.moveToNext();
			//Log.e("Scores","____"+ mTempRec.getRecordIdNum());
			
		}
		mPlayerListC.close();
		mDatabase.close();
		return mList;
	}
	
	public void insertRecordIfRanks(Record mHighScores) {
		String query = new String();
		Record mLowestScore = new Record();
		//SharedPreferences preferences = mContext.getSharedPreferences(Options.AWESOME_NAME, Context.MODE_PRIVATE);
		
		/* first check if record is 'anonymous' -- if so, exit !! */
		if(mHighScores.getName().contentEquals(mLowestScore.getName())) return;
		
		
		ArrayList<Record> test = this.getHighScorePlayerList(mHighScores.getNumRecords());
		if (test.size() > 0) {
			mLowestScore = test.get(test.size() - 1);
		}
		
		if (mHighScores.getScore() > mLowestScore.getScore() || test.size() < mHighScores.getNumRecords()) {
			mOpenHelper = new ScoreOpenHelper(mContext);
			SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
			
			//mHighScores.listInLog();
			
			if(mHighScores.isNewRecord()) {
				//set new record to false
				//set ID Num
				
				long i = mDatabase.insert(TABLE_SCORES_NAME, null, this.getInsertScoresContentValues());
				
				
				mHighScores.setRecordIdNum((int)i);
				mHighScores.setNewRecord(false);
				
				
				
			}
			else  {
				query = this.getUpdateScoreLevelString(mHighScores.getRecordIdNum());
				//Cursor c;
				mIfRanksC = mDatabase.rawQuery(query, null);
				int i = mIfRanksC.getCount();
				//Log.e("Scores","setting old score number <----------------" + mHighScores.getRecordIdNum())	;
				mIfRanksC.close();
				
			}
			mDatabase.close();
		}
	}
	
	public void updateNumOfRecords(int idnum) {
		mOpenHelper = new ScoreOpenHelper(mContext);
		SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
		//Cursor c ;
		mNumOfRecordsC = mDatabase.rawQuery(this.getUpdateNumOfRecordsString(idnum), null);
		mNumOfRecordsC.getCount();
		mNumOfRecordsC.close();
		mDatabase.close();
	}
	
	public void updateOptions(int idnum) {
		ArrayList<Record> mList = this.getHighScorePlayerList(-1);
		boolean found = false;
		if(mList.size() > 0 ) {
			for (int i = 0; i < mList.size(); i ++ ) {
				if (idnum == mList.get(i).getRecordIdNum()) found = true;
			}
		}
		if (found) {
			mOpenHelper = new ScoreOpenHelper(mContext);
			SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
			//Cursor c ;
			mUpdateOptionsC = mDatabase.rawQuery(this.getUpdateOptionsString(idnum), null);
			mUpdateOptionsC.getCount();
			mUpdateOptionsC.close();
			mDatabase.close();
		}
		//Log.e("Scores", "at Options save");
	}
	
	public int pruneScoresList() {
		ArrayList<Record> mList = this.getHighScorePlayerList(-1);
		mOpenHelper = new ScoreOpenHelper(mContext);
		SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
		int num = 0;
		if (mHighScores.getNumRecords() < mList.size()) {
			num = mList.size() - mHighScores.getNumRecords();
			for (int i = mHighScores.getNumRecords(); i < mList.size(); i ++) {
				int j = mList.get(i).getRecordIdNum();
				//Cursor c ;
				mPruneScoresC = mDatabase.rawQuery("DELETE FROM "+ TABLE_SCORES_NAME + " WHERE id=" + j, null);
				mPruneScoresC.getCount();
				mPruneScoresC.close();
				//Log.e("scores", "REMOVE RECORD " + j + "<--------------");
				//mList.get(i).listInLog();
			}
		}
		mDatabase.close();
		return num;
	}
	
    public String getInsertString(String tableName) {
    	return new String("INSERT INTO " +
    						tableName + " " +		
    						"( new_record  , " +
    						" name  , " +
    						" level  , " +
    						" score  , " +
    						" lives  , " +
    						" cycles  , " +
    						" save  , " +
    						" game_speed  , " +
    						" num_records  , " +
    						" sound  , " +
    						" enable_jni  , " +
    						" enable_monsters  , " +
    						" enable_collision  ) " +
							" VALUES ( " +
							// keep order correct
							" \"" + "false" + "\"  , " + //new_record
							" \"" + mHighScores.getName() + "\"  , " + //name
							" " + mHighScores.getLevel() + "  , " + //level
							" " + mHighScores.getScore() + "  , " +  //score
							" " + mHighScores.getLives() + "  , " +  //lives
							" " + mHighScores.getCycles() + "  , " +  //cycles
							" " + mHighScores.getSave1() + "  , " + //save
							" " + mHighScores.getGameSpeed() + "  , " + //game_speed
							" " + mHighScores.getNumRecords() + "  , " +  //num_records
							" \"" + new Boolean(mHighScores.isSound()).toString() + "\"  , " +//sound
							" \"" + new Boolean(mHighScores.isEnableJNI()).toString() + "\"  , " +//enable_jni
							" \"" + new Boolean(mHighScores.isEnableMonsters()).toString() + "\"  , " + //enable_monsters
							" \"" + new Boolean(mHighScores.isEnableCollision()).toString() + "\" " + //enable_collision
							" ) " ); 
    }
    
	
	public String getSelectNumOfRecordsString( int num ) {
		return new String ("SELECT * FROM " +
							TABLE_SCORES_NAME + " " +
							" ORDER BY score DESC LIMIT " + num +
							" ");
	}
	
	public String getSelectAllRecordsString() {
		return new String("SELECT * FROM " + TABLE_SCORES_NAME +" ORDER BY score DESC");
	}
	
	public String getUpdateScoreLevelString(int id) {
		return new String("UPDATE " + TABLE_SCORES_NAME + " " +
							" SET score=" + mHighScores.getScore() + " , " +
							" level=" + mHighScores.getLevel() + " " + // note: level is used for checkpoints
							" WHERE id=" + id);
	}
	
	public String getUpdateNumOfRecordsString(int id) {
		return new String("UPDATE " + TABLE_SCORES_NAME + " " +
							" SET num_records=" + mHighScores.getNumRecords() +
							" WHERE id=" + id);
	}
	
	public String getUpdateOptionsString(int id) {
		return new String("UPDATE " + TABLE_SCORES_NAME + " " +
							" SET  " +
							" game_speed=" + mHighScores.getGameSpeed() + " , " +
							" num_records=" + mHighScores.getNumRecords() + " , " +
							" sound='" + new Boolean(mHighScores.isSound()).toString() + "' , " +
							" enable_jni='" + new Boolean(mHighScores.isEnableJNI()).toString() + "' , " +
							" enable_monsters='" + new Boolean(mHighScores.isEnableMonsters()).toString() + "' , " +
							" enable_collision='" + new Boolean(mHighScores.isEnableCollision()).toString() + "' " +
							" WHERE id=" + id);
	}
	
	public ContentValues getInsertScoresContentValues() {
		ContentValues mValues = new ContentValues();
		mValues.put("new_record", "false");
		mValues.put("name", mHighScores.getName());
		mValues.put("level", mHighScores.getLevel());
		mValues.put("score", mHighScores.getScore());
		mValues.put("lives", mHighScores.getLives());
		mValues.put("cycles", mHighScores.getCycles());
		mValues.put("save", mHighScores.getSave1());
		mValues.put("game_speed", mHighScores.getGameSpeed());
		mValues.put("num_records", mHighScores.getNumRecords());
		mValues.put("sound", new Boolean(mHighScores.isSound()).toString());
		mValues.put("enable_jni", new Boolean(mHighScores.isEnableJNI()).toString());
		mValues.put("enable_monsters", new Boolean(mHighScores.isEnableMonsters()).toString());
		mValues.put("enable_collision", new Boolean(mHighScores.isEnableCollision()).toString());
		
		return mValues;
	}
	
	public ArrayList<High> getGameHighList(int num) {
		ArrayList<High> mList = new ArrayList<High>();
		mOpenHelper = new ScoreOpenHelper(mContext);
		
		try {
    		mDatabase.close();
    	}
    	catch (NullPointerException e) {
    		//Log.e("Awesomeguy", "Null Pointer mDatabase");
    	}
		
		mDatabase = mOpenHelper.getReadableDatabase();
		//Cursor c;
		mGameHighC = mDatabase.rawQuery(this.getSelectAllHighRecordsString(), null);
		
		if (mGameHighC.getCount() == 0) return mList;
		mGameHighC.moveToFirst();
		for (int i = 0; i < mGameHighC.getCount(); i ++ ) {
			High mTempRec = new High();
			mTempRec.setKey(mGameHighC.getInt(mGameHighC.getColumnIndex("id")));
			mTempRec.setName(mGameHighC.getString(mGameHighC.getColumnIndex("name")));
			mTempRec.setScoreKey(mGameHighC.getInt(mGameHighC.getColumnIndex("score_key")));
			mTempRec.setHigh(mGameHighC.getInt(mGameHighC.getColumnIndex("high")));
			
			mTempRec.setDate(Long.parseLong((mGameHighC.getString(mGameHighC.getColumnIndex("date")))));

			mTempRec.setInternetKey(mGameHighC.getInt(mGameHighC.getColumnIndex("internet_key")));
			mTempRec.setSave(mGameHighC.getInt(mGameHighC.getColumnIndex("save")));
			
			mTempRec.setGameSpeed(mGameHighC.getInt(mGameHighC.getColumnIndex("game_speed")));
			mTempRec.setSoundOn(new Boolean(mGameHighC.getString(mGameHighC.getColumnIndex("sound"))).booleanValue());
			mTempRec.setEnableMonsters(new Boolean(mGameHighC.getString(mGameHighC.getColumnIndex("enable_monsters"))).booleanValue());
			mTempRec.setMonsterCollision(new Boolean(mGameHighC.getString(mGameHighC.getColumnIndex("enable_collision"))).booleanValue());
			
			mTempRec.setLevel(mGameHighC.getInt(mGameHighC.getColumnIndex("level")));
			mTempRec.setLives(mGameHighC.getInt(mGameHighC.getColumnIndex("lives")));
			
			
			mList.add(mTempRec);
			mGameHighC.moveToNext();
			//Log.e("Scores","____"+ mTempRec.getRecordIdNum());
			
		}
		mGameHighC.close();
		mDatabase.close();
		return mList;
	}
	
	public void insertHighInTableIfRanks(Record mHighScores) {
		String query = new String();
		High mLowestScore = new High();
		//SharedPreferences preferences = mContext.getSharedPreferences(Options.AWESOME_NAME, Context.MODE_PRIVATE);
		
		ArrayList<High> test = this.getGameHighList(0); 
		if (test.size() > 0) {
			mLowestScore = test.get(test.size() - 1);
		}
		
		if (mHighScores.getScore() > mLowestScore.getHigh() || test.size() < mHighScores.getNumRecords()) {
			mOpenHelper = new ScoreOpenHelper(mContext);
			SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
			
			
			query = this.getInsertHighString(mHighScores, mHighScores.getRecordIdNum());
			//Cursor c;
			mHighInTableC = mDatabase.rawQuery(query, null);
			int i = mHighInTableC.getCount();
			//Log.e("Scores","setting old score number <----------------" + mHighScores.getRecordIdNum())	;
			mHighInTableC.close();
				
			
			mDatabase.close();
		}
	}
	
	public int pruneHighList() {
		ArrayList<Scores.High> mList = this.getGameHighList(0);
		mOpenHelper = new ScoreOpenHelper(mContext);
		SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
		int num = 0;
		if (50 < mList.size()) {
			num = mList.size() - 50;
			for (int i = mHighScores.getNumRecords(); i < mList.size(); i ++) {
				int j = mList.get(i).getKey();
				//Cursor c;
				mPruneHighC = mDatabase.rawQuery("DELETE FROM "+ TABLE_HIGHS_NAME + " WHERE id=" + j, null);
				mPruneHighC.getCount();
				mPruneHighC.close();
				//Log.e("scores", "REMOVE RECORD " + j + "<--------------");
				//mList.get(i).listInLog();
			}
		}
		mDatabase.close();
		return num;
		
	}
	
	public String getSelectAllHighRecordsString() {
		return new String("SELECT * FROM " + TABLE_HIGHS_NAME +" ORDER BY high DESC");
	}
	
	public String getInsertHighString(Record mHighScores, int mScoreKey) {
		return new String (
				"INSERT INTO " +
				TABLE_HIGHS_NAME +
				" ( " +
				" name, " +
				" score_key, " +
				" high, " +
				" date, " +
				" internet_key, " +
				" save, " +
				" game_speed, " +
				" sound, " +
				" enable_monsters, " +
				" enable_collision " +
				" ) " +
				" VALUES " +
				" ( " +
				" \"" + mHighScores.getName() + "\", " +
				mScoreKey + ", " +
				mHighScores.getScore() + ", " +
				" \"" + System.currentTimeMillis() + "\", " +
				0 + ", " + // internet_key
				0 + ", " + // save
				mHighScores.getGameSpeed() + ", " +
				" \"" + new Boolean(mHighScores.isSound()).toString() + "\", " +
				" \"" + new Boolean(mHighScores.isEnableMonsters()).toString() + "\", " +
				" \"" + new Boolean(mHighScores.isEnableCollision()).toString() + "\" " + 
				" ) ");
	}
	
	
	public static class ScoreOpenHelper extends SQLiteOpenHelper {
		ScoreOpenHelper(Context context) {
			super(context, DATABASE_NAME, null, DATABASE_VERSION);
		}

		@Override
		public void onCreate(SQLiteDatabase db) {
			db.execSQL(getCreatePlayerTableString());
			db.execSQL(getCreateHighsTableString());
		}
		
		@Override
		public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
			//Log.w("Scores", "Upgrading database, this will drop tables and recreate.");
			db.execSQL("DROP TABLE IF EXISTS " + TABLE_SCORES_NAME);
			db.execSQL("DROP TABLE IF EXISTS " + TABLE_HIGHS_NAME);
			onCreate(db);
		}
		
		public String getCreatePlayerTableString() {
			return new String(
					" CREATE TABLE " +
					TABLE_SCORES_NAME + " " +
					" ( id INTEGER PRIMARY KEY , " +
					" new_record TEXT , " +
					" name TEXT , " +
					" level INTEGER , " +
					" score INTEGER , " +
					" lives INTEGER , " +
					" cycles INTEGER , " +
					" save INTEGER , " +
					" game_speed INTEGER , " +
					" num_records INTEGER , " +
					" sound TEXT , " +
					" enable_jni TEXT , " +
					" enable_monsters TEXT , " +
					" enable_collision TEXT  " +
					" ) "
					);
		}
		
		public String getCreateHighsTableString() {
			return new String (
					" CREATE TABLE " +
					TABLE_HIGHS_NAME + " " + 
					" ( id INTEGER PRIMARY KEY , " +
					" name TEXT , " +
					" score_key INTEGER , " +
					" high INTEGER , " +
					" date TEXT , " +
					" internet_key INTEGER, " +
					" save INTEGER , " +
					
					" level INTEGER , " +
					" lives INTEGER , " +
					
					" game_speed INTEGER , " +
					" sound TEXT , " +
					" enable_monsters TEXT , " +
					" enable_collision TEXT  " +
					" ) "
					);
		}
		
		
		
	}
	

	
	public static class High {
		private int mKey;
		private String mName;
		private int mScoreKey;
		private int mHigh;
		private long mDate;
		private int mInternetKey;
		private int mSave;
		
		private int mLevel;
		private int mLives;
		
		private int mGameSpeed;
		private boolean mSoundOn;
		private boolean mEnableMonsters;
		private boolean mMonsterCollision;
		
		public High () {
			mKey = 0;
			mName = "anonymous";
			mScoreKey = 0;
			mHigh = 0;
			mDate = System.currentTimeMillis();
			mInternetKey = 0;
			mSave = 0;
			
			mLives = 0;
			mLevel = 0;
			
			mGameSpeed = 0;
			mSoundOn = true;
			mEnableMonsters = true;
			mMonsterCollision = true;
		}

		public int getKey() {
			return mKey;
		}

		public void setKey(int mKey) {
			this.mKey = mKey;
		}

		public String getName() {
			return mName;
		}

		public void setName(String mName) {
			this.mName = mName;
		}

		public int getScoreKey() {
			return mScoreKey;
		}

		public void setScoreKey(int mScoreKey) {
			this.mScoreKey = mScoreKey;
		}

		public int getHigh() {
			return mHigh;
		}

		public void setHigh(int mHigh) {
			this.mHigh = mHigh;
		}

		public long getDate() {
			return mDate;
		}

		public void setDate(long mDate) {
			this.mDate = mDate;
		}

		public int getInternetKey() {
			return mInternetKey;
		}

		public void setInternetKey(int mInternetKey) {
			this.mInternetKey = mInternetKey;
		}

		public int getSave() {
			return mSave;
		}

		public void setSave(int mSave) {
			this.mSave = mSave;
		}

		public int getGameSpeed() {
			return mGameSpeed;
		}

		public void setGameSpeed(int mGameSpeed) {
			this.mGameSpeed = mGameSpeed;
		}

		public boolean isSoundOn() {
			return mSoundOn;
		}

		public void setSoundOn(boolean mSoundOn) {
			this.mSoundOn = mSoundOn;
		}

		public boolean isEnableMonsters() {
			return mEnableMonsters;
		}

		public void setEnableMonsters(boolean mEnableMonsters) {
			this.mEnableMonsters = mEnableMonsters;
		}

		public boolean isMonsterCollision() {
			return mMonsterCollision;
		}

		public void setMonsterCollision(boolean mMonsterCollision) {
			this.mMonsterCollision = mMonsterCollision;
		}

		public int getLevel() {
			return mLevel;
		}

		public void setLevel(int mLevel) {
			this.mLevel = mLevel;
		}

		public int getLives() {
			return mLives;
		}

		public void setLives(int mLives) {
			this.mLives = mLives;
		}
		
		
	}
}
