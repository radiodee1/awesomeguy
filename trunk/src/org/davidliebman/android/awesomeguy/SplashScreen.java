package org.davidliebman.android.awesomeguy;

import android.app.Activity;
import android.database.sqlite.SQLiteDatabase;
import android.content.Intent;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.Window;
import android.content.*;

public class SplashScreen extends Activity {
    protected boolean mActive = true;
    protected int mSplashTime = 20000;
    
    public static final String AWESOME_NAME = new String("org.awesomeguy");
    
    private Record mHighScores;
    private Scores.ScoreOpenHelper mScoresHelper;
    private Scores mScores;
    private SQLiteDatabase db;
    
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.splashscreen);
       
        /* init database if not already done so */
        mScoresHelper = new Scores.ScoreOpenHelper(this);
        db = mScoresHelper.getReadableDatabase();
        db.close();
        
        
        /* one highscores record passed around for preferences */
        mHighScores = new Record();
        
        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.addToPreferences(preferences);
        
        /* reset preferences so that game starts with room 1 */
        SharedPreferences.Editor e = preferences.edit();
        e.putInt(Options.SAVED_ROOM_NUM, 1);
        e.commit();
        
        /* init scores object */
        mScores = new Scores(this, mHighScores);
        //mScores.setHighScores(mHighScores);
        //mScores.test();
        
        // thread for displaying the SplashScreen
        Thread splashTread = new Thread() {
            @Override
            public void run() {
                try {
                    int waited = 0;
                    while(mActive && (waited < mSplashTime)) {
                        sleep(10);
                        if(mActive) {
                            waited += 10;
                        }
                    }
                } catch(InterruptedException e) {
                    // do nothing
                } finally {
                    finish();
                    startActivity(new Intent("org.davidliebman.android.awesomeguy.Menu"));
                    //stop();
                    interrupt();
                }
            }
        };
        splashTread.start();
    }
    
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            mActive = false;
        }
        return true;
    }
}