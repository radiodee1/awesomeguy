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
        
        /** number of high scores **/
        final OnClickListener radio_listener = new OnClickListener() {
            public void onClick(View v) {
                // Perform action on clicks
                RadioButton rb = (RadioButton) v;
                Toast.makeText(Options.this, rb.getText(), Toast.LENGTH_SHORT).show();
            }
        };
        
        
        
        SharedPreferences.Editor mCode = this.getSharedPreferences(Options.AWESOME_CODE, 0).edit();
        
        /* more radio button stuff */
        final RadioButton radio_players_five = (RadioButton) findViewById(R.id.radio_players_five);
        final RadioButton radio_players_ten = (RadioButton) findViewById(R.id.radio_players_ten);
        final RadioButton radio_players_fifty = (RadioButton) findViewById(R.id.radio_players_fifty);

        radio_players_five.setOnClickListener(radio_listener);
        radio_players_ten.setOnClickListener(radio_listener);
        radio_players_fifty.setOnClickListener(radio_listener);
        /* end radio button stuff */
        //
    }
}