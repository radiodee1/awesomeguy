package org.davidliebman.android.awesomeguy;

import android.app.ActivityManager;
import android.app.Dialog;
import android.app.ListActivity;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.widget.*;
import android.content.*;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;
//import android.text.InputType;
//import android.util.Log;
import android.view.View.OnKeyListener;
import java.util.ArrayList;
import android.view.*;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnFocusChangeListener;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.app.AlertDialog;
import com.google.android.apps.analytics.GoogleAnalyticsTracker;

//import android.util.Log;

public class Players extends ListActivity {
		
    public static final String AWESOME_NAME = new String("org.awesomeguy");
    public static final String SAVED_NUM_SCORES = new String("saved_num_scores");
	public static final String SAVED_ROOM_NUM = new String("room");
	public static final String SAVED_LOOK_FOR_XML = new String("look_for_xml");
	public static final String SAVED_REMEMBER_PLAYER = new String("remember_player");
	public static final String SAVED_ANALYTICS = new String("analytics_tracking");
	public static final String SAVED_TOS = new String("terms_of_service_shown");
	public static final String SAVED_VERSIONCODE = new String("old_versioncode");
	
    private ArrayList<Record> mNames = new ArrayList<Record>();
    private Record mRec = new Record();
    private SharedPreferences mPreferences;
    private RecordAdapter mAdapter;
    private SplashScreen mSplash;
    private Animation myFadeInAnimation;
    private TextView mPlayerText;
    private TextView mNumPlayers;
    private EditText mEdittext;
    private int mPreferredNumRecords;
    private int mRoomNumSelected = 1;
    private boolean mLookForXml;
    private boolean mIsNewRecord;
    private boolean mShowMenu = false;
    
    public static final int VIEW_SPLASH = 0;
    public static final int VIEW_PLAYERS = 1;
    public static final int VIEW_TEXT = 2;
    public static final int VIEW_SCORES = 3;
    
    public static final int TEXT_NOTEXT = -1;
    public static final int TEXT_HELP = 0;
    public static final int TEXT_STORY = 1;
    public static final int TEXT_LEGAL = 2;
    
    public static final int DIALOG_USERNUM_CHANGED = 0;
    public static final int DIALOG_STARTGAME = 1;
    public static final int DIALOG_UNUSED = 2;
    
    public static final int MENU_BASE = Menu.FIRST;
    public static final int MENU_GROUP_SUBMENU = MENU_BASE + 1;
    public static final int MENU_GROUP_ROOMS = MENU_BASE + 2; //this is always last entry

    
    protected boolean mActive = true;
    private boolean mRememberPlayer = true;
    private boolean mGoogleAnalytics;
    private boolean mTermsOfService;
    private int mVersionCode = 1;
    public static final String UA_NUMBER = new String("UA-19479622-2");
    public GoogleAnalyticsTracker tracker;
    private Record mHighScores;
    private Scores.ScoreOpenHelper mScoresHelper;
    private Scores mScores;
    private SQLiteDatabase db;
    
	private InitBackground.LevelList mList;
	private InitBackground.ParseXML mParser = new InitBackground.ParseXML(this);
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        //////////////////////start SplashScreen
        /* init database if not already done so */
        mScoresHelper = new Scores.ScoreOpenHelper(this);
        db = mScoresHelper.getReadableDatabase();
        db.close();
        
        /* one highscores record passed around for preferences */
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mRememberPlayer = mPreferences.getBoolean(Players.SAVED_REMEMBER_PLAYER, true);
        mHighScores = new Record();


        
        /* if 'anonymous' then blank out record. */
        if(mHighScores.getName().contentEquals(new Record().getName())) {
        	mHighScores = new Record();
        }
        
        /* google analytics tracker */
        mGoogleAnalytics = mPreferences.getBoolean(Players.SAVED_ANALYTICS, true);

        tracker = GoogleAnalyticsTracker.getInstance();
        tracker.start(UA_NUMBER, 5, this);
        if (mGoogleAnalytics) {
            tracker.trackPageView("/SplashScreen");
            tracker.dispatch();
            //Log.e("Awesomeguy","Google Analytics-----------------");
        }
        
            
        //////////////////////end SplashScreen
        
        /* retrieve Record mHighScores */
    	mHighScores = new Record();
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(mPreferences);
        this.mPreferredNumRecords = mHighScores.getNumRecords();
        
        mScores = new Scores(this, mHighScores);
        mNames = mScores.getHighScorePlayerList(mHighScores.getNumRecords());

        
        mAdapter = new RecordAdapter(this, R.layout.players, mNames);
        mAdapter.setNotifyOnChange(true);
        mAdapter.notifyDataSetChanged();
        
        setContentView(R.layout.players);      
        setListAdapter(mAdapter);
        ListView lv = getListView();
        lv.setTextFilterEnabled(true);
        lv.setOnItemClickListener(new OnItemClickListener () {
        	
        	@Override
        	 public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        		mRec = mNames.get(position);

        		//AlertNumRecords mAlert = new AlertNumRecords(Players.this,mHighScores,mRec);
        		mPreferredNumRecords = mHighScores.getNumRecords();
        		if ( mPreferredNumRecords != mRec.getNumRecords() ) {
      			   showDialog(Players.DIALOG_USERNUM_CHANGED);
        		}
        		
        		//mRec.setNumRecords(mAlert.alertUser()); // TODO: is this redundant??
        		mHighScores = mRec;

        		Toast.makeText(Players.this, "Player Selected: " + mHighScores.getName(), Toast.LENGTH_SHORT).show();
        		SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
            	mHighScores.setNewRecord(false);
        		mHighScores.addToPreferences(preferences);
                mPlayerText.setText("Player Chosen: " +mHighScores.getName());
                ((TextView)findViewById(R.id.edittext_name)).setText("");
                /* save num of high scores */
                SharedPreferences.Editor mSave = mPreferences.edit();
                mSave.putInt(Players.SAVED_NUM_SCORES, mHighScores.getNumRecords());
                mSave.commit();
                mNumPlayers.setText("This is where you enter a new player name, or choose from a list of " + mHighScores.getNumRecords() + " players.");
                
                /* save num of high scores for player */
                //TODO: TEST ME!!
                mScores.updateNumOfRecords(mHighScores.getNumRecords());
                
                /* adjust number of high scores shown */
                mScores.pruneScoresList();
                
                mIsNewRecord = false;
        	 }
        	
        	
        });
        
        /* long click code */
        lv.setLongClickable(true);
        lv.setOnItemLongClickListener(new OnItemLongClickListener () {
        	
        	public boolean onItemLongClick (AdapterView<?> parent, View view, int position, long id) {
//        		Toast.makeText(Players.this, "Player - Num Records: " + mNames.get(position).getNumRecords() + 
//        				" Record ID: " + mNames.get(position).getRecordIdNum(), Toast.LENGTH_LONG).show();

        		return true;
        	}
        });
        
        
        /* edit text field*/
        //final EditText 
        mEdittext = (EditText) findViewById(R.id.edittext_name);
        
        mEdittext.setOnKeyListener(new OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                // If the event is a key-down event on the "enter" button
                if ((event.getAction() == KeyEvent.ACTION_DOWN) &&
                    (keyCode == KeyEvent.KEYCODE_ENTER)) {
                  // Perform action on key press

                	if( ! mEdittext.getText().toString().contentEquals("")  &&
                			! mEdittext.getText().toString().contentEquals(mHighScores.getName())) {
                		setNewName();
                	}
                  return true;
                }
                return false;
                //return true;
            }
            
            
        });
        
        mEdittext.setOnFocusChangeListener( new OnFocusChangeListener () {

			@Override
			public void onFocusChange(View v, boolean hasFocus) {
				// 
				if (hasFocus) {
					mIsNewRecord = true;
				}
				
			} 
        	
        });
        
        /* button at bottom of view */
        final Button button = (Button) findViewById(R.id.button_players);
        button.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	if (! mEdittext.getText().toString().contentEquals("") && 
            			! mEdittext.getText().toString().contentEquals(mHighScores.getName())) {
            		if ( mIsNewRecord ) setNewName();
            		
            	}
            	Intent StartGameIntent = new Intent(Players.this,GameStart.class);
        		startActivity(StartGameIntent);
            	
            	//Toast.makeText(Players.this, "And We're Off", Toast.LENGTH_SHORT).show();
            }
        });
        
        
        /* button at bottom of view */
        final Button buttonText = (Button) findViewById(R.id.button_endtext);
        buttonText.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	showView(Players.VIEW_PLAYERS);
            	showDialog(Players.DIALOG_STARTGAME);
            	//Toast.makeText(Players.this, "And We're Off", Toast.LENGTH_SHORT).show();

            }
        });
        
        /* dismiss splash screen on touch */
        final View buttonSplash =  findViewById(R.id.view_splash);
        buttonSplash.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	
            	if (mSplash != null && !mSplash.isCancelled()) {
            		mSplash.cancel(true);
            		myFadeInAnimation.scaleCurrentDuration(0);
            		onPostSplash();
            	
            	}
            }
        });
        
        mNumPlayers = (TextView) findViewById(R.id.text_num_message);
        mNumPlayers.setText("This is where you choose from a list of " + mHighScores.getNumRecords() + " players.");
        
        mPlayerText = (TextView) findViewById(R.id.text_player_name);
        mPlayerText.setText("Player Chosen: " +mHighScores.getName());
        
        mScores.pruneScoresList();
        
    }
    
    /* when the activity is resumed, re-display a new list */
    @Override
    public void onResume() {
    	super.onResume();
    	
    	this.showView(VIEW_PLAYERS);
    	
    	/* retrieve Record mHighScores */
    	mHighScores = new Record();
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        
        mRememberPlayer = mPreferences.getBoolean(Players.SAVED_REMEMBER_PLAYER, true);
        //mHighScores = new Record();

        if(!mRememberPlayer) {
        	mHighScores.addToPreferences(mPreferences);
        }
        else {
        	mHighScores.getFromPreferences(mPreferences);
        }
        
        //mHighScores.getFromPreferences(mPreferences);
        mPlayerText.setText("Player Chosen: " +mHighScores.getName());
        
        this.mPreferredNumRecords = this.mPreferences.getInt(Players.SAVED_NUM_SCORES, Record.RADIO_PLAYERS_FIFTY);
        mNumPlayers.setText("This is where you choose from a list of " + this.mPreferredNumRecords + " players.");

        try {
    		mScores.closeAll();
    	}
    	catch (NullPointerException e) {
    		//Log.e("Awesomeguy", "Null Pointer Players");
    	}
        
        mScores = new Scores(this, mHighScores);

    	
    	ArrayList<Record> temp = mScores.getHighScorePlayerList(mHighScores.getNumRecords());
        this.mNames.clear();
        this.mNames.addAll(temp);
        mAdapter = new RecordAdapter(this, R.layout.players, mNames);
        setListAdapter(mAdapter);
    	mAdapter.notifyDataSetChanged();
    	
    	/////////////////////////////start TOS
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);

        mLookForXml = mPreferences.getBoolean(SAVED_LOOK_FOR_XML, false);
        //mRememberPlayer = mPreferences.getBoolean(SAVED_REMEMBER_PLAYER, true);
        
    	 /* get TOS info from preferences */
        mGoogleAnalytics = mPreferences.getBoolean(Players.SAVED_ANALYTICS, true);
        mTermsOfService = mPreferences.getBoolean(Players.SAVED_TOS, false);
        //Log.e("tag", "version code saved " + mPreferences.getInt(SAVED_VERSIONCODE, 1));
        
        /* check version / show TermsOfService.java */
        PackageManager mManager = this.getPackageManager();
        try {
        	PackageInfo mInfo = mManager.getPackageInfo("org.davidliebman.android.awesomeguy", 0);
        	mVersionCode = mInfo.versionCode;
        	
        }
        catch (NameNotFoundException e) {
        	// not a big deal if Package Manager 
        	// doesn't find the version code.
        	e.printStackTrace();
        	mVersionCode = 1;
        }
        /* if game was just updated, show TOS page. */
        if (mPreferences.getInt(Players.SAVED_VERSIONCODE, 1) != mVersionCode) {
        	mTermsOfService = false;
        	
        }
        
        /* reset preferences so that game starts with room 1 */
        SharedPreferences.Editor e = mPreferences.edit();
        e.putInt(Options.SAVED_ROOM_NUM, 1);
        e.commit();
        
    	////////////////////////////start splashscreen
        
    	mSplash = new SplashScreen();
    	mSplash.execute(new Integer[] {0});
    	
    }
    
    public void onPostSplash() {
    	
    	int num = mScores.pruneScoresList();
    	if (num > 0) {
    		Toast.makeText(Players.this, num + " scores were removed from High Score List!!", Toast.LENGTH_LONG).show();
    	}
    	if (!mTermsOfService) {
    		displayText(Players.TEXT_LEGAL);
        	SharedPreferences.Editor edit = mPreferences.edit();
        	edit.putBoolean(Players.SAVED_TOS, true);
            edit.putInt(Options.SAVED_VERSIONCODE, mVersionCode);

        	edit.commit();
    	}
    	else {
    		//this.checkAccountStartAuth();
    		showView(Players.VIEW_PLAYERS);
    		showDialog(Players.DIALOG_STARTGAME);
    	}
    }
    
    public void setNewName() {
        mRec = new Record();
        mRec.setName(mEdittext.getText().toString().trim());
        mRec.setNumRecords(mHighScores.getNumRecords());
        if ( isNameTaken(mNames, mRec.getName())) {
            Toast.makeText(Players.this, "This name is already taken: " + mEdittext.getText(), Toast.LENGTH_LONG).show();

        }
        else {
            Toast.makeText(Players.this, "Player Selected: " + mEdittext.getText(), Toast.LENGTH_SHORT).show();
      	  mHighScores = mRec;
      	  mHighScores.setNewRecord(true);
      	  
      	  mHighScores.addToPreferences(mPreferences);
      	  mPlayerText.setText("Player Chosen: " +mHighScores.getName());
            mNumPlayers.setText("This is where you choose from a list of " + mHighScores.getNumRecords() + " players.");
            SharedPreferences.Editor edit = mPreferences.edit();
            edit.putInt(Players.SAVED_ROOM_NUM, mHighScores.getLevel());
            edit.commit();
        }
    }
    
    @Override
    protected void onDestroy() {
    	super.onDestroy();
    	tracker.stop();
    }
    
    
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
    	MenuInflater inflate = getMenuInflater();
    	inflate.inflate(R.menu.main_menu, menu);
    	

    	return true;
    	
    }
    
    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
    	
    	if (! mEdittext.getText().toString().contentEquals("") && 
    			! mEdittext.getText().toString().contentEquals(mHighScores.getName())) {
    		if ( mIsNewRecord ) setNewName();
    		
    	}
    	
    	mList = new InitBackground.LevelList();
    	mList = mParser.getLevelList(mLookForXml);
    	
    	//erase old room menu
    	menu.removeGroup(Players.MENU_GROUP_SUBMENU);
    	//must populate menu entries for level
    	SubMenu mRoomMenu = menu.addSubMenu(Players.MENU_GROUP_SUBMENU, 0, 1, "Starting Level");
    	for (int x = 0; x < mList.size(); x ++ ) {
    		mRoomMenu.add(Players.MENU_GROUP_ROOMS,Players.MENU_BASE + mList.getNum(x), 0, "Level #" + mList.getNum(x));	
    	}
    	mRoomMenu.setGroupCheckable(Players.MENU_GROUP_ROOMS, true, true);

    	//set one entry as selected
    	for (int x = 0; x < mList.size(); x ++ ) {
    		if (this.mRoomNumSelected == mList.getNum(x)) {
    			menu.findItem(Players.MENU_BASE + mList.getNum(x)).setChecked(true);
    		}
    	}
    	
    	//set game speed
    	if (mHighScores.getGameSpeed() == Record.SPEED_SLOW) {
    		menu.findItem(R.id.menu_options_speed_slow_item).setChecked(true);
    	}
    	if (mHighScores.getGameSpeed() == Record.SPEED_MEDIUM) {
    		menu.findItem(R.id.menu_options_speed_medium_item).setChecked(true);
    	}
    	if (mHighScores.getGameSpeed() == Record.SPEED_FAST) {
    		menu.findItem(R.id.menu_options_speed_fast_item).setChecked(true);
    	}
    	if (mHighScores.getGameSpeed() == Record.SPEED_FASTER) {
    		menu.findItem(R.id.menu_options_speed_faster_item).setChecked(true);
    	}
    	
    	if (mHighScores.getGameSpeed() == Record.SPEED_SYSTEM) {
    		menu.findItem(R.id.menu_options_speed_system_item).setChecked(true);
    	}
    	//play game sound
    	if (!mHighScores.isSound()) {
    		menu.findItem(R.id.menu_options_sound_no_item).setChecked(true);
    	}
    	else {
    		menu.findItem(R.id.menu_options_sound_yes_item).setChecked(true);
    	}
    	//how many players
    	if (mHighScores.getNumRecords() == Record.RADIO_PLAYERS_FIFTY) {
    		menu.findItem(R.id.menu_options_players_fifty_item).setChecked(true);
    	}
    	if (mHighScores.getNumRecords() == Record.RADIO_PLAYERS_TEN) {
    		menu.findItem(R.id.menu_options_players_ten_item).setChecked(true);
    	}
    	if (mHighScores.getNumRecords() == Record.RADIO_PLAYERS_FIVE) {
    		menu.findItem(R.id.menu_options_players_five_item).setChecked(true);
    	}
    	//remember me
    	if (mRememberPlayer) {
    		menu.findItem(R.id.menu_options_rememberme_yes_item).setChecked(true);
    	}
    	else {
    		menu.findItem(R.id.menu_options_rememberme_no_item).setChecked(true);
    	}
    	//look for xml
    	if (!mLookForXml) {
    		menu.findItem(R.id.menu_options_xml_no_item).setChecked(true);
    	}
    	else {
    		menu.findItem(R.id.menu_options_xml_yes_item).setChecked(true);
    	}
    	//use google analytics
    	if (mGoogleAnalytics ) {
    		menu.findItem(R.id.menu_options_analytics_yes_item).setChecked(true);
    	}
    	else {
    		menu.findItem(R.id.menu_options_analytics_no_item).setChecked(true);
    	}
    	//will game have monsters?
    	if (mHighScores.isEnableMonsters()) {
    		menu.findItem(R.id.menu_options_monsters_yes_item).setChecked(true);
    	}
    	else {
    		menu.findItem(R.id.menu_options_monsters_no_item).setChecked(true);
    	}
    	//will game have collision?
    	if (mHighScores.isEnableCollision()) {
    		menu.findItem(R.id.menu_options_collision_yes_item).setChecked(true);
    	}
    	else {
    		menu.findItem(R.id.menu_options_collision_no_item).setChecked(true);
    	}
    	
    	return this.mShowMenu;
    }
    
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
    	switch (item.getItemId()) {
    	case R.id.menu_credits_legal_item:
    		displayText(Players.TEXT_LEGAL);
    		break;
    	case R.id.menu_game_item:
        	Intent StartGameIntent = new Intent(Players.this,GameStart.class);
    		startActivity(StartGameIntent);
    		break;
    	case R.id.menu_help_item:
    		displayText(Players.TEXT_HELP);
    		break;
    	case R.id.menu_highs_item:
    		mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        	mHighScores.addToPreferences(mPreferences);

        	Intent HighScoreIntent = new Intent(Players.this,Highscores.class);
    		startActivity(HighScoreIntent);
    		break;
    	case R.id.menu_story_item:
    		displayText(Players.TEXT_STORY);
    		break;
    	case R.id.menu_options_speed_slow_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setGameSpeed(Record.SPEED_SLOW);
    		}
    		break;
    	case R.id.menu_options_speed_medium_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setGameSpeed(Record.SPEED_MEDIUM);
    		}
    		break;
    	case R.id.menu_options_speed_fast_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setGameSpeed(Record.SPEED_FAST);
    		}
    		break;

    	case R.id.menu_options_speed_faster_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setGameSpeed(Record.SPEED_FASTER);
    		}
    		break;
    	case R.id.menu_options_speed_system_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setGameSpeed(Record.SPEED_SYSTEM);
    		}
    		break;
    	case R.id.menu_options_players_fifty_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setNumRecords(Record.RADIO_PLAYERS_FIFTY);
    			showDialog(Players.DIALOG_USERNUM_CHANGED);
    		}
    		break;
    	case R.id.menu_options_players_ten_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setNumRecords(Record.RADIO_PLAYERS_TEN);
    			showDialog(Players.DIALOG_USERNUM_CHANGED);
    		}
    		break;
    	case R.id.menu_options_players_five_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setNumRecords(Record.RADIO_PLAYERS_FIVE);
    			showDialog(Players.DIALOG_USERNUM_CHANGED);
    		}
    		break;
    	case R.id.menu_options_sound_yes_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setSound(true);
    		}
    		break;
    	case R.id.menu_options_sound_no_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setSound(false);
    		}
    		break;
    	case R.id.menu_options_rememberme_yes_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			this.mRememberPlayer = true;
    		}
    		break;
    	case R.id.menu_options_rememberme_no_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			this.mRememberPlayer = false;
    		}
    		break;
    	case R.id.menu_options_xml_yes_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			this.mLookForXml = true;
    		}
    		break;
    	case R.id.menu_options_xml_no_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			this.mLookForXml = false;
    		}
    		break;
    	case R.id.menu_options_analytics_yes_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			this.mGoogleAnalytics = true;
    		}
    		break;
    	case R.id.menu_options_analytics_no_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			this.mGoogleAnalytics = false;
    		}
    		break;
    	case R.id.menu_options_monsters_yes_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			mHighScores.setEnableMonsters(true);
    		}
    		break;
    	case R.id.menu_options_monsters_no_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			this.mHighScores.setEnableMonsters(false);
    		}
    		break;
    	case R.id.menu_options_collision_yes_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			this.mHighScores.setEnableCollision(true);
    		}
    		break;
    	case R.id.menu_options_collision_no_item:
    		if (!item.isChecked()) {
    			item.setChecked(true);
    			this.mHighScores.setEnableCollision(false);
    		}
    		break;
    	case R.id.menu_url_item:
    		
    		try {
	    		ActivityManager actMngr = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
	    		String runningPkg = actMngr.getRunningTasks(1).get(0).topActivity.getPackageName();
	
	    		PackageManager pm = getPackageManager();
	    		ApplicationInfo ai = pm.getApplicationInfo(runningPkg , 0);
	    		
	    		String url = WebScoreUpload.MY_URL + WebScoreUpload.MY_PATH_INDEX + "?game=" +
	    				ai.packageName;
	    		
	    		//Log.e("Players ----","package: " +ai.packageName);
	    		
	    		Intent i = new Intent(Intent.ACTION_VIEW);
	    		i.setData(Uri.parse(url));
	    		startActivity(i);
    		}
    		catch (Exception e ) {
    			e.printStackTrace();
    		}
    		break;
    	case R.id.menu_username_item:
    		Intent intent = new Intent(this, WebAuthActivity.class);
    		intent.putExtra(WebAuth.EXTRA_NAME, WebAuth.TASK_USERNAME);
    		startActivity(intent);
    		break;
    		
    	}
    	
    	for (int x = 0; x < mList.size(); x ++ ) {
    		if (Players.MENU_BASE + mList.getNum(x) == item.getItemId()) {
    			this.mRoomNumSelected = x + 1;
    		}
    	}

    	SharedPreferences.Editor edit = mPreferences.edit();
        edit.putInt(SAVED_ROOM_NUM, mRoomNumSelected);
        edit.putBoolean(SAVED_LOOK_FOR_XML, mLookForXml);
        edit.putBoolean(SAVED_REMEMBER_PLAYER, mRememberPlayer);
        edit.putBoolean(SAVED_ANALYTICS, mGoogleAnalytics);
        //edit.putInt(SAVED_NUM_SCORES, mPreferredNumRecords);
        edit.commit();
                
    	mHighScores.addToPreferences(mPreferences);
    	mScores.setHighScores(mHighScores);
    	mScores.updateOptions(mHighScores.getRecordIdNum());
    	return true;
    }
    
    public void adjustPlayersList(int mNewNumOfRecords) {
    	//mPreferredNumRecords = mHighScores.getNumRecords();
		
		//mPreferredNumRecords = mNewNumOfRecords;
		
		mHighScores.setNumRecords(mNewNumOfRecords);
        /* save num of high scores */
        SharedPreferences.Editor mSave = mPreferences.edit();
        mSave.putInt(Options.SAVED_NUM_SCORES, mNewNumOfRecords);
        mSave.commit();
        mNumPlayers.setText("This is where you enter a new player name, or choose from a list of " + mHighScores.getNumRecords() + " players.");
        
        /* save num of high scores for player */
        
        //save options again...
        mHighScores.addToPreferences(mPreferences);
    	mScores.setHighScores(mHighScores);
    	mScores.updateOptions(mHighScores.getRecordIdNum());
    	
    	mScores.pruneScoresList();
    	mNames.clear();
    	mNames.addAll(mScores.getHighScorePlayerList(mNewNumOfRecords));
        mAdapter = new RecordAdapter(this, R.layout.players, mNames);

        setListAdapter(mAdapter);
    
        mAdapter.notifyDataSetChanged();

    	mPreferredNumRecords = mNewNumOfRecords;
	
    }
    
    /* determine if a name is already taken */
    public static boolean isNameTaken(ArrayList<Record> mNames, String test) {
    	boolean value = false;
    	if (mNames.size() > 0) {
    		for (int i = 0; i < mNames.size(); i ++ ) {
    			if (mNames.get(i).getName().contentEquals(test)) {
    				value = true;
    			}
    		}
    	}
    	
    	return value;
    }
    
    @Override
    public void onPause() {
    
    	if (mSplash != null) {
    		mSplash.cancel(true);
    	}
    	
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
    	mHighScores.addToPreferences(mPreferences);
    	
    	SharedPreferences.Editor edit = mPreferences.edit();
        edit.putBoolean(SAVED_REMEMBER_PLAYER, mRememberPlayer);
        edit.commit();
    	try {
    		mScores.closeAll();
    	}
    	catch(NullPointerException e) {
    		//Log.e("Awesomeguy", "Null Pointer Players");
    	}
    	super.onPause();
    }
    
    protected Dialog onCreateDialog(int mId) {
    	Dialog  dialog = new Dialog(Players.this);
    	AlertDialog.Builder builder;
    	AlertDialog alertDialog;
    	LayoutInflater mInflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
    	View mLayout;
    	
    	mLayout = mInflater.inflate(R.layout.congrats, 
    			(ViewGroup) findViewById(R.id.layout_root));
    	mLayout.findViewById(R.id.image).setBackgroundResource(R.drawable.guy_icon);
    	
    	switch (mId) {
    	/////////////////////////////////////
    	case Players.DIALOG_USERNUM_CHANGED:
    		//old: mPreferredNumRecords
    		//new: mHighScores.getNumRecords()
 		   if ( mPreferredNumRecords != mHighScores.getNumRecords() ) {
	   	    	builder = new AlertDialog.Builder(Players.this);
	   	    	builder.setView(mLayout);
	   	    	String mAMessage = new String("Your old preference for 'Number of Player Records' is " 
	   	    			+ mPreferredNumRecords);
	   	    	((TextView)mLayout.findViewById(R.id.congrats_text)).setText(mAMessage);
	   	    	String mPositive = new String("Choose " + mHighScores.getNumRecords() + " records.");
	   	    	String mNegative = new String("Choose " + mPreferredNumRecords + " records.");
	   	    	builder.setCancelable(false)
	   	    	       .setPositiveButton(mPositive, new DialogInterface.OnClickListener() {
	   	    	           public void onClick(DialogInterface dialog, int id) {
	   	    	        	   adjustPlayersList(mHighScores.getNumRecords());
	   	    	        	   dialog.cancel();
	   	    	        	   removeDialog(Players.DIALOG_USERNUM_CHANGED);
	   	    	           }
	   	    	       })
	   	    	       .setNegativeButton(mNegative, new DialogInterface.OnClickListener() {
	   	    	           public void onClick(DialogInterface dialog, int id) {
	   	    	        	   mHighScores.setNumRecords(mPreferredNumRecords);	
	   	    	        	   removeDialog(Players.DIALOG_USERNUM_CHANGED);
	   	    	                dialog.cancel();
	   	    	           }
	   	    	       });
	   	    	AlertDialog alert = builder.create();
	   	    	dialog = (Dialog) alert;
	       	}
    		
    		break;
    	////////////////////////////////////
    	case Players.DIALOG_STARTGAME:
    		
    		builder = new AlertDialog.Builder(Players.this);
    		builder.setView(mLayout);
   	    	String mAMessage = new String("Play Awesomeguy as \'" + mHighScores.getName() +
   	    			"\' or choose another player:");
   	    	((TextView)mLayout.findViewById(R.id.congrats_text)).setText(mAMessage);

   	    	String mPositive = new String("Choose " + mHighScores.getName() );
   	    	String mNegative = new String("Stay on this screen." );
   	    	builder.setCancelable(false)
   	    	       .setPositiveButton(mPositive, new DialogInterface.OnClickListener() {
   	    	    	   public void onClick(DialogInterface dialog, int id) {
   	    	    		   mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
   	    	    		   mHighScores.addToPreferences(mPreferences);

   	    	    		   Intent StartGameIntent = new Intent(Players.this,GameStart.class);
   	    	    		   startActivity(StartGameIntent);   	    	        	   
   	    	    		   dialog.cancel();
   	    	        	   removeDialog(Players.DIALOG_STARTGAME);
   	    	           }
   	    	       })
   	    	       .setNegativeButton(mNegative, new DialogInterface.OnClickListener() {
   	    	           public void onClick(DialogInterface dialog, int id) {
   	    	        	   	removeDialog(Players.DIALOG_STARTGAME);
   	    	                dialog.cancel();
   	    	           }
   	    	       });
   	    	AlertDialog alert = builder.create();
   	    	dialog = (Dialog) alert;
    		
    		break;
    	////////////////////////////////////
    	case Players.DIALOG_UNUSED:
    		break;
    	////////////////////////////////////
    		default:
    			dialog = null;
    	}
    	
    	return dialog;
    }
    
    
    public void showView(int mViewToShow) {
    	// blank out all views
    	this.findViewById(R.id.view_splash).setEnabled(false);
    	this.findViewById(R.id.view_splash).setVisibility(View.GONE);
    	this.findViewById(R.id.view_players).setEnabled(false);
    	this.findViewById(R.id.view_players).setVisibility(View.GONE);
    	this.findViewById(R.id.view_text).setEnabled(false);
    	this.findViewById(R.id.view_text).setVisibility(View.GONE);
    	this.mShowMenu = false;
    	// show selected view
    	switch (mViewToShow) {
    	case Players.VIEW_SPLASH:
    		this.findViewById(R.id.view_splash).setEnabled(true);
    		this.findViewById(R.id.view_splash).setVisibility(View.VISIBLE);
    		break;
    	case Players.VIEW_PLAYERS:
    		this.findViewById(R.id.view_players).setEnabled(true);
    		this.findViewById(R.id.view_players).setVisibility(View.VISIBLE);
    		this.mShowMenu = true;
    		break;
    	case Players.VIEW_TEXT:
    		this.findViewById(R.id.view_text).scrollTo(0, 0);
    		this.findViewById(R.id.view_text).setEnabled(true);
    		this.findViewById(R.id.view_text).setVisibility(View.VISIBLE);
    		break;
    	case Players.VIEW_SCORES:
    		break;
    	}
    }
    
    public void displayText(int mText) {
    	this.showView(Players.VIEW_TEXT);
    	TextView mTextView = (TextView) this.findViewById(R.id.text_out);
    	switch (mText) {
    	case Players.TEXT_HELP:
    		mTextView.setText(R.string.app_helptext);
    		break;
    	case Players.TEXT_LEGAL:
    		mTextView.setText(R.string.app_legal);
    		break;
    	case Players.TEXT_STORY :
    		mTextView.setText(R.string.app_storytext);
    		break;
    	}
    }
    
//    public void checkAccountStartAuth() {
//    	WebAuth auth = new WebAuth(this, null);
//    	if (! auth.isAccountSet()) {
//    	
//    		Intent intent = new Intent(this, WebAuthActivity.class);
//    		intent.putExtra(WebAuth.EXTRA_NAME, WebAuth.TASK_USERNAME);
//    		//intent = addRecordToIntent(intent, in);
//    		startActivity(intent);
//    		//startActivityForResult(intent, 999);
//    	}
//    }
    
    /* special adapter for displaying list from ArrayList */
    public class RecordAdapter extends ArrayAdapter<Record> {
    	ArrayList<Record> mList;
    	Context mContext;
    	int mPosition;
    	
    	public RecordAdapter(Context context, int resourceID, ArrayList<Record> list) {
            super(context, resourceID, list);
            this.mList = list;
            mContext = context;
    	}
    	
    	
    	@Override
        public View getView(int position, View convertView, ViewGroup parent) {
    		
    		LayoutInflater inflater = (LayoutInflater)mContext.getSystemService (Context.LAYOUT_INFLATER_SERVICE);
    		convertView = inflater.inflate(R.layout.data_players_row, null);
    		Record mRec = mList.get(position);
    		mPosition = position;
    		
    		TextView mName = (TextView) convertView.findViewById(R.id.text_name);
    		TextView mScore = (TextView) convertView.findViewById(R.id.text_score);
    		TextView mLevel = (TextView) convertView.findViewById(R.id.text_level);
    		ImageView mImage = (ImageView) convertView.findViewById(R.id.icon);
    		
    		mName.setText("Name: " + mRec.getName() );//+ " id " + mRec.getRecordIdNum());
    		mScore.setText("Personal Best Score: "+ mRec.getScore());
    		mLevel.setText("Last Checkpoint: Level " + mRec.getLevel());
    		mImage.setImageResource(this.getGuyIcon(position));
    		
    		
    		return convertView;
    	}
    	
    	public int getGuyIcon(int mPosition ) {
    		int mI = R.drawable.guy_icon;
    		switch(mPosition % 9) {
    		case 0:
    			mI = R.drawable.ic_guy_0;
    			break;
    		case 1:
    			mI = R.drawable.ic_guy_1;
    			break;
    		case 2:
    			mI = R.drawable.ic_guy_2;
    			break;
    		case 3:
    			mI = R.drawable.ic_guy_3;
    			break;
    		case 4:
    			mI = R.drawable.ic_guy_4;
    			break;
    		case 5:
    			mI = R.drawable.ic_guy_5;
    			break;
    		case 6:
    			mI = R.drawable.ic_guy_6;
    			break;
    		case 7:
    			mI = R.drawable.ic_guy_7;
    			break;
    		case 8:
    			mI = R.drawable.ic_guy_8;
    			break;
    		}
    		
    		return mI;
    	}
    	
    };
    

   private class SplashScreen extends AsyncTask<Integer, Void, String> {
	   @Override
	   protected void onPreExecute() {
		   showView(Players.VIEW_SPLASH);
		   myFadeInAnimation = AnimationUtils.loadAnimation(Players.this, R.anim.fadein);
		   findViewById(R.id.view_splash).startAnimation(myFadeInAnimation);
	   }
	   
	   @Override
	   protected String doInBackground(Integer ... mSec) {
		   String mReturn = new String("");
		   try {
			   Thread.sleep(3500);
		   }
		   catch (Exception e) {
			   
		   }
		   return mReturn;
	   }
	   
	   @Override
	   protected void onPostExecute(String mResult) {
		   myFadeInAnimation.scaleCurrentDuration(0);
		   showView(Players.VIEW_PLAYERS);
		   onPostSplash();
	   }
   }
}

