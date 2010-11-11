package org.davidliebman.android.awesomeguy;

import java.util.ArrayList;

import android.app.ListActivity;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class Highscores   extends ListActivity {

	public static final String AWESOME_NAME = new String("org.awesomeguy");
    private ArrayList<Scores.High> mNames = new ArrayList<Scores.High>();
    private Scores mScores ;
	private Record mHighScores;
    private Scores.High mRec =  new Scores.High();
    private SharedPreferences mPreferences;
    private HighAdapter mAadapter;
    //private TextView mPlayerText;
    //private TextView mNumPlayers;
    private int mPreferredNumRecords;
	
    
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.highscores);      

        /* retrieve Record mHighScores */
    	mHighScores = new Record();
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(mPreferences);
        this.mPreferredNumRecords = this.mPreferences.getInt(Options.SAVED_NUM_SCORES, Record.RADIO_PLAYERS_FIFTY);

        
        mScores = new Scores(this, mHighScores);

        mNames = mScores.getGameHighList(0);
      
        mAadapter = new HighAdapter(this, R.layout.players, mNames);
        mAadapter.setNotifyOnChange(true);
    	
    	setListAdapter(mAadapter);
        ListView lv = getListView();
        lv.setTextFilterEnabled(true);
        lv.setOnItemClickListener(new OnItemClickListener () {
        	
        	@Override
        	 public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        		
        	 }
        	
        	
        });
        
        /* button at bottom of view */
        final Button button = (Button) findViewById(R.id.button_highscores);
        button.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	Intent StartGameIntent = new Intent(Highscores.this,GameStart.class);
        		startActivity(StartGameIntent);
            	//Toast.makeText(Players.this, "And We're Off", Toast.LENGTH_SHORT).show();
            }
        });
        
	}
	
	/* when the activity is resumed, re-display a new list */
    @Override
    public void onResume() {
    	super.onResume();
    	
    	/* retrieve Record mHighScores */
    	mHighScores = new Record();
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(mPreferences);
        this.mPreferredNumRecords = this.mPreferences.getInt(Options.SAVED_NUM_SCORES, Record.RADIO_PLAYERS_FIFTY);
        
        mScores = new Scores(this, mHighScores);

    	
    	ArrayList<Scores.High> temp = mScores.getGameHighList(0);
        this.mNames.clear();
        this.mNames.addAll(temp);
    	
    	mAadapter.notifyDataSetChanged();
    	
    	int num = mScores.pruneHighList();
    	if (num > 0) {
    		Toast.makeText(Highscores.this, num + "You Have 50 Scores In Your List!!", Toast.LENGTH_LONG).show();
    	}
    }
	
	/* special adapter for displaying list from ArrayList */
    public class HighAdapter extends ArrayAdapter<Scores.High> {
    	ArrayList<Scores.High> mList;
    	Context mContext;
    	int mPosition;
    	
    	public HighAdapter(Context context, int resourceID, ArrayList<Scores.High> list) {
            super(context, resourceID, list);
            this.mList = list;
            mContext = context;
    	}
    	
    	@Override
        public View getView(int position, View convertView, ViewGroup parent) {
    		
    		LayoutInflater inflater = (LayoutInflater)mContext.getSystemService (Context.LAYOUT_INFLATER_SERVICE);
    		convertView = inflater.inflate(R.layout.data_highscores_row, null);
    		Scores.High mRec = mList.get(position);
    		mPosition = position;
    		
    		TextView mName = (TextView) convertView.findViewById(R.id.text_name);
    		TextView mScore = (TextView) convertView.findViewById(R.id.text_score);
    		TextView mDate = (TextView) convertView.findViewById(R.id.text_date);
    		
    		/* Convert milliseconds to readable date */
    		long mMilliseconds = mRec.getDate();
    		DateFormat mFormat = new SimpleDateFormat("dd/MM/yyyy");
    		Calendar mCalendar = Calendar.getInstance();
    		mCalendar.setTimeInMillis(mMilliseconds);
    		String mDateString = new String(mFormat.format(mCalendar.getTime()));
    		
    		/* Insert info in inflated layout */
    		mName.setText("#" + (position + 1 )+ ". " + mRec.getName() );//+ " id " + mRec.getRecordIdNum());
    		mScore.setText("Score: "+ mRec.getHigh());
    		mDate.setText("Date: " + mDateString);
    		
    		
    		
    		return convertView;
    	}
    };
    
}
