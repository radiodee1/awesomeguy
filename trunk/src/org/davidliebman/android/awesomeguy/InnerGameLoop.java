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
		    
		    
		    if (!mGameV.isUseSavedBundle()) mGameV.setScore(10);
		    
		    mGameV.setEndGame(false);
		    
		    while(mGameV.getRoomNo() <= mGameV.getLevelList().size()  && !mGameV.isEndGame() 
		    		&& mGameV.isGameRunning() && mGameV.getLives() > 0) {

   
		     // advance through rooms


		    
		    if (!mGameV.isUseSavedBundle()) {
		    	mHandler.sendEmptyMessage(GameStart.STARTLEVEL);
		    	//init room
			    mGameV.getBackground().setLevel(mGameV.getLevelList().getNum(mGameV.getRoomNo()-1));

		    	
		    }
		    else {
			   mGameV.getBackground().setLevel(mGameV.getLevelList().getNum(mGameV.getRoomNo() -1));
			   
		    	mHandler.sendEmptyMessage(GameStart.REORIENTATION);
		    	//mGameV.incrementRoomNo();
		    }
		    
		    
    		mHandler.removeMessages(GameStart.MOVEMENTVALUES);

		   

		    
		    if (!mGameV.isUseSavedBundle() ) {
		    	mMovementV.setScrollX(0);
		    	mMovementV.setScrollY(0);
		    	
		    	mGameV.getBackground().initLevel(mMovementV);
		    
		    	mPanel.setLevelData(mGameV.getLevelArray(), mGameV.getObjectsArray(), mGameV.getMapH(), mGameV.getMapV());
		    
		    	mPanel.addMonstersJNI();
		    	mPanel.addPlatformsJNI();
		    }
		    else {
		    	
		    	
		    }
		    
		    
		    //end of restore from bundle
		    //mGameV.setUseSavedBundle(false);
		    mGameV.setXmlMode(GameValues.XML_USE_BOTH);
		    
		    //get guy sprite reference 
			mGuySprite = mGameV.getSpriteStart();
		    mPanel.setGuySprite(mGuySprite);
			
		    mGameV.setEndLevel(false);
		    mGameV.setGameDeath(false);

		    mPanel.setJNIAnimateOnly(Panel.JNI_FALSE);
		    
			mLoop = true;
		    while(mLoop && mGameV.isGameRunning() && !mGameV.isEndLevel()) { // GAME PLAY LOOP
		       boolean mIsNotLate = false;
		    	//mCanvas = null;
		    	if (mGameV.isGameRunning()) mIsNotLate = gameSpeedRegulator(); //call inside 'game play' loop

		    	mGameV.setGuyScore(mHighScores);

		    	
		    	mGameV.getPanel().setPanelScroll(mMovementV.getScrollX(), mMovementV.getScrollY());
    			
    			if (mMovementV.getLetterKeyB() > 0) mGameV.getPanel().setKeyB(true);
    			else mGameV.getPanel().setKeyB(false);
    			
		    	if (mIsNotLate ) {
		    		
		    		
		    		/* formerly above 'draw' */
		    		mGameV.getPanel().setScoreLives(mGameV.getScore(), mGameV.getLives());
		    		
		    		mGameV.getPanel().checkRegularCollisions();

					mGameV.getPanel().checkPhysicsAdjustments();
									
					mGameV.getPanel().scrollBg(); //always call this last!!
					
					/* JNI method now calls 'drawLevel()' with animate var */
					mGameV.getPanel().callJNIdrawLevel();
				
					/* at end of level -- call after 'drawLevel()' */
		    		if(mGameV.getPanel().getEndLevel() == 1) {
		    			mGameV.setEndLevel(true);
		    			mGameV.decrementLives();
		    			mGameV.setGameDeath(true);
		    		}
		    		
		    		/* changes during level -- call after 'drawLevel()' */
		    		mHighScores.setLives(mGameV.getPanel().getLives());
		    		mHighScores.setScore(mGameV.getPanel().getScore());
		    		mGameV.setScore(mGameV.getPanel().getScore());
					
		    		/* call after 'drawLevel()' */
					mGameV.getPanel().playSounds();
					
	
					
		    	}
		
				

		    } // end of gameplay loop
		    

		    mGameV.getPanel().setReturnBackgroundGraphics();
		   
		    
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
		      if( mGameV.getRoomNo() > mGameV.getTotNumRooms() &&  !mGameV.isEndLevel() && !mGameV.isUseSavedBundle() ) {
		        
		    	  mGameV.setRoomNo(1);
		    	  //saveRoomNo();

		      }
			   mGameV.setUseSavedBundle(false);

		      
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