package org.davidliebman.android.awesomeguy;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import org.xmlpull.v1.XmlPullParserException;
import android.app.*;
import android.graphics.Canvas;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.widget.FrameLayout;
import android.widget.Toast;
import android.view.*;
import android.view.ViewGroup.LayoutParams;
import android.content.*;
import android.widget.*;
import android.inputmethodservice.KeyboardView;
import android.view.inputmethod.*;
import android.content.res.*;

//import android.util.Log;

public class GameStart extends Activity  implements KeyEvent.Callback{
	
	public static final int GAMEVALUES = 1;
	public static final int STARTLEVEL = 2;
	public static final int MOVEMENTVALUES = 3;
	public static final int INVALIDATE = 4;
	public static final int INPUTVALUES_KEYUP = 5;
	public static final int GAMESTOP = 6;
	public static final int INPUTVALUES_TRACKUP = 7;
	public static final int CONGRATS = 8;
	public static final int PLAYAGAIN = 9;
	public static final int REORIENTATION = 10;

	public static final int DIALOG_PAUSED_ID = 0;
	public static final int DIALOG_GAMEOVER_ID = 1;
	public static final int DIALOG_CONGRATS_ID = 2;
	
	
	private GameValues mGameV = new GameValues();
	private MovementValues mMovementV = new MovementValues();
	private InitBackground mBackground ;
    private FrameLayout mBotFrame;
    private InnerGameLoop mGameLoopBot;
	private InitBackground.ParseXML mParser = new InitBackground.ParseXML(this);

    
    private RelativeLayout mRLayout ;
    private TableLayout mTLayoutOuter ;
    private TableLayout mTLayout ;
    private FrameLayout mFLayoutBot ;
    private Panel mPanelBot ;
	//private GameKeys mKeysView;
    
    private View mSpaceView, mSpaceViewSecond,mSpaceViewThird;
    private TableLayout mGameRow;
    
    private RelativeLayout mRLayoutGamepad;
    
    private Configuration mConfig;
    private int panelH, panelV;
    private int screenHeight;
    private int mButtonHeight, mButtonWidth;
    private int mScrollConst = 200;
    private double mTrackballDist = 1.0;
    private int mDimensionWidth, mDimensionHeight;
    private Context mContext;
    private Bundle mBundle;
    private boolean mUseSavedBundle = false;
    private boolean mScreenOrientationChange = false;
    
    private boolean mTestLandscapeButtons = true;
    
    //private ArrayList<TouchButton> mButtonList = new ArrayList<TouchButton>();
    
	public static final String AWESOME_NAME = new String("org.awesomeguy");

    
    /* old GameLoop - variables */
    private boolean gameRunning = true;
	private boolean mLoop = true;
	private boolean mGameDeath = false;
	private boolean mPlayAgain = true;
	private Record mHighScores;
	private SpriteInfo mGuySprite;
    private Scores mScores;
    private boolean mUsedSavedRoom;
    private boolean mLookForXml;
	
	/* old GameLoop - prepare timer */
	private static long framesPerSec = 25;
	private static final long skipTicks = 1000 / framesPerSec;
	private long ticksElapsed; //, startTicks;
	private long sleepTime = 0;
	private long nextGameTick = 0;
	
	
    
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        
        requestWindowFeature(Window.FEATURE_NO_TITLE);
       
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        
        if(savedInstanceState != null) {
        	mBundle = savedInstanceState;
        	//mUseSavedBundle = true;
        }
        else {
        	mBundle = mGameV.getInitialBundle();
        	
        }
        
        this.setOrientationVars(); 
        ////////////////////////////////
        
        /* generate components for top of screen */
        mRLayout = new RelativeLayout(this) ; 
        mTLayoutOuter = new TableLayout(this);
        mTLayout = new TableLayout(this);
        mFLayoutBot = new FrameLayout(this);
        
        
        /* assemble components for top of screen */
        mRLayout.setBackgroundColor(Color.BLACK);
        if (mGameV.getScreenOrientation() != GameValues.ORIENTATION_LANDSCAPE) {
        	mRLayout.setBackgroundResource(R.drawable.background);
        }
        ViewGroup.LayoutParams mRLayoutParams = new 
        	ViewGroup.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.FILL_PARENT);//.WRAP_CONTENT);
        mRLayout.setLayoutParams(mRLayoutParams);
        mRLayout.setHorizontalGravity(Gravity.CENTER_HORIZONTAL);
        
        //try to detect size of mRLayout
        mGameV.setViewH(this.mRLayout.getHeight());
        mGameV.setViewW(this.mRLayout.getWidth());
        
        ViewGroup.LayoutParams mTLayoutOuterParams = new 
    		ViewGroup.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);//480,WRAP_CONTENT
        mTLayoutOuter.setLayoutParams(mTLayoutOuterParams);
        
        
        ViewGroup.LayoutParams mTLayoutParams = new 
    		ViewGroup.LayoutParams(mDimensionWidth, ViewGroup.LayoutParams.WRAP_CONTENT);
        mTLayout.setLayoutParams(mTLayoutParams);
        
        mGameRow = new TableLayout(this);
        ViewGroup.LayoutParams mGameRowParams = new 
			ViewGroup.LayoutParams(mDimensionWidth,panelV);
        mGameRow.setLayoutParams(mGameRowParams);
        
        ViewGroup.LayoutParams mFLayoutBotParams = new 
			ViewGroup.LayoutParams(panelH,panelV);
        mFLayoutBot.setLayoutParams(mFLayoutBotParams);
        
        /* small view to draw line between game pad and screens */
        mSpaceView = new View(this);
        mSpaceView.setBackgroundColor(Color.GRAY);
        ViewGroup.LayoutParams mSpaceLayoutParams = new 
    		ViewGroup.LayoutParams(mDimensionWidth, 2);
        mSpaceView.setLayoutParams(mSpaceLayoutParams);
        
        /* small view to draw line between game pad and screens */
        mSpaceViewSecond = new View(this);
        mSpaceViewSecond.setBackgroundColor(Color.GRAY);
        ViewGroup.LayoutParams mSpaceLayoutParamsSecond = new 
    		ViewGroup.LayoutParams(mDimensionWidth, 2);
        mSpaceViewSecond.setLayoutParams(mSpaceLayoutParamsSecond);
        
        /* small view to draw line between game pad and screens */
        mSpaceViewThird = new View(this);
        mSpaceViewThird.setBackgroundColor(Color.GRAY);
        ViewGroup.LayoutParams mSpaceLayoutParamsThird = new 
    		ViewGroup.LayoutParams(mDimensionWidth, 2);
        mSpaceViewThird.setLayoutParams(mSpaceLayoutParamsThird);
   
        
        /* generate components for game pad */
        mRLayoutGamepad = new RelativeLayout(this);
        mRLayoutGamepad.setHorizontalGravity(Gravity.CENTER_HORIZONTAL);
        
        
        this.setContentView(mRLayout);
        
        mButtonHeight = mDimensionWidth/5;//95
        mButtonWidth = mDimensionWidth/5;//95
       
        /* assemble top part of screen */
    	
        mRLayout.addView((View)mTLayoutOuter);
        mTLayoutOuter.addView((View)mTLayout);
        mTLayout.addView((View)this.mSpaceView);

        
        mTLayout.addView((View)mGameRow	);

        mGameRow.addView((View)mFLayoutBot);
        
        if (!mGameV.isDoubleScreen() || panelH == 256 * 2) {
        	
        	mGameRow.setHorizontalGravity(Gravity.CENTER_HORIZONTAL);
          
        }
        

        mTLayout.addView((View)this.mSpaceViewSecond);

        /* add gamepad to bottom of screen */
        mTLayoutOuter.addView((View)mRLayoutGamepad);
        
        /* add spaceview to bottom of gamepad */
        mTLayoutOuter.addView((View)mSpaceViewThird);
        
        
        mGameV.setSpriteStart();
        
    }
    
    
    
    @Override
    public void onPause() {
    	
    	// Stop Game Loop Thread
    	gameRunning = false;
    	Message mEndMessage = new Message();
    	mEndMessage.what = GAMESTOP;
    	mHandler.sendMessageAtFrontOfQueue(mEndMessage);
    	
    	try {
    		mGameLoopBot.join();//100
    		
    	}
    	catch (Exception e) {
    		//
       	}
    	
    	if(!mScreenOrientationChange) {
	    	// save high scores if they rank
	    	if(mHighScores.getScore() > mGameV.getOldGuyScore()) {
		    	  
		    	  mScores.insertRecordIfRanks(mHighScores);
		    	  mHighScores.setNewRecord(false);
	
		      }
	    	mScores.insertHighInTableIfRanks(mHighScores);
    	}
    	mScreenOrientationChange = false;
    	
    	//TODO: make sure records are not saved when screen is re-oriented
    	
		SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);

    	mHighScores.addToPreferences(preferences);
    	
	    super.onPause();
    }
    
    @Override
    public void onSaveInstanceState(Bundle b) {
    	mPanelBot.updateSpriteList();
    	mGameV.addToBundle(b, mMovementV);
    	
    	super.onSaveInstanceState(b);
    }
    
    @Override
    public void onRestoreInstanceState(Bundle b) {

    	super.onRestoreInstanceState(b);
    	mBundle = b;
    	
    	if(!mBundle.getBoolean(GameValues.BUNDLE_INITIAL)) {
    		mGameV.useBundleInfo(mBundle, mMovementV);
    		mUseSavedBundle = true;
    		mGameV.setXmlMode(GameValues.XML_USE_LEVEL);
    	}
    	
    	
    	if(mBundle.getInt(GameValues.BUNDLE_LAST_ORIENTATION) != mGameV.getScreenOrientation()) {
    		mScreenOrientationChange = true;
    	}
    }
    
    @Override
    public void onResume() {
        	    	
    	/* retrieve Record mHighScores */
    	mHighScores = new Record();
        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(preferences);
                
        /* retrieve other saved preferences */	
        
        mLookForXml = preferences.getBoolean(Options.SAVED_LOOK_FOR_XML, false);
        mGameV.setRoomNo(preferences.getInt(Options.SAVED_ROOM_NUM, 1));
        mGameV.setLookForXml(mLookForXml);
        
        
    	mScores = new Scores(this, mHighScores);
        
    	framesPerSec = mHighScores.getGameSpeed();
    	
    	/* init background */
    	
    	this.setOrientationVars();
    	mPanelBot = new Panel(this,  mGameV, this, mMovementV, mHighScores);
    	
    	if( mConfig.orientation == Configuration.ORIENTATION_PORTRAIT){
    		//mRLayoutGamepad.addView((View)new GamePad(this, true, mDimensionWidth));
    		mRLayoutGamepad.addView((View) 
    				new ButtonManager(this, mMovementV, mGameV, mHandler ,ButtonManager.MODE_PORTRAIT));
    	}
    	else if (mGameV.isPutGameKeys()) {
    		//mKeysView = new GameKeys(this, mGameV.getLandscapeButtonPixel(), true);
    		//mRLayoutGamepad.addView(mKeysView);
    		mRLayoutGamepad.addView((View)
    				new ButtonManager(this, mMovementV, mGameV, mHandler, ButtonManager.MODE_STRIP));
    		//TODO: check that this works on landscape AND portrait
    	}
    	
    	mBackground = new InitBackground(mGameV, this, mLookForXml);

    	mFLayoutBot.addView((View)mPanelBot);
    	
    	mPanelBot.setEnableSounds(mHighScores.isSound());
    	
    	
    	/* create game loop thread */
    	mGameLoopBot = new InnerGameLoop(this); 
    	
    	/* set loop to 'endless' */
    	mGameLoopBot.setGameRunning(true);
    	
    	this.getSavedRoom();

    	
    	/* start game loop thread */
    	mGameLoopBot.start();
    	super.onResume();
    	
    	

    }
    
    public void setOrientationVars() {

    	Display display = ((WindowManager) getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();    	
        mDimensionWidth = display.getWidth();
        mDimensionHeight = display.getHeight();
        
        mGameV.setDisplayWidth(mDimensionWidth);
        mGameV.setDisplayHeight(mDimensionHeight);
        
        mGameV.setScreenTitle((int)(mDimensionHeight * .10));
        
        mConfig = this.getResources().getConfiguration();
        
        if (mConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
        	mGameV.setScreenOrientation(GameValues.ORIENTATION_LANDSCAPE);
        }
        else {
        	mGameV.setScreenOrientation(GameValues.ORIENTATION_PORTRAIT);
        }
        
        panelH = mDimensionWidth;
        panelV = 192;
        screenHeight = display.getHeight();
        
        if(mGameV.getScreenOrientation() == GameValues.ORIENTATION_PORTRAIT) {
        	if ( screenHeight - ((192 * 2) + (mDimensionWidth/5) * 3) > 0 ) {
        		mGameV.setDoubleScreen(true);
        		
        	}
        	
        	if ( screenHeight - ((192 * mGameV.getScaleH()) + (mDimensionWidth/5) * 3) > 0 ) {
        		panelV = (int)(192 * mGameV.getScaleV());
        		panelH = mDimensionWidth;
        	}
        	
        	
        }
        else if (mGameV.getScreenOrientation() == GameValues.ORIENTATION_LANDSCAPE 
        		&& ((mConfig.keyboard != Configuration.KEYBOARD_NOKEYS &&
        		mConfig.hardKeyboardHidden == Configuration.HARDKEYBOARDHIDDEN_NO) &&
        		this.mTestLandscapeButtons == false)
        		) {
        	
        	panelH = mDimensionWidth;
        	//panelV = mDimensionHeight;
    		panelV = (int)(192 * mGameV.getScaleV());

        }
        else if (mGameV.getScreenOrientation() == GameValues.ORIENTATION_LANDSCAPE && this.mTestLandscapeButtons) {
        	//put screen with touch buttons
        	mGameV.setPutGameKeys(true);
        	panelV = (int) (192 * mGameV.getScaleV());
        }
        
        
        mGameV.setDisplayWidth(mDimensionWidth);
        ////////////////////////////////
        
    }
    
    public void closeSoftKeyboard(View v) {
    	InputMethodManager inputManager = (InputMethodManager)this.getSystemService(Context.INPUT_METHOD_SERVICE);
    	inputManager.hideSoftInputFromWindow(v.getApplicationWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
    }
    
    
    /** Start key listener overrides **/

    
	@Override
	public boolean onKeyDown( int keyCode, KeyEvent event) {
		//this.closeSoftKeyboard((View)this.getCurrentFocus());
		
		if (keyCode == KeyEvent.KEYCODE_BACK ){
			
			finish();
		}
		//super(keyCode, event);
		if(keyCode == KeyEvent.KEYCODE_A || keyCode == KeyEvent.KEYCODE_DPAD_LEFT) {
			mMovementV.setKeyInput(MovementValues.KEY_LEFT);
	    	mPanelBot.readKeys(mTrackballDist);
	    	
		}
		if(keyCode == KeyEvent.KEYCODE_S || keyCode == KeyEvent.KEYCODE_DPAD_RIGHT) {
			mMovementV.setKeyInput(MovementValues.KEY_RIGHT);
	    	mPanelBot.readKeys(mTrackballDist);
	   
		}
		if(keyCode == KeyEvent.KEYCODE_D || keyCode == KeyEvent.KEYCODE_DPAD_UP) {
			
	    	mMovementV.setKeyInput(MovementValues.KEY_UP);
	    	mPanelBot.readKeys(mTrackballDist);
	    	
		}
		if(keyCode == KeyEvent.KEYCODE_F || keyCode == KeyEvent.KEYCODE_DPAD_DOWN) {

	    	mMovementV.setKeyInput(MovementValues.KEY_DOWN);
	    	mPanelBot.readKeys(mTrackballDist);
	    	
			
		}
		if(keyCode == KeyEvent.KEYCODE_SPACE || keyCode == KeyEvent.KEYCODE_DPAD_CENTER) {
			mPanelBot.setKeyB(true);
			
		}
		
		return super.onKeyDown(keyCode, event);
	}


	
	@Override
	public boolean onKeyUp( int keyCode, KeyEvent event) {
		//this.closeSoftKeyboard((View)this.getCurrentFocus());

		
		//super(keyCode, event);
		if(keyCode == KeyEvent.KEYCODE_A || keyCode == KeyEvent.KEYCODE_DPAD_LEFT) {
			mMovementV.clearKeys();
			mPanelBot.readKeys(0);
			
		}
		if(keyCode == KeyEvent.KEYCODE_S || keyCode == KeyEvent.KEYCODE_DPAD_RIGHT) {
			mMovementV.clearKeys();
			mPanelBot.readKeys(0);
			
			
		}
		if(keyCode == KeyEvent.KEYCODE_D || keyCode == KeyEvent.KEYCODE_DPAD_UP) {
			
			mMovementV.clearKeys();
			mPanelBot.readKeys(0);
			
		}
		if(keyCode == KeyEvent.KEYCODE_F || keyCode == KeyEvent.KEYCODE_DPAD_DOWN) {
			mMovementV.clearKeys();
			mPanelBot.readKeys(0);
			
			
		}
		if(keyCode == KeyEvent.KEYCODE_SPACE || keyCode == KeyEvent.KEYCODE_DPAD_CENTER) {
			mPanelBot.setKeyB(true);
			
		}
		return true;
	}
	
	

    
    
    public Handler mHandler = new Handler() {
    	public void handleMessage(Message msg) {
    		if(msg.what == GAMEVALUES) {
    		
	    		mPanelBot.invalidate();
	       		
    		}
    		else if(msg.what == STARTLEVEL) {
    			
    			this.removeMessages(MOVEMENTVALUES);
    			this.removeMessages(GAMEVALUES);
    			this.removeMessages(INPUTVALUES_KEYUP);
    			    			
    		    mPanelBot.setAnimationOnly(false);
    		    mPanelBot.setJNIAnimateOnly(0); // '0' is false for JNI
    		    
    		    mPanelBot.setInitialBackgroundGraphics();
    		    mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    		    mPanelBot.setGuySprite(mGameV.getSpriteStart()); //must refresh reference to guySprite
    		    
    			
    			mPanelBot.invalidate();
    			
    		}
    		else if (msg.what == REORIENTATION) {
    			
    			this.removeMessages(MOVEMENTVALUES);
    			this.removeMessages(GAMEVALUES);
    			this.removeMessages(INPUTVALUES_KEYUP);
    			 
        		mGameV.useBundleInfo(mBundle, mMovementV);
    			
    		    mPanelBot.setAnimationOnly(false);
    		    mPanelBot.setJNIAnimateOnly(0); // '0' is false for JNI
    		    
    		    
    		    mPanelBot.setReturnBackgroundGraphics();
    		    mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    		    mPanelBot.setGuySprite(mGameV.getSpriteStart()); //must refresh reference to guySprite

    		    
    			
    			mPanelBot.invalidate();
    			
    			
    		}
    		else if(msg.what == MOVEMENTVALUES) {
    			mPanelBot.setHighScores((Record)msg.obj);
    			
    			mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    			
    			if (mMovementV.getLetterKeyB() > 0) mPanelBot.setKeyB(true);
    			else mPanelBot.setKeyB(false);
    			
    			mPanelBot.invalidate();
    			
    		}
    		
    		else if(msg.what == INPUTVALUES_TRACKUP) {
    			mMovementV.clearKeys();
    			mPanelBot.readKeys(0);
    			//Log.v("Handler", "Keyup " );
    		}
    		
    		
    		else if (msg.what == GAMESTOP) {
    			//do something here?
    	    	mPanelBot.setAnimationOnly(true);
    	    	mPanelBot.setJNIAnimateOnly(1); // '1' is true for JNI
    	    	mPanelBot.invalidate();
    			this.removeMessages(MOVEMENTVALUES);
    			this.removeMessages(GAMEVALUES);
    			this.removeMessages(INPUTVALUES_KEYUP);
    			this.removeMessages(INPUTVALUES_TRACKUP);
    			mMovementV.clearKeys();
    			
    		}
    		else if (msg.what == CONGRATS) {
    			//This displays the end-of-level dialog box.
    			showDialog(GameStart.DIALOG_CONGRATS_ID);
    			
    		}
    		else if (msg.what == PLAYAGAIN) {
    			//This displays the end-of-GAME dialog box.
        		Toast.makeText(GameStart.this, "PLAY AGAIN!!" , Toast.LENGTH_LONG).show();
    			
    		}
    		

    		
    		else super.handleMessage(msg);
    		
    	}
    
    };
    
    
    
    class InnerGameLoop extends Thread {
    	//private SoundPoolManager mSounds;

    	public InnerGameLoop (GameStart game) {
    		//Log.v("InnerGameLoop", "init");
    		
    	}
    	
    	@Override
    	public void run() {
    		
    		gameRunning = true;
    		//prepare timer
    		Date startDate = new Date();
    		nextGameTick = startDate.getTime();
    		
    		boolean mSavedRoomFlag = false;
			
    		
    		
    		  ///////////////////////////////////////////////////////
    		  // PLAY THE GAME
    		  while(mPlayAgain && gameRunning) {
    		    mPlayAgain = false;
    		
    		  //do something here.
    		    
    			
    			// new score ?? SAVE OLD SCORE!!
    		    mGameV.setOldGuyScore(mHighScores.getScore());
    			
    		    ////////////////////////////////////////////////////////
    		    // PREP FOR GAME PLAY
    		    // set lives
    		    
    		    if (!mUseSavedBundle) mGameV.setLives(3);
    		    // set room num
    		    
    		    if (mSavedRoomFlag == true) mGameV.setRoomNo(1);
    		    mSavedRoomFlag = true;
    		    
    		    //getSavedRoom();
    		    
    		    if (!mUseSavedBundle) mGameV.setScore(10);
    		    
    		    mGameV.setEndGame(false);
    		    
    		    while(mGameV.getRoomNo() <= mGameV.getLevelList().size()  && !mGameV.isEndGame() && gameRunning && mGameV.getLives() > 0) {

       
    		     // advance through rooms

    		      
    		    if (!mUseSavedBundle) {
    		    	mHandler.sendEmptyMessage(GameStart.STARTLEVEL);
    		    }
    		    else {
    		    	mHandler.sendEmptyMessage(GameStart.REORIENTATION);
    		    }
    		    
    		    
        		mHandler.removeMessages(GameStart.MOVEMENTVALUES);

    		    //init room
    		    mBackground.setLevel(mGameV.getLevelList().getNum(mGameV.getRoomNo()-1));

    		    if (!mUseSavedBundle) {
    		    	mMovementV.setScrollX(0);
    		    	mMovementV.setScrollY(0);
    		    	
    		    	mBackground.initLevel(mMovementV);
    		    
    		    	//jni  !!
    		    
    		    	mPanelBot.setLevelData(mGameV.getLevelArray(), mGameV.getObjectsArray(), mGameV.getMapH(), mGameV.getMapV());
    		    
    		    	mPanelBot.addMonstersJNI();
    		    	mPanelBot.addPlatformsJNI();
    		    }
    		    
    		    
		    	//mPanelBot.setLevelData(mGameV.getLevelArray(), mGameV.getObjectsArray(), mGameV.getMapH(), mGameV.getMapV());

    		    
    		    //end of restore from bundle
    		    mUseSavedBundle = false;
    		    mGameV.setXmlMode(GameValues.XML_USE_BOTH);
    		    
    		    //get guy sprite reference 
    			mGuySprite = mGameV.getSpriteStart();
    		    mPanelBot.setGuySprite(mGuySprite);
    	    	
    		    //
    			
    		    mGameV.setEndLevel(false);
    		    mGameV.setGameDeath(false);
    		    
    			mLoop = true;
    		    while(mLoop && gameRunning && !mGameV.isEndLevel()) { // GAME PLAY LOOP
    		       
    		    	if (gameRunning) gameSpeedRegulator(); //call inside 'game play' loop
    		    	
    		    
    		    	
    		    	// ** ALWAYS SEND THIS MESSAGE **	
    		    	Message mM = new Message();
    		    	mM.what = GameStart.MOVEMENTVALUES;
    		    	mM.obj = mHighScores;
    		    	mHandler.sendMessageAtFrontOfQueue(mM);
    				
        			
    		    } // end of gameplay loop

    		   
    		    
    	    	mHandler.sendEmptyMessage(GameStart.GAMESTOP);
    		    // *** ANIMATE SPINNING GUY ***
    	    	if (gameRunning) {
    	    		try {
    	    			Thread.sleep(1000);
    	    		} catch (InterruptedException e) {
    	    			//
    	    		} 
    	    	}
    		      // ** CHECK IF LEVEL IS OVER ***
    		      // * advance the room count if it is
    		      // * necessary.
    		      //
    		      if (!mGameV.isGameDeath()) {
    		        mGameV.incrementRoomNo();
    		        
    		        //saveRoomNo();

    		        mGameV.setEndGame(false);
    		        mGameV.setEndLevel(false);
    		      }
    		      else {
    		        mGameV.setEndLevel(true);
    		      }
    		      
    		     
    		      // increment cycle count and set room to 1...
    		      if( mGameV.getRoomNo() > mGameV.getTotNumRooms() &&  !mGameV.isEndLevel() ) {
    		        
    		    	  mGameV.setRoomNo(1);
    		    	  //saveRoomNo();

    		      }

    		      
    		      if (!mGameV.isGameDeath() && gameRunning ) {
    		    	  mHandler.sendEmptyMessage(GameStart.CONGRATS);
    		    	  
    		      }
    		      
    		    } /////////// while NUM_ROOMS loop

    		    if (gameRunning) {
    		    	mHandler.sendEmptyMessage(GameStart.PLAYAGAIN);
    		    	
    		    	// this basically saves high scores...
      		      	// duplicated in 'onPause()'
	      		      if(mHighScores.getScore() > mGameV.getOldGuyScore()) {
	      		    	  
	      		    	  mScores.insertRecordIfRanks(mHighScores);
	      		    	  mHighScores.setNewRecord(false);
	      		    	  mGameV.setOldGuyScore(mHighScores.getScore());
	
	      		      }
      		        mScores.insertHighInTableIfRanks(mHighScores);

    		    	
    		    }
    		    
    		    
    		    mPlayAgain = true;

    		  } // playAgain

    		

    	}
    	
    	public void setGameRunning(boolean isRunning) {
    		gameRunning = isRunning;
    	}
    	
    	public   void gameSpeedRegulator() {
    		
    		Date newDate = new Date();
    		ticksElapsed = newDate.getTime();
    		nextGameTick += skipTicks;
    		sleepTime = nextGameTick - ticksElapsed;
    		if ( sleepTime >= 0 && gameRunning) {
    		
    			//Log.v("InnerGameLoop", "---Passing time");
    			try {
    	            Thread.sleep(sleepTime);
    	    	} catch (InterruptedException e) {
    	    		//
    	    	} 
    	    	
    		}
    		else {
    			//Log.v("InnerGameLoop", "Running behind");
    			newDate = new Date();
    			nextGameTick = newDate.getTime();
    			//ticksElapsed = newDate.getTime();
    		}
    	}
    	
    	
    	
    	
    };

    public void saveRoomNo() {
    	// this function doesn't seem to work from inside the 'InnerGameLoop'
    	// because it's a separate thread.
        SharedPreferences preferences = getSharedPreferences(Players.AWESOME_NAME, MODE_PRIVATE);
        SharedPreferences.Editor mPrefEdit = preferences.edit();
        mPrefEdit.putInt(Options.SAVED_ROOM_NUM, mGameV.getRoomNo());
        mPrefEdit.commit();
	}
	
	public void getSavedRoom() {
		SharedPreferences preferences = getSharedPreferences(Players.AWESOME_NAME, MODE_PRIVATE);
		mGameV.setRoomNo(preferences.getInt(Options.SAVED_ROOM_NUM, 1));
	}

	
	
	public Record getHighScores() {
		return mHighScores;
	}

	public void setHighScores(Record mHighScores) {
		this.mHighScores = mHighScores;
	}

	public boolean isGameDeath() {
		return mGameDeath;
	}

	public void setGameDeath(boolean mGameDeath) {
		this.mGameDeath = mGameDeath;
	}
    
	protected Dialog onCreateDialog(int id) {
	    Dialog dialog;
	    AlertDialog.Builder builder;
    	AlertDialog alertDialog;

    	Context mContext = getApplicationContext();
    	LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(LAYOUT_INFLATER_SERVICE);
    	View layout;
    	TextView text;
    	ImageView image;
    	String mPositive, mNegative;
    	
	    switch(id) {
	    case DIALOG_CONGRATS_ID:
	    	
	    	layout = inflater.inflate(R.layout.congrats,
	    	                               (ViewGroup) findViewById(R.id.layout_root));
	    	text = (TextView) layout.findViewById(R.id.congrats_text);
	    	text.setText("congratulations you've finished the level!!");
	    	image = (ImageView) layout.findViewById(R.id.image);
	    	image.setImageResource(R.drawable.guy_icon);
	    	mPositive = new String("Play next level.");
   	    	mNegative = new String("Stop game now.");
	    	builder = new AlertDialog.Builder(this);
	    	builder.setView(layout);
	    	builder.setCancelable(false)
    	       .setPositiveButton(mPositive, new DialogInterface.OnClickListener() {
    	           public void onClick(DialogInterface dialog, int id) {
    	        	  
    	        	   dialog.cancel();
    	        	   
    	           }
    	       })
    	       .setNegativeButton(mNegative, new DialogInterface.OnClickListener() {
    	           public void onClick(DialogInterface dialog, int id) {
    	        	   	Intent MenuIntent = new Intent(GameStart.this,Players.class);
    	        		startActivity(MenuIntent);
    	                dialog.cancel();
    	           }
    	       });
	    	
	    	alertDialog = builder.create();
	    	
	    	dialog = (Dialog) alertDialog;
	    	//////////////////////////////
	    	
	    	break;
	    case DIALOG_PAUSED_ID:
	        // do the work to define the pause Dialog
	    	dialog = null;
	        break;
	    case DIALOG_GAMEOVER_ID:
	        
	    	dialog = null;
	    	//////////////////////////////
	        break;
	    default:
	        dialog = null;
	    }
	    return dialog;
	}
    
}
