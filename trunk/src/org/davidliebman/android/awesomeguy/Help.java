package org.davidliebman.android.awesomeguy;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class Help extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.help);      
         
        /* button at bottom of view */
	    final Button button = (Button) findViewById(R.id.button_help);
	    button.setOnClickListener(new OnClickListener() {
	        public void onClick(View v) {
	        	Intent MenuIntent = new Intent(Help.this,Menu.class);
	    		startActivity(MenuIntent);
	        	//Toast.makeText(Players.this, "And We're Off", Toast.LENGTH_SHORT).show();
	        }
	    });
    }
}