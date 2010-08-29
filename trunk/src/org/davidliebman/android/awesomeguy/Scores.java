package org.davidliebman.android.awesomeguy;


import android.util.Log;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteStatement;
import android.util.Log;
import java.util.*;

public class Scores {
	private static final String DATABASE_NAME = "AwesomeguyScores.db";
	private static final int DATABASE_VERSION = 2;
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
					mHighScores.getInsertString(TABLE_NAME));

		}
		mDatabase.close();
	}
	
	public ArrayList<Record> getHighScoreList(int num) {
		ArrayList<Record> mList = new ArrayList<Record>();
		mOpenHelper = new ScoreOpenHelper(mContext);
		mDatabase = mOpenHelper.getReadableDatabase();
		Cursor c = mDatabase.rawQuery(this.getSelectNumOfRecordsString(num), null);
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
		mDatabase.close();
		return mList;
	}
	
	public void insertRecordIfRanks() {
		Log.d("insertRecordIfRanks", "here");
		String query = new String();
		if(mHighScores.isNewRecord()){
			query = mHighScores.getInsertString(TABLE_NAME);
		}
		else {
			query = this.getUpdateScoreLevelString(mHighScores.getRecordIdNum());
		}
		Log.d("insertRecordIfRanks", "-> " + query);
		ArrayList<Record> test = this.getHighScoreList(mHighScores.getNumRecords());
		Record mLowestScore = test.get(mHighScores.getNumRecords()-1);
		Log.d("insertRecordIfRanks", " lowest "+ mLowestScore.getScore());
		if (mHighScores.getScore() > mLowestScore.getScore()) {
			mOpenHelper = new ScoreOpenHelper(mContext);
			SQLiteDatabase mDatabase = mOpenHelper.getWritableDatabase();
			Cursor c = mDatabase.rawQuery(query, null);
			int i = c.getCount();
			Log.d("insertRecordIfRanks", " count from query: "+ i);

			mDatabase.close();
		}
		
	}
	
	public String getSelectNumOfRecordsString( int num ) {
		return new String ("SELECT * FROM " +
							TABLE_NAME + " " +
							" ORDER BY score DESC LIMIT " + num +
							" ");
	}
	
	public String getUpdateScoreLevelString(int id) {
		return new String("UPDATE " + TABLE_NAME + " " +
							" SET score=" + mHighScores.getScore() + " " +
							" level=" + mHighScores.getLevel() + " " + 
							" WHERE id=" + id);
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
