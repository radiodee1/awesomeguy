package org.davidliebman.android.awesomeguy;

import android.app.Activity;
import android.util.Log;
import android.widget.*;
import android.view.*;
import android.view.View.OnClickListener;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;

public class Options extends Activity {
	
	public static final String AWESOME_NAME = new String("org.awesomeguy");
	public static final String SAVED_NUM_SCORES = new String("saved_num_scores");

	
	private Record mHighScores = new Record() ;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
            
              
        /** retrieve Record mHighScores **/
        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);

        mHighScores.getFromPreferences(preferences);
        if (mHighScores.isNewRecord()) {
        	mHighScores.setNumRecords(preferences.getInt(SAVED_NUM_SCORES, 50));
        }
        //mHighScores.listInLog();
        
        setContentView(R.layout.options);  
        
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
        
        /** JNI usage **/
        final CheckBox checkbox_jni = (CheckBox) findViewById(R.id.checkbox_jni );
        checkbox_jni.setChecked(mHighScores.isEnableJNI());
        checkbox_jni.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "JNI Selected", Toast.LENGTH_SHORT).show();
                    mHighScores.setEnableJNI(true);
                } else {
                    Toast.makeText(Options.this, "JNI Not Selected", Toast.LENGTH_SHORT).show();
                    mHighScores.setEnableJNI(false);
                }
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
        SharedPreferences preferences = getSharedPreferences(AWESOME_NAME, MODE_PRIVATE);

    	mHighScores.addToPreferences(preferences);
	    super.onPause();

    }
}