package org.davidliebman.android.awesomeguy;

import android.app.ListActivity;
import android.os.Bundle;
import android.widget.*;
import android.content.*;

import java.util.ArrayList;
import android.view.*;

public class Players extends ListActivity {
		
    public static final String AWESOME_NAME = new String("org.awesomeguy");
    private ArrayList<Record> mNames = new ArrayList<Record>();
    private Scores mScores ;
	private Record mHighScores;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        /* retrieve Record mHighScores */
    	mHighScores = new Record();
        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(preferences);
        
        /* create bogus record */
        Record mRec = new Record();
        mRec.setName("dave");
        mRec.setScore(110);
        mRec.setLevel(3);
        mNames.add(mRec);
        
        mNames.add(mHighScores);
        
        mScores = new Scores(this, mHighScores);
        mNames = mScores.getHighScoreList(3);
        
        RecordAdapter mAadapter = new RecordAdapter(this, R.layout.players, mNames);
        
        setContentView(R.layout.players);      
        setListAdapter(mAadapter);
        getListView().setTextFilterEnabled(true);
    
        
    }
    
    public class RecordAdapter extends ArrayAdapter<Record> {
    	ArrayList<Record> mList;
    	Context mContext;
    	
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
    		
    		TextView mName = (TextView) convertView.findViewById(R.id.text_name);
    		TextView mScore = (TextView) convertView.findViewById(R.id.text_score);
    		TextView mLevel = (TextView) convertView.findViewById(R.id.text_level);
    		
    		mName.setText("Name: " + mRec.getName());
    		mScore.setText("Score: "+ mRec.getScore());
    		mLevel.setText("Level: " + mRec.getLevel());
    		
    		return convertView;
    	}
    };
    
   

}

