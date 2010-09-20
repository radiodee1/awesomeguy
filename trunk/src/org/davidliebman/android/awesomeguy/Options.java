package org.davidliebman.android.awesomeguy;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;

import org.xmlpull.v1.XmlPullParserException;

import android.app.Activity;
import android.util.Log;
import android.widget.*;
import android.view.*;
import android.view.View.OnClickListener;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.widget.AdapterView.OnItemSelectedListener;


public class Options extends Activity {
	
	public static final String AWESOME_NAME = new String("org.awesomeguy");
	public static final String SAVED_NUM_SCORES = new String("saved_num_scores");
	public static final String SAVED_ROOM_NUM = new String("room");
	public static final String SAVED_LOOK_FOR_XML = new String("look_for_xml");
	
	private int mRoomNumSelected = 1;

	private Record mHighScores = new Record() ;
	private Scores mScores ;
	private InitBackground.LevelList mList;
	private ArrayAdapter<CharSequence> adapter;
	/* NOTE: game values instance is bogus!! */
	private InitBackground.ParseXML mParser = new InitBackground.ParseXML(this);
	
	private boolean mLookForXml = false;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        mScores = new Scores(this, mHighScores);
              
        /** retrieve Record mHighScores **/
        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);

        mHighScores.getFromPreferences(preferences);
        if (mHighScores.isNewRecord()) {
        	mHighScores.setNumRecords(preferences.getInt(SAVED_NUM_SCORES, 50));
        }
        mLookForXml = preferences.getBoolean(SAVED_LOOK_FOR_XML, false);
        
        setContentView(R.layout.options);  
        
        /** player name on screen **/
        final TextView textview_name = (TextView) this.findViewById(R.id.player_name_options);
        textview_name.setText("Player Name: " + mHighScores.getName());
        
        /** spinner for picking starting level **/
        mList = new InitBackground.LevelList();
        final Spinner spinner = (Spinner) findViewById(R.id.room_spinner);
        mList = mParser.getLevelList(mLookForXml);
        
        
        adapter = new ArrayAdapter(this, android.R.layout.simple_spinner_item, mList.getStrings().toArray());
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        
        spinner.setAdapter(adapter);
        spinner.setOnItemSelectedListener(
                new OnItemSelectedListener() {
                    public void onItemSelected(
                            AdapterView<?> parent, View view, int position, long id) {
                    	Toast.makeText(Options.this, "Level " +(position + 1) + " selected", Toast.LENGTH_SHORT).show();
                    	mRoomNumSelected = position + 1;
                    }

                    public void onNothingSelected(AdapterView<?> parent) {
                    	Toast.makeText(Options.this, "Default level selected", Toast.LENGTH_SHORT).show();
                    }
                });
        //adapter.notifyDataSetChanged();
        //adapter.setNotifyOnChange(true);
        

        /** sound effects play **/
        final CheckBox checkbox_sounds = (CheckBox) findViewById(R.id.checkbox_sounds );
        checkbox_sounds.setChecked(mHighScores.isSound());
        
        checkbox_sounds.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "Sound Selected", Toast.LENGTH_SHORT).show();
                    mHighScores.setSound(true);
                } else {
                    Toast.makeText(Options.this, "Sound Not selected", Toast.LENGTH_SHORT).show();
                    mHighScores.setSound(false);
                }
            }
        });
        
        /** Search for XML **/
        final CheckBox checkbox_xml = (CheckBox) findViewById(R.id.checkbox_xml );
        checkbox_xml.setChecked(mLookForXml); // hard code 'false'...
        checkbox_xml.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "Searching For XML", Toast.LENGTH_SHORT).show();
                    mLookForXml = true;
                    
                } else {
                    Toast.makeText(Options.this, "Not Searching For XML", Toast.LENGTH_SHORT).show();
                    mLookForXml = false;
                    
                }
                mList = mParser.getLevelList(mLookForXml);
                
                adapter = new ArrayAdapter(Options.this, android.R.layout.simple_spinner_item, mList.getStrings().toArray());
                adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

                spinner.setAdapter(adapter);
                adapter.notifyDataSetChanged();
            }
        });
        
        /** monsters in game **/
        final CheckBox checkbox_monsters = (CheckBox) findViewById(R.id.checkbox_monsters );
        checkbox_monsters.setChecked(mHighScores.isEnableMonsters());
        checkbox_monsters.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "Monsters Included", Toast.LENGTH_SHORT).show();
                    mHighScores.setEnableMonsters(true);
                } else {
                    Toast.makeText(Options.this, "Monsters Not Included", Toast.LENGTH_SHORT).show();
                    mHighScores.setEnableMonsters(false);
                }
            }
        });
        
        /** monster collision **/
        final CheckBox checkbox_collision = (CheckBox) findViewById(R.id.checkbox_collision );
        checkbox_collision.setChecked(mHighScores.isEnableCollision());
        checkbox_collision.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "Monster Collision Enabled", Toast.LENGTH_SHORT).show();
                    mHighScores.setEnableCollision(true);
                } else {
                    Toast.makeText(Options.this, "Monster Collision Not Enabled", Toast.LENGTH_SHORT).show();
                    mHighScores.setEnableCollision(false);
                }
            }
        });
        /** number of high scores **/
        final OnClickListener radio_players = new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks
                RadioButton rb = (RadioButton) v;
                Toast.makeText(Options.this, rb.getText(), Toast.LENGTH_SHORT).show();
                
                if(rb.getId() == R.id.radio_players_ten) mHighScores.setNumRecords(10);
                if(rb.getId() == R.id.radio_players_five) mHighScores.setNumRecords(5);
                if(rb.getId() == R.id.radio_players_fifty) mHighScores.setNumRecords(50);
                SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
                SharedPreferences.Editor out = preferences.edit();
                out.putInt(SAVED_NUM_SCORES, mHighScores.getNumRecords());
                out.commit();
                
            }
        };
        /** end number **/
        
        /** game speed in fps **/
        final OnClickListener radio_speed = new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks
                RadioButton rb = (RadioButton) v;
                Toast.makeText(Options.this, rb.getText(), Toast.LENGTH_SHORT).show();
                
                if(rb.getId() == R.id.radio_speed_16) mHighScores.setGameSpeed(16);
                if(rb.getId() == R.id.radio_speed_20) mHighScores.setGameSpeed(20);
                if(rb.getId() == R.id.radio_speed_24) mHighScores.setGameSpeed(24);
            }
        };
        /** end game speed **/
        
        /* button at bottom of view */
        final Button button = (Button) findViewById(R.id.button_options);
        button.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	Intent StartGameIntent = new Intent(Options.this,GameStart.class);
        		startActivity(StartGameIntent);
            	//Toast.makeText(Players.this, "And We're Off", Toast.LENGTH_SHORT).show();
            }
        });
        
        
        /* more radio button stuff - number of players */
        final RadioButton radio_players_five = (RadioButton) findViewById(R.id.radio_players_five);
        if (mHighScores.getNumRecords() == 5) radio_players_five.setChecked(true);
        final RadioButton radio_players_ten = (RadioButton) findViewById(R.id.radio_players_ten);
        if (mHighScores.getNumRecords() == 10) radio_players_ten.setChecked(true);
        final RadioButton radio_players_fifty = (RadioButton) findViewById(R.id.radio_players_fifty);
        if (mHighScores.getNumRecords() == 50) radio_players_fifty.setChecked(true);
        
        radio_players_five.setOnClickListener(radio_players);
        radio_players_ten.setOnClickListener(radio_players);
        radio_players_fifty.setOnClickListener(radio_players);
        /* end radio button stuff */
        
        /* more radio button stuff - game speed*/
        final RadioButton radio_speed_16 = (RadioButton) findViewById(R.id.radio_speed_16);
        if (mHighScores.getGameSpeed() == 16) radio_speed_16.setChecked(true);
        final RadioButton radio_speed_20 = (RadioButton) findViewById(R.id.radio_speed_20);
        if (mHighScores.getGameSpeed() == 20) radio_speed_20.setChecked(true);
        final RadioButton radio_speed_24 = (RadioButton) findViewById(R.id.radio_speed_24);
        if (mHighScores.getGameSpeed() == 24) radio_speed_24.setChecked(true);
        
        radio_speed_16.setOnClickListener(radio_speed);
        radio_speed_20.setOnClickListener(radio_speed);
        radio_speed_24.setOnClickListener(radio_speed);
        /* end radio button stuff */
    }
    
    
    
    @Override
    public void onPause() {
    	
        //mHighScores.setEnableJNI(true);

        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);
        
        /* save mHighScores so other activities can see it */
    	mHighScores.addToPreferences(preferences);
    	
    	/* save desired starting room num */
    	SharedPreferences.Editor edit = preferences.edit();
        edit.putInt(SAVED_ROOM_NUM, mRoomNumSelected);
        edit.putBoolean(SAVED_LOOK_FOR_XML, mLookForXml);
        edit.commit();
        
        /* save all other options to player's personal record if it's not 'anonymous' */
        if (!mHighScores.isNewRecord()) mScores.updateOptions(mHighScores.getRecordIdNum());
        
	    super.onPause();

    }
   
}