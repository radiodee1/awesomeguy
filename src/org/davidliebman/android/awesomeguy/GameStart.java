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
    private PanelGLSurfaceView mPanelView;
	private PanelHandler mHandler;
    
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
    
    private ButtonManager mButtonManager;
    
	public static final String AWESOME_NAME = new String("org.awesomeguy");

    
    /* old GameLoop - variables */
    private boolean gameRunning = true;
	private boolean mLoop = true;
	private boolean mGameDeath = false;
	private boolean mPlayAgain = true;
	private Record mHighScores;
	private SpriteInfo mGuySprite;
    private Scores mScores;
    private boolean mLookForXml;
	
	/* old GameLoop - prepare timer */
	private long framesPerSec = 25;
	private long skipTicks = 1000 / framesPerSec;
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
          mGameV.setViewH((int)(192 * mGameV.getScaleV()) + 6); // 192 for game and 6 for two dividers.
          //Log.e("GameStart","h pixels " + mGameV.getViewH());
//        mGameV.setViewW(this.mRLayout.getWidth());
        
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
    	mGameV.setGameRunning(false);
    	Message mEndMessage = new Message();
    	mEndMessage.what = GAMESTOP;
    	mHandler.sendMessageAtFrontOfQueue(mEndMessage);
    	
    	boolean retry = false;
    	while (retry) {
    	
	    	try {
	    		mGameLoopBot.join();//100
	    		retry = true;
	    	}
	    	catch (InterruptedException e) {
	    		//
	       	}
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
    		mGameV.setUseSavedBundle(true);
    	}
    }
    
    @Override
    public void onResume() {
        
    	
    	
    	/* setup handler */
    	mHandler = new PanelHandler();
        mGameV.setHandler(mHandler);
        mGameV.setMovementValues(mMovementV);
        
    	/* retrieve Record mHighScores */
    	mHighScores = new Record();
        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(preferences);
        mGameV.setGuyScore(mHighScores);
        /* retrieve other saved preferences */	
        
        mLookForXml = preferences.getBoolean(Options.SAVED_LOOK_FOR_XML, false);
        mGameV.setRoomNo(preferences.getInt(Options.SAVED_ROOM_NUM, 1));
        mGameV.setLookForXml(mLookForXml);
        
        
    	mScores = new Scores(this, mHighScores);
        mGameV.setScores(mScores);
    	
    	framesPerSec = mHighScores.getGameSpeed();
    	skipTicks = 1000 / framesPerSec;
    	
    	/* init background */
    	
    	this.setOrientationVars();
//    	mPanelBot = new Panel(this,  mGameV, this, mMovementV);//, mHighScores);
    	mPanelView = new PanelGLSurfaceView(this, mGameV, this, mMovementV);
    	mPanelBot = mPanelView.getPanel();
    	
    	if( mConfig.orientation == Configuration.ORIENTATION_PORTRAIT){
    		mButtonManager = new ButtonManager(this, mMovementV, mGameV,ButtonManager.MODE_PORTRAIT);
    		mRLayoutGamepad.addView((View) mButtonManager);
    	}
    	else if (mGameV.isPutGameKeys()) {
    		mButtonManager = new ButtonManager(this, mMovementV, mGameV, ButtonManager.MODE_STRIP);
    		mRLayoutGamepad.addView((View) mButtonManager);
    		//TODO: check that this works on landscape AND portrait
    	}
    	
    	//mGameV.setHolder(mPanelBot.getHolder());
		mGameV.setPanel(mPanelBot);
    	
    	mBackground = new InitBackground(mGameV, this, mLookForXml);
    	mGameV.setBackground(mBackground);
    	
    	//mFLayoutBot.addView((View)mPanelBot);//TODO: commented out for testing
    	mFLayoutBot.addView((View)mPanelView);
    	//mFLayoutBot.addView(mPanelView);
    	
    	mPanelBot.setEnableSounds(mHighScores.isSound());
    	
    	
    	/* create game loop thread */
    	mGameLoopBot = new InnerGameLoop(this, mGameV, mPanelBot); 
    	
    	/* set loop to 'endless' */
    	mGameV.setGameRunning(true);
    	
    	this.getSavedRoom();

    	
    	/* start game loop thread */
    	//mGameLoopBot.start();
    	super.onResume();
    	
    	

    }
    
    @Override
    public void onWindowFocusChanged(boolean hasWindowFocus) {
    	if (true) {
    		mButtonManager.setButtonBoundingBoxAll();
    	}
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
	
	

    class PanelHandler extends Handler {
    	

    	public void handleMessage(Message msg) {
    		switch(msg.what) {
    		
    		case GAMEVALUES: {
    		
	    		//mPanelBot.invalidate();
	       		
    		}
    			break;
    		
    		case STARTLEVEL: {
    			
    			this.removeMessages(MOVEMENTVALUES);
    			this.removeMessages(GAMEVALUES);
    			this.removeMessages(INPUTVALUES_KEYUP);
    			    			
    		    mPanelBot.setAnimationOnly(false);
    		    mPanelBot.setJNIAnimateOnly(Panel.JNI_FALSE); // '0' is false for JNI
    		    
    		    mPanelBot.setInitialBackgroundGraphics();
    		    mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    		    mPanelBot.setGuySprite(mGameV.getSpriteStart()); //must refresh reference to guySprite
    		    
    		    if (!mGameLoopBot.isAlive()) mGameLoopBot.start();
    			
    			
    		}
    			break;
    		case REORIENTATION: {
    			
    			this.removeMessages(MOVEMENTVALUES);
    			this.removeMessages(GAMEVALUES);
    			this.removeMessages(INPUTVALUES_KEYUP);
    			 
        		mGameV.useBundleInfo(mBundle, mMovementV);
    			
    		    mPanelBot.setAnimationOnly(false);
    		    mPanelBot.setJNIAnimateOnly(Panel.JNI_FALSE); // '0' is false for JNI
    		    
    		    
    		    mPanelBot.setReturnBackgroundGraphics();
    		    mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    		    mPanelBot.setGuySprite(mGameV.getSpriteStart()); //must refresh reference to guySprite

    		    if (!mGameLoopBot.isAlive()) {
    		    	//mGameLoopBot = new InnerGameLoop(GameStart.this, mGameV, mPanelBot); 

    		    	mGameLoopBot.start();
    		    }

    			
    			//mPanelBot.invalidate();
    			
    			
    		}
    			break;
    		case MOVEMENTVALUES: {
    			//mPanelBot.setHighScores((Record)msg.obj);
    			
//    			mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
//    			
//    			if (mMovementV.getLetterKeyB() > 0) mPanelBot.setKeyB(true);
//    			else mPanelBot.setKeyB(false);
    			
    			//mPanelBot.invalidate();
    			
    		}
    			break;
    		case INPUTVALUES_TRACKUP: {
    			mMovementV.clearKeys();
    			mPanelBot.readKeys(0);
    			//Log.v("Handler", "Keyup " );
    		}
    		
    			break;
    		case GAMESTOP: {
    			//do something here?
    	    	mPanelBot.setAnimationOnly(true);
    	    	mPanelBot.setJNIAnimateOnly(1); // '1' is true for JNI
    	    	//mPanelBot.invalidate();
    			this.removeMessages(MOVEMENTVALUES);
    			this.removeMessages(GAMEVALUES);
    			this.removeMessages(INPUTVALUES_KEYUP);
    			this.removeMessages(INPUTVALUES_TRACKUP);
    			mMovementV.clearKeys();
    			
    		}
    			break;
    		case CONGRATS: {
    			//This displays the end-of-level dialog box.
    			showDialog(GameStart.DIALOG_CONGRATS_ID);
    			
    		}
    			break;
    		case PLAYAGAIN: {
    			//This displays the end-of-GAME dialog box.
        		Toast.makeText(GameStart.this, "PLAY AGAIN!!" , Toast.LENGTH_LONG).show();
    			
    		}
    			break;
    		default:{
    			super.handleMessage(msg);
    		}
    			break;
    		}// end case
    		
    		
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
