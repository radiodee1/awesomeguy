package org.davidliebman.android.awesomeguy;


import android.util.Log;
import android.content.Context;
import android.content.ContentValues;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteStatement;
//import android.util.Log;
import java.util.*;

public class Scores {
	private static final String DATABASE_NAME = "AwesomeguyScores.db";
	private static final int DATABASE_VERSION = 15;
	private static final String TABLE_SCORES_NAME = "scores";
	private static final String TABLE_HIGHS_NAME = "highs";
	
	private SQLiteDatabase mDatabase;
	private ScoreOpenHelper mOpenHelper;
	public Context mContext;
	public Record mHighScores;
	
	public Scores (Context context, Record highScores) {
		mContext = context;
		mOpenHelper = new ScoreOpenHelper(mContext);
		mHighScores = highScores;
	}
	public void setHighScores(Record highScores) {
		mHighScores = highScores;
	}
	
	
	public ArrayList<Record> getHighScorePlayerList(int num) {
		// NOTE: if 'num' is negative, all records are returned
		ArrayList<Record> mList = new ArrayList<Record>();
		mOpenHelper = new ScoreOpenHelper(mContext);
		mDatabase = mOpenHelper.getReadableDatabase();
		Cursor c;
		if (num < 0 ) {
			c = mDatabase.rawQuery(this.getSelectAllRecordsString(), null);
		}
		else {
			c = mDatabase.rawQuery(this.getSelectNumOfRecordsString(num), null);
		}
		if (c.getCount() == 0) return mList;
		c.moveToFirst();
		for (int i = 0; i < c.getCount(); i ++ ) {
			//Log.d("Scores","_id" + c.getColumnIndex("_id"));
			//Log.d("Scores","id" + c.getColumnIndex("id"));
			Record mTempRec = new Record();
			mTempRec.setRecordIdNum(c.getInt(c.getColumnIndex("id")));
			mTempRec.setNewRecord(new Boolean(c.getString(c.getColumnIndex("new_record"))).booleanValue());//TODO: should I change this to 'false'??
			mTempRec.setName(c.getString(c.getColumnIndex("name")));
			mTempRec.setLevel(c.getInt(c.getColumnIndex("level")));
			mTempRec.setScore(c.getInt(c.getColumnIndex("score")));
			mTempRec.setLives(c.getInt(c.getColumnIndex("lives")));
			mTempRec.setCycles(c.getInt(c.getColumnIndex("cycles")));
			mTempRec.setSave1(c.getInt(c.getColumnIndex("save")));
			mTempRec.setGameSpeed(c.getInt(c.getColumnIndex("game_speed")));
			mTempRec.setNumRecords(c.getInt(c.getColumnIndex("num_records")));
			mTempRec.setSound(new Boolean(c.getString(c.getColumnIndex("sound"))).booleanValue());
			mTempRec.setEnableJNI(new Boolean(c.getString(c.getColumnIndex("enable_jni"))).booleanValue());
			mTempRec.setEnableMonsters(new Boolean(c.getString(c.getColumnIndex("enable_monsters"))).booleanValue());
			mTempRec.setEnableCollision(new Boolean(c.getString(c.getColumnIndex("enable_collision"))).booleanValue());
			mList.add(mTempRec);
			c.moveToNext();
			//Log.e("Scores","____"+ mTempRec.getRecordIdNum());
			
		}
		c.close();
		mDatabase.close();
		return mList;
	}
	
	public void insertRecordIfRanks(Record mHighScores) {
		this.insertHighInTableIfRanks(mHighScores);
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
				
				/* the record id and 'new_record' fields have changed, so we put them in shared preferences */
				//mHighScores.addToPreferences(preferences);
				
				Log.e("Scores", "setting new record number <-------------- "+ i);
				//mHighScores.listInLog();
				
			}
			else  {
				query = this.getUpdateScoreLevelString(mHighScores.getRecordIdNum());
				Cursor c = mDatabase.rawQuery(query, null);
				int i = c.getCount();
				Log.e("Scores","setting old score number <----------------" + mHighScores.getRecordIdNum())	;
				c.close();
				
			}
			mDatabase.close();
		}
	}
	
	public void updateNumOfRecords(int idnum) {
		mOpenHelper = new ScoreOpenHelper(mContext);
		SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
		Cursor c = mDatabase.rawQuery(this.getUpdateNumOfRecordsString(idnum), null);
		c.getCount();
		c.close();
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
			Cursor c = mDatabase.rawQuery(this.getUpdateOptionsString(idnum), null);
			c.getCount();
			c.close();
			mDatabase.close();
		}
		Log.e("Scores", "at Options save");
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
				Cursor c = mDatabase.rawQuery("DELETE FROM "+ TABLE_SCORES_NAME + " WHERE id=" + j, null);
				c.getCount();
				c.close();
				Log.e("scores", "REMOVE RECORD " + j + "<--------------");
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
		mDatabase = mOpenHelper.getReadableDatabase();
		Cursor c;
		c = mDatabase.rawQuery(this.getSelectAllHighRecordsString(), null);
		/*
		if (num < 0 ) {
			c = mDatabase.rawQuery(this.getSelectAllRecordsString(), null);
		}
		else {
			c = mDatabase.rawQuery(this.getSelectNumOfRecordsString(num), null);
		}
		*/
		if (c.getCount() == 0) return mList;
		c.moveToFirst();
		for (int i = 0; i < c.getCount(); i ++ ) {
			High mTempRec = new High();
			mTempRec.setKey(c.getInt(c.getColumnIndex("id")));
			mTempRec.setName(c.getString(c.getColumnIndex("name")));
			mTempRec.setScoreKey(c.getInt(c.getColumnIndex("score_key")));
			mTempRec.setHigh(c.getInt(c.getColumnIndex("high")));
			
			mTempRec.setDate(Long.parseLong((c.getString(c.getColumnIndex("date")))));

			mTempRec.setInternetKey(c.getInt(c.getColumnIndex("internet_key")));
			mTempRec.setSave(c.getInt(c.getColumnIndex("save")));
			mList.add(mTempRec);
			c.moveToNext();
			//Log.e("Scores","____"+ mTempRec.getRecordIdNum());
			
		}
		c.close();
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
			
			
			query = this.getInsertHighString(mHighScores, 0);
			Cursor c = mDatabase.rawQuery(query, null);
			int i = c.getCount();
			//Log.e("Scores","setting old score number <----------------" + mHighScores.getRecordIdNum())	;
			c.close();
				
			
			mDatabase.close();
		}
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
				" save " +
				" ) " +
				" VALUES " +
				" ( " +
				mHighScores.getName() + ", " +
				mScoreKey + ", " +
				mHighScores.getScore() + ", " +
				System.currentTimeMillis() + ", " +
				0 + ", " +
				0 + ", " +
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
			Log.w("Scores", "Upgrading database, this will drop tables and recreate.");
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
					" save INTEGER " +
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
		
		public High () {
			mKey = 0;
			mName = "anonymous";
			mScoreKey = 0;
			mHigh = 0;
			mDate = System.currentTimeMillis();
			mInternetKey = 0;
			mSave = 0;
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
		
	}
}
