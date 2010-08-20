package org.davidliebman.android.awesomeguy;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.Window;
import android.widget.ImageView;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.content.Intent;
import android.os.Bundle;

public class SplashScreen extends Activity {
    protected boolean mActive = true;
    protected int mSplashTime = 20000;
    
    private Scores.Record mHighScores;
    
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.splashscreen);
       
        mHighScores = new Scores.Record();
        Bundle r = new Bundle();
        r.putParcelable("awesomeguy", mHighScores);
        
        // Always these three intents together??!!
        Intent i = new Intent(this, Options.class);
        i.putExtras(r);
        
        Intent j = new Intent(this, Players.class);
        j.putExtras(r);
        
        Intent k = new Intent(this, GameStart.class);
        k.putExtras(k);
        
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