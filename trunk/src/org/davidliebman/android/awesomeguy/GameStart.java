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
import android.content.res.*;

//import android.util.Log;

public class GameStart extends Activity implements KeyEvent.Callback{
	
	public static final int GAMEVALUES = 1;
	public static final int STARTLEVEL = 2;
	public static final int MOVEMENTVALUES = 3;
	public static final int INVALIDATE = 4;
	public static final int INPUTVALUES_KEYUP = 5;
	public static final int GAMESTOP = 6;
	public static final int INPUTVALUES_TRACKUP = 7;
	public static final int CONGRATS = 8;
	public static final int PLAYAGAIN = 9;

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
    
    private boolean mTestLandscapeButtons = true;
    
    private ArrayList<TouchButton> mButtonList = new ArrayList<TouchButton>();
    
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
    		mGameLoopBot.join(1000);
    		
    	}
    	catch (Exception e) {
    		//
       	}
    	
    	// save high scores if they rank
    	if(mHighScores.getScore() > mGameV.getOldGuyScore()) {
	    	  
	    	  mScores.insertRecordIfRanks(mHighScores);
	    	  mHighScores.setNewRecord(false);

	      }
    	mScores.insertHighInTableIfRanks(mHighScores);

    	//TODO: make sure records are not saved when screen is re-oriented
    	
		SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);

    	mHighScores.addToPreferences(preferences);
    	
	    super.onPause();
    }
    
    @Override
    public void onSaveInstanceState(Bundle b) {
    	
    	mGameV.addToBundle(b, mMovementV);
    	super.onSaveInstanceState(b);
    }
    
    @Override
    public void onRestoreInstanceState(Bundle b) {
    	//mBundle = b;
    	super.onRestoreInstanceState(b);
    	mBundle = b;
    	
    	if(!mBundle.getBoolean(GameValues.BUNDLE_INITIAL)) {
    		mGameV.useBundleInfo(mBundle, mMovementV);
    		mUseSavedBundle = true;
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
    		mRLayoutGamepad.addView((View)new GamePad(this, true, mDimensionWidth));
    	}
    	else if (mGameV.isPutGameKeys()) {
    		mRLayoutGamepad.addView((View)new GameKeys(this, mGameV.getLandscapeButtonPixel() , true));
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

        ////////////////////////////////
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
    
    public void addButton(TouchButton mButton) {
    	this.mButtonList.add(mButton);
    }
    
    public TouchButton getButton(int i) {
    	return this.mButtonList.get(i);
    }
    
    public int getButtonListSize() {
    	return this.mButtonList.size();
    }
    public void clearButtonList() {
    	this.mButtonList.clear();
    }
    
    /** Start key listener overrides **/

	
	@Override
	public boolean onKeyDown( int keyCode, KeyEvent event) {
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
		return true;
	}


	
	@Override
	public boolean onKeyUp( int keyCode, KeyEvent event) {
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

	
    /** Game Pad Here **/
    public class GamePad extends  TableLayout {
    	
    	public GamePad(Context c, boolean mMultiTouch, int widthDimension) {
    		super(c);
    		mButtonHeight = widthDimension/5;//95
    		mButtonWidth = widthDimension/5;//95
    		mContext = c;

    		/* first row buttons */
    		BlankButton mButtonTop3 = new BlankButton(mContext);
    		BlankButton mButtonTop4 = new BlankButton(mContext);
    		BlankButton mButtonTop5 = new BlankButton(mContext);
    		TouchButton mButtonTop6 = new TouchButton(mContext, mMultiTouch ,R.drawable.button_up, mButtonWidth, mButtonHeight, 0, "button_up", MovementValues.KEY_UP);
    		BlankButton mButtonTop7 = new BlankButton(mContext);

    		/* middle row buttons */
    		TouchButton mButtonMid3 = new TouchButton(mContext, mMultiTouch ,R.drawable.button_b, mButtonWidth, mButtonHeight, 0, "button_b", MovementValues.KEY_B);
    		BlankButton mButtonMid4 = new BlankButton(mContext);
    		TouchButton mButtonMid5 = new TouchButton(mContext, mMultiTouch ,R.drawable.button_left, mButtonWidth, mButtonHeight, 0, "button_left", MovementValues.KEY_LEFT);
    		BlankButton mButtonMid6 = new BlankButton(mContext);
    		mButtonMid6.setBackgroundResource(R.drawable.button_center);
    		//mButtonMid6 = new TouchButton(this, R.drawable.button_center, mButtonWidth, mButtonHeight, 0, "button_center", 0);
    		TouchButton mButtonMid7 = new TouchButton(mContext, mMultiTouch ,R.drawable.button_right, mButtonWidth, mButtonHeight, 0, "button_right", MovementValues.KEY_RIGHT);

    		/* bottom row buttons */
    		BlankButton mButtonBot3 = new BlankButton(mContext);
    		BlankButton mButtonBot4 = new BlankButton(mContext);
    		BlankButton mButtonBot5 = new BlankButton(mContext);
    		TouchButton mButtonBot6 = new TouchButton(mContext,mMultiTouch , R.drawable.button_down, mButtonWidth, mButtonHeight, 0, "button_down", MovementValues.KEY_DOWN);
    		BlankButton mButtonBot7 = new BlankButton(mContext);

    		/* put buttons in rows */
    		TableRow mTRowTop = new TableRow(mContext);
    		mTRowTop.addView((View)mButtonTop3);
    		mTRowTop.addView((View)mButtonTop4);
    		mTRowTop.addView((View)mButtonTop5);
    		mTRowTop.addView((View)mButtonTop6);
    		mTRowTop.addView((View)mButtonTop7);

    		TableRow mTRowMid = new TableRow(mContext);
    		mTRowMid.addView((View)mButtonMid3);
    		mTRowMid.addView((View)mButtonMid4);
    		mTRowMid.addView((View)mButtonMid5);
    		mTRowMid.addView((View)mButtonMid6);
    		mTRowMid.addView((View)mButtonMid7);

    		TableRow mTRowBot = new TableRow(mContext);
    		mTRowBot.addView((View)mButtonBot3);
    		mTRowBot.addView((View)mButtonBot4);
    		mTRowBot.addView((View)mButtonBot5);
    		mTRowBot.addView((View)mButtonBot6);
    		mTRowBot.addView((View)mButtonBot7);

    		/* put rows in table */
    		this.addView((View)mTRowTop);
    		this.addView((View)mTRowMid);
    		this.addView((View)mTRowBot);
    		
    		/* set button x and button y */
    		mButtonTop6.setButtonXY(3, 0);
    		mButtonMid3.setButtonXY(0, 1);
    		mButtonMid5.setButtonXY(2, 1);
    		mButtonMid7.setButtonXY(4, 1);
    		mButtonBot6.setButtonXY(3, 2);
    		
    		/* populate button list */
    		clearButtonList();
    		addButton(mButtonTop6);
    		addButton(mButtonMid3);
    		addButton(mButtonMid5);
    		addButton(mButtonMid7);
    		addButton(mButtonBot6);
    		

    	}//end constructor
    	
    	
    	
    	
    }// end of inner class
    
    public class GameKeys extends TableLayout{
    	public GameKeys(Context c, int widthDimension, boolean mMultiTouch) {
    		super (c);
    		
    		int mButtonHeight = widthDimension;
    		int mButtonWidth = widthDimension;
    		
    		TableRow mTRow = new TableRow(c);
    		TouchButton mButton1 = new TouchButton(c, mMultiTouch ,R.drawable.button_left, mButtonWidth, mButtonHeight, 0, "button_left", MovementValues.KEY_LEFT);
    		TouchButton mButton2 = new TouchButton(c, mMultiTouch ,R.drawable.button_right, mButtonWidth, mButtonHeight, 0, "button_right", MovementValues.KEY_RIGHT);
    		TouchButton mButton3 = new TouchButton(c, mMultiTouch ,R.drawable.button_up, mButtonWidth, mButtonHeight, 0, "button_up", MovementValues.KEY_UP);
    		TouchButton mButton4 = new TouchButton(c,mMultiTouch , R.drawable.button_down, mButtonWidth, mButtonHeight, 0, "button_down", MovementValues.KEY_DOWN);

    		TouchButton mButton5 = new TouchButton(c, mMultiTouch ,R.drawable.button_b, mButtonWidth, mButtonHeight, 0, "button_b", MovementValues.KEY_B);

    		
    		BlankButton mDeviderView1 = new BlankButton(c, 2, mButtonHeight);
    		BlankButton mDeviderView2 = new BlankButton(c, 2, mButtonHeight);
    		BlankButton mDeviderView3 = new BlankButton(c, 2, mButtonHeight);
    		BlankButton mDeviderView4 = new BlankButton(c, 2, mButtonHeight);
    		
    		mTRow.addView((View)mButton1);
    		mTRow.addView((View)mDeviderView1);
    		mTRow.addView((View)mButton2);
    		mTRow.addView((View)mDeviderView2);
    		mTRow.addView((View)mButton3);
    		mTRow.addView((View)mDeviderView3);
    		mTRow.addView((View)mButton4);
    		mTRow.addView((View)mDeviderView4);
    		mTRow.addView((View)mButton5);

    		this.addView((View)mTRow);
    	}
    }

    /* button listeners */
    public class TouchButton extends Button implements View.OnTouchListener {
    	int mKeyValue = 0;
    	int mButtonX, mButtonY;
    	boolean mMultiTouch;
    	String mDescription;
    	
        public TouchButton (Context c, boolean mMultiTouch, int background, int width, int height, int id, String idString, int directionKey) {
        	super(c);
        	this.mMultiTouch = mMultiTouch;
        	this.setBackgroundColor(Color.BLACK);
        	if (background != 0 ) {
        		this.setBackgroundResource(background);
        		this.setOnTouchListener(this);
    			this.setOnKeyListener(new View.OnKeyListener() {
    		
				
    				@Override
    				public boolean onKey(View v, int keyCode, KeyEvent event) {
    					if (keyCode == KeyEvent.KEYCODE_DPAD_CENTER) {
    		    			mPanelBot.setKeyB(true);

    					}
    					
    					if (keyCode == KeyEvent.KEYCODE_DPAD_LEFT)
                        {
    						
    						mMovementV.setKeyInput(MovementValues.KEY_LEFT);
    				    	mPanelBot.readKeys(mTrackballDist);
    				    	
    				    	Message mEnd = new Message();
    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
    				    	mHandler.sendMessageDelayed(mEnd, mScrollConst);
    				    	
    						
    						//Log.v("button factory", "trackball??? left");
                        }
                        else if (keyCode == KeyEvent.KEYCODE_DPAD_RIGHT)
                        {	
                        	
            		    	mMovementV.setKeyInput(MovementValues.KEY_RIGHT);
    				    	mPanelBot.readKeys(mTrackballDist);
            		    	
            		    	Message mEnd = new Message();
    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
    				    	mHandler.sendMessageDelayed(mEnd, mScrollConst);
    				    	
    				    	
    						//Log.v("button factory", "trackball??? right");
                        }
    					if (keyCode == KeyEvent.KEYCODE_DPAD_UP)
                        {
    						
    				    	mMovementV.setKeyInput(MovementValues.KEY_UP);
    				    	mPanelBot.readKeys(mTrackballDist);
    				    	
    				    	Message mEnd = new Message();
    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
    				    	mHandler.sendMessageDelayed(mEnd, mScrollConst);
    				    	
    						
    						//Log.v("button factory", "trackball??? up");
                        }
                        else if (keyCode == KeyEvent.KEYCODE_DPAD_DOWN)
                        {
                        	
                        	
            		    	mMovementV.setKeyInput(MovementValues.KEY_DOWN);
    				    	mPanelBot.readKeys(mTrackballDist);
            		    	
            		    	Message mEnd = new Message();
    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
    				    	mHandler.sendMessageDelayed(mEnd, mScrollConst);
    				    	
                        	
    						//Log.v("button factory", "trackball??? down");
                        }
    					
    					return true;
    				}
    			});
        	}
        	this.setWidth(width);
        	this.setHeight(height);
        	this.setText("");
        	this.setId(id);
        	this.setTag(idString);
        	this.mDescription = idString;
        	mKeyValue = directionKey;
        }
    	
    	public TouchButton(Context c, int direction) {
    		super(c);
    		mKeyValue = direction;
    	}
    	public TouchButton(Context c) {
    		super(c);
    	}
    	
    	/* multi-touch implementation */
    	public void setButtonXY(int mButtonX, int mButtonY) {
    		this.mButtonX = mButtonX;
    		this.mButtonY = mButtonY;
    	}
    	
    	public int getButtonX() {
    		return mButtonX;
    	}
    	
    	public int getButtonY() {
    		return mButtonY;
    	}
    	
    	public int getKeyValue() {
    		return this.mKeyValue;
    	}
    	
    	public String getDescription() {
    		return this.mDescription;
    	}
    	/* end multi-touch specific */
    	
    	@Override
    	public boolean onTouch(View v, MotionEvent m) {
    		
    		if(m.getAction() == MotionEvent.ACTION_DOWN && mKeyValue == MovementValues.KEY_B) {
    			mPanelBot.setKeyB(true);
    			// this is needed if 'B' key is pressed first...
    		}
    		
    		else if(m.getAction() == MotionEvent.ACTION_DOWN) {

		    	
		    	// mMovementV.setKeyInput(mKeyValue);
    			// handle this below.
    		}
    		if(m.getAction() == MotionEvent.ACTION_UP) {
    			
    			mMovementV.clearKeys(); 
    			return true;
    		}
    		
    		
			//Log.e("MULTI-TOUCH", "multi-touch here");
			
			if(m.getPointerCount() > 1 ) {
				
				checkTwoCoordinates((int)m.getX(0), (int)m.getY(0), (int)m.getX(1), (int)m.getY(1));
			}
			else {
				checkTwoCoordinates((int)m.getX(0), (int)m.getY(0), (int)m.getX(0), (int)m.getY(0));
			}

    		return true;
    	}
    	
    	private void checkTwoCoordinates(int mFirstX, int mFirstY, int mSecondX, int mSecondY) {
    		int mFirstOffsetX = 0; 
    		int mFirstOffsetY = 0;
    		int mSecondOffsetX = 0;
    		int mSecondOffsetY = 0;
    		
			mFirstOffsetX = getButtonX();
			mFirstOffsetY = getButtonY();
			//handle first click here !! current button must have focus.
	    	
			mMovementV.setKeyInput(mKeyValue);
    		
    		if (mFirstX == mSecondX && mFirstY == mSecondY) return;
    		
    		for (int i = 0; i < getButtonListSize(); i ++) {
    			mSecondOffsetX = getButton(i).getButtonX();
    			mSecondOffsetY = getButton(i).getButtonY();
    			
    			if (mSecondX + mFirstOffsetX * mButtonWidth > mSecondOffsetX * mButtonWidth &&
    					mSecondX + mFirstOffsetX * mButtonWidth < (mSecondOffsetX + 1) * mButtonWidth &&
    					mSecondY + mFirstOffsetY * mButtonHeight > mSecondOffsetY * mButtonHeight &&
    					mSecondY + mFirstOffsetY * mButtonHeight < (mSecondOffsetY + 1) * mButtonHeight) {
    				//handle second click here !!

    				if (getButton(i).getKeyValue() == MovementValues.KEY_B) {
    		    		mPanelBot.setKeyB(true);
    		    	}
    		    	else{
    		    		mMovementV.setKeyInput(getButton(i).getKeyValue());
    		    	}

    			}
    		}
    		
    	}
    	
    };
    
    public class BlankButton extends Button {
    	BlankButton(Context c) {
    		super(c);
    		this.setWidth(mButtonWidth);
    		this.setHeight(mButtonHeight);
        	this.setBackgroundColor(Color.TRANSPARENT);
    	}
    	BlankButton(Context c, int width, int height) {
    		super(c);
    		this.setWidth(width);
    		this.setHeight(height);
    		this.setBackgroundColor(Color.TRANSPARENT);
    	}
    };
    
    
    
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
    		    
    		    if( !mUseSavedBundle ) {
    		    	mPanelBot.setInitialBackgroundGraphics();
    		    	mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    		    	mPanelBot.setGuySprite(mGameV.getSpriteStart()); //must refresh reference to guySprite
    		    }
    		    else {
    		    	mPanelBot.setReturnBackgroundGraphics();
    		    	mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    		    	mPanelBot.setGuySprite(mGameV.getSpriteStart()); //must refresh reference to guySprite

    		    }
    			
    			mPanelBot.invalidate();
    			
    		}
    		
    		else if(msg.what == MOVEMENTVALUES) {
    			
    			mPanelBot.setHighScores((Record)msg.obj);
    			
    			mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    			
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
    		    
    		    mGameV.setLives(3);
    		    // set room num
    		    
    		    if (mSavedRoomFlag == true) mGameV.setRoomNo(1);
    		    mSavedRoomFlag = true;
    		    
    		    //getSavedRoom();
    		    
    		    mGameV.setScore(10);
    		    
    		    mGameV.setEndGame(false);
    		    
    		    while(mGameV.getRoomNo() <= mGameV.getLevelList().size()  && !mGameV.isEndGame() && gameRunning && mGameV.getLives() > 0) {

       
    		     // advance through rooms

    		      
    		    mHandler.sendEmptyMessage(GameStart.STARTLEVEL);

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
    		    
    		    //end of restore from bundle
    		    mUseSavedBundle = false;
    		    
    		    //get guy sprite reference 
    			mGuySprite = mGameV.getSpriteStart();
    		    mPanelBot.setGuySprite(mGuySprite);
    	    	
    		    //
    			
    		    mGameV.setEndLevel(false);
    		    mGameV.setGameDeath(false);
    		    
    			mLoop = true;
    		    while(mLoop && gameRunning && !mGameV.isEndLevel()) { // GAME PLAY LOOP
    		       
    		    	if (true) gameSpeedRegulator(); //call inside 'game play' loop
    		    	
    		    
    		    	
    		    	// ** ALWAYS SEND THIS MESSAGE **	
    		    	Message mM = new Message();
    		    	mM.what = GameStart.MOVEMENTVALUES;
    		    	mM.obj = mHighScores;
    		    	mHandler.sendMessageAtFrontOfQueue(mM);
    				
        			
    		    } // end of gameplay loop

    		   
    		    
    	    	mHandler.sendEmptyMessage(GameStart.GAMESTOP);
    		    // *** ANIMATE SPINNING GUY ***
    		    try {
    		    	Thread.sleep(1000);
    		    } catch (InterruptedException e) {
    		    	//
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
    		if ( sleepTime >= 0 ) {
    		
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
        SharedPreferences preferences = getSharedPreferences(SplashScreen.AWESOME_NAME, MODE_PRIVATE);
        SharedPreferences.Editor mPrefEdit = preferences.edit();
        mPrefEdit.putInt(Options.SAVED_ROOM_NUM, mGameV.getRoomNo());
        mPrefEdit.commit();
	}
	
	public void getSavedRoom() {
		SharedPreferences preferences = getSharedPreferences(SplashScreen.AWESOME_NAME, MODE_PRIVATE);
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
    	        	   	Intent MenuIntent = new Intent(GameStart.this,Menu.class);
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
