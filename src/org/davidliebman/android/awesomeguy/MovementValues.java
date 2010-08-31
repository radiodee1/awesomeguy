package org.davidliebman.android.awesomeguy;

//import android.util.Log;


public class MovementValues {
	
	private boolean mTrackballInput;
	
	private int scrollX;
	private int scrollY;
	private int characterX;
	private int characterY;
	
	private int directionKeyUp;
	private int directionKeyDown;
	private int directionKeyLeft;
	private int directionKeyRight;
	private int letterKeyA;
	private int letterKeyB;
	
	public static final int KEY_UP = 1;
	public static final int KEY_DOWN = 2;
	public static final int KEY_LEFT = 3;
	public static final int KEY_RIGHT = 4;
	public static final int KEY_A = 5;
	public static final int KEY_B = 6;
	
	private int mHMove = 3;//1;
	private int mVMove = 3;//1;
	
	public MovementValues() {
		scrollX = 0;
		scrollY = 0;
		characterX = 0;
		characterY = 0;
		clearKeys();
	}
	
	public MovementValues(MovementValues mOrig) {
		this.scrollX = mOrig.scrollX;
		this.scrollY = mOrig.scrollY;
		clearKeys();
	}
	
	/* screen position (scrolling) */
	public  int getScrollX() {
		return scrollX;
	}
	public   void setScrollX(int scrollX) {
		this.scrollX = scrollX;
	}
	public void incrementScrollX(int num) {
		this.scrollX = this.scrollX + num;
	}
	
	public   int getScrollY() {
		return scrollY;
	}
	public   void setScrollY(int scrollY) {
		this.scrollY = scrollY;
	}
	public void incrementScrollY(int num) {
		this.scrollY = this.scrollY + num;
	}
	
	/* unused ? */
	public int getCharacterX() {
		return characterX;
	}
	public void setCharacterX(int characterX) {
		this.characterX = characterX;
	}
	public int getCharacterY() {
		return characterY;
	}
	public void setCharacterY(int characterY) {
		this.characterY = characterY;
	}
	
	/* key presses and navigation */
	public   int getDirectionLR() {
		int temp = 0;
		if(this.directionKeyLeft == 1 && this.directionKeyRight == 1) {
			this.directionKeyLeft = 0;
			this.directionKeyRight = 0;
		}
		if(this.directionKeyLeft == 1) {
			temp = MovementValues.KEY_LEFT;
			//Log.v("MovementValues", "Left");
		}
		else if(this.directionKeyRight == 1) {
			temp = MovementValues.KEY_RIGHT;
			//Log.v("MovementValues", "Right"	);
		}
		return temp;
	}
	public   int getDirectionUD() {
		int temp = 0;
		if(this.directionKeyDown == 1 && this.directionKeyUp == 1) {
			this.directionKeyDown = 0;
			this.directionKeyUp = 0;
		}
		if(this.directionKeyDown == 1) {
			temp = MovementValues.KEY_DOWN;
			//Log.v("MovementValues", "Down");
		}
		else if(this.directionKeyUp == 1) {
			temp = MovementValues.KEY_UP;
			//Log.v("MovementValues", "Up");
		}
		return temp;
	}
	public   int getLetterKeyA() {
		return letterKeyA;
	}
	public   int getLetterKeyB() {
		return letterKeyB;
	}
	
	public   void setKeyInput(int num) {
		if(num == KEY_UP) {
			this.directionKeyUp = 1;
		}
		if(num == KEY_DOWN) {
			this.directionKeyDown = 1;
		}
		if(num == KEY_LEFT) {
			this.directionKeyLeft = 1;
		}
		if(num == KEY_RIGHT) {
			this.directionKeyRight = 1;
		}
		if(num == KEY_A) {
			this.letterKeyA = 1;
		}
		if(num == KEY_B) {
			this.letterKeyB = 1;
		}

	}
	public   void clearKeys() {
		this.directionKeyUp = 0;
		this.directionKeyDown = 0;
		this.directionKeyLeft = 0;
		this.directionKeyRight = 0;
		this.letterKeyA = 0;
		//this.letterKeyB = 0;
		this.mTrackballInput = false;
	}
	
	/** determine if trackball input was used **/
	public   boolean isTrackballInput() {
		return mTrackballInput;
	}

	public   void setTrackballInput(boolean mTrackballInput) {
		this.mTrackballInput = mTrackballInput;
	}

	/** get-ers and set-ers for M&H move **/
	public int getHMove() {
		return mHMove;
	}

	public void setHMove(int mHMove) {
		this.mHMove = mHMove;
	}

	public int getVMove() {
		return mVMove;
	}

	public void setVMove(int mVMove) {
		this.mVMove = mVMove;
	}
	
}
