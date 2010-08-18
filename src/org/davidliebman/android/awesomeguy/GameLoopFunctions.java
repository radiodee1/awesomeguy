package org.davidliebman.android.awesomeguy;

import android.os.Message;
import android.util.Log;
import java.util.Date;
import android.media.*;
import android.content.*;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Paint;


public class GameLoopFunctions  {
	
	private GameValues mGameV;
	private GameStart mGame;
	private MovementValues mMovementV;
	private Scores mHighScores;
	// test jni
	private Panel mPanel;
	
	private SoundPoolManager mSounds;
	
	/* game loop and game play logic */
	private boolean gameRunning = true;
	private boolean mLoop = true;
	private int mOldLives;
	//private boolean mScoresOnScreen = false;
	private boolean mPlayAgain = true;
	private boolean mMakeName = false;
	private boolean ranks = false;
	
	/* prepare timer */
	//private static final long framesPerSec = 16;
	//private static final long skipTicks = 1000 / framesPerSec;
	//private long startTicks, ticksElapsed;
	//private long sleepTime = 0;
	//private long nextGameTick = 0;
	
	
	private boolean changeX = false;
	private boolean changeY = false;
	
	/* for scrolling */
	private final int LR_MARGIN = 80;
	private final int TB_MARGIN = 40;
	private SpriteInfo mGuySprite;
	
	/* for scrolling, collision, etc. */
	private boolean canScroll;
	private int oldX;
	private int oldY;
	private int screenX;
	private int screenY;
	private int mapH;
	private int mapV;
	
	private int mapX;
	private int mapY;
	
	private int newMapX;
	private int newMapY;
	
	private int newX;
	private int newY;
	
	private int guyWidth; 
	private int guyHeight;
	
	private int x;
	private int y;
	
	private boolean keyB = false;
	private int jumptime;
	
	private double mXMultiplier = 1;
	private double mYMultiplier = 1;
	
	private boolean ladderTest = false;
	private boolean blockTest = false;
	private boolean boundaryTest = false;
	private boolean boundaryLeft = false;
	private boolean boundaryRight = false;
	private boolean canFall = false;
	private boolean canJump = false;
	
	public static final int END = 1;
	public static final int MIDDLE = 2;
	public static final int START = 3;
	
	/* for monster animation */
	public static final int ANIM_SPEED = 5;
	private Paint mP = new Paint();
	
	//private BoundingBox guyBox;
	
	public GameLoopFunctions (GameValues gameV, GameStart game , MovementValues movement, Panel panel) {
		mGame = game;
		mGameV = gameV;
		mMovementV = movement;
		mHighScores = new Scores();
		mPanel = panel;
		
		mSounds = new SoundPoolManager(game);
		mSounds.init();
		
		mP.setAlpha(0xff);
	}
	
	
	
	
	
	
	public   void readKeys(double num) {
		mXMultiplier = num;
		mYMultiplier = num;
		readKeys();
		mXMultiplier = 1;
		mYMultiplier = 1;
	}
	
	
	public  void readKeys() {		
		
		
		/* set x and y as determined by game pad input */
    	x=0;
    	y=0;
    	
    	//keyB = false;
    	
    	changeX = false;
    	changeY = false;
    	
    	if(mMovementV.getDirectionLR() == MovementValues.KEY_RIGHT) {
    		
    		x =  (int) + (mMovementV.getHMove() * mXMultiplier);
    		changeX = true;
    		//keyB = false;
    	}
    	if(mMovementV.getDirectionLR() == MovementValues.KEY_LEFT) {
    		x =  (int) - (mMovementV.getHMove() * mXMultiplier);
    		changeX = true;
    		//keyB = false;
    	}
    	if(mMovementV.getDirectionUD() == MovementValues.KEY_UP) {
    		y =  (int) - (mMovementV.getVMove() * mYMultiplier);
    		changeY = true;
    		//keyB = false;
    	}
    	if(mMovementV.getDirectionUD() == MovementValues.KEY_DOWN) {
    		y =  (int) + (mMovementV.getVMove() * mYMultiplier);
    		changeY = true;
    		//keyB = false;
    	}
    	/*
    	if(mMovementV.getLetterKeyB() == MovementValues.KEY_B) {
    		keyB = true;
    	}
    	*/
    	
	}

	public void physicsAdjustments() {
		
		
		
		/* All sorts of adjustments go here. ladder, jump, gravity, 
		 * the ground, and solid objects in general.
		 */
		BoundingBox guyBox = BoundingBox.makeSpriteBox(mGuySprite,0,0);

		
		int jumpHeight = 15;

		int center = ((guyBox.getLeft() + guyBox.getRight() ) / 2) /8; 
		int actual = ((guyBox.getLeft() + guyBox.getRight() ) / 2) - (center *8);
		int centerBlock = BoundingBox.getCenterBlock(guyBox);
		//if (center == centerBlock) centerTest = true;


		/* LADDER TEST */
		if (ladderTest) {
			canFall = false;
			//Log.v("ladder test", "canfall = false;");

		}
		
		else if (y  < 0 && jumptime <= 0){
			y = 0;
			canFall = true;
		}
		
		
		
		
		
		/* JUMP */
		if (keyB) {

			if ( jumptime <= 0 && y == 0 && actual >= 2 && actual <= 6 &&
					(mGameV.getObjectsCellReversed(mapY/8 -1, centerBlock) != mGameV.mBlock  ||
					mGameV.getObjectsCellReversed(mapY/8 - 1, centerBlock) != mGameV.mBlock) && // mapX/8 + 1 
					(mGameV.getObjectsCellReversed(mapY/8 + 2, centerBlock) == mGameV.mBlock || // mapX/8 + 1 
					ladderTest || guyBox.getBottom() == mGameV.getMapV() * 8 || canJump) ) {

				jumptime = mMovementV.getVMove() * jumpHeight;

			} 
			else  if ( jumptime <= 0 && y == 0 && actual > 6 &&
					(mGameV.getObjectsCellReversed(mapY/8 -1,centerBlock + 1) != mGameV.mBlock ||
					mGameV.getObjectsCellReversed(mapY/8 -1,centerBlock + 1) != mGameV.mBlock) && // mapX/8 + 1 
					(mGameV.getObjectsCellReversed(mapY/8 + 2,centerBlock + 1) == mGameV.mBlock || // mapX/8 + 1 
					ladderTest || guyBox.getBottom() == mGameV.getMapV() * 8 || canJump) ) {

				jumptime = mMovementV.getVMove() * jumpHeight;

			} 
			else if ( jumptime <= 0 && y == 0 && actual < 2 &&
					(mGameV.getObjectsCellReversed(mapY/8 -1,centerBlock - 1) != mGameV.mBlock ||
					mGameV.getObjectsCellReversed(mapY/8 -1,centerBlock -1) != mGameV.mBlock) && // mapX/8 + 1 
					(mGameV.getObjectsCellReversed(mapY/8 + 2,centerBlock - 1) == mGameV.mBlock || // mapX/8 + 1 
					ladderTest || guyBox.getBottom() == mGameV.getMapV() * 8 || canJump) ) {

				jumptime = mMovementV.getVMove() * jumpHeight;

			} 
			keyB = false;
		}
		
		
		

		/* BLOCK TEST */

		if (actual > 6) {
			if(!boundaryRight) center ++;
			collisionWithBlocks(   center , END);
		}
		else if (actual < 2) {
			if(!boundaryLeft) center --;
			collisionWithBlocks(   center , START);
		}
		else {
			collisionWithBlocks(   center , MIDDLE);
		}

		/* PLATFORMS */
		//canJump = collisionWithPlatforms( keys, canFall);

		/*
		 * handle jumps.
		 */
		if (jumptime > 0) {
			jumptime = jumptime - mMovementV.getVMove() ;
			y =  - mMovementV.getVMove();// * 2 / 3);
			//if(jumptime >  mMovementV.getVMove() * 3) x = 0;
			canFall = false;
			Log.v("functions","jumping");
		}

		/* 
		 * Here we implement the gravity.
		 */
		if(canFall && !ladderTest) {
			y = y + mMovementV.getVMove() ;

		}
		
		


	}

	private boolean collisionWithBlocks(  int centerBlock , int boundaryTest) {
		int i;
		int below = 2;
		int mapY = mGuySprite.getMapPosY();
		i = mapY / 8;
		if (mapY - (i *8) > 4) below --;
		boolean keyLeft = false;
		boolean keyRight = false;
		//boolean keyUp = false;
		boolean keyDown = false;

		/* these are shortcuts for commonly used values in this function */
		int centerBlockIm1 = mGameV.getObjectsCellReversed(i-1, centerBlock); // i minus 1
		int centerBlockI = mGameV.getObjectsCellReversed(i, centerBlock);     // i
		int centerBlockIp1 = mGameV.getObjectsCellReversed(i+1, centerBlock); // i plus 1
		int centerBlockIp2 = mGameV.getObjectsCellReversed(i+2, centerBlock); // i plus 2
		int centerBlockIpBelow = mGameV.getObjectsCellReversed(i+below, centerBlock); // i plus below
		
		if (mMovementV.getDirectionLR() == MovementValues.KEY_LEFT) keyLeft = true;
		if (mMovementV.getDirectionLR() == MovementValues.KEY_RIGHT) keyRight = true;
		if (mMovementV.getDirectionUD() == MovementValues.KEY_DOWN) keyDown = true;
		//if (mMovementV.getDirectionUD() == MovementValues.KEY_UP) keyUp = true;

		
		
		//what if centerBlock is on the boundary??
		if(centerBlock == mGameV.getMapH()) {
			//y = 0;
			canFall = false;
			return false;
		}
		
		
		if(keyDown ) { // regular falling ... don't adjust y in case of ladders.
			canFall = false;

		}


		if (// boundaryTest == MIDDLE &&
				centerBlockIm1 != mGameV.mLadder && ladderTest == false) { 
			// ladder above?
			if (y > 0 ) y = 0;
			canFall = false;
		}
		if (keyDown && ladderTest && 
				centerBlockIp2 == mGameV.mBlock) { // bottom of ladder?
			// don't go through floor!
			y =0;
			canFall = false;
		}
		
		if (jumptime > 0 && 
				centerBlockI == mGameV.mBlock ){    // hit block from below
			//y = V_MOVE * 2;
			y = 0;
			canFall = true;
			jumptime =0;
		}

		// wall at RIGHT
		if (keyRight && boundaryTest == END && 
				centerBlockIp2 != mGameV.mBlock &&   // not on ground
				(
				centerBlockI== mGameV.mBlock ||      // one block to the right
				centerBlockIp1== mGameV.mBlock )) {   // or another block to the right
			canFall = true;
			x =  0;

		}
		// wall at RIGHT and hanging
		if (  boundaryTest == END && mGameV.getObjectsCellReversed(i+2,centerBlock-1) != mGameV.mBlock 
			&& !ladderTest &&  // not on ground
				(
				centerBlockI == mGameV.mBlock ||      // one block to the right
				centerBlockIp1 == mGameV.mBlock )) {   // or another block to the right
			canFall = true;
			x =  0;

		}
		// wall at RIGHT on ground
		if (keyRight && boundaryTest == END && 
				centerBlockIp2 == mGameV.mBlock&& // on ground 
				centerBlockI == mGameV.mBlock) {     // block to the right // j + 2
			x = 0;
		}
		// wall at LEFT
		if (keyLeft && boundaryTest == START && 
				centerBlockIp2 != mGameV.mBlock && 
				// not on ground
				(
				centerBlockI == mGameV.mBlock ||      // one block to the left
				centerBlockIp1 == mGameV.mBlock)){ // or another block to the left
			canFall = true;
			x = 0;//- H_MOVE;
		}
		// wall at LEFT and hanging
		if (  boundaryTest == START && mGameV.getObjectsCellReversed(i+2,centerBlock+1) != mGameV.mBlock 
			&& !ladderTest &&   // not on ground
				(
				centerBlockI == mGameV.mBlock ||      // one block to the right
				centerBlockIp1 == mGameV.mBlock )) {   // or another block to the right
			canFall = true;
			x =  0;

		}
		// wall at LEFT on ground
		if (keyLeft && boundaryTest == START && 
				centerBlockIp2 == mGameV.mBlock &&  // on ground
				centerBlockI == mGameV.mBlock) {    // block to the left
			x = 0;//- H_MOVE;
		}
		// skip RIGHT
		if(keyRight  && 
				centerBlockIp1 == mGameV.mBlock && 
				centerBlockI != mGameV.mBlock && 
				centerBlockIm1 != mGameV.mBlock ) { //y,x
			canFall = false;
			y = - (8 +  mMovementV.getVMove());
		}
		else if(keyRight && 
				centerBlockIp1 == mGameV.mBlock) { //hit block from side
			x = 0;

		}
		
		// skip LEFT
		if(keyLeft && 
				centerBlockIp1 == mGameV.mBlock && 
				centerBlockI != mGameV.mBlock &&
				centerBlockIm1 != mGameV.mBlock) {// j-1 j-1
			canFall = false;
			y = - (8 + mMovementV.getVMove());
		}
		else if(keyLeft && 
				centerBlockIp1 == mGameV.mBlock ) { // hit block from side
			x = 0;
		}

		// no hanging
		if( 
				centerBlockIp1 != mGameV.mBlock && 
				centerBlockIp2 != mGameV.mBlock && 
				centerBlockIm1== mGameV.mBlock && !ladderTest) { 
			// no hanging from
			// blocks by accident
			Log.v("functions","no hanging");
			
			y = mMovementV.getVMove() ;//crucial?
			
			canFall = true;
			jumptime =0;
		}

		if(keyRight && 
				centerBlockI== mGameV.mBlock && 
				centerBlockIp1 == mGameV.mBlock && 
				!ladderTest && boundaryTest == END) {                                         // hit wall
			// no hanging from
			// blocks by accident
			x = 0 ;
			canFall = true;

		}
		if(keyLeft && 
				centerBlockI == mGameV.mBlock && 
				centerBlockIp1 == mGameV.mBlock && 
				!ladderTest && boundaryTest == START) {                                       // hit wall
			// no hanging from
			// blocks by accident
			x = 0 ;
			canFall = true;

		}
		
		if (jumptime <= 0 && //boundaryTest == MIDDLE && 
				centerBlockIpBelow == mGameV.mBlock || 
				centerBlockIpBelow == mGameV.mLadder
				
				) { // i + 2
			// if no space below, then don't fall.
			//y = V_MOVE;
			canFall = false;
		}
		if (jumptime <= 0 // && boundaryTest == MIDDLE 
				&& 
				centerBlockIpBelow != mGameV.mBlock && 
				centerBlockIpBelow != mGameV.mLadder
				){ // i + 2
			// if space below, then fall.
			//y = V_MOVE;
			canFall = true;
		}
		
		//if no space above and guy is rising
		if ((y < 0 && boundaryTest == MIDDLE && 
				centerBlockIm1 == mGameV.mBlock) || 
				(y < 0 && 
				mGameV.getObjectsCellReversed(i-1,centerBlock+1) == mGameV.mBlock
				&& boundaryTest == MIDDLE)) {
			
			if (!ladderTest) y = 0;
		}
		//guy shouldn't sink at boundary of level
		if (this.boundaryTest &&  
				centerBlockIp2 == mGameV.mBlock) {
			y = 0;
			
		}
		//ladders should work - no sliding at top of ladder
		if (ladderTest) {
			canFall = false;
		}
		// if you start to fall, and there's a ladder below you
		// you should stop falling
		if (!keyDown && ladderTest) {
			if(y > 0) y = 0;
		}
		
		return canFall;
	}
	
	public void collisionWithMonsters() {

		  int i;
		  BoundingBox guyBox = BoundingBox.makeSpriteBox( mGameV.getSpriteStart() , 0, 0 );

		  /*** CHECK MONSTERS FOR COLLISION WITH CHARACTER ***/
		  for (i = mGameV.getMonsterOffset()  ; i < mGameV.getMonsterOffset() + mGameV.getMonsterNum() ; i++) {   
		    BoundingBox monsterBox = BoundingBox.makeSpriteBox(mGameV.getSprite(i) , 0, 0 );
		    boolean test = guyBox.collisionSimple(monsterBox);// collisionSimple(guyBox, monsterBox);
		    if (test && mGameV.getSprite(i).getActive()  == true) {
		    
		      if (guyBox.getBottom()  < monsterBox.getBottom()) {
		    	mGameV.getSprite(i).setActive(false);
		    	mPanel.inactivateMonster(i );
		    	//sprites[i].active = false;
		    	mGameV.incrementScore(10);
				mSounds.playSound(SoundPoolManager.SOUND_BOOM);

		        
		        
		      }
		      else {
		    	mGameV.setEndLevel(true);
		    	//level.endLevel = true;
		        mGameV.decrementLives();
				mSounds.playSound(SoundPoolManager.SOUND_OW);

		      }
		    }
		  }
		}


	
	public void scrollBg() {
		/* scroll registers for background */
		
		canScroll = true;
		oldX = mMovementV.getScrollX();
		oldY = mMovementV.getScrollY();
		screenX = oldX;
		screenY = oldY;
		mapH = mGameV.getMapH();
		mapV = mGameV.getMapV();
		
		mapX = mGuySprite.getMapPosX();
		mapY = mGuySprite.getMapPosY();
		
		newMapX = mapX;
		newMapY = mapY;
		
		newX = mGuySprite.getX();
		newY = mGuySprite.getY();
		
		guyWidth = mGuySprite.getRightBB() - mGuySprite.getLeftBB(); // 12 ?
		guyHeight = mGuySprite.getBottomBB() - mGuySprite.getTopBB();
		
		
		
    	/* 
    	 * determine position of guy on screen and determine position
    	 * of background on screen also... set scrolling, etc. x and y
    	 * are set by routine 'readKeys()'
    	 */
		
    	if (x > 0) {   

    		if (oldX > mapH * 8 ) oldX = -1;

    		if (oldX >= ((mapH -32) * 8 - x)  ) canScroll = false;
    		else canScroll = true;
    		//move RIGHT?
    		if ((mGuySprite.getX() + x) >= ((32)  * 8 - guyWidth) || mapX + x >= mapH * 8  - guyWidth) {
    			newMapX = mapH * 8  - guyWidth;
    			newX = 32  * 8 - guyWidth;

    		}

    		if ((mapX + x) >= (oldX + LR_MARGIN) ) {        


    			if (canScroll ) {
    				screenX += x;
    				newMapX += x;
    			}
    			else if ( mapX <= (mapH ) * 8 - guyWidth ) {
    				newX += x;
    				newMapX += x;
    			}

    		}
    		else if ((mapX + x) <= (oldX + LR_MARGIN) &&  canScroll) {
    			//move sprite?
    			newX += x;
    			newMapX += x;

    		}


    	}  

    	//////////////////////////////////////
    	else if (x < 0) {   
    		if (oldX > 8 * mapH + 1) oldX = -1;

    		if (oldX <= 0 - x) canScroll = false;
    		else canScroll = true;
    		//move LEFT?
    		if ((mGuySprite.getX() + x) <= (0) || mapX + x <= 0) {
    			newMapX = 1;
    			newX = 1;

    		}

    		if ((mapX + x) <= (oldX +( (32) * 8 ) - LR_MARGIN) ) {   //32 * 8     


    			if (canScroll) {
    				screenX  += x;
    				newMapX += x;

    			}
    			else if ( mapX >= 0 ) {
    				newX += x;
    				newMapX += x; 

    			}

    		}
    		else if ((mapX + x) >= (oldX + ( (32) * 8) - LR_MARGIN) &&  canScroll) { // 32 * 8
    			//move sprite?
    			newX += x;
    			newMapX += x;

    		}

    	}  
    	
    	//////////////////////////////////////
    	if (y > 0) {   
    		if (oldY > mapV * 8) oldY = -1; 

    		if (oldY >= ((mapV - 24) * 8 - y) ) canScroll = false;
    		else canScroll = true;
    		//move DOWN?
    		if ((this.mGuySprite.getY() + y) >= (24 * 8 - guyHeight) || mapY + y >= mapV * 8  - guyHeight) {
    			newMapY = mapV * 8  - guyHeight;
    			newY = 24 * 8 - guyHeight;

    		}

    		if ((mapY + y) >= (oldY + TB_MARGIN) ) {        


    			if (canScroll) {
    				screenY += y;
    				newMapY += y;
    			}
    			else if ( mapY <= mapV * 8  - guyHeight ) {
    				newY += y;
    				newMapY += y;
    			}

    		}
    		else if ((mapY + y) <= (oldY + TB_MARGIN) &&  canScroll) {
    			//move sprite?
    					newY += y;
    			newMapY += y;

    		}

    	}  
    	////////////////////////////////////// 
    	else if (y < 0) {   
    		if (oldY > mapV * 8) oldY = -1;

    		if (oldY < ( 0 - y) ) canScroll = false;
    		else canScroll = true;
    		//move UP?
    		if ((this.mGuySprite.getY() + y) <= (0) || mapY + y <= 0) {
    			newMapY = 1;
    			newY = 1;

    		}

    		if ((mapY + y) <= (oldY +( (24 ) * 8 ) - TB_MARGIN) ) { //32 * 8       


    			if (canScroll && screenY + y > 0) {
    				screenY += y;
    				newMapY += y;

    			}
    			else if ( mapY >= 0 ) {
    				newY += y;
    				newMapY += y;
    			}

    		}
    		else if ((mapY + y) >= (oldY + ( 24  * 8 ) - TB_MARGIN) &&  canScroll) { //32 * 8
    			//move sprite?
    			newY += y;
    			newMapY += y;

    		}

    	}
    	////////////////////////


    	mGuySprite.setMapPosX(newMapX);
    	mGuySprite.setMapPosY(newMapY);
    	mGuySprite.setX(newX);
    	mGuySprite.setY(newY);
    	
		mMovementV.setScrollX(screenX);
		mMovementV.setScrollY(screenY);
	}
	
	public void checkRegularCollisions() {
		
		/*
		 * Here we create a BoundingBox for the guy character. Then
		 * we check the level for collisions.
		 */
				
		//BoundingBox guyBoxNext = makeSpriteBox(guy, x, y);
		BoundingBox guyBox = BoundingBox.makeSpriteBox(mGuySprite, 0, 0 );

		// set ladderTest to false
		ladderTest = false;
		blockTest = false;
		boundaryTest = false;
		boundaryLeft = false;
		boundaryRight = false;
		canFall = true;

		int i,j;

		for (j =  mGuySprite.getMapPosX() / 8 -1; j <  mGuySprite.getMapPosX() / 8 + 3; j ++ ) { // x coordinates
			for (i = mGuySprite.getMapPosY() / 8 - 1; i < mGuySprite.getMapPosY() / 8 + 3; i ++ ) { // y coordinates
				if(j >= 0 && j < mGameV.getMapH()  && i >= 0 && i < mGameV.getMapV()) {// indexes OK?

					if (mGameV.getObjectsCell(j,i)  != 0 && gameRunning) { // I/J or J/I... which one???

						/* save time here by checking the bounding 
						 * box only in the squares immediately surrounding
						 * the character...
						 * Instead of checking the whole field of play.
						 */

						BoundingBox testMe = BoundingBox.makeBlockBox(j,i);
						//bool testNext = collisionSimple(guyBoxNext, testMe);
						boolean test = guyBox.collisionSimple( testMe);

						/****** tests here ******/

						/*********  block ***************/
						if (test && mGameV.getObjectsCell(j, i) == mGameV.mBlock) {
							blockTest = true;


						}
						/******** ladder **********/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mLadder) {
							ladderTest = true;
						}

						/************ GOAL ****************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mGoal ) {

							mGameV.setEndLevel(true);

							mGameV.setObjectsCell(j, i, 0);
							
							//mPanel.setObjectsDisplay(j, i, 0);//jni
							
							mGameV.incrementScore(100);
							//mmEffect(SFX_GOAL);
							mSounds.playSound(SoundPoolManager.SOUND_GOAL);
							
						}
						/************ goal ends ****************/
						/************* prizes ******************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mPrize ) {

							mGameV.setObjectsCell(j, i, 0);
							
							mPanel.setObjectsDisplay(j, i, 0);//jni
							
							mGameV.incrementScore(10);
							//mmEffect(SFX_PRIZE);
							mSounds.playSound(SoundPoolManager.SOUND_PRIZE);
						}

						/********** prizes end *****************/
						/************* keys   ******************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mKey ) {

							mGameV.setObjectsCell(j, i, 0);
							
							//mPanel.setObjectsDisplay(j, i, 0);//jni
							
							mGameV.incrementScore(50);
							//mmEffect(SFX_PRIZE);
							mSounds.playSound(SoundPoolManager.SOUND_PRIZE);
							//data[level.usernum].level = level.room;
							//must save this data...
						}

						/**********   keys end *****************/
						/**************** oneup ****************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mOneup ) {

							mGameV.setObjectsCell(j, i, 0);
							
							//mPanel.setObjectsDisplay(j, i, 0);//jni
							//mmEffect(SFX_GOAL);
							mSounds.playSound(SoundPoolManager.SOUND_GOAL);
							mGameV.incrementLives();
						}
						/*****************end oneup *************/
						/**************** bigprize ****************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mBigprize ) {

							mGameV.setObjectsCell(j, i, 0);
							
							//mPanel.setObjectsDisplay(j, i, 0);//jni
							
							mGameV.incrementScore(200);
							//mmEffect(SFX_PRIZE);
							mSounds.playSound(SoundPoolManager.SOUND_PRIZE);

						}
						/*****************end bigprize *************/
						/************ death ****************/
						if (test && mGameV.getObjectsCell(j,i) == mGameV.mDeath ) {


							mGameV.setEndLevel(true);
							mGameV.decrementLives();

							//mmEffect(SFX_OW);
							mSounds.playSound(SoundPoolManager.SOUND_OW);
						}
						/************ death ends ****************/
						/****** end tests  ******/
						
						//mHighScores.setAll(mGameV, mGameV.getUsernum());
						//mHighScores.setAll(mGameV.getGuyScore());
						
					}//if block
				} // indexes OK?
				else {

					boundaryTest = true;
					if(j >= mGameV.getMapH() -1) boundaryRight = true;
					if(j <= 1) boundaryLeft = true;
				}
			} // i block
		} // j block



	}
	
	public void moveMonsters(Canvas canvas, Panel panel) {
		int i;
		int x,y,z;
		boolean markerTest = false;
		boolean hide = true;
		boolean show = false;
		boolean visibility = false;

		//for each monster...
		for (i =  mGameV.getMonsterOffset() ; i < mGameV.getMonsterOffset() + mGameV.getMonsterNum()  ; i++) {   
			markerTest = false; 
			SpriteInfo sprites = mGameV.getSprite(i);
			
			if (sprites.getActive() == true ) {
				x = sprites.getMapPosX() / 8;
				y = sprites.getMapPosY() / 8;
				// Must move and stop monsters when they hit bricks or
				// markers or the end of the screen/room/level.

				if(sprites.getFacingRight()) {
					//sprites[i].mapPosX += 1;
					sprites.incrementMapPosX(3);
					// marker test
					if(mGameV.getObjectsCellReversed(y, x+2) == mGameV.mBlock ) markerTest = true;
					if(mGameV.getObjectsCellReversed(y, x+2) == mGameV.mMarker ) markerTest = true;
					if(mGameV.getObjectsCellReversed(y+1, x+2) == 0) markerTest = true;
					// turn monster
					if (sprites.getMapPosX() > mGameV.getMapH() * 8  - 16 || markerTest) {
						//if (sprites[i].mapPosX > 32 * 8 * 2 - 16 || markerTest) {
						//sprites[i].facingRight = false;
						sprites.setFacingRight(false);
					}
				}
				else {
					//sprites[i].mapPosX -= 1;
					sprites.decrementMapPosX(3);
					// marker test
					if(mGameV.getObjectsCellReversed(y, x) == mGameV.mBlock) markerTest = true;
					if(mGameV.getObjectsCellReversed(y, x) == mGameV.mMarker) markerTest = true;
					if(mGameV.getObjectsCellReversed(y+1, x-1) == 0) markerTest = true;
					// turn monster
					if (sprites.getMapPosX() < 0 || markerTest) {
						//sprites[i].facingRight = true;
						sprites.setFacingRight(true);
					}
				}

				//Only show monsters that are on the screen properly


				//default is to show monster
				visibility = show;
				//hide monster
				if(sprites.getMapPosX() > mMovementV.getScrollX() + 32 * 8 + 16 ) {
					visibility = hide;
				}
				if (sprites.getMapPosX() < mMovementV.getScrollX() - 16) {
					visibility = hide;
				}
				if(sprites.getMapPosY() > mMovementV.getScrollY() + 24 * 8 + 16) {
					visibility = hide;
				}
				if ( sprites.getMapPosY() < mMovementV.getScrollY()  - 16) {
					visibility = hide;
				}
			}

			if(sprites.getActive() && visibility == show) {
			
				Bitmap spriteBitmap = BitmapFactory.decodeResource(panel.getResources(),
						sprites.getResourceId());

	    		canvas.drawBitmap(
	    				spriteBitmap, 
	    				sprites.getMapPosX(), 
	    				sprites.getMapPosY() , mP);
	    		
			}
			
			//swap monsters
			//sprites[i].animIndex = (sprites[i].animIndex + 1 ) ;
			sprites.incrementAnimIndex();
			if (sprites.getAnimIndex() > ANIM_SPEED * 4) sprites.setAnimIndex(0);
			if (sprites.getAnimIndex() > ANIM_SPEED * 2) z = 1;
			else z = 0;
			swapMonster( sprites , z);
		}
		//oamUpdate(&oamMain);

		return;
	}

	public void swapMonster(SpriteInfo sprites, int animationIndex) {

		boolean facingRight = sprites.getFacingRight();

		if(facingRight) {
			if(animationIndex == 0) {
				sprites.setResourceId(R.drawable.monster_r0);

			}
			else if (animationIndex == 1) {
				sprites.setResourceId(R.drawable.monster_r1);

			}
		}
		else if (!facingRight) {
			if(animationIndex == 0) {
				sprites.setResourceId(R.drawable.monster_l0);

			}
			else if (animationIndex == 1) {
				sprites.setResourceId(R.drawable.monster_l1);

			}
		}
		return;                
	}
	
	public void setKeyB(boolean b) {
		keyB = b;
	}
	
	
	
	/**  used to refresh reference to Guy Sprite before start of level. **/
	public void setGuySprite(SpriteInfo sprite) {
		mGuySprite = sprite;
	}
	
	
	
	
	
}
