package org.davidliebman.android.awesomeguy;

//import java.util.ArrayList;
import android.os.Environment;
import android.util.Log;
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
		mParser = new ParseXML(mContext);
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
		mGameV.setMonsterNum(0);
		mGameV.setPlatformNum(-1);
		mGameV.setPlatformOffset(0);
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
		
		mGameV.setPlatformOffset(num );
		
		for(i = 0; i< mGameV.getMapV(); i ++) { //y
			for (j = 0; j <  mGameV.getMapH(); j ++) { //x
				if( mGameV.getObjectsCell(j, i) == mGameV.mPlatform ) { //32,64
					if(GameValues.PLATFORM_TOTAL > num - mGameV.getPlatformOffset()) {
						//put platform object in ArrayList here...
						SpriteInfo temp = new SpriteInfo(R.drawable.concrete, 0, 8, 0, 40);
						temp.setMapPosX(j * 8);
						temp.setMapPosY(i * 8);
						temp.setActive(true);
						temp.setVisible(true);
						temp.setFacingRight(true);
	
						mGameV.addSprite(temp);
						     
						num ++;
	
						mGameV.setPlatformNum(num);
					}
				}
				
			}
		}
		
		this.setStartingScrollPosition(mMovementV);
		
		

	}

	public void setStartingScrollPosition(MovementValues mMovementV) {
		//set starting scroll position
		
		int i,j;
		
		mMovementV.setScrollX(0);
		mMovementV.setScrollY(0);


		boolean flag = false;

		i = mGameV.getSprite(0).getMapPosX(); 
		j = mGameV.getSprite(0).getMapPosY();

		//scroll screen to starting location of guy...
		while(i >  (mGameV.getScreenTilesHMod()  /2 )* 8 && flag == false) {

			if ( mMovementV.getScrollX() + ((mGameV.getScreenTilesHMod()  ) * 8) < mGameV.getMapH()  * 8) {
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
		boolean test = false;
		try {
			test = mParser.setXmlPullParser(mGameV.isLookForXml());
			if (test ) test = mParser.parseLevelXml(num, mGameV);
		}
		catch (Exception e) {
			Log.e("INIT LEVEL",e.getMessage());
			
		}
		//try again without sdcard.
		if (test == false ) {
			try {
				mParser.setXmlPullParser(false);
				mParser.parseLevelXml(num, mGameV);
			}
			catch (Exception e) {
				Log.e("INIT LEVEL",e.getMessage());
				
			}
			
		}

	}

	


	public static class ParseXML {
		private Context mContext;
		private GameValues mGameV;
		private XmlPullParser mXpp;
		
		public static final String SDCARD_FILE = new String ("awesomeguy.xml");

		
		final String NUMBER = new String("number");
		final String VERTICAL = new String("vertical");
		final String HORIZONTAL = new String("horizontal");
		final String LEVEL = new String("level");
		final String TILES = new String("tiles_level");
		final String OBJECTS = new String("tiles_objects");
		final String LAST = new String("last_level");
		final String GAME = new String("game");
		
		public ParseXML(Context context) {
			mContext = context;
			this.mGameV = new GameValues();
		}
		
		public boolean setXmlPullParser(boolean mLookForXml) throws XmlPullParserException, IOException{
			if (!mLookForXml) {
				mXpp = mContext.getResources().getXml(R.xml.awesomeguy);
			}
			else {
				
			   XmlPullParserFactory factory = XmlPullParserFactory.newInstance();
			   factory.setNamespaceAware(true);
			   mXpp = factory.newPullParser(); 	
			   File sdcard = Environment.getExternalStorageDirectory();
			   Log.e("XML", sdcard.getAbsolutePath());
			   int BUFFER_SIZE = 8192;

			   if(sdcard.canRead()) {
				   Log.e("XML", "sdcard.canRead()");
				   File mFileInput = new File(sdcard, SDCARD_FILE);
				   
				   FileReader mReader = new FileReader(mFileInput);
				   
				   BufferedReader in = new BufferedReader(mReader,BUFFER_SIZE);

				   mXpp.setInput(in);
				   
			   }
			}
			return true;
		}
		
		public LevelList getXmlList(GameValues mGameV) throws XmlPullParserException, IOException{

			LevelList mList = new LevelList();

			int mIndexNum = 0;

			
			int eventType = mXpp.getEventType();
			while (eventType != XmlPullParser.END_DOCUMENT ) {
				
				System.out.println("name: " + mXpp.getName());
				
				if(eventType == XmlPullParser.START_TAG && mXpp.getName().equalsIgnoreCase(LEVEL) ) {
				
					/* get 'number' attribute from xml tag 'level' */
					if (mXpp.getAttributeCount() == 1 && mXpp.getAttributeName(0).contentEquals( NUMBER)) {
						
						mIndexNum = new Integer(mXpp.getAttributeValue(0).toString().trim()).intValue();

						Log.e("XML", " attribute number " + mIndexNum);
						if(mIndexNum - 1 == mList.size()) {
							mList.add(new String("Room Num "+mIndexNum),mIndexNum);
						}
						else {
							mList.add(new String("Room Num "+ ( mList.size() + 1 )+" ID:"+mIndexNum),mIndexNum);
						}
						//mList.add(mIndexNum);
					}
					else Log.e("XML", mXpp.getAttributeName(0) + " " + mXpp.getAttributeCount());
				
					
				}
				eventType = mXpp.next();
			}
			if (mGameV != null) {
				mGameV.setTotNumRooms(mList.size());
			}
			return mList;
		}
		
		public boolean parseLevelXml(int num, GameValues mGameV) throws XmlPullParserException, IOException {
			boolean mStopParse = false;
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
			
			//XmlPullParser xpp = mContext.getResources().getXml(R.xml.awesomeguy);
			
			int eventType = mXpp.getEventType();
			while (eventType != XmlPullParser.END_DOCUMENT && !mStopParse) {
				
				System.out.println("name: " + mXpp.getName());
				
				if(eventType == XmlPullParser.START_TAG && mXpp.getName().equalsIgnoreCase(LEVEL) ) {
				
					/* get 'number' attribute from xml tag 'level' */
					if (mXpp.getAttributeCount() == 1 && mXpp.getAttributeName(0).contentEquals( NUMBER)) {
						
						mIndexNum = new Integer(mXpp.getAttributeValue(0).toString().trim()).intValue();
						//mReadNum = true;
						if (mIndexNum == num) mStopParse = true;
						Log.e("XML", " attribute number " + mIndexNum);
					}
					else Log.e("XML", mXpp.getAttributeName(0) + " " + mXpp.getAttributeCount());
				
					
				}
				eventType = mXpp.next();
			}
				
			if(  mIndexNum == num) {
				/* found right level entry !!*/
				while (!(eventType == XmlPullParser.END_TAG && mXpp.getName().contentEquals(LEVEL))) {
					//mHorizontal
					if(eventType == XmlPullParser.START_TAG && mXpp.getName().contentEquals(HORIZONTAL)) {
						System.out.println("Start tag "+mXpp.getName() + " number " + mIndexNum);
						mHorizontal = true;
					} else if(eventType == XmlPullParser.END_TAG && mXpp.getName().contentEquals(HORIZONTAL)) {
						System.out.println("End tag "+mXpp.getName());
						mHorizontal = false;
					} else if(eventType == XmlPullParser.TEXT && mHorizontal == true) {
						mHorDimensions = new Integer(mXpp.getText()).intValue();
						//mGameV.setMapH(new Integer(xpp.getText()).intValue());
					}
					//mVertical
					if(eventType == XmlPullParser.START_TAG && mXpp.getName().contentEquals(VERTICAL)) {
						System.out.println("Start tag "+mXpp.getName());
						mVertical = true;
					} else if(eventType == XmlPullParser.END_TAG && mXpp.getName().contentEquals(VERTICAL)) {
						System.out.println("End tag "+mXpp.getName());
						mVertical = false;
					} else if(eventType == XmlPullParser.TEXT && mVertical == true) {
						mVerDimensions = new Integer(mXpp.getText()).intValue();
						//mGameV.setMapV(new Integer(xpp.getText()).intValue());
					}
					//mObjects
					if(eventType == XmlPullParser.START_TAG && mXpp.getName().contentEquals(OBJECTS)) {
						System.out.println("Start tag "+mXpp.getName());
						mObjects = true;
					} else if(eventType == XmlPullParser.END_TAG && mXpp.getName().contentEquals(OBJECTS)) {
						System.out.println("End tag "+mXpp.getName());
						mObjects = false;
					} else if(eventType == XmlPullParser.TEXT && mObjects == true) {
						mOList = mXpp.getText();
					}
					//mTiles
					if(eventType == XmlPullParser.START_TAG && mXpp.getName().contentEquals(TILES)) {
						System.out.println("Start tag "+mXpp.getName());
						mTiles = true;
					} else if(eventType == XmlPullParser.END_TAG && mXpp.getName().contentEquals(TILES)) {
						System.out.println("End tag "+mXpp.getName());
						mTiles = false;
					} else if(eventType == XmlPullParser.TEXT && mTiles == true) {
						mTList = mXpp.getText();
					}
					
					eventType = mXpp.next();

				}
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
				return false;
			}
			return true;
		}

	}
	
	public static class LevelList  {
		private ArrayList<LevelData> mList = new ArrayList<LevelData>();
		
		public void add(String text, Integer i) {
			LevelData temp = new LevelData();
			temp.mNum = i;
			temp.mText = text;
			mList.add(temp);
		}
		public int size() {
			return mList.size();
		}
		
		public ArrayList<String> getStrings() {
			ArrayList<String> temp = new ArrayList<String>();
			for(int i = 0; i < mList.size(); i ++) {
				temp.add(mList.get(i).mText);
			}
			return temp;
		}
	}
	
	public static class LevelData {
		public String mText = new String("blank");
		public Integer mNum = 1;
	}
}
