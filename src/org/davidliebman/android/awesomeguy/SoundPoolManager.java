package org.davidliebman.android.awesomeguy;

import android.media.*;
import android.content.*;
//import android.util.Log;
//import java.util.*;

public class SoundPoolManager { 
    private static final String TAG = "SoundPoolSoundManager";

    private boolean enabled = true;
    private Context context;
    private SoundPool soundPool;
    private int mSoundOw, mSoundBoom, mSoundGoal, mSoundPrize;
    private boolean mPlaySounds;
    
    public static final int SOUND_BOOM = 0;
    public static final int SOUND_GOAL = 1;
    public static final int SOUND_OW = 2;
    public static final int SOUND_PRIZE = 3;
    
    public SoundPoolManager(Context context) {
            this.context = context;
    }

    public void reInit() {
            init();
    }

    public void init() {
            if (enabled) {
                    //Log.d(TAG, "Initializing new SoundPool");
                    //re-init sound pool to work around bugs
                    release();
                    soundPool = new SoundPool(2,AudioManager.STREAM_NOTIFICATION, 0);
                    this.mSoundOw = soundPool.load(context, R.raw.ow, 1);
                    this.mSoundBoom = soundPool.load(context, R.raw.boom, 1);
                    this.mSoundGoal = soundPool.load(context, R.raw.goal, 1);
                    this.mSoundPrize = soundPool.load(context, R.raw.prize, 1);
                    
                    //Log.d(TAG, "SoundPool initialized");
            }
    }

    public void release() {
            if (soundPool != null) {
                    //Log.d(TAG, "Closing SoundPool");
                    soundPool.release();
                    soundPool = null;
                    //Log.d(TAG, "SoundPool closed");
                    return;
            }
    }

    public void playSound(int sound) {
            if (soundPool != null && mPlaySounds) {
                    //Log.d(TAG, "Playing Sound " + sound);
                    AudioManager mgr = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
                    int streamVolume = mgr.getStreamVolume(AudioManager.STREAM_MUSIC);
                    
                    
                    if (sound == SOUND_BOOM) {
                    	soundPool.play(this.mSoundBoom, streamVolume, streamVolume, 1, 0, 1f);
                    }
                    if (sound == SOUND_GOAL) {
                    	soundPool.play(this.mSoundGoal, streamVolume, streamVolume, 1, 0, 1f);
                    }
                    if (sound == SOUND_OW) {
                    	soundPool.play(this.mSoundOw, streamVolume, streamVolume, 1, 0, 1f);
                    }
                    if (sound == SOUND_PRIZE) {
                    	soundPool.play(this.mSoundPrize, streamVolume, streamVolume, 1, 0, 1f);
                    }
                    
            }
    }

    public void setEnabled(boolean enabled) {
            this.enabled = enabled;
            this.mPlaySounds = enabled;
    }

} 
