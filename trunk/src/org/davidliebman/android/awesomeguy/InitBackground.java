package org.davidliebman.android.awesomeguy;

//import java.util.ArrayList;
import android.os.Environment;
import android.util.Log;
import android.util.Xml;
import android.util.AttributeSet;
import java.io.*;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;
import android.content.*;
import java.util.*;

public class InitBackground {
	private GameValues mGameV;
	private Context mContext;
	private ParseXML mParser;
	
	public InitBackground(GameValues gV, Context context) {
		mGameV = gV;
		mContext = context;
		mParser = new ParseXML(mContext, mGameV);
	}
	
	public void initLevel(MovementValues mMovementV) {
		int i,j;
		int num = 0;
		
		/*try {
			mParser.testParse(1);
		}
		catch (Exception e) {
			Log.e("INIT LEVEL",e.getMessage());
		}
		*/
		
		mGameV.clearSpriteList();
		mGameV.setSpriteStart();
		mGameV.setMonsterOffset(1);
		//find starting guy position
		for(i = 0; i< mGameV.getMapV(); i ++) { //y
			for (j = 0; j <  mGameV.getMapH(); j ++) { //x
				if( mGameV.getObjectsCell(j, i) == mGameV.mStart ) { //32,64

					mGameV.getSprite(0).setMapPosX(j*8);
					mGameV.getSprite(0).setMapPosY(i*8);

				}

				//add monster here
				if(mGameV.getObjectsCell(j, i) == mGameV.mMonster ) { //32,64
					if (GameValues.MONSTER_TOTAL >= num) {

						//put monster object in ArrayList here...
						SpriteInfo temp = new SpriteInfo(R.drawable.monster_l0, 3, 8, 0, 16);
						temp.setMapPosX(j * 8);
						temp.setMapPosY(i * 8);
						temp.setActive(true);
						temp.setVisible(true);
						temp.setFacingRight(true);
						//temp.setResourceId(R.drawable.monster_l0);
						mGameV.addSprite(temp);
						     
						num ++;

						mGameV.setMonsterNum(num);
					}
				}


			}
		}

		//set starting scroll position
		mMovementV.setScrollX(0);
		mMovementV.setScrollY(0);


		boolean flag = false;

		i = mGameV.getSprite(0).getMapPosX(); 
		j = mGameV.getSprite(0).getMapPosY();

		//scroll screen to starting location of guy...
		while(i >  (GameValues.SCREEN_TILES_H /2 )* 8 && flag == false) {

			if ( mMovementV.getScrollX() + ((GameValues.SCREEN_TILES_H  ) * 8) < mGameV.getMapH()  * 8) {
				mMovementV.incrementScrollX(8);
				i = i - 8; // X
			}
			else flag = true;

		}
		flag = false;
		while( j >  (GameValues.SCREEN_TILES_V /2) * 8 && flag == false) {


			if (mMovementV.getScrollY()  + ((GameValues.SCREEN_TILES_V  ) * 8) <  mGameV.getMapV()  * 8) {
				mMovementV.incrementScrollY(8);
				j = j - 8; // Y
			}
			else flag = true;
		}

	}

	/* set level map info */
	public void setLevel(int num) {

		try {
			mParser.testParse(num);
		}
		catch (Exception e) {
			Log.e("INIT LEVEL",e.getMessage());
		}
		

	}

	


			public static class ParseXML {
				private Context mContext;
				private GameValues mGameV;
				private boolean mStopParse;
				
				final String NUMBER = new String("number");
				final String VERTICAL = new String("vertical");
				final String HORIZONTAL = new String("horizontal");
				final String LEVEL = new String("level");
				final String TILES = new String("tiles_level");
				final String OBJECTS = new String("tiles_objects");
				final String LAST = new String("last_level");
				final String GAME = new String("game");
				
				public ParseXML(Context context, GameValues mGameV) {
					mContext = context;
					this.mGameV = mGameV;
				}
				
				public void testParse(int num) throws XmlPullParserException, IOException {
					mStopParse = false;
					boolean mReadNum = false;
					int mIndexNum = 0;
					boolean mHorizontal, mVertical, mTiles, mObjects, mLastLevel;
					
					String mOList = new String();
					String mTList = new String();
					
					mHorizontal = false;
					mVertical = false;
					mTiles = false;
					mObjects = false;
					mLastLevel = false;
					
					int mHorDimensions = 0;
					int mVerDimensions = 0;
					
					XmlPullParser xpp = mContext.getResources().getXml(R.xml.awesomeguy);//factory.newPullParser();
					
					int eventType = xpp.getEventType();
					while (eventType != XmlPullParser.END_DOCUMENT && !mStopParse) {
						
						System.out.println("name: " + xpp.getName());
						
						if(eventType == XmlPullParser.START_TAG && xpp.getName().equalsIgnoreCase(LEVEL) ) {
						
							/* get 'number' attribute from xml tag 'level' */
							if (xpp.getAttributeCount() == 1 && xpp.getAttributeName(0).contentEquals( NUMBER)) {
								
								mIndexNum = new Integer(xpp.getAttributeValue(0)).intValue();
								mReadNum = true;
								Log.e("XML", " attribute number " + mIndexNum);
							}
							else Log.e("XML", xpp.getAttributeName(0) + " " + xpp.getAttributeCount());
						
							
						}
						
						if(  mIndexNum == num) {
							/* found right level entry !!*/
							while (!(eventType == XmlPullParser.END_TAG && xpp.getName().contentEquals(LEVEL))) {
								//mHorizontal
								if(eventType == XmlPullParser.START_TAG && xpp.getName().contentEquals(HORIZONTAL)) {
									System.out.println("Start tag "+xpp.getName() + " number " + mIndexNum);
									mHorizontal = true;
								} else if(eventType == XmlPullParser.END_TAG && xpp.getName().contentEquals(HORIZONTAL)) {
									System.out.println("End tag "+xpp.getName());
									mHorizontal = false;
								} else if(eventType == XmlPullParser.TEXT && mHorizontal == true) {
									mHorDimensions = new Integer(xpp.getText()).intValue();
									//mGameV.setMapH(new Integer(xpp.getText()).intValue());
								}
								//mVertical
								if(eventType == XmlPullParser.START_TAG && xpp.getName().contentEquals(VERTICAL)) {
									System.out.println("Start tag "+xpp.getName());
									mVertical = true;
								} else if(eventType == XmlPullParser.END_TAG && xpp.getName().contentEquals(VERTICAL)) {
									System.out.println("End tag "+xpp.getName());
									mVertical = false;
								} else if(eventType == XmlPullParser.TEXT && mVertical == true) {
									mVerDimensions = new Integer(xpp.getText()).intValue();
									//mGameV.setMapV(new Integer(xpp.getText()).intValue());
								}
								//mObjects
								if(eventType == XmlPullParser.START_TAG && xpp.getName().contentEquals(OBJECTS)) {
									System.out.println("Start tag "+xpp.getName());
									mObjects = true;
								} else if(eventType == XmlPullParser.END_TAG && xpp.getName().contentEquals(OBJECTS)) {
									System.out.println("End tag "+xpp.getName());
									mObjects = false;
								} else if(eventType == XmlPullParser.TEXT && mObjects == true) {
									mOList = xpp.getText();
								}
								//mTiles
								if(eventType == XmlPullParser.START_TAG && xpp.getName().contentEquals(TILES)) {
									System.out.println("Start tag "+xpp.getName());
									mTiles = true;
								} else if(eventType == XmlPullParser.END_TAG && xpp.getName().contentEquals(TILES)) {
									System.out.println("End tag "+xpp.getName());
									mTiles = false;
								} else if(eventType == XmlPullParser.TEXT && mTiles == true) {
									mTList = xpp.getText();
								}
								
								eventType = xpp.next();

							}
						}
						else {
							//don't do this...
							//Log.e("XML", " no level number match");
							//return;
						}
						
						eventType = xpp.next();
					}
					//parse strings here...
					StringTokenizer mTileToken = new StringTokenizer(mTList,",");
					int mTotalTileTokens = mTileToken.countTokens();
					
					StringTokenizer mObjectToken = new StringTokenizer(mOList,",");
					int mTotalObjectTokens = mObjectToken.countTokens();
					
					mGameV.setMapH(mHorDimensions);
					mGameV.setMapV(mVerDimensions);

					
					if(mTotalTileTokens == mHorDimensions * mVerDimensions && 
							mTotalObjectTokens == mHorDimensions * mVerDimensions) {
						
						
						for(int i = 0; i < mGameV.getMapV(); i ++) { // 32 y
							for(int j =0; j < mGameV.getMapH(); j ++) { // 64 x

								mGameV.setLevelCell(j, i,  new Integer(mTileToken.nextToken().trim()).intValue());
								mGameV.setObjectsCell(j, i, new Integer(mObjectToken.nextToken().trim()).intValue());

							} //j block                        
						} // i block
						
						
					
					}
					else {
						/* throw hairy fit */
						Log.e("XML"," 'tokens' doesn't match 'dimensions'!!!");
						return;
					}
				}

			}
}
