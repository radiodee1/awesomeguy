package org.davidliebman.android.awesomeguy;

import android.app.Dialog;
import android.app.ListActivity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.widget.*;
import android.content.*;
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
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.app.AlertDialog;
//import android.util.Log;

public class Players extends ListActivity {
		
    public static final String AWESOME_NAME = new String("org.awesomeguy");
    private ArrayList<Record> mNames = new ArrayList<Record>();
    private Scores mScores ;
	private Record mHighScores;
    private Record mRec = new Record();
    private SharedPreferences mPreferences;
    private RecordAdapter mAadapter;
    private TextView mPlayerText;
    private TextView mNumPlayers;
    private int mPreferredNumRecords;
    
    public static final int VIEW_SPLASH = 0;
    public static final int VIEW_PLAYERS = 1;
    public static final int VIEW_TEXT = 2;
    public static final int VIEW_SCORES = 3;
    
    public static final int TEXT_HELP = 0;
    public static final int TEXT_STORY = 1;
    public static final int TEXT_LEGAL = 2;
    
    public static final int DIALOG_USERNUM_CHANGED = 0;
    public static final int DIALOG_UNUSED = 1;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        /* retrieve Record mHighScores */
    	mHighScores = new Record();
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(mPreferences);
        this.mPreferredNumRecords = this.mPreferences.getInt(Options.SAVED_NUM_SCORES, Record.RADIO_PLAYERS_FIFTY);
        
        
        mScores = new Scores(this, mHighScores);
        mNames = mScores.getHighScorePlayerList(mHighScores.getNumRecords());

        
        mAadapter = new RecordAdapter(this, R.layout.players, mNames);
        mAadapter.setNotifyOnChange(true);
        
        setContentView(R.layout.players);      
        setListAdapter(mAadapter);
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
                
                /* save num of high scores */
                SharedPreferences.Editor mSave = mPreferences.edit();
                mSave.putInt(Options.SAVED_NUM_SCORES, mHighScores.getNumRecords());
                mSave.commit();
                mNumPlayers.setText("This is where you enter a new player name, or choose from a list of " + mHighScores.getNumRecords() + " players.");
                
                /* save num of high scores for player */
                //TODO: TEST ME!!
                mScores.updateNumOfRecords(mHighScores.getNumRecords());
                
                /* adjust number of high scores shown */
                mScores.pruneScoresList();
        	 }
        	
        	
        });
        
        /* long click code */
        lv.setLongClickable(true);
        lv.setOnItemLongClickListener(new OnItemLongClickListener () {
        	
        	public boolean onItemLongClick (AdapterView<?> parent, View view, int position, long id) {
        		Toast.makeText(Players.this, "Player - Num Records: " + mNames.get(position).getNumRecords() + 
        				" Record ID: " + mNames.get(position).getRecordIdNum(), Toast.LENGTH_LONG).show();

        		return true;
        	}
        });
        
        
        /* edit text field*/
        final EditText edittext = (EditText) findViewById(R.id.edittext_name);
        
        edittext.setOnKeyListener(new OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                // If the event is a key-down event on the "enter" button
                if ((event.getAction() == KeyEvent.ACTION_DOWN) &&
                    (keyCode == KeyEvent.KEYCODE_ENTER)) {
                  // Perform action on key press
                  mRec = new Record();
                  mRec.setName(edittext.getText().toString().trim());
                  mRec.setNumRecords(mHighScores.getNumRecords());
                  if ( isNameTaken(mNames, mRec.getName())) {
                      Toast.makeText(Players.this, "This name is already taken: " + edittext.getText(), Toast.LENGTH_LONG).show();

                  }
                  else {
                      Toast.makeText(Players.this, "Player Selected: " + edittext.getText(), Toast.LENGTH_SHORT).show();
                	  mHighScores = mRec;
                	  mHighScores.setNewRecord(true);
                	  
                	  mHighScores.addToPreferences(mPreferences);
                	  mPlayerText.setText("Player Chosen: " +mHighScores.getName());
                      mNumPlayers.setText("This is where you choose from a list of " + mHighScores.getNumRecords() + " players.");
                      SharedPreferences.Editor edit = mPreferences.edit();
                      edit.putInt(Options.SAVED_ROOM_NUM, mHighScores.getLevel());
                      edit.commit();
                  }
                  return true;
                }
                return false;
                //return true;
            }
            
            
        });
        
        /* button at bottom of view */
        final Button button = (Button) findViewById(R.id.button_players);
        button.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
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
//            	Intent StartGameIntent = new Intent(Players.this,GameStart.class);
//        		startActivity(StartGameIntent);
            	//Toast.makeText(Players.this, "And We're Off", Toast.LENGTH_SHORT).show();
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
        mHighScores.getFromPreferences(mPreferences);
        this.mPreferredNumRecords = this.mPreferences.getInt(Options.SAVED_NUM_SCORES, Record.RADIO_PLAYERS_FIFTY);
        
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
    	
    	mAadapter.notifyDataSetChanged();
    	
    	
    	SplashScreen mSplash = new SplashScreen();
    	mSplash.execute(new Integer[] {0});
    	
    }
    
    public void onPostSplash() {
    	
    	int num = mScores.pruneScoresList();
    	if (num > 0) {
    		Toast.makeText(Players.this, num + " scores were removed from High Score List!!", Toast.LENGTH_LONG).show();
    	}
    	
    }
    
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
    	MenuInflater inflate = getMenuInflater();
    	inflate.inflate(R.menu.main_menu, menu);
    	
    	return true;
    	
    }
    
    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
    	return true;
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
        	Intent HighScoreIntent = new Intent(Players.this,Highscores.class);
    		startActivity(HighScoreIntent);
    		break;
    	case R.id.menu_story_item:
    		displayText(Players.TEXT_STORY);
    		break;
    	case R.id.menu_options_item:
    		break;
    	}
    	return true;
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
    	
    	switch (mId) {
    	/////////////////////////////////////
    	case Players.DIALOG_USERNUM_CHANGED:
 		   this.mPreferredNumRecords = mHighScores.getNumRecords();

 		   if ( mPreferredNumRecords != mRec.getNumRecords() ) {
	   	    	builder = new AlertDialog.Builder(Players.this);
	   	    	String mAMessage = new String("Your old preference for 'Number of Player Records' is " + mHighScores.getNumRecords());
	   	    	String mPositive = new String("Choose " + mHighScores.getNumRecords() + " records.");
	   	    	String mNegative = new String("Choose " + mRec.getNumRecords() + " records.");
	   	    	builder.setMessage(mAMessage)
	   	    	       .setCancelable(false)
	   	    	       .setPositiveButton(mPositive, new DialogInterface.OnClickListener() {
	   	    	           public void onClick(DialogInterface dialog, int id) {
	   	    	                //Players.this.finish();
	   	    	        	   mRec.setNumRecords(mHighScores.getNumRecords());
	   	    	        	   dialog.cancel();
	   	    	        	   
	   	    	           }
	   	    	       })
	   	    	       .setNegativeButton(mNegative, new DialogInterface.OnClickListener() {
	   	    	           public void onClick(DialogInterface dialog, int id) {
	   	    	        	   	
	   	    	                dialog.cancel();
	   	    	           }
	   	    	       });
	   	    	AlertDialog alert = builder.create();
	   	    	dialog = (Dialog) alert;
	       	}
    		
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
    	// show selected view
    	switch (mViewToShow) {
    	case Players.VIEW_SPLASH:
    		this.findViewById(R.id.view_splash).setEnabled(true);
    		this.findViewById(R.id.view_splash).setVisibility(View.VISIBLE);
    		break;
    	case Players.VIEW_PLAYERS:
    		this.findViewById(R.id.view_players).setEnabled(true);
    		this.findViewById(R.id.view_players).setVisibility(View.VISIBLE);
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
    		
    		mName.setText("Name: " + mRec.getName() );//+ " id " + mRec.getRecordIdNum());
    		mScore.setText("Personal Best Score: "+ mRec.getScore());
    		mLevel.setText("Last Checkpoint: Level " + mRec.getLevel());
    		
    		
    		
    		return convertView;
    	}
    };
    
    
    
   /* Inner class for making alert message about number of high scores */
//   public static class AlertNumRecords {
//	   
//	   Record mRec = new Record();
//	   Record mHighScores = new Record();
//	   int mPreferredNumRecords;
//	   Context mParent;
//	   
//	   public AlertNumRecords(Context parent, Record mHighScores, Record mRec) {
//		   this.mHighScores = mHighScores;
//		   this.mRec = mRec;
//		   this.mPreferredNumRecords = mHighScores.getNumRecords();
//		   mParent = parent;
//	   }
//	   
//	   public int alertUser() {
//	       	if ( mPreferredNumRecords != mRec.getNumRecords() ) {
//	   	    	AlertDialog.Builder builder = new AlertDialog.Builder(mParent);
//	   	    	String mAMessage = new String("Your old preference for 'Number of Player Records' is " + mHighScores.getNumRecords());
//	   	    	String mPositive = new String("Choose " + mHighScores.getNumRecords() + " records.");
//	   	    	String mNegative = new String("Choose " + mRec.getNumRecords() + " records.");
//	   	    	builder.setMessage(mAMessage)
//	   	    	       .setCancelable(false)
//	   	    	       .setPositiveButton(mPositive, new DialogInterface.OnClickListener() {
//	   	    	           public void onClick(DialogInterface dialog, int id) {
//	   	    	                //Players.this.finish();
//	   	    	        	   mRec.setNumRecords(mHighScores.getNumRecords());
//	   	    	        	   dialog.cancel();
//	   	    	        	   
//	   	    	           }
//	   	    	       })
//	   	    	       .setNegativeButton(mNegative, new DialogInterface.OnClickListener() {
//	   	    	           public void onClick(DialogInterface dialog, int id) {
//	   	    	        	   	
//	   	    	                dialog.cancel();
//	   	    	           }
//	   	    	       });
//	   	    	AlertDialog alert = builder.create();
//	   	    	alert.show();
//	       	}
//       /* regardless which the user chooses, copy mRec */
//       mHighScores = mRec;
//       return mHighScores.getNumRecords() ;
//       }
//   }

   private class SplashScreen extends AsyncTask<Integer, Void, String> {
	   @Override
	   protected void onPreExecute() {
		   showView(Players.VIEW_SPLASH);
		   Animation myFadeInAnimation = AnimationUtils.loadAnimation(Players.this, R.anim.fadein);
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
		   showView(Players.VIEW_PLAYERS);
		   onPostSplash();
	   }
   }
}

