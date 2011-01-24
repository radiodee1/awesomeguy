package org.davidliebman.android.awesomeguy;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.Button;

public class Story extends Activity {
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.story);
        
        SharedPreferences preferences = getSharedPreferences(Options.AWESOME_NAME, MODE_PRIVATE);
    	SharedPreferences.Editor edit = preferences.edit();
    	edit.putBoolean(Options.SAVED_TOS, true);
    	edit.commit();
        
		/* button at bottom of view */
	    final Button button = (Button) findViewById(R.id.button_termsofservice);
	    button.setOnClickListener(new OnClickListener() {
	        public void onClick(View v) {
	        	Intent MenuIntent = new Intent(Story.this,Menu.class);
	    		startActivity(MenuIntent);
	        	//Toast.makeText(Players.this, "And We're Off", Toast.LENGTH_SHORT).show();
	        }
	    });
    
	}
}
