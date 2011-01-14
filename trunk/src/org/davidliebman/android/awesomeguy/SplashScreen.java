package org.davidliebman.android.awesomeguy;

import com.google.android.apps.analytics.GoogleAnalyticsTracker;
import android.util.Log;
import android.app.Activity;
import android.database.sqlite.SQLiteDatabase;
import android.content.Intent;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.Window;
import android.content.*;
import android.content.pm.*;
import android.content.pm.PackageManager.NameNotFoundException;

public class SplashScreen extends Activity {
    protected boolean mActive = true;
    protected int mSplashTime = 20000;
    private boolean mRememberPlayer;
    private boolean mGoogleAnalytics;
    private boolean mTermsOfService;
    private int mVersionCode = 1;
    public static final String AWESOME_NAME = new String("org.awesomeguy");
    public static final String UA_NUMBER = new String("UA-19479622-2");
    
    private Record mHighScores;
    private Scores.ScoreOpenHelper mScoresHelper;
    private Scores mScores;
    private SQLiteDatabase db;
    
    GoogleAnalyticsTracker tracker;
    
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
        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mRememberPlayer = preferences.getBoolean(Options.SAVED_REMEMBER_PLAYER, false);
        mHighScores = new Record();

        if(!mRememberPlayer) {
        	mHighScores.addToPreferences(preferences);
        }
        else {
        	mHighScores.getFromPreferences(preferences);
        }
        
        /* if 'anonymous' then blank out record. */
        if(mHighScores.getName().contentEquals(new Record().getName())) {
        	mHighScores = new Record();
        }
        
        /* get TOS info from preferences */
        mGoogleAnalytics = preferences.getBoolean(Options.SAVED_ANALYTICS, true);
        mTermsOfService = preferences.getBoolean(Options.SAVED_TOS, false);
        
        /* check version / show TermsOfService.java */
        PackageManager mManager = this.getPackageManager();
        try {
        	PackageInfo mInfo = mManager.getPackageInfo("org.davidliebman.android.awesomeguy", 0);
        	mVersionCode = mInfo.versionCode;
        }
        catch (NameNotFoundException e) {
        	// not a big deal if Package Manager 
        	// doesn't find the version code.
        	mVersionCode = 1;
        }
        /* if game was just updated, show TOS page. */
        if (preferences.getInt(Options.SAVED_VERSIONCODE, 1) != mVersionCode) {
        	mTermsOfService = false;
        	
        }
        
        /* google analytics tracker */
        tracker = GoogleAnalyticsTracker.getInstance();
        tracker.start(UA_NUMBER, this);
        if (mGoogleAnalytics) {
            tracker.trackPageView("/SplashScreen");
            tracker.dispatch();
            //Log.d("Awesomeguy","Google Analytics-----------------");
        }
        
        /* reset preferences so that game starts with room 1 */
        /* save most recent version code */
        SharedPreferences.Editor e = preferences.edit();
        e.putInt(Options.SAVED_ROOM_NUM, 1);
        e.putInt(Options.SAVED_VERSIONCODE, mVersionCode);
        e.commit();
        
        /* init scores object */
        mScores = new Scores(this, mHighScores);
        
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
                    if (! mTermsOfService ) {
                    	startActivity(new Intent(SplashScreen.this,TermsOfService.class));
                    	
                    }
                    else {
                    	startActivity(new Intent("org.davidliebman.android.awesomeguy.Menu"));
                    }
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
    
    @Override
    protected void onDestroy() {
    	super.onDestroy();
    	tracker.stop();
    }
}