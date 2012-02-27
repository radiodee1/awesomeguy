package org.davidliebman.android.awesomeguy;

import java.util.ArrayList;


import android.content.Context;
import android.graphics.Color;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.TableLayout;
import android.widget.TableRow;

public class ButtonManager extends TableLayout {

	public static final int MODE_PORTRAIT = 0;
	public static final int MODE_STRIP = 1;
	public static final int MODE_TRANSPARENT = 2;
	
    private ArrayList<TouchButton> mButtonList = new ArrayList<TouchButton>();
    private Context mContext;
	private MovementValues mMovementV;
    private GameValues mGameV;
    private Handler mHandler;
	
    private RelativeLayout mRLayout ;
    private TableLayout mTLayoutOuter ;
    private TableLayout mTLayout ;
    private FrameLayout mFLayoutBot ;
    //private Panel mPanelBot ;
	private GameKeys mKeysView;
    
	//private RelativeLayout mParent;
	
	private int mDimensionWidth;
	private int mButtonHeight;
	private int mButtonWidth;
	private int mMode;
	
    private double mTrackballDist = 1.0;
    private int mScrollConst = 200;
    private boolean mTestLandscapeButtons = true;

    
	
	public ButtonManager(Context c, MovementValues m, GameValues v, Handler h, int mode ) {
		super(c);
		mContext = c;
		mMovementV = m;
		mGameV = v;
		mHandler = h;
		mMode = mode;
		mDimensionWidth = mGameV.getDisplayWidth();
		
		switch (mMode) {
		case ButtonManager.MODE_PORTRAIT:
			this.addView((View)new GamePad(mContext, true, mDimensionWidth) );
			break;
		case ButtonManager.MODE_STRIP:
			this.addView((View)new GameKeys(mContext, mGameV.getLandscapeButtonPixel(), true));
			break;
		case ButtonManager.MODE_TRANSPARENT:
			break;
		}
		
		
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
    	
    	
    	
    	
    };// end of inner class
    
    class GameKeys extends TableLayout{
    	public GameKeys(Context c, int widthDimension, boolean mMultiTouch) {
    		super (c);
    		
    		int mButtonHeight = widthDimension;
    		int mButtonWidth = widthDimension;
    		
    		mButtonWidth = mGameV.getLandscapeButtonPixel();
    		mButtonHeight = mGameV.getLandscapeButtonPixel();
    		
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
    		
    		/* set button x and button y */
    		mButton1.setButtonXY(0, 0);
    		mButton2.setButtonXY(1, 0);
    		mButton3.setButtonXY(2, 0);
    		mButton4.setButtonXY(3, 0);
    		mButton5.setButtonXY(4, 0);
    		
    		/* populate button list */
    		clearButtonList();
    		addButton(mButton1);
    		addButton(mButton2);
    		addButton(mButton3);
    		addButton(mButton4);
    		addButton(mButton5);
    	}
    };
    
    /* button listeners */
    class TouchButton extends Button implements View.OnTouchListener {
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
//    			this.setOnKeyListener(new View.OnKeyListener() {
//    		
//				
//    				@Override
//    				public boolean onKey(View v, int keyCode, KeyEvent event) {
//    					
//    					//closeSoftKeyboard(v);
//    					
//    					if (keyCode == KeyEvent.KEYCODE_DPAD_CENTER || keyCode == KeyEvent.KEYCODE_SPACE) {
//    		    			mPanelBot.setKeyB(true);
//
//    					}
//    					
//    					if (keyCode == KeyEvent.KEYCODE_DPAD_LEFT || keyCode == KeyEvent.KEYCODE_A)
//                        {
//    						
//    						mMovementV.setKeyInput(MovementValues.KEY_LEFT);
//    				    	mPanelBot.readKeys(mTrackballDist);
//    				    	
//    				    	Message mEnd = new Message();
//    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
//    				    	mHandler.sendMessageDelayed(mEnd, mScrollConst);
//    				    	
//    						
//    						//Log.v("button factory", "trackball??? left");
//                        }
//                        else if (keyCode == KeyEvent.KEYCODE_DPAD_RIGHT || keyCode == KeyEvent.KEYCODE_S)
//                        {	
//                        	
//            		    	mMovementV.setKeyInput(MovementValues.KEY_RIGHT);
//    				    	mPanelBot.readKeys(mTrackballDist);
//            		    	
//            		    	Message mEnd = new Message();
//    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
//    				    	mHandler.sendMessageDelayed(mEnd, mScrollConst);
//    				    	
//    				    	
//    						//Log.v("button factory", "trackball??? right");
//                        }
//    					if (keyCode == KeyEvent.KEYCODE_DPAD_UP || keyCode == KeyEvent.KEYCODE_D)
//                        {
//    						
//    				    	mMovementV.setKeyInput(MovementValues.KEY_UP);
//    				    	mPanelBot.readKeys(mTrackballDist);
//    				    	
//    				    	Message mEnd = new Message();
//    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
//    				    	mHandler.sendMessageDelayed(mEnd, mScrollConst);
//    				    	
//    						
//    						//Log.v("button factory", "trackball??? up");
//                        }
//                        else if (keyCode == KeyEvent.KEYCODE_DPAD_DOWN || keyCode == KeyEvent.KEYCODE_F)
//                        {
//                        	
//                        	
//            		    	mMovementV.setKeyInput(MovementValues.KEY_DOWN);
//    				    	mPanelBot.readKeys(mTrackballDist);
//            		    	
//            		    	Message mEnd = new Message();
//    				    	mEnd.what = GameStart.INPUTVALUES_TRACKUP;
//    				    	mHandler.sendMessageDelayed(mEnd, mScrollConst);
//    				    	
//                        	
//    						//Log.v("button factory", "trackball??? down");
//                        }
//    					
//    					return true;
//    				}
//    			});
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
    			//mPanelBot.setKeyB(true);
    			mMovementV.setKeyInput(MovementValues.KEY_B);
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
    			
    			
    	
    			
    			int mNewButtonWidth = getButton(i).getWidth();
    			int mNewButtonHeight = getButton(i).getHeight();
    				     			
    			//landscape - buttons are a different size
    			if (//(mGameV.getScreenOrientation() == GameValues.ORIENTATION_LANDSCAPE && mTestLandscapeButtons) &&
    					mSecondX + mFirstOffsetX * mNewButtonWidth >  mSecondOffsetX * mNewButtonWidth &&
    					mSecondX + mFirstOffsetX * mNewButtonWidth <  (mSecondOffsetX + 1) * mNewButtonWidth &&
    					mSecondY + mFirstOffsetY * mNewButtonHeight > mSecondOffsetY * mNewButtonHeight &&
    					mSecondY + mFirstOffsetY * mNewButtonHeight < (mSecondOffsetY + 1) * mNewButtonHeight) {
    				//handle second click here !!
    				
    				if (getButton(i).getKeyValue() == MovementValues.KEY_B) {
    		    		//mPanelBot.setKeyB(true);
    		    		mMovementV.setKeyInput(MovementValues.KEY_B);
    		    	}
    		    	else{
    		    		mMovementV.setKeyInput(getButton(i).getKeyValue());
    		    	}
    		    	
    			}
    		}
    		
    	}
    	
    };
    
    class BlankButton extends Button {
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
}
