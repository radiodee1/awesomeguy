package org.davidliebman.android.awesomeguy;


import android.util.Log;
import android.content.Context;
import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteStatement;
import android.util.Log;
import java.util.*;

public class Scores {
	private static final String DATABASE_NAME = "AwesomeguyScores.db";
	private static final int DATABASE_VERSION = 5;
	private static final String TABLE_NAME = "scores";
	
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
	public void test() {
		
		mDatabase = mOpenHelper.getWritableDatabase();

		for (int i = 0; i < 5; i ++ ) {
			mDatabase.execSQL(
					this.getInsertString(TABLE_NAME));

		}
		mDatabase.close();
	}
	
	public ArrayList<Record> getHighScoreList(int num) {
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
			mTempRec.setNewRecord(new Boolean(c.getString(c.getColumnIndex("new_record"))).booleanValue());
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
			//Log.d("Scores","____");
		}
		c.close();
		mOpenHelper.close();
		mDatabase.close();
		return mList;
	}
	
	public void insertRecordIfRanks() {
		String query = new String();
		Record mLowestScore = new Record();

		ArrayList<Record> test = this.getHighScoreList(mHighScores.getNumRecords());
		if (test.size() > 0) {
			mLowestScore = test.get(test.size() - 1);
		}
		
		if(mHighScores.isNewRecord()){
			query = this.getInsertString(TABLE_NAME);
		}
		else {
			query = this.getUpdateScoreLevelString(mHighScores.getRecordIdNum());
		}
		
		if (mHighScores.getScore() > mLowestScore.getScore() || test.size() < mHighScores.getNumRecords()) {
			mOpenHelper = new ScoreOpenHelper(mContext);
			SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
			
			
		
			if(mHighScores.isNewRecord()) {
				//set new record to false
				//set ID Num
				long i = mDatabase.insert(TABLE_NAME, null, this.getInsertContentValues());
				
				
				mHighScores.setRecordIdNum((int)i);
				mHighScores.setNewRecord(false);
				Log.d("Scores", "setting new record number <--------------");
				//mHighScores.listInLog();
				
			}
			else  {
				Cursor c = mDatabase.rawQuery(query, null);
				int i = c.getCount();
	
				c.close();
				
			}
			mDatabase.close();
		}
	}
	
	public void pruneScoresList() {
		ArrayList<Record> mList = this.getHighScoreList(-1);
		mOpenHelper = new ScoreOpenHelper(mContext);
		SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
		if (mHighScores.getNumRecords() < mList.size()) {
			for (int i = mHighScores.getNumRecords(); i < mList.size(); i ++) {
				int j = mList.get(i).getRecordIdNum();
				Cursor c = mDatabase.rawQuery("DELETE FROM "+ TABLE_NAME + " WHERE id=" + j, null);
				c.getCount();
				c.close();
				//Log.d("scores", "REMOVE RECORD " + j + "<--------------");
				//mList.get(i).listInLog();
			}
		}
		mDatabase.close();
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
							" \"" + false + "\"  , " + //new_record
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
							TABLE_NAME + " " +
							" ORDER BY score DESC LIMIT " + num +
							" ");
	}
	
	public String getSelectAllRecordsString() {
		return new String("SELECT * FROM " + TABLE_NAME +" ORDER BY score DESC");
	}
	
	public String getUpdateScoreLevelString(int id) {
		return new String("UPDATE " + TABLE_NAME + " " +
							" SET score=" + mHighScores.getScore() + " , " +
							" level=" + mHighScores.getLevel() + " " + 
							" WHERE id=" + id);
	}
	
	public ContentValues getInsertContentValues() {
		ContentValues mValues = new ContentValues();
		mValues.put("new_record", new Boolean(mHighScores.isNewRecord()).toString());
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
	
	public static class ScoreOpenHelper extends SQLiteOpenHelper {
		ScoreOpenHelper(Context context) {
			super(context, DATABASE_NAME, null, DATABASE_VERSION);
		}

		@Override
		public void onCreate(SQLiteDatabase db) {
			db.execSQL(getCreateTableString());
		}
		
		@Override
		public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
			Log.w("Scores", "Upgrading database, this will drop tables and recreate.");
			db.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME);
			onCreate(db);
		}
		
		public String getCreateTableString() {
			return new String(
					" CREATE TABLE " +
					TABLE_NAME + " " +
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
		
	}
}
