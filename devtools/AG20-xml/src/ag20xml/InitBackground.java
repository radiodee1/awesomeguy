package ag20xml;

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
	private ArrayList mLevelList;
	private static boolean mLookForXml;
        private static String mXMLFilename = "awesomeguy.xml";
	
	public InitBackground( boolean mLookForXml, String mFileName) {
		//mGameV = gV;
		//mContext = context;
		mParser = new ParseXML();
		//mCParser = new ParseChallengeXML(mContext);
		this.mLookForXml = mLookForXml;
                if (!mFileName.trim().contentEquals("")) {
                    mXMLFilename = mFileName;
                }
		

	}
	
	
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


	}

	


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
		

		
		public void parseLevelXml(int num, int mLabel,  ArrayList mList) throws XmlPullParserException, IOException {
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
				//mList.setTiles(num,new String( mTList), new String( mOList));

				
				
			
			}
			else {
				/* throw hairy fit */
				//Log.e("XML"," 'tokens' doesn't match 'dimensions'!!!");
				//return false;
			}
			return;
		}
		
        }
        
}
