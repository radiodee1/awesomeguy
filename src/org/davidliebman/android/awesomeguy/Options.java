package org.davidliebman.android.awesomeguy;

import android.app.Activity;
import android.widget.*;
import android.view.*;
import android.view.View.OnClickListener;
import android.content.SharedPreferences;
import android.os.Bundle;

public class Options extends Activity {
	
	public static final String AWESOME_NAME = new String("awesomename");
	public static final String AWESOME_RANK = new String("awesomerank");
	public static final String AWESOME_CODE = new String("awesomecode");
	public static final String AWESOME_NEWNAME = new String("awesomenewname");
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.options);      
              
        /** sound effects play **/
        final CheckBox checkbox_sounds = (CheckBox) findViewById(R.id.checkbox_sounds );
        checkbox_sounds.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "Sound Selected", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(Options.this, "Sound Not selected", Toast.LENGTH_SHORT).show();
                }
            }
        });
        
        /** JNI usage **/
        final CheckBox checkbox_jni = (CheckBox) findViewById(R.id.checkbox_jni );
        checkbox_jni.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "JNI Selected", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(Options.this, "JNI Not Selected", Toast.LENGTH_SHORT).show();
                }
            }
        });
        
        /** monsters in game **/
        final CheckBox checkbox_monsters = (CheckBox) findViewById(R.id.checkbox_monsters );
        checkbox_monsters.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "Monsters Included", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(Options.this, "Monsters Not Included", Toast.LENGTH_SHORT).show();
                }
            }
        });
        
        /** monster collision **/
        final CheckBox checkbox_collision = (CheckBox) findViewById(R.id.checkbox_collision );
        checkbox_collision.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks, depending on whether it's now checked
                if (((CheckBox) v).isChecked()) {
                    Toast.makeText(Options.this, "Monster Collision Enabled", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(Options.this, "Monster Collision Not Enabled", Toast.LENGTH_SHORT).show();
                }
            }
        });
        /** number of high scores **/
        final OnClickListener radio_players = new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks
                RadioButton rb = (RadioButton) v;
                Toast.makeText(Options.this, rb.getText(), Toast.LENGTH_SHORT).show();
            }
        };
        /** end number **/
        
        /** game speed in fps **/
        final OnClickListener radio_speed = new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks
                RadioButton rb = (RadioButton) v;
                Toast.makeText(Options.this, rb.getText(), Toast.LENGTH_SHORT).show();
            }
        };
        /** end game speed **/
        
        SharedPreferences.Editor mCode = this.getSharedPreferences(Options.AWESOME_CODE, 0).edit();
        
        /* more radio button stuff - number of players */
        final RadioButton radio_players_five = (RadioButton) findViewById(R.id.radio_players_five);
        final RadioButton radio_players_ten = (RadioButton) findViewById(R.id.radio_players_ten);
        final RadioButton radio_players_fifty = (RadioButton) findViewById(R.id.radio_players_fifty);

        radio_players_five.setOnClickListener(radio_players);
        radio_players_ten.setOnClickListener(radio_players);
        radio_players_fifty.setOnClickListener(radio_players);
        /* end radio button stuff */
        
        /* more radio button stuff - game speed*/
        final RadioButton radio_speed_16 = (RadioButton) findViewById(R.id.radio_speed_16);
        final RadioButton radio_speed_20 = (RadioButton) findViewById(R.id.radio_speed_20);
        final RadioButton radio_speed_24 = (RadioButton) findViewById(R.id.radio_speed_24);

        radio_speed_16.setOnClickListener(radio_speed);
        radio_speed_20.setOnClickListener(radio_speed);
        radio_speed_24.setOnClickListener(radio_speed);
        /* end radio button stuff */
    }
}