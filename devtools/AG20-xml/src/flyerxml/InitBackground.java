package flyerxml;

//import android.os.Environment;
//import android.util.Log;
//import android.util.Log;
import java.io.*;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;
//import android.content.*;
import java.util.*;

public class InitBackground {
	//private GameValues mGameV;
	//private Context mContext;
	private ParseXML mParser;
	//private InitFlyerChallenges mFChallenges;
	//private ParseChallengeXML mCParser;
	private LevelList mLevelList;
	private static boolean mLookForXml;
        private static String mXMLFilename = "awesome-flyer.xml";
	
	public InitBackground( boolean mLookForXml, String mFileName) {
		//mGameV = gV;
		//mContext = context;
		mParser = new ParseXML();
		//mCParser = new ParseChallengeXML(mContext);
		this.mLookForXml = mLookForXml;
                if (!mFileName.trim().contentEquals("")) {
                    mXMLFilename = mFileName;
                }
		
		//mFChallenges = new InitFlyerChallenges(mGameV, mContext, this.mLookForXml);
		
		//this.populateLevelList();

	}
	
//	public void initLevel(MovementValues mMovementV) {
//		int i,j;
//		int num = 0;
//
//		
//		mGameV.clearSpriteList();
//		mGameV.setSpriteStart();
//		
//		mGameV.setMonsterOffset(1);
//		mGameV.setMonsterNum(0);
//		mGameV.setPlatformNum(-1);
//		mGameV.setPlatformOffset(0);
//		//find starting guy position
//		for(i = 0; i< mGameV.getMapV(); i ++) { //y
//			for (j = 0; j <  mGameV.getMapH(); j ++) { //x
//				if( mGameV.getObjectsCell(j, i) == mGameV.mStart ) { //32,64
//
//					mGameV.getSprite(0).setMapPosX(j*8);
//					mGameV.getSprite(0).setMapPosY(i*8);
//
//				}
//				//add monster here
//				if(mGameV.getObjectsCell(j, i) == mGameV.mMonster ) { //32,64
//					if (GameValues.MONSTER_TOTAL >= num) {
//
//						//put monster object in ArrayList here...
//						SpriteInfo temp = new SpriteInfo(R.drawable.monster_l0, 3, 8, 0, 16);
//						temp.setMapPosX(j * 8);
//						temp.setMapPosY(i * 8);
//						temp.setActive(true);
//						temp.setVisible(true);
//						temp.setFacingRight(true);
//						//temp.setResourceId(R.drawable.monster_l0);
//						mGameV.addSprite(temp);
//						     
//						num ++;
//
//						mGameV.setMonsterNum(num);
//					}
//				}
//
//
//			}
//		}
//		
//		mGameV.setPlatformOffset(num );
//		
//		for(i = 0; i< mGameV.getMapV(); i ++) { //y
//			for (j = 0; j <  mGameV.getMapH(); j ++) { //x
//				if( mGameV.getObjectsCell(j, i) == mGameV.mPlatform ) { //32,64
//					if(GameValues.PLATFORM_TOTAL > num - mGameV.getPlatformOffset()) {
//						//put platform object in ArrayList here...
//						SpriteInfo temp = new SpriteInfo(R.drawable.concrete, 0, 8, 0, 40);
//						temp.setMapPosX(j * 8);
//						temp.setMapPosY(i * 8);
//						temp.setActive(true);
//						temp.setVisible(true);
//						temp.setFacingRight(true);
//	
//						mGameV.addSprite(temp);
//						     
//						num ++;
//	
//						mGameV.setPlatformNum(num);
//					}
//				}
//				
//			}
//		}
//		
//		this.setStartingScrollPosition(mMovementV);
//				
//		//mGameV.setLevelLoading(false);
//
//	}

//	public void setStartingScrollPosition(MovementValues mMovementV) {
//		//set starting scroll position
//		
//		int i,j;
//		
//		mMovementV.setScrollX(0);
//		mMovementV.setScrollY(0);
//
//
//		boolean flag = false;
//
//		i = mGameV.getSprite(0).getMapPosX(); 
//		j = mGameV.getSprite(0).getMapPosY();
//
//		//scroll screen to starting location of guy...
////		while(i >  (mGameV.getScreenTilesHMod()  /2 )* 8 && flag == false) {
////
////			if ( mMovementV.getScrollX() + ((mGameV.getScreenTilesHMod()  ) * 8) < mGameV.getMapH()  * 8) { // 8
////				mMovementV.incrementScrollX(8);
////				i = i - 8; // X
////			}
////			
////			else flag = true;
////
////		}
//		
//		if ( i > mGameV.getScreenTilesHMod() * (8 / 2)) {
//			mMovementV.setScrollX(i - (mGameV.getScreenTilesHMod() * 4) );
//
//		}
//		else {
//			mMovementV.setScrollX((GameValues.MAP_TILES_H * 8) - ( (mGameV.getScreenTilesHMod() * 4) - i) );
//			Log.e("InitBackground", "--" + mMovementV.getScrollX());
//		}
//		
//		flag = false;
//		while( j >  (GameValues.SCREEN_TILES_V /2) * 8 && flag == false) {
//
//
//			if (mMovementV.getScrollY()  + ((GameValues.SCREEN_TILES_V  ) * 8) <  mGameV.getMapV()  * 8) {
//				mMovementV.incrementScrollY(8);
//				j = j - 8; // Y
//			}
//			else flag = true;
//		}
//	}
	
	/* set level map info */
	public void setLevel(int num) {
		boolean test1 = false;
		boolean test2 = false;
		int mSearchNum = num;
		
		try {
			test1 = mParser.setXmlPullParser(this.mLookForXml);
			//if (test1) test1 = mCParser.setXmlPullParser(this.mLookForXml);
			//if (test1) test1 = mCParser.parseChallengeXml(mSearchNum, mGameV);
			if (test1) {
                            //TODO: fix me!!
				//test1 = mParser.parseLevelXml(mSearchNum);
			}
			
		}
		catch (Exception e) {
			//Log.e("INIT LEVEL",e.getMessage());
			
		}
		//try again without sdcard.
//		if (test1 == false ) {
//			try {
////				mParser.setXmlPullParser(false);
////				mParser.parseLevelXml(num, mGameV);
//				
//				test1 = mParser.setXmlPullParser(false);
//				if (test1) test1 = mCParser.setXmlPullParser(false);
//				if (test1) test1 = mCParser.parseChallengeXml(mSearchNum, mGameV);
//				if (test1) {
//					test1 = mParser.parseLevelXml(mCParser.getFoundBackgroundNum(), mGameV);
//				}
//			}
//			catch (Exception e) {
//				//Log.e("INIT LEVEL",e.getMessage());
//				
//			}
//			
//		}

	}

	
//	public void populateLevelList() {
//		mLevelList = this.mCParser.getLevelList(mLookForXml);
//		/* NOTE: we are now populating the level list from the challenges.xml file */
//		mGameV.setLevelList(mLevelList);
//	}

	public static class ParseXML {
		//private Context mContext;
		//private GameValues mGameV;
		private XmlPullParser mXpp;
		
		public static final String SDCARD_FILE = new String ("awesomeflyer.xml");

		
		final String NUMBER = new String("number");
		final String VERTICAL = new String("vertical");
		final String HORIZONTAL = new String("horizontal");
		final String LEVEL = new String("level");
		final String TILES = new String("tiles_level");
		final String OBJECTS = new String("tiles_objects");
		final String LAST = new String("last_level");
		final String GAME = new String("game");
		
		public ParseXML() {
			//mContext = context;
			//this.mGameV = new GameValues();
		}
		
                public ParseXML( boolean mLook, String mName) {
                    mLookForXml = mLook;
                if (!mName.trim().contentEquals("")) {
                    mXMLFilename = mName;
                }
                }
                
		public boolean setXmlPullParser(boolean mLookForXml) throws XmlPullParserException, IOException{
			if (!mLookForXml) {
				//mXpp = mContext.getResources().getXml(R.xml.awesomeflyer);
			}
			else {
				
			   XmlPullParserFactory factory = XmlPullParserFactory.newInstance();
			   factory.setNamespaceAware(true);
			   mXpp = factory.newPullParser(); 	
                           
                           FileInputStream fstream = new FileInputStream(mXMLFilename);
                           DataInputStream in = new DataInputStream(fstream);
                           int BUFFER_SIZE = 8192;
                           
                           BufferedReader br = new BufferedReader(new InputStreamReader(in), BUFFER_SIZE);
                           
			  
			   mXpp.setInput(br);
				   
			}
			return true;
		}
		
		public LevelList getXmlList() throws XmlPullParserException, IOException{

			LevelList mList = new LevelList();

			int mIndexNum = 0;

			
			int eventType = mXpp.getEventType();
			while (eventType != XmlPullParser.END_DOCUMENT ) {
				
				//System.out.println("name: " + mXpp.getName());
				
				if(eventType == XmlPullParser.START_TAG && mXpp.getName().equalsIgnoreCase(LEVEL) ) {
				
					/* get 'number' attribute from xml tag 'level' */
					if (mXpp.getAttributeCount() == 1 && mXpp.getAttributeName(0).contentEquals( NUMBER)) {
						
						mIndexNum = new Integer(mXpp.getAttributeValue(0).toString().trim()).intValue();
                                                //System.out.println("constructing list " + mIndexNum);
						//Log.e("XML", " attribute number " + mIndexNum);
						if(mIndexNum - 1 == mList.size()) {
							mList.add(new String("Room Num "+mIndexNum),mIndexNum);
						}
						else {
							mList.add(new String("Room Num "+ ( mList.size() + 1 )+" ID:"+mIndexNum),mIndexNum);
						}
						//mList.add(mIndexNum);
					}
					else {
						//Log.e("XML", mXpp.getAttributeName(0) + " " + mXpp.getAttributeCount());
					}
				
					
				}
				eventType = mXpp.next();
			}
//			if (mGameV != null) {
//				mGameV.setTotNumRooms(mList.size());
//			}
                        //System.out.println(mList.size());
                        for (int x = 0; x < mList.size(); x ++  ) {
                            //System.out.println(mList.getNum(x)+ " " + x );
                            this.parseLevelXml(x, mList.getNum(x), mList);
                            //System.out.println(mList.getObjectTiles(x));
                        }
			return mList;
		}
		
		public LevelList parseLevelXml(int num, int mLabel,  LevelList mList) throws XmlPullParserException, IOException {
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
			this.setXmlPullParser(true);
                        
			int eventType = mXpp.getEventType();
			while (eventType != XmlPullParser.END_DOCUMENT && !mStopParse) {
				
				//System.out.println("name: " + mXpp.getName());
				
				if(eventType == XmlPullParser.START_TAG && mXpp.getName().equalsIgnoreCase(LEVEL) ) {
				
					/* get 'number' attribute from xml tag 'level' */
					if (mXpp.getAttributeCount() == 1 && mXpp.getAttributeName(0).contentEquals( NUMBER)) {
						
						mIndexNum = new Integer(mXpp.getAttributeValue(0).toString().trim()).intValue();
						//System.out.println("found label " + mIndexNum);
						if (mIndexNum == mLabel) {
                                                    mStopParse = true;
                                                    
                                                }
						//Log.e("XML", " attribute number " + mIndexNum);
					}
					else {
						//Log.e("XML", mXpp.getAttributeName(0) + " " + mXpp.getAttributeCount());
					}
				
					
				}
				eventType = mXpp.next();
			}
				
			if(  mIndexNum == mLabel) {
                            //System.out.println("found " + mLabel);
				/* found right level entry !!*/
				while (!(eventType == XmlPullParser.END_TAG && mXpp.getName().contentEquals(LEVEL))) {
					//mHorizontal
					if(eventType == XmlPullParser.START_TAG && mXpp.getName().contentEquals(HORIZONTAL)) {
						//System.out.println("Start tag "+mXpp.getName() + " number " + mIndexNum);
						mHorizontal = true;
					} else if(eventType == XmlPullParser.END_TAG && mXpp.getName().contentEquals(HORIZONTAL)) {
						//System.out.println("End tag "+mXpp.getName());
						mHorizontal = false;
					} else if(eventType == XmlPullParser.TEXT && mHorizontal == true) {
						mHorDimensions = new Integer(mXpp.getText()).intValue();
						//mGameV.setMapH(new Integer(xpp.getText()).intValue());
					}
					//mVertical
					if(eventType == XmlPullParser.START_TAG && mXpp.getName().contentEquals(VERTICAL)) {
						//System.out.println("Start tag "+mXpp.getName());
						mVertical = true;
					} else if(eventType == XmlPullParser.END_TAG && mXpp.getName().contentEquals(VERTICAL)) {
						//System.out.println("End tag "+mXpp.getName());
						mVertical = false;
					} else if(eventType == XmlPullParser.TEXT && mVertical == true) {
						mVerDimensions = new Integer(mXpp.getText()).intValue();
						//mGameV.setMapV(new Integer(xpp.getText()).intValue());
					}
					//mObjects
					if(eventType == XmlPullParser.START_TAG && mXpp.getName().contentEquals(OBJECTS)) {
						//System.out.println("Start tag "+mXpp.getName());
						mObjects = true;
					} else if(eventType == XmlPullParser.END_TAG && mXpp.getName().contentEquals(OBJECTS)) {
						//System.out.println("End tag "+mXpp.getName());
						mObjects = false;
					} else if(eventType == XmlPullParser.TEXT && mObjects == true) {
						mOList = mXpp.getText();
					}
					//mTiles
					if(eventType == XmlPullParser.START_TAG && mXpp.getName().contentEquals(TILES)) {
						//System.out.println("Start tag "+mXpp.getName());
						mTiles = true;
					} else if(eventType == XmlPullParser.END_TAG && mXpp.getName().contentEquals(TILES)) {
						//System.out.println("End tag "+mXpp.getName());
						mTiles = false;
					} else if(eventType == XmlPullParser.TEXT && mTiles == true) {
						mTList = mXpp.getText();
                                                //System.out.println(mTList);
					}
					
					eventType = mXpp.next();

				}
			}
				
			
			//System.err.println("here " + mTList);
				
			//parse strings here...
			StringTokenizer mTileToken = new StringTokenizer(mTList,",");
			int mTotalTileTokens = mTileToken.countTokens();
			
			StringTokenizer mObjectToken = new StringTokenizer(mOList,",");
			int mTotalObjectTokens = mObjectToken.countTokens();
			
//			mGameV.setMapH(mHorDimensions);
//			mGameV.setMapV(mVerDimensions);
			
			
			if(mTotalTileTokens == mHorDimensions * mVerDimensions && 
					mTotalObjectTokens == mHorDimensions * mVerDimensions) {
				mList.setTiles(num,new String( mTList), new String( mOList));
//				for(int i = 0; i < mGameV.getMapV(); i ++) { // 32 y
//					for(int j =0; j < mGameV.getMapH(); j ++) { // 64 x
//						
//						if (mGameV.getXmlMode() == GameValues.XML_USE_BOTH || mGameV.getXmlMode() == GameValues.XML_USE_LEVEL) {
//							int mL = new Integer(mTileToken.nextToken().trim()).intValue();
//							if (mL != 0) {
//								mGameV.setLevelCell(j, i, mL + GameValues.MAPPY_ERROR_FACTOR);
//							}
//							else {
//								mGameV.setLevelCell(j, i, 0);
//							}
//						}
//						if (mGameV.getXmlMode() == GameValues.XML_USE_BOTH || mGameV.getXmlMode() == GameValues.XML_USE_OBJECTS) {
//							int mO = new Integer(mObjectToken.nextToken().trim()).intValue();
//							if (mO != 0) {
//								mGameV.setObjectsCell(j, i, mO + GameValues.MAPPY_ERROR_FACTOR);
//							}
//							else {
//								mGameV.setObjectsCell(j, i, 0);
//							}
//						}
//
//					} //j block                        
//				} // i block
				
				
			
			}
			else {
				/* throw hairy fit */
				//Log.e("XML"," 'tokens' doesn't match 'dimensions'!!!");
				//return false;
			}
			return mList;
		}
		
		public  InitBackground.LevelList getLevelList(boolean mLookForXml) {
	    	boolean test = true;
	    	InitBackground.LevelList mList = new InitBackground.LevelList();
	    	try {
				test = setXmlPullParser(mLookForXml);
	        	mList = getXmlList();
			}
			
			catch (XmlPullParserException e) {
				//Log.e("INIT LEVEL","XmlPullParserException -- " + e.getMessage());
			}
			catch (IOException e) {
				//Log.e("INIT LEVEL","IO exception " + e.getMessage());
			}
			catch (Exception e) {
				//Log.e("INIT LEVEL", "exception " + e.getMessage());
			}
			
			//try again without sdcard.
			if (mList.size() == 0 ) {
				try {
					//Log.e("INIT LEVEL","failed mLookForXml -- " + test);

					setXmlPullParser(false);
		        	mList = getXmlList();
				}
				catch (Exception e) {
					//Log.e("INIT LEVEL",e.getMessage());
					
				}
				
			}
			return mList;
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
                public void add(String text, Integer i, String ml, String mO) {
			LevelData temp = new LevelData();
			temp.mNum = i;
			temp.mText = text;
                        temp.mLevelTiles = ml;
                        temp.mObjectTiles = mO;
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
		public int getNum(int num) {
			return mList.get(num).mNum;
		}
                
                public void setLabelNumber(int num, int mLabel) {
                    mList.get(num).mNum = mLabel;
                }
                public String getLevelTiles(int num) {
			return mList.get(num).mLevelTiles;
		}
                public String getObjectTiles(int num) {
			return mList.get(num).mObjectTiles;
		}
                
                public void setTiles(int num, String mL, String mO ) {
                        mList.get(num).mLevelTiles = mL;
                        mList.get(num).mObjectTiles = mO;
                }
	}
	
	public static class LevelData {
		public String mText = new String("blank");
		public Integer mNum = 1;
                
                public String mLevelTiles = new String();
                public String mObjectTiles = new String();
	}
}
