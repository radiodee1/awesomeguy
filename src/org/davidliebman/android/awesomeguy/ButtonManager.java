package org.davidliebman.android.awesomeguy;

import java.util.ArrayList;


import android.content.Context;
import android.graphics.Color;
import android.graphics.Rect;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.Toast;

public class ButtonManager extends FrameLayout {

	public static final int MODE_PORTRAIT = 0;
	public static final int MODE_STRIP = 1;
	public static final int MODE_TRANSPARENT = 2;
	
    private ArrayList<TouchButton> mButtonList = new ArrayList<TouchButton>();
    private Context mContext;
	private MovementValues mMovementV;
    private GameValues mGameV;
	
    public BoundingBox mLargeBox;
    
 
	private RelativeLayout mParent;
	private Button mBackground;
	
	private int mDimensionHeight;
	private int mDimensionWidth;
	private int mButtonHeight;
	private int mButtonWidth;
	private int mMode;
    
	
	public ButtonManager(Context c, MovementValues m, GameValues v,  int mode ) {
		super(c);
		mContext = c;
		mMovementV = m;
		mGameV = v;
		mMode = mode;
		mDimensionHeight = mGameV.getDisplayHeight() - mGameV.getViewH();
		mDimensionWidth = mGameV.getDisplayWidth();
		mParent = new RelativeLayout(mContext);
		
		
		switch (mMode) {
		case ButtonManager.MODE_PORTRAIT:
			mParent.addView((View)new GamePad(mContext, true) );
			break;
		case ButtonManager.MODE_STRIP:
			mParent.addView((View)new GameKeys(mContext,  true));
			break;
		case ButtonManager.MODE_TRANSPARENT:
			break;
		}
		
		ViewGroup.LayoutParams mRLayoutParams = new 
    		ViewGroup.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.FILL_PARENT);
		this.setLayoutParams(mRLayoutParams);
		
		ViewGroup.LayoutParams mRLayoutParamsParent = new 
		ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);

		
		mParent.setLayoutParams(mRLayoutParams);
		
		initBackgroundButton();

		this.addView(mParent);

		this.addView(mBackground);

	}

	public void initBackgroundButton() {
		ViewGroup.LayoutParams mRLayoutParams = new 
    		ViewGroup.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.FILL_PARENT);
		
		mBackground = new Button(mContext);
		mBackground.setLayoutParams(mRLayoutParams);
		
		mBackground.setBackgroundColor(Color.TRANSPARENT);
		mBackground.setVisibility(View.VISIBLE);
		mBackground.setEnabled(true);
		
		mBackground.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				if(event.getAction() == MotionEvent.ACTION_DOWN) {
					boolean mTest = false;
					// go through pointers
					for (int i = 0; i < event.getPointerCount(); i ++) {
						//go through buttons and check if one has input
						for (int j = 0; j < mButtonList.size(); j ++ ) {
							if (checkOneButton( j, mMovementV , (int)event.getX(i), (int)event.getY(i))) {
								mTest = true;
							}
						}
					}
					
					return mTest;
				}
				else if (event.getAction() == MotionEvent.ACTION_UP) {
					mMovementV.clearKeys();
					return true;
				}
				
				return false;
			}
		});
	}
	
	public boolean checkOneButton(int mButtonIndex, MovementValues mV, int mX, int mY) {
		mY = mY + this.mLargeBox.getTop();
		TouchButton mTemp = mButtonList.get(mButtonIndex);
		
		if (mX >= mTemp.mBox.getLeft() && mX <= mTemp.mBox.getRight() &&
				mY >= mTemp.mBox.getTop() && mY <= mTemp.mBox.getBottom()) {
			mMovementV.setKeyInput(mTemp.getKeyValue());
			return true;
		}
		return false;
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
    public BoundingBox getButtonBoundingBox(int i) {
    	return this.mButtonList.get(i).mBox;
    }
    
    public void setButtonBoundingBoxAll() {
    	this.requestLayout();
    	    	
    	mBackground.requestLayout();
    	int location[] = new int[2];
    	mBackground.getLocationOnScreen(location);
    	
    	mLargeBox = new BoundingBox(location[0], location[0] + mBackground.getWidth(), 
    			location[1], location[1] + mBackground.getHeight());
    
    	
    	for (int i = 0; i < this.mButtonList.size(); i ++ ) {
    		
    		TouchButton temp = this.mButtonList.get(i);
    		temp.getLocationOnScreen(location);
    		
    		temp.mBox = new BoundingBox(location[0], location[0] + temp.getWidth(), 
        			location[1], location[1] + temp.getHeight());
    		

    	}
    }
    
	/** Game Pad Here **/
    public class GamePad extends  TableLayout {
    	
    	public GamePad(Context c, boolean mMultiTouch) {
    		super(c);
    		mContext = c;
    		float mRatioAvailable = (float)mDimensionHeight/(float)mDimensionWidth;
    		int mLeftSpace = 0;
    		int mTopSpace = 0;
    		
    		
    		if ( mRatioAvailable >= (float) 3/5 ) {
    			//height is greater
    			mButtonHeight = mDimensionWidth/5;//95
        		mButtonWidth = mDimensionWidth/5;//95
        		
    		}
    		else {
    			//width is greater
    			mButtonHeight = mDimensionHeight/3;
        		mButtonWidth = mDimensionHeight/3;
        		mLeftSpace = (mDimensionWidth - (mButtonWidth * 5)) /2;
    		}
    		
    		/* left space */
    		BlankButton mButtonTop1 = new BlankButton(mContext, mLeftSpace, mButtonHeight);
    		BlankButton mButtonMid1 = new BlankButton(mContext, mLeftSpace, mButtonHeight);
    		BlankButton mButtonBot1 = new BlankButton(mContext, mLeftSpace, mButtonHeight);

    		
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
    		//mButtonMid6.setBackgroundResource(R.drawable.button_center);
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
    		mTRowTop.addView((View)mButtonTop1);// blank
    		mTRowTop.addView((View)mButtonTop3);
    		mTRowTop.addView((View)mButtonTop4);
    		mTRowTop.addView((View)mButtonTop5);
    		mTRowTop.addView((View)mButtonTop6);
    		mTRowTop.addView((View)mButtonTop7);

    		TableRow mTRowMid = new TableRow(mContext);
    		mTRowMid.addView((View)mButtonMid1);// blank
    		mTRowMid.addView((View)mButtonMid3);
    		mTRowMid.addView((View)mButtonMid4);
    		mTRowMid.addView((View)mButtonMid5);
    		mTRowMid.addView((View)mButtonMid6);
    		mTRowMid.addView((View)mButtonMid7);

    		TableRow mTRowBot = new TableRow(mContext);
    		mTRowBot.addView((View)mButtonBot1);// blank
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
    	public GameKeys(Context c,  boolean mMultiTouch) {
    		super (c);
    		
    		int mButtonHeight = mGameV.getLandscapeButtonPixel();//widthDimension;
    		int mButtonWidth = mGameV.getLandscapeButtonPixel();
    		
    		/* percent of free space used for 4 spacers */
    		float mSpacerPercent = (float) 0.20; 
    		
    		float mSpacerWidth = ((float)(mDimensionWidth - (mButtonWidth * 5 ))) * mSpacerPercent;
    		
    		int mIndentWidth = (mDimensionWidth - ((mButtonWidth * 5) + ((int )mSpacerWidth * 4)))/2;
    		
    		
    		
    		TableRow mTRow = new TableRow(c);
    		TouchButton mButton1 = new TouchButton(c, mMultiTouch ,R.drawable.button_left, mButtonWidth, mButtonHeight, 0, "button_left", MovementValues.KEY_LEFT);
    		TouchButton mButton2 = new TouchButton(c, mMultiTouch ,R.drawable.button_right, mButtonWidth, mButtonHeight, 0, "button_right", MovementValues.KEY_RIGHT);
    		TouchButton mButton3 = new TouchButton(c, mMultiTouch ,R.drawable.button_up, mButtonWidth, mButtonHeight, 0, "button_up", MovementValues.KEY_UP);
    		TouchButton mButton4 = new TouchButton(c,mMultiTouch , R.drawable.button_down, mButtonWidth, mButtonHeight, 0, "button_down", MovementValues.KEY_DOWN);

    		TouchButton mButton5 = new TouchButton(c, mMultiTouch ,R.drawable.button_b, mButtonWidth, mButtonHeight, 0, "button_b", MovementValues.KEY_B);

    		
    		BlankButton mDeviderView1 = new BlankButton(c, (int) mSpacerWidth, mButtonHeight);
    		BlankButton mDeviderView2 = new BlankButton(c, (int) mSpacerWidth, mButtonHeight);
    		BlankButton mDeviderView3 = new BlankButton(c, (int) mSpacerWidth, mButtonHeight);
    		BlankButton mDeviderView4 = new BlankButton(c, (int) mSpacerWidth, mButtonHeight);
    		
    		BlankButton mIndentView = new BlankButton(c, mIndentWidth, mButtonHeight);
    		
    		mTRow.addView((View)mIndentView);
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
    class TouchButton extends Button { //Button implements View.OnTouchListener {
    	int mKeyValue = 0;
    	int mButtonX, mButtonY;
    	boolean mMultiTouch;
    	String mDescription;
    	public BoundingBox mBox;
    	
        public TouchButton (Context c, boolean mMultiTouch, int background, int width, int height, int id, String idString, int directionKey) {
        	super(c);
        	this.mMultiTouch = mMultiTouch;
        	this.setBackgroundColor(Color.BLACK);
        	if (background != 0 ) {
        		this.setBackgroundResource(background);
        		//this.setOnTouchListener(this);

        	}
        	this.setWidth(width);
        	this.setHeight(height);
        	this.setText("");
        	this.setId(id);
        	this.setTag(idString);
        	this.mDescription = idString;
        	mKeyValue = directionKey;
        	
        	// left, right, top, bottom...
        	mBox = new BoundingBox( 0, 0, 0, 0);
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
