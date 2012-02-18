package org.davidliebman.android.awesomeguy;

public class SpriteInfo {
	
	/* int used for resource ID, in the form of R.drawable.myresource
	 * can be changed with setters and getters.
	 */
	private int mResourceId;
	/* Used for storing the screen x and y of the sprite. 
	 * This is the x and y on the screen
     * if no scrolling were considered, 0 <= x <= 256, 0 <= y <= 192
     */
    
    private int mWidth;
    private int mHeight;
    /* the following are for keeping track of the guy sprite in the
     * context of the game's room/level size.
     */
    private int mapPosX;
    private int mapPosY;
    /* the following are for the sprite bounding box...
     * used for collision detection.
     */
    private int mTopBB;
    private int mBottomBB;
    private int mLeftBB;
    private int mRightBB;
    /* the following is mostly for the guy sprite and remembering
     * weather or not it is jumping. 'isJumping' can be ignored in other
     * contexts.
     */
    private boolean mIsJumping;
    /* This lets the program animate the sprite in question by
     * passing back and forth weather the sprite is currently
     * moving.
     */
    private boolean mAnimate;
    /* This is originally for monsters. It tells weather or not to put the 
     * monster on the screen.
     */
    private boolean mVisible;
     /* This is originally for monsters. It tells weather or not the 
      * sprite is facing right.
      */
    private boolean mFacingRight;
     /* This is supposed to be used to determine what sprite index to
      * show at a given time.
      */
    private int mAnimIndex;
     /* This is for monsters so that you can tell which ones have been
      * destroyed and then you can 'not' display them.
      */
    private boolean mActive;
    
    /* Constructors */
    public SpriteInfo(int resID, int top, int bot, int left, int right) {
    	clearInfo();
    	this.mResourceId = resID;
    	this.mTopBB = top;
    	this.mBottomBB = bot;
    	this.mLeftBB = left;
    	this.mRightBB = right;
    	
    	this.mVisible = true;
    	this.mActive = true;
    	//this.mAnimate = true;
    }
    
    public SpriteInfo(int resource) {
    	clearInfo();
    	if (resource == R.drawable.guy0) {
    		this.mResourceId = resource;
    		this.mTopBB = 2;
    		this.mBottomBB = 16;
    		this.mLeftBB = 4;
    		this.mRightBB = 10;
    		this.mVisible = true;
    		this.mActive = true;
    		this.mAnimate = true;
    	}
    	if (resource == R.drawable.monster_l0) {
    		this.mResourceId = resource;
    		this.mTopBB = 3;
    		this.mBottomBB = 8;
    		this.mLeftBB = 0;
    		this.mRightBB = 16;
    		this.mVisible = true;
    		this.mActive = true;
    		this.mFacingRight = true;
    	}
    	if (resource == R.drawable.concrete) {
    		this.mResourceId = resource;
    		this.mTopBB = 0;
    		this.mBottomBB = 8;
    		this.mLeftBB = 0;
    		this.mRightBB = 40;
    		this.mVisible = true;
    		this.mActive = true;
    		this.mFacingRight = true;
    	}
    }
    
    public SpriteInfo( int top, int bot, int left, int right) {
    	clearInfo();
    	this.mResourceId = 0;
    	this.mTopBB = top;
    	this.mBottomBB = bot;
    	this.mLeftBB = left;
    	this.mRightBB = right;
    	
    	this.mVisible = true;
    	this.mActive = true;
    	//this.mAnimate = true;
    }
    
    public SpriteInfo() {
    	clearInfo();
    }
    
    /* some utility functions */
    public void clearInfo() {
    	
    	this.mActive = false;
    	this.mAnimate = false;
    	this.mAnimIndex = 0;
    	this.mapPosX = 0;
    	this.mapPosY = 0;
    	this.mBottomBB = 0;
    	this.mTopBB = 0;
    	this.mLeftBB = 0;
    	this.mRightBB = 0;
    	this.mFacingRight = true;
    	this.mHeight = 0;
    	this.mWidth = 0;
    	this.mIsJumping = false;
    	this.mResourceId = 0;
    	this.mVisible = false;
    	
    }
    
    
    /* some setters and getters */
	public int getResourceId() {
		return mResourceId;
	}
	public void setResourceId(int mResourceId) {
		this.mResourceId = mResourceId;
	}
	
	public int getWidth() {
		return mWidth;
	}
	public void setWidth(int mWidth) {
		this.mWidth = mWidth;
	}
	public int getHeight() {
		return mHeight;
	}
	public void setHeight(int mHeight) {
		this.mHeight = mHeight;
	}
	public int getMapPosX() {
		return mapPosX;
	}
	public void setMapPosX(int mapPosX) {
		this.mapPosX = mapPosX;
	}
	public void incrementMapPosX() {
		this.mapPosX ++;
	}
	public void decrementMapPosX() {
		this.mapPosX --;
	}
	public void incrementMapPosX(int x) {
		this.mapPosX = this.mapPosX + x;
	}
	public void decrementMapPosX(int x) {
		this.mapPosX = this.mapPosX - x;
	}
	public int getMapPosY() {
		return mapPosY;
	}
	public void setMapPosY(int mapPosY) {
		this.mapPosY = mapPosY;
	}
	public int getTopBB() {
		return mTopBB;
	}
	public void setTopBB(int mTopBB) {
		this.mTopBB = mTopBB;
	}
	public int getBottomBB() {
		return mBottomBB;
	}
	public void setBottomBB(int mBottomBB) {
		this.mBottomBB = mBottomBB;
	}
	public int getLeftBB() {
		return mLeftBB;
	}
	public void setLeftBB(int mLeftBB) {
		this.mLeftBB = mLeftBB;
	}
	public int getRightBB() {
		return mRightBB;
	}
	public void setRightBB(int mRightBB) {
		this.mRightBB = mRightBB;
	}
	public boolean getIsJumping() {
		return mIsJumping;
	}
	public void setIsJumping(boolean mIsJumping) {
		this.mIsJumping = mIsJumping;
	}
	public boolean getAnimate() {
		return mAnimate;
	}
	public void setAnimate(boolean mAnimate) {
		this.mAnimate = mAnimate;
	}
	public boolean isVisible() {
		return mVisible;
	}
	public void setVisible(boolean mVisible) {
		this.mVisible = mVisible;
	}
	public boolean getFacingRight() {
		return mFacingRight;
	}
	public void setFacingRight(boolean mFacingRight) {
		this.mFacingRight = mFacingRight;
	}
	public int getAnimIndex() {
		return mAnimIndex;
	}
	public void incrementAnimIndex() {
		mAnimIndex ++;
	}
	public void setAnimIndex(int mAnimIndex) {
		this.mAnimIndex = mAnimIndex;
	}
	public boolean getActive() {
		return mActive;
	}
	public void setActive(boolean mActive) {
		this.mActive = mActive;
	}
	
	
	
}
