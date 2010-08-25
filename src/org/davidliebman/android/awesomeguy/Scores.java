package org.davidliebman.android.awesomeguy;


import android.util.Log;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteStatement;
import android.util.Log;

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
