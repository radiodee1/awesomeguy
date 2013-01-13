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
import android.graphics.Color;
import android.os.AsyncTask;
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

//import org.davidliebman.android.androidawesomescores.WebScoreUpload;


import android.telephony.TelephonyManager;
import android.util.Log;

public class Highscores   extends ListActivity {

	public static final String AWESOME_NAME = new String("org.awesomeguy");
    private ArrayList<Scores.High> mNames = new ArrayList<Scores.High>();
    private Scores mScores ;
	private Record mHighScores;
    private Scores.High mRec =  new Scores.High();
    private SharedPreferences mPreferences;
    private HighAdapter mAadapter;
	private WebScoreUpload web ;
	private String mCountry = new String("");
    private WebAuth auth;
	
    public static final int DIALOG_PREFERENCES = 1;
    public static final int DIALOG_WEB_SUCCESS = 2;
    public static final int DIALOG_WEB_FAILURE = 3;
    
    
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.highscores);      

        TelephonyManager mService = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
        mCountry = mService.getNetworkCountryIso();
        
        /* retrieve Record mHighScores */
    	mHighScores = new Record();
        mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        mHighScores.getFromPreferences(mPreferences);
        web = new WebScoreUpload(this);
        auth = new WebAuth(this, null);
        
        mScores = new Scores(this, mHighScores);

        mNames = mScores.getGameHighList(0);
      
        mAadapter = new HighAdapter(this, R.layout.players, mNames);
        mAadapter.setNotifyOnChange(true);
    	
    	setListAdapter(mAadapter);
        ListView lv = getListView();
        lv.setTextFilterEnabled(true);


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
          if (mRec.getInternetKey() == 0) {
        	  menu.add(Menu.NONE, 1, 1 , "Send Score To Online List");
          }
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
    	  if (mRec != null && mRec.getInternetKey() == 0) {
    		  addScoreToOnlineList(mRec);
    		  
    	  }
    	  else if (mRec.getInternetKey() != 0 ) {
    		  showDialog(Highscores.DIALOG_WEB_FAILURE);
    		  
    		  
    		  Toast mPrevious = Toast.makeText(this, 
    				  "You have already sent that record!!", Toast.LENGTH_LONG);
    		  mPrevious.show();
    	  }
    	  break;
      case 2:
    	  //do nothing here.
    	  break;
      }
      
      return true;
    }
    public void addScoreToOnlineList(Scores.High in) {
    	
    	int task = 0;
    	if (auth.isAccountSet()) {
    		task = WebAuth.TASK_SEND_SCORE;
    	}
    	else {
    		task = WebAuth.TASK_NAME_AND_SCORE;
    	}
    	
    	Intent intent = new Intent(this, WebAuthActivity.class);
		intent.putExtra(WebAuth.EXTRA_NAME, task);
		intent = addRecordToIntent(intent, in);
		//startActivity(intent);
    	startActivityForResult(intent, 999);
		

    	
    }
    

    
    
    @Override
    protected void onActivityResult (int requestCode, int resultCode, Intent data) {
    	//Log.e("Highscores", "--- "+ requestCode +" "+ resultCode);

    	ArrayList<Scores.High> temp = mScores.getGameHighList(0);
		this.mNames.clear();
		this.mNames.addAll(temp);
        mAadapter = new HighAdapter(this, R.layout.players, mNames);
		mAadapter.notifyDataSetChanged();
		setListAdapter(mAadapter);
    }
    
    
    public Intent addRecordToIntent(Intent mIntent, Scores.High mIn ) {
		mIntent.putExtra(WebAuth.INTENT_DATE, mIn.getDate());
		mIntent.putExtra(WebAuth.INTENT_COUNTRY, mCountry);
		mIntent.putExtra(WebAuth.INTENT_COLLISION, mIn.isMonsterCollision());
		mIntent.putExtra(WebAuth.INTENT_EMAIL, "");
		mIntent.putExtra(WebAuth.INTENT_LEVEL, mIn.getLevel());
		mIntent.putExtra(WebAuth.INTENT_LIVES, mIn.getLives());
		mIntent.putExtra(WebAuth.INTENT_LOCAL_ID, mIn.getKey());
		mIntent.putExtra(WebAuth.INTENT_MONSTERS, mIn.isEnableMonsters());
		mIntent.putExtra(WebAuth.INTENT_NAME, mIn.getName());
		mIntent.putExtra(WebAuth.INTENT_SCORE, mIn.getHigh());
		mIntent.putExtra(WebAuth.INTENT_SOUND, mIn.isSoundOn());
		mIntent.putExtra(WebAuth.INTENT_SPEED, mIn.getGameSpeed());
		mIntent.putExtra(WebAuth.INTENT_APPNAME, "");
		return mIntent;
	}
	
    /////////////////////////////
    protected Dialog onCreateDialog(int mId) {
    	Dialog  dialog = new Dialog(Highscores.this);
    	AlertDialog.Builder builder;
    	//AlertDialog alertDialog;
    	AlertDialog alert;
    	LayoutInflater mInflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
    	View mLayout;
    	String mAMessage = new String();
    	String mPositive = new String();
    	
    	
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
    		
    		
   	    	mAMessage = new String("Score: " + mRec.getHigh() +"*\n" + 
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

   	    	mPositive = new String("OK"  );
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
   	    	alert = builder.create();
   	    	dialog = (Dialog) alert;
    		
    		break;
    	////////////////////////////////////
    	case Highscores.DIALOG_WEB_FAILURE:
    		builder = new AlertDialog.Builder(Highscores.this);
    		builder.setView(mLayout);
    		
   	    	mAMessage = new String("Connection to the internet failed, or the server is down. Try again later.") ;
   	    	
   	    	((TextView)mLayout.findViewById(R.id.congrats_text)).setText(mAMessage);

   	    	mPositive = new String("OK"  );
   	    	//String mNegative = new String("Stay on this screen." );
   	    	builder.setCancelable(false)
   	    	       .setPositiveButton(mPositive, new DialogInterface.OnClickListener() {
   	    	    	   public void onClick(DialogInterface dialog, int id) {
   	    	    		   //mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
   	    	    		   removeDialog(Highscores.DIALOG_WEB_FAILURE);
   	    	    		   dialog.cancel();
   	    	        	   //removeDialog(Highscores.DIALOG_PREFERENCES);
   	    	           }
   	    	       });
   	    	alert = builder.create();
   	    	dialog = (Dialog) alert;
    		break;
    		
    	case Highscores.DIALOG_WEB_SUCCESS:
    		builder = new AlertDialog.Builder(Highscores.this);
    		builder.setView(mLayout);
    		
   	    	mAMessage = new String("Your score has been submitted to the online database. " +
   	    	"You will not be able to submit any score twice.") ;
   	    	
   	    	
   	    	((TextView)mLayout.findViewById(R.id.congrats_text)).setText(mAMessage);

   	    	mPositive = new String("OK"  );
   	    	//String mNegative = new String("Stay on this screen." );
   	    	builder.setCancelable(false)
   	    	       .setPositiveButton(mPositive, new DialogInterface.OnClickListener() {
   	    	    	   public void onClick(DialogInterface dialog, int id) {
   	    	    		   //mPreferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
   	    	    		   removeDialog(Highscores.DIALOG_WEB_SUCCESS);
   	    	    		   dialog.cancel();
   	    	        	   //removeDialog(Highscores.DIALOG_PREFERENCES);
   	    	           }
   	    	       });
   	    	alert = builder.create();
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
    		
    		if (mRec.getInternetKey() != 0){
    			convertView.setBackgroundColor(Color.DKGRAY);
    		}
    		
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
