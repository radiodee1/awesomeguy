package org.davidliebman.android.awesomeguy;

import java.util.Date;

import android.graphics.Canvas;
import android.os.Message;
import android.util.Log;

public class InnerGameLoop extends Thread {
	/* old GameLoop - variables */
	private boolean mLoop = true;
	private boolean mPlayAgain = true;
	private Record mHighScores;
	private SpriteInfo mGuySprite;
    private Scores mScores;
    	
	/* old GameLoop - prepare timer */
	private long framesPerSec = 25;
	private long skipTicks = 1000 / framesPerSec;
	private long ticksElapsed; //, startTicks;
	private long sleepTime = 0;
	private long nextGameTick = 0;
	
	private GameValues mGameV;
	private MovementValues mMovementV;
	private Panel mPanel;
	private GameStart.PanelHandler mHandler;
	
	public InnerGameLoop (GameStart game, GameValues mValues, Panel mPanelBot) {
		//Log.v("InnerGameLoop", "init");
		mGameV = mValues;
		mMovementV = mValues.getMovementValues();
		mHandler = (GameStart.PanelHandler) mValues.getHandler();
		mPanel = mPanelBot;
		mScores = mGameV.getScores();
		
		mHighScores = mGameV.getGuyScore();
		framesPerSec = mHighScores.getGameSpeed();
    	skipTicks = 1000 / framesPerSec;
    	if (framesPerSec < 0 || skipTicks < 0) skipTicks = 1;
    	
	}
	
	@Override
	public void run() {
		
		//prepare timer
		Date startDate = new Date();
		nextGameTick = startDate.getTime();
		
//		boolean mSavedRoomFlag = false;
		Canvas mCanvas;
		
		
		  ///////////////////////////////////////////////////////
		  // PLAY THE GAME
		  while(mPlayAgain && mGameV.isGameRunning()) {
		    mPlayAgain = false;
		
			
			// new score ?? SAVE OLD SCORE!!
		    mGameV.setOldGuyScore(mHighScores.getScore());
			
		    ////////////////////////////////////////////////////////
		    // PREP FOR GAME PLAY
		    // set lives
		    
		    if (!mGameV.isUseSavedBundle()) mGameV.setLives(3);
		    // set room num
		    
//		    if (mSavedRoomFlag == true) mGameV.setRoomNo(1);
//		    mSavedRoomFlag = true;
		    
		    
		    if (!mGameV.isUseSavedBundle()) mGameV.setScore(10);
		    
		    mGameV.setEndGame(false);
		    
		    while(mGameV.getRoomNo() <= mGameV.getLevelList().size()  && !mGameV.isEndGame() 
		    		&& mGameV.isGameRunning() && mGameV.getLives() > 0) {

   
		     // advance through rooms

		      
		    if (!mGameV.isUseSavedBundle()) {
		    	//mHandler.sendEmptyMessage(GameStart.STARTLEVEL);
		    }
		    else {
		    	mHandler.sendEmptyMessage(GameStart.REORIENTATION);
		    }
		    
		    
    		mHandler.removeMessages(GameStart.MOVEMENTVALUES);

		    //init room
		    mGameV.getBackground().setLevel(mGameV.getLevelList().getNum(mGameV.getRoomNo()-1));

		    if (!mGameV.isUseSavedBundle()) {
		    	mMovementV.setScrollX(0);
		    	mMovementV.setScrollY(0);
		    	
		    	mGameV.getBackground().initLevel(mMovementV);
		    
		    	//jni  !!
		    
		    	mPanel.setLevelData(mGameV.getLevelArray(), mGameV.getObjectsArray(), mGameV.getMapH(), mGameV.getMapV());
		    
		    	mPanel.addMonstersJNI();
		    	mPanel.addPlatformsJNI();
		    }
		    
		    

		    
		    //end of restore from bundle
		    mGameV.setUseSavedBundle(false);
		    mGameV.setXmlMode(GameValues.XML_USE_BOTH);
		    
		    //get guy sprite reference 
			mGuySprite = mGameV.getSpriteStart();
		    mPanel.setGuySprite(mGuySprite);
	    	
		    //Canvas mCanvas;
			
		    mGameV.setEndLevel(false);
		    mGameV.setGameDeath(false);
		    
			mLoop = true;
		    while(mLoop && mGameV.isGameRunning() && !mGameV.isEndLevel()) { // GAME PLAY LOOP
		       boolean mIsNotLate = false;
		    	mCanvas = null;
		    	if (mGameV.isGameRunning()) mIsNotLate = gameSpeedRegulator(); //call inside 'game play' loop

		    	
		    	// ** ALWAYS SEND THIS MESSAGE **
		    	mGameV.setGuyScore(mHighScores);
//		    	Message mM = new Message();
//		    	mM.what = GameStart.MOVEMENTVALUES;
//		    	mM.obj = mHighScores;
//		    	mHandler.sendMessageAtFrontOfQueue(mM);
				
		    	//mHandler.sendEmptyMessage(GameStart.MOVEMENTVALUES);
    			
		    	//mGameV.getPanel().setAnimationOnly(false);
		    	
		    	mGameV.getPanel().setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    			
    			if (mMovementV.getLetterKeyB() > 0) mGameV.getPanel().setKeyB(true);
    			else mGameV.getPanel().setKeyB(false);
    			
		    	if (mIsNotLate ) {
		    		
		    		/* at end of level */
		    		if(mGameV.getPanel().getEndLevel() == 1) {
		    			mGameV.setEndLevel(true);
		    			mGameV.decrementLives();
		    			mGameV.setGameDeath(true);
		    		}
		    		
		    		/* changes during level */
		    		mHighScores.setLives(mGameV.getPanel().getLives());
		    		mHighScores.setScore(mGameV.getPanel().getScore());
		    		mGameV.setScore(mGameV.getPanel().getScore());
		    		
		    		/* formerly above 'draw' */
		    		mGameV.getPanel().setScoreLives(mGameV.getScore(), mGameV.getLives());
		    		
		    		mGameV.getPanel().checkRegularCollisions();

					mGameV.getPanel().checkPhysicsAdjustments();
					
					mGameV.getPanel().animateItems();
				
					mGameV.getPanel().scrollBg(); //always call this last!!
					
					mGameV.getPanel().prepareBitmap();
					
					//mGameV.getPanel().JNIcopyToTexture();
					
					mGameV.getPanel().playSounds();
					
					//Log.e("InnerGameLoop","call jni");
		    	}
		    	
//				try {
//					mCanvas = mGameV.getHolder().lockCanvas(null);
//
//					synchronized(mGameV.getHolder()) {
//
//						//mGameV.getPanel().postInvalidate();
//
//					}
//			
//					
//				}
//				//catch(Exception e) {e.printStackTrace();}
//				finally {
//					if (mCanvas != null) {
//						mGameV.getHolder().unlockCanvasAndPost(mCanvas);
//					}
//				} // end finally
				
				
				
		    } // end of gameplay loop

		   
		    
	    	mHandler.sendEmptyMessage(GameStart.GAMESTOP);
	    	
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
		      if( mGameV.getRoomNo() > mGameV.getTotNumRooms() &&  !mGameV.isEndLevel() ) {
		        
		    	  mGameV.setRoomNo(1);
		    	  //saveRoomNo();

		      }

		      
		      if (!mGameV.isGameDeath() && mGameV.isGameRunning() ) {
		    	  mHandler.sendEmptyMessage(GameStart.CONGRATS);
		    	  
		      }
		      
		    } /////////// while NUM_ROOMS loop

		    if (mGameV.isGameRunning()) {
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
	

	
	public   boolean gameSpeedRegulator() {
		
		boolean mIsNotLate = true;
		
		Date newDate = new Date();
		ticksElapsed = newDate.getTime();
		nextGameTick += skipTicks;
		sleepTime = nextGameTick - ticksElapsed;

		
		if ( (sleepTime >= 0 && mGameV.isGameRunning()) || framesPerSec < 0 ) {
		
			//Log.e("InnerGameLoop", "---Passing time");
			try {
	            if (framesPerSec > 0) Thread.sleep(sleepTime);
	    	} catch (InterruptedException e) {
	    		//
	    	} 
	    	mIsNotLate = true;
		}
		else {
			//Log.e("InnerGameLoop", "---Running behind");
			newDate = new Date();
			nextGameTick = newDate.getTime();
			//ticksElapsed = newDate.getTime();
			mIsNotLate = false;
		}
		return mIsNotLate;
	}
	
	
	
	
};