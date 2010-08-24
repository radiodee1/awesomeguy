package org.davidliebman.android.awesomeguy;

import java.util.Date;

import android.app.Activity;
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
import android.view.*;
import android.content.*;
import android.widget.*;
import android.util.Log;

public class GameStart extends Activity {
	
	public static final int GAMEVALUES = 1;
	public static final int STARTLEVEL = 2;
	public static final int MOVEMENTVALUES = 3;
	public static final int SPLASH = 4;
	public static final int INVALIDATE = 5;
	public static final int INPUTVALUES_KEYUP = 6;
	public static final int GAMESTOP = 7;
	public static final int INPUTVALUES_TRACKUP = 8;
	
	GameValues mGameV = new GameValues();
	MovementValues mMovementV = new MovementValues();
	InitBackground mBackground ;
    Canvas mCanvas;
    FrameLayout mBotFrame;
    InnerGameLoop mGameLoopBot;
    
    RelativeLayout mRLayout ;
    TableLayout mTLayout ;
    FrameLayout mFLayoutTop ;
    FrameLayout mFLayoutBot ;
    Panel mPanelTop ;
    Panel mPanelBot ;
	
    View mSpaceView;
    
    RelativeLayout mRLayoutGamepad;
    TableLayout mGamepad;
    TableRow mTRowTop;
    TableRow mTRowMid;
    TableRow mTRowBot;
    
    TouchButton mButtonTop1, mButtonTop2, mButtonTop3, 
    	mButtonTop4, mButtonTop5, mButtonTop6, mButtonTop7;
    TouchButton mButtonMid1, mButtonMid2, mButtonMid3, 
    	mButtonMid4, mButtonMid5, mButtonMid6, mButtonMid7;
    TouchButton mButtonBot1, mButtonBot2, mButtonBot3, 
    	mButtonBot4, mButtonBot5, mButtonBot6, mButtonBot7;
        
    private int mButtonHeight, mButtonWidth;
    private int mScrollConst = 200;
    private double mTrackballDist = 1.0;
    
	public static final String AWESOME_NAME = new String("org.awesomeguy");

    
    /* old GameLoop - variables */
    private boolean gameRunning = true;
	private boolean mLoop = true;
	private int mOldLives;
	private boolean mGameDeath = false;
	private boolean mPlayAgain = true;
	private Record mHighScores;
	private SpriteInfo mGuySprite;

	
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
        
        /* generate components for top of screen */
        mRLayout = new RelativeLayout(this) ; 
        mTLayout = new TableLayout(this);
        mFLayoutTop = new FrameLayout(this);
        mFLayoutBot = new FrameLayout(this);
        mPanelTop = new Panel(this,  mGameV, this, mMovementV);
        mPanelBot = new Panel(this,  mGameV, this, mMovementV);
        
        
        /* assemble components for top of screen */
        mRLayout.setBackgroundColor(Color.BLUE);
        mRLayout.setBackgroundResource(R.drawable.background);
        ViewGroup.LayoutParams mRLayoutParams = new 
        	ViewGroup.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        mRLayout.setLayoutParams(mRLayoutParams);
        mRLayout.setHorizontalGravity(Gravity.CENTER_HORIZONTAL);
        
        mTLayout.setBackgroundColor(Color.BLACK);
        ViewGroup.LayoutParams mTLayoutParams = new 
    		ViewGroup.LayoutParams(256, ViewGroup.LayoutParams.WRAP_CONTENT);
        mTLayout.setLayoutParams(mTLayoutParams);
        
        mFLayoutTop.setBackgroundColor(Color.RED);
        ViewGroup.LayoutParams mFLayoutTopParams = new 
			ViewGroup.LayoutParams(256,192);
        mFLayoutTop.setLayoutParams(mFLayoutTopParams);
          
        mFLayoutBot.setBackgroundColor(Color.BLACK);
        ViewGroup.LayoutParams mFLayoutBotParams = new 
			ViewGroup.LayoutParams(256,192);
        mFLayoutBot.setLayoutParams(mFLayoutBotParams);
        
        /* small view to draw line between game pad and screens */
        mSpaceView = new View(this);
        mSpaceView.setBackgroundColor(Color.GRAY);
        ViewGroup.LayoutParams mSpaceLayoutParams = new 
    		ViewGroup.LayoutParams(256, 2);
        mSpaceView.setLayoutParams(mSpaceLayoutParams);
        
        /* generate components for game pad */
        mRLayoutGamepad = new RelativeLayout(this);
        mRLayoutGamepad.setHorizontalGravity(Gravity.CENTER_HORIZONTAL);
        mGamepad = new TableLayout(this);
        mTRowTop = new TableRow(this);
        mTRowMid = new TableRow(this);
        mTRowBot = new TableRow(this);
        
        mButtonHeight = 23;
        mButtonWidth = 23;
        
        /* first row buttons */
        mButtonTop1 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
        mButtonTop2 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
        mButtonTop3 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
    	mButtonTop4 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
    	mButtonTop5 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
    	mButtonTop6 = new TouchButton(this, R.drawable.button_up, mButtonWidth, mButtonHeight, 0, "button_up", MovementValues.KEY_UP);
    	mButtonTop7 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
        
    	/* middle row buttons */
        mButtonMid1 = new TouchButton(this, R.drawable.button_a, mButtonWidth, mButtonHeight, 0, "button_a", MovementValues.KEY_A);
        mButtonMid2 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
        mButtonMid3 = new TouchButton(this, R.drawable.button_b, mButtonWidth, mButtonHeight, 0, "button_b", MovementValues.KEY_B);
    	mButtonMid4 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
    	mButtonMid5 = new TouchButton(this, R.drawable.button_left, mButtonWidth, mButtonHeight, 0, "button_left", MovementValues.KEY_LEFT);
    	mButtonMid6 = new TouchButton(this, R.drawable.button_center, mButtonWidth, mButtonHeight, 0, "button_center", 0);
    	mButtonMid7 = new TouchButton(this, R.drawable.button_right, mButtonWidth, mButtonHeight, 0, "button_right", MovementValues.KEY_RIGHT);
    	
    	/* bottom row buttons */
        mButtonBot1 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
        mButtonBot2 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
        mButtonBot3 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
    	mButtonBot4 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
    	mButtonBot5 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
    	mButtonBot6 = new TouchButton(this, R.drawable.button_down, mButtonWidth, mButtonHeight, 0, "button_down", MovementValues.KEY_DOWN);
    	mButtonBot7 = new TouchButton(this, 0, mButtonWidth, mButtonHeight, 0, "", 0);
    	
    	/* put buttons in rows */
    	mTRowTop.addView((View)mButtonTop1);
    	mTRowTop.addView((View)mButtonTop2);
    	mTRowTop.addView((View)mButtonTop3);
    	mTRowTop.addView((View)mButtonTop4);
    	mTRowTop.addView((View)mButtonTop5);
    	mTRowTop.addView((View)mButtonTop6);
    	mTRowTop.addView((View)mButtonTop7);
    	
    	mTRowMid.addView((View)mButtonMid1);
    	mTRowMid.addView((View)mButtonMid2);
    	mTRowMid.addView((View)mButtonMid3);
    	mTRowMid.addView((View)mButtonMid4);
    	mTRowMid.addView((View)mButtonMid5);
    	mTRowMid.addView((View)mButtonMid6);
    	mTRowMid.addView((View)mButtonMid7);
    	
    	mTRowBot.addView((View)mButtonBot1);
    	mTRowBot.addView((View)mButtonBot2);
    	mTRowBot.addView((View)mButtonBot3);
    	mTRowBot.addView((View)mButtonBot4);
    	mTRowBot.addView((View)mButtonBot5);
    	mTRowBot.addView((View)mButtonBot6);
    	mTRowBot.addView((View)mButtonBot7);
    	
    	/* put rows in table */
    	mGamepad.addView((View)mTRowTop);
    	mGamepad.addView((View)mTRowMid);
    	mGamepad.addView((View)mTRowBot);
    	
        /* assemble top part of screen */
        mRLayout.addView((View)mTLayout);
        mTLayout.addView((View)mFLayoutTop);
        mTLayout.addView((View)mFLayoutBot);
        mFLayoutTop.addView((View)mPanelTop);
        mFLayoutBot.addView((View)mPanelBot);
        
        mTLayout.addView(mSpaceView);
        
        /* add gamepad to bottom of screen */
        mRLayoutGamepad.addView((View)mGamepad);
        mTLayout.addView((View)mRLayoutGamepad);
        
        setContentView(mRLayout);
        //mGameFunct = new GameLoop(mGameV, this , mMovementV);

        
        mGameV.setSpriteStart();
    }
    
    @Override
    public void onPause() {
    	
    	//mGameLoopBot.setGameRunning(false);
    	gameRunning = false;
    	Message mEndMessage = new Message();
    	mEndMessage.what = GAMESTOP;
    	myPanelUpdateHandler.sendMessageAtFrontOfQueue(mEndMessage);
    	
    	try {
    		mGameLoopBot.join(1000);
    		
    	}
    	catch (Exception e) {
    		//
       	}
    	
	    super.onPause();
    }
    
    @Override
    public void onResume() {
    	
    	/* retrieve Record mHighScores */
    	mHighScores = new Record();
        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(preferences);
        //mHighScores.listInLog();    	
    	//mGameV.setGuyScore(mHighScores);
    	
    	/* TODO must modify saved high scores for game play */
    	framesPerSec = mHighScores.getGameSpeed();
    	mPanelBot.setUseJNI(mHighScores.isEnableJNI());
    	mPanelBot.setEnableSounds(mHighScores.isSound());
    	
    	/* init background */
    	mBackground = new InitBackground(mGameV);
    	
    	/* create game loop thread */
    	mGameLoopBot = new InnerGameLoop(this);
    	
    	/* set loop to 'endless' */
    	//mGameFunct.setGameRunning(true);
    	mGameLoopBot.setGameRunning(true);
    	
    	/* start game loop thread */
    	mGameLoopBot.start();
    	super.onResume();
    	
    	

    }
    
    
    /* button listeners */
    public class TouchButton extends Button implements View.OnTouchListener {
    	int mKeyValue = 0;
    	
        public TouchButton (Context c, int background, int width, int height, int id, String idString, int directionKey) {
        	super(c);
        	this.setBackgroundColor(Color.BLACK);
        	if (background != 0) {
        		this.setBackgroundResource(background);
        		this.setOnTouchListener(this);
        		this.setOnKeyListener(new View.OnKeyListener() {
    				
    				@Override
    				public boolean onKey(View v, int keyCode, KeyEvent event) {
    					
    					
    					if (keyCode == KeyEvent.KEYCODE_DPAD_LEFT)
                        {
    						
    						mMovementV.setKeyInput(MovementValues.KEY_LEFT);
    				    	mPanelBot.readKeys(mTrackballDist);
    				    	
    				    	Message mEnd = new Message();
    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
    				    	myPanelUpdateHandler.sendMessageDelayed(mEnd, mScrollConst);
    				    	
    						
    						//Log.v("button factory", "trackball??? left");
                        }
                        else if (keyCode == KeyEvent.KEYCODE_DPAD_RIGHT)
                        {	
                        	
            		    	mMovementV.setKeyInput(MovementValues.KEY_RIGHT);
    				    	mPanelBot.readKeys(mTrackballDist);
            		    	
            		    	Message mEnd = new Message();
    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
    				    	myPanelUpdateHandler.sendMessageDelayed(mEnd, mScrollConst);
    				    	
    				    	
    						//Log.v("button factory", "trackball??? right");
                        }
    					if (keyCode == KeyEvent.KEYCODE_DPAD_UP)
                        {
    						
    				    	mMovementV.setKeyInput(MovementValues.KEY_UP);
    				    	mPanelBot.readKeys(mTrackballDist);
    				    	
    				    	Message mEnd = new Message();
    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
    				    	myPanelUpdateHandler.sendMessageDelayed(mEnd, mScrollConst);
    				    	
    						
    						//Log.v("button factory", "trackball??? up");
                        }
                        else if (keyCode == KeyEvent.KEYCODE_DPAD_DOWN)
                        {
                        	
                        	
            		    	mMovementV.setKeyInput(MovementValues.KEY_DOWN);
    				    	mPanelBot.readKeys(mTrackballDist);
            		    	
            		    	Message mEnd = new Message();
    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
    				    	myPanelUpdateHandler.sendMessageDelayed(mEnd, mScrollConst);
    				    	
                        	
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
        	mKeyValue = directionKey;
        }
    	
    	public TouchButton(Context c, int direction) {
    		super(c);
    		mKeyValue = direction;
    	}
    	public TouchButton(Context c) {
    		super(c);
    	}
    	
    	@Override
    	public boolean onTouch(View v, MotionEvent m) {
    		
    		if(m.getAction() == MotionEvent.ACTION_DOWN && mKeyValue == MovementValues.KEY_B) {
    			mPanelBot.setKeyB(true);
    		
    		}
    		
    		else if(m.getAction() == MotionEvent.ACTION_DOWN) {

		    	
		    	mMovementV.setKeyInput(mKeyValue);
		    	mPanelBot.readKeys();
    		
    		}
    		if(m.getAction() == MotionEvent.ACTION_UP) {
    			
    			mMovementV.clearKeys(); 
    			mPanelBot.readKeys();
    		}
    		
    		
    		return true;
    	}
    
    	
    }
    
    
    
    public void clearMessages() {
    	this.myPanelUpdateHandler.removeMessages(GAMEVALUES);
    	this.myPanelUpdateHandler.removeMessages(STARTLEVEL);
    	this.myPanelUpdateHandler.removeMessages(MOVEMENTVALUES);
    	this.myPanelUpdateHandler.removeMessages(SPLASH);
    	this.myPanelUpdateHandler.removeMessages(INVALIDATE);
    	this.myPanelUpdateHandler.removeMessages(GAMESTOP);
    	this.myPanelUpdateHandler.removeMessages(INPUTVALUES_KEYUP);
    	this.myPanelUpdateHandler.removeMessages(INPUTVALUES_TRACKUP);
    }
    
    public Handler myPanelUpdateHandler = new Handler() {
    	public void handleMessage(Message msg) {
    		if(msg.what == GAMEVALUES) {
    		
	    		mPanelBot.invalidate();
	       		
    		}
    		else if(msg.what == STARTLEVEL) {
    			
    			this.removeMessages(MOVEMENTVALUES);
    			this.removeMessages(GAMEVALUES);
    			this.removeMessages(INPUTVALUES_KEYUP);
    			
    			mPanelBot.setBackgroundGraphics();
    			mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    			mPanelBot.setGuySprite(mGameV.getSpriteStart()); //must refresh reference to guySprite
    			mPanelBot.invalidate();
    			
    		}
    		else if(msg.what == SPLASH) {
    			mPanelTop.setBackgroundShow(mGameV.getRoomNo());
    		}
    		else if(msg.what == MOVEMENTVALUES) {
    			
    			mPanelBot.setHighScores((Record)msg.obj);
    			mPanelBot.setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    			mPanelBot.invalidate();
    		}
    		
    		else if(msg.what == INPUTVALUES_TRACKUP) {
    			mMovementV.clearKeys();
    			mPanelBot.readKeys(0);
    			Log.v("Handler", "Keyup " );
    		}
    		
    		
    		else if (msg.what == GAMESTOP) {
    			//do something here?
    			this.removeMessages(MOVEMENTVALUES);
    			this.removeMessages(GAMEVALUES);
    			this.removeMessages(INPUTVALUES_KEYUP);
    			this.removeMessages(INPUTVALUES_TRACKUP);
    			mMovementV.clearKeys();
    			
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
    		//////////////////////////////////////////////
        	// TODO: GAME LOOP EXPEREMENT
        	//////////////////////////////////////////////
    		
            
    		
    		gameRunning = true;
    		//prepare timer
    		Date startDate = new Date();
    		nextGameTick = startDate.getTime();
    		
    		
    		
    		  ///////////////////////////////////////////////////////
    		  // PLAY THE GAME
    		  while(mPlayAgain && gameRunning) {
    		    mPlayAgain = false;
    		
    		  //do something here.
    		    //myPanelUpdateHandler.removeMessages(GameStart.MOVEMENTVALUES);
    			//myPanelUpdateHandler.removeMessages(GameStart.GAMEVALUES);
    		    mMovementV.setScrollX(0);
    		    mMovementV.setScrollY(0);
    			
    		    //myPanelUpdateHandler.sendEmptyMessage(GameStart.STARTLEVEL);
    			
    			
    		    
    			
    		    ////////////////////////////////////////////////////////
    		    // PREP FOR GAME PLAY
    		    // set lives
    		    /*
    		    if (mHighScores.getSave1( mGameV.getUsernum() ) > 3) {
    		    	mGameV.setLives(mHighScores.getSave1(mGameV.getUsernum()));
    		    }
    		    else {
    		    	mGameV.setLives(3);
    		    }
    		    */
    		    mGameV.setLives(3);
    		    // set room num
    		    /*
    		    if(mHighScores.getLevel(mGameV.getUsernum())>0) {
    		      mGameV.setRoomNo(mHighScores.getLevel(mGameV.getUsernum()));
    		    }
    		    else {
    		      mGameV.setRoomNo(1);
    		    }
    		    */
    		    mGameV.setRoomNo(1);
    		    // put graphic on top panel
    			
    			myPanelUpdateHandler.sendEmptyMessage(GameStart.SPLASH);
    			
    		    // new score ??
    		    
    		    mGameV.setScore(10);
    		    
    		    mGameV.setEndGame(false);
    		    
    		    while(mGameV.getRoomNo() <= GameValues.NUM_ROOMS && !mGameV.isEndGame() && gameRunning && mGameV.getLives() > 0) {

       
    		     // advance through rooms

    		      // Zero out lower screen. Could use another method. Maybe print picture on
    		       // main engine...
    		       //
    		    myPanelUpdateHandler.sendEmptyMessage(GameStart.STARTLEVEL);

        		myPanelUpdateHandler.removeMessages(GameStart.MOVEMENTVALUES);
    			//myPanelUpdateHandler.removeMessages(GameStart.GAMEVALUES);
    		    mMovementV.setScrollX(0);
    		    mMovementV.setScrollY(0);
    			
    			
    			// put graphic on top panel
    			
    			myPanelUpdateHandler.sendEmptyMessage(GameStart.SPLASH);
    			
    			
    		    
    		    //init room
    		    mBackground.setLevel(mGameV.getRoomNo());
    	    	mBackground.initLevel(mMovementV);
    	    	
    	    	//jni test !!
    		    mPanelBot.setLevelData(mGameV.getLevelArray(), mGameV.getObjectsArray(), mGameV.getMapV(), mGameV.getMapH());
    	    	mPanelBot.addMonstersJNI();
    		    
    		    //get guy sprite reference 
    			mGuySprite = mGameV.getSpriteStart();
    		    mPanelBot.setGuySprite(mGuySprite);
    	    	
    		    //mPanelBot.setBackgroundGraphics();
    			
    		    mGameV.setEndLevel(false);
    		    mGameV.setGameDeath(false);
    		    
    			mLoop = true;
    		    while(mLoop && gameRunning && !mGameV.isEndLevel()) { // GAME PLAY LOOP
    		       
    		    	if (true) gameSpeedRegulator(); //call inside 'game play' loop
    		    	
    		    	//mOldLives = level.lives;
    		    	mOldLives = mGameV.getLives();
    		    	//mScoresOnScreen = false;

    		    	
    		    	// ** ALWAYS SEND THIS MESSAGE **	
    		    	Message mM = new Message();
    		    	mM.what = GameStart.MOVEMENTVALUES;
    		    	mM.obj = mHighScores;
    		    	myPanelUpdateHandler.sendMessageAtFrontOfQueue(mM);
    				
        			
    		    } // end of gameplay loop

    		   
    		    
    	    	myPanelUpdateHandler.sendEmptyMessage(GameStart.GAMESTOP);
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
    		        mGameV.setEndGame(false);
    		        mGameV.setEndLevel(false);
    		      }
    		      else {
    		        mGameV.setEndLevel(true);
    		      }
    		      
    		     
    		      // increment cycle count and set room to 1...
    		      if( mGameV.getRoomNo() > GameValues.NUM_ROOMS &&  !mGameV.isEndLevel() ) {
    		        
    		    	  mGameV.setRoomNo(1);
    		    	  //mHighScores.incrementSave2(mGameV.getUsernum());
    		    	  // used for cycles
    		      }

    		      // this basically saves checkpoints and cycles...
    		      // deal with high scores
    		      /*
    		      if ( mHighScores.getScore(mGameV.getUsernum())  > mGameV.getScore() && mGameV.getUsernum() < 4 ) {
    		        //writeData(highScores); // or is this needed?
    		      }

    		      // save a high score and decide weather or not it 'ranks'...
    		      if ( mHighScores.getScore(mGameV.getUsernum())  <= mGameV.getScore() || mGameV.getUsernum() == 4) {
    		        mHighScores.setScore(mGameV.getScore() ,mGameV.getUsernum()) ;
    		        //ranks = sortScores(highScores);
    		        //writeData(highScores);
    		      }
    		      else {
    		        ranks = false;
    		      }
    		      
    		      */

    		    } /////////// while NUM_ROOMS loop

    		  
    		    
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
    			Log.v("InnerGameLoop", "Running behind");
    			newDate = new Date();
    			nextGameTick = newDate.getTime();
    			//ticksElapsed = newDate.getTime();
    		}
    	}
    };



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
    
    
    
}
