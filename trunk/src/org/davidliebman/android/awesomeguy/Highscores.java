package org.davidliebman.android.awesomeguy;

import android.app.ListActivity;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;


public class Highscores   extends Activity { //ListActivity {

	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.highscores);      

        
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
}
