package org.davidliebman.android.awesomeguy;

import android.app.ListActivity;
import android.os.Bundle;
import android.widget.*;
import android.content.*;
import android.view.View.OnKeyListener;
import java.util.ArrayList;
import android.view.*;
import android.view.View.OnClickListener;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.app.AlertDialog;
import android.util.Log;

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
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        /* retrieve Record mHighScores */
    	mHighScores = new Record();
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(mPreferences);
        this.mPreferredNumRecords = this.mPreferences.getInt(Options.SAVED_NUM_SCORES, 50);
        
        
        mScores = new Scores(this, mHighScores);
        mNames = mScores.getHighScoreList(mHighScores.getNumRecords());

        
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

        		AlertNumRecords mAlert = new AlertNumRecords(Players.this,mHighScores,mRec);
        		mRec.setNumRecords(mAlert.alertUser());
        		mHighScores = mRec;

        		Toast.makeText(Players.this, "Player Selected: " + mHighScores.getName(), Toast.LENGTH_SHORT).show();
        		SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
            	mHighScores.setNewRecord(false);
        		mHighScores.addToPreferences(preferences);
                mPlayerText.setText("Player Chosen: " +mHighScores.getName());
                
                /* save num of high scores */
                SharedPreferences.Editor mSave = mPreferences.edit();
                mSave.putInt(Options.SAVED_NUM_SCORES, mHighScores.getRecordIdNum());
                mSave.commit();
                mNumPlayers.setText("This is where you choose from a list of " + mHighScores.getNumRecords() + " high scores.");


        	 }
        	
        	
        });
        
        /* long click code */
        lv.setLongClickable(true);
        lv.setOnItemLongClickListener(new OnItemLongClickListener () {
        	
        	public boolean onItemLongClick (AdapterView<?> parent, View view, int position, long id) {
        		Toast.makeText(Players.this, "Player Num Records: " + mHighScores.getNumRecords(), Toast.LENGTH_SHORT).show();

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
                      Toast.makeText(Players.this, "This name is already taken: " + edittext.getText(), Toast.LENGTH_SHORT).show();

                  }
                  else {
                      Toast.makeText(Players.this, "Player Selected: " + edittext.getText(), Toast.LENGTH_SHORT).show();
                	  mHighScores = mRec;
                      //this.alertNumRecords();
                	  mHighScores.addToPreferences(mPreferences);
                	  mPlayerText.setText("Player Chosen: " +mHighScores.getName());
                      mNumPlayers.setText("This is where you choose from a list of " + mHighScores.getNumRecords() + " high scores.");
                      SharedPreferences.Editor edit = mPreferences.edit();
                      edit.putInt(Options.SAVED_ROOM_NUM, mHighScores.getLevel());
                      edit.commit();
                  }
                  return true;
                }
                return false;
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
        
        mNumPlayers = (TextView) findViewById(R.id.text_num_message);
        mNumPlayers.setText("This is where you choose from a list of " + mHighScores.getNumRecords() + " high scores.");
        
        mPlayerText = (TextView) findViewById(R.id.text_player_name);
        mPlayerText.setText("Player Chosen: " +mHighScores.getName());
        
        mScores.pruneScoresList();
        
    }
    
    /* when the activity is resumed, re-display a new list */
    @Override
    public void onResume() {
    	super.onResume();
    	ArrayList<Record> temp = mScores.getHighScoreList(mHighScores.getNumRecords());
        this.mNames.clear();
        this.mNames.addAll(temp);
    	
    	mAadapter.notifyDataSetChanged();
    	
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
    		convertView = inflater.inflate(R.layout.data_row, null);
    		Record mRec = mList.get(position);
    		mPosition = position;
    		
    		TextView mName = (TextView) convertView.findViewById(R.id.text_name);
    		TextView mScore = (TextView) convertView.findViewById(R.id.text_score);
    		TextView mLevel = (TextView) convertView.findViewById(R.id.text_level);
    		
    		mName.setText("Name: " + mRec.getName());
    		mScore.setText("Score: "+ mRec.getScore());
    		mLevel.setText("Level: " + mRec.getLevel());
    		
    		
    		
    		return convertView;
    	}
    };
    
   /* Inner class for making alert message about number of high scores */
   public static class AlertNumRecords {
	   
	   Record mRec = new Record();
	   Record mHighScores = new Record();
	   int mPreferredNumRecords;
	   Context mParent;
	   
	   public AlertNumRecords(Context parent, Record mHighScores, Record mRec) {
		   this.mHighScores = mHighScores;
		   this.mRec = mRec;
		   this.mPreferredNumRecords = mHighScores.getNumRecords();
		   mParent = parent;
	   }
	   
	   public int alertUser() {
	       	if ( mPreferredNumRecords != mRec.getNumRecords() ) {
	   	    	AlertDialog.Builder builder = new AlertDialog.Builder(mParent);
	   	    	String mAMessage = new String("Your old preference for 'Number of High Score Records' is " + mHighScores.getNumRecords());
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
	   	    	alert.show();
	       	}
       /* regardless which the user chooses, copy mRec */
       mHighScores = mRec;
       return mHighScores.getNumRecords() ;
       }
   }

}

