package org.davidliebman.android.awesomeguy;

import java.util.ArrayList;
import java.util.Date;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ListActivity;
//import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;


import android.util.Log;

public class Highscores   extends ListActivity {

	public static final String AWESOME_NAME = new String("org.awesomeguy");
    private ArrayList<Scores.High> mNames = new ArrayList<Scores.High>();
    private Scores mScores ;
	private Record mHighScores;
    private Scores.High mRec =  new Scores.High();
    private SharedPreferences mPreferences;
    private HighAdapter mAadapter;
    
    public static final int DIALOG_PREFERENCES = 1;
    
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.highscores);      

        /* retrieve Record mHighScores */
    	mHighScores = new Record();
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(mPreferences);

        
        mScores = new Scores(this, mHighScores);

        mNames = mScores.getGameHighList(0);
      
        mAadapter = new HighAdapter(this, R.layout.players, mNames);
        mAadapter.setNotifyOnChange(true);
    	
    	setListAdapter(mAadapter);
        ListView lv = getListView();
        lv.setTextFilterEnabled(true);
//        lv.setOnItemClickListener(new OnItemClickListener () {
//        	
//        	@Override
//        	 public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
//        		// fire dialog here....
//        		mRec = mNames.get(position);
//        		showDialog(Highscores.DIALOG_PREFERENCES);
//        	 }
//        	
//        	
//        });
        registerForContextMenu(lv);
        /* button at bottom of view */
        final Button button = (Button) findViewById(R.id.button_highscores);
        button.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
            	mHighScores.addToPreferences(mPreferences);

            	Intent StartGameIntent = new Intent(Highscores.this,Players.class);
        		startActivity(StartGameIntent);
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
        
        try {
    		mScores.closeAll();
    	}
    	catch (NullPointerException e) {
    		//
    	}
        
        mScores = new Scores(this, mHighScores);

    	
    	ArrayList<Scores.High> temp = mScores.getGameHighList(0);
        this.mNames.clear();
        this.mNames.addAll(temp);
    	
    	mAadapter.notifyDataSetChanged();
    	
    	int num = mScores.pruneHighList();
    	if (num > 0) {
    		Toast.makeText(Highscores.this, "You have more than 51 scores in your list!! Some will be dropped!", Toast.LENGTH_LONG).show();
    		temp = mScores.getGameHighList(0);
    		this.mNames.clear();
    		this.mNames.addAll(temp);
            mAadapter = new HighAdapter(this, R.layout.players, mNames);
    		mAadapter.notifyDataSetChanged();
    		
    	}
    }
	
    @Override
    public void onPause() {

    	try {
    		mScores.closeAll();
    	}
    	catch (NullPointerException e) {
    		Log.e("Awesomeguy", "Null Pointer Highscores");
    	}
    	super.onPause();
    }
    
    
    @Override
    public void onCreateContextMenu(ContextMenu menu, View v,
        ContextMenuInfo menuInfo) {
    	//if (v.getId() == R.id.)
          AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo)menuInfo;

          mRec = mNames.get(info.position);
          menu.setHeaderTitle(mNames.get(info.position).getName() + " - " + mNames.get(info.position).getHigh());
          
          menu.add(Menu.NONE, 0, 0 , "Show Extra Info");
          menu.add(Menu.NONE, 1, 1 , "Send Score To Online List");
          menu.add(Menu.NONE, 2, 2 , "Exit Menu");
    }
    
    @Override
    public boolean onContextItemSelected(MenuItem item) {
      AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo)item.getMenuInfo();
      int menuItemIndex = item.getItemId();
      
      switch (menuItemIndex) {
      case 0:
    	  if ( mRec != null) {
    		  showDialog(Highscores.DIALOG_PREFERENCES);
    	  }
    	  break;
      case 1:
    	  if (mRec != null ) {
    		  addScoreToOnlineList(mRec);
    	  }
    	  break;
      case 2:
    	  //do nothing here.
    	  break;
      }
      
      return true;
    }
    public void addScoreToOnlineList(Scores.High in) {
    	RecordJson rec = new RecordJson();
    	rec.setCountry("");
    	rec.setDate(new Date(in.getDate()));
    	rec.setEmail("");
    	rec.setEnableCollision(in.isMonsterCollision());
    	rec.setEnableMonsters(in.isEnableMonsters());
    	rec.setGameSpeed(in.getGameSpeed());
    	rec.setLevel(in.getLevel());
    	rec.setLives(in.getLives());
    	rec.setName(in.getName());
    	
    }
    
    /////////////////////////////
    protected Dialog onCreateDialog(int mId) {
    	Dialog  dialog = new Dialog(Highscores.this);
    	AlertDialog.Builder builder;
    	AlertDialog alertDialog;
    	LayoutInflater mInflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
    	View mLayout;
    	
    	mLayout = mInflater.inflate(R.layout.congrats, 
    			(ViewGroup) findViewById(R.id.layout_root));
    	mLayout.findViewById(R.id.image).setBackgroundResource(R.drawable.guy_icon);
    	
    	switch (mId) {
    	/////////////////////////////////////
    	

    	////////////////////////////////////
    	case Highscores.DIALOG_PREFERENCES:
    		
    		builder = new AlertDialog.Builder(Highscores.this);
    		builder.setView(mLayout);
    		
    		String mPart = new Integer(mRec.getGameSpeed()).toString();
    		if (mRec.getGameSpeed() >= Record.SPEED_SYSTEM) mPart = "System Defined";
    		
    		
   	    	String mAMessage = new String("Score: " + mRec.getHigh() +"*\n" + 
   	    			"This player uses the handle \'" + mRec.getName() +
   	    			"\'. They got this score with these special settings:" +
   	    			"\nGame Speed: " +
   	    			mPart +
   	    			"\nGame Sound: " +
   	    			new Boolean(mRec.isSoundOn()).toString() +
   	    			"\nEnable Monsters: " +
   	    			new Boolean(mRec.isEnableMonsters()).toString()) ;
   	    	if(mRec.isEnableMonsters()) {
   	    			mAMessage = mAMessage + "\nMonster Collision: " +
   	    			new Boolean(mRec.isMonsterCollision()).toString();
   	    	}
   	    	mAMessage = mAMessage + "\nAlso: " +
   	    			"\nLives: " + mRec.getLives() ;
   	    	((TextView)mLayout.findViewById(R.id.congrats_text)).setText(mAMessage);

   	    	String mPositive = new String("OK"  );
   	    	//String mNegative = new String("Stay on this screen." );
   	    	builder.setCancelable(false)
   	    	       .setPositiveButton(mPositive, new DialogInterface.OnClickListener() {
   	    	    	   public void onClick(DialogInterface dialog, int id) {
   	    	    		   mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
   	    	    		   removeDialog(Highscores.DIALOG_PREFERENCES);
   	    	    		   dialog.cancel();
   	    	        	   //removeDialog(Highscores.DIALOG_PREFERENCES);
   	    	           }
   	    	       });
   	    	AlertDialog alert = builder.create();
   	    	dialog = (Dialog) alert;
    		
    		break;
    	
    	////////////////////////////////////
    		default:
    			dialog = null;
    	}
    	
    	return dialog;
    }
    /////////////////////////////
    
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
    		ImageView mImage = (ImageView) convertView.findViewById(R.id.icon);
    		
    		/* Convert milliseconds to readable date */
    		long mMilliseconds = mRec.getDate();
    		DateFormat mFormat = new SimpleDateFormat("MM/dd/yyyy");
    		Calendar mCalendar = Calendar.getInstance();
    		mCalendar.setTimeInMillis(mMilliseconds);
    		String mDateString = new String(mFormat.format(mCalendar.getTime()));
    		
    		/* Insert info in inflated layout */
    		mName.setText("#" + (position + 1 )+ ". " + mRec.getName() );//+ " id " + mRec.getRecordIdNum());
    		mScore.setText("Score: "+ mRec.getHigh());
    		mDate.setText("Date: " + mDateString);
    		mImage.setImageResource(this.getGatorIcon(position));
    		
    		
    		return convertView;
    	}
    	public int getGatorIcon(int mPosition ) {
    		int mI = R.drawable.guy_icon;
    		switch(mPosition % 8) {
    		case 0:
    			mI = R.drawable.ic_gator_0;
    			break;
    		case 1:
    			mI = R.drawable.ic_gator_1;
    			break;
    		case 2:
    			mI = R.drawable.ic_gator_2;
    			break;
    		case 3:
    			mI = R.drawable.ic_gator_3;
    			break;
    		case 4:
    			mI = R.drawable.ic_gator_4;
    			break;
    		case 5:
    			mI = R.drawable.ic_gator_5;
    			break;
    		case 6:
    			mI = R.drawable.ic_gator_6;
    			break;
    		case 7:
    			mI = R.drawable.ic_gator_7;
    			break;
    		
    		}
    		
    		return mI;
    	}
    	
    };
    
}
