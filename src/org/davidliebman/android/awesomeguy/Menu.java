package org.davidliebman.android.awesomeguy;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class Menu extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.menu);
        
        Button StartGameButton = (Button)findViewById(R.id.GameStart );
        StartGameButton.setOnClickListener(new OnClickListener() {
        	
        	public void onClick(View v) {
        		Intent StartGameIntent = new Intent(Menu.this,GameStart.class);
        		startActivity(StartGameIntent);
        	}
        });
        
        Button HelpButton = (Button)findViewById(R.id.Help);
        HelpButton.setOnClickListener(new OnClickListener() {
        	
        	public void onClick(View v) {
        		Intent HelpIntent = new Intent(Menu.this,Help.class);
        		startActivity(HelpIntent);
        	}
        });
        
        Button OptionsButton = (Button)findViewById(R.id.Options);
        OptionsButton.setOnClickListener(new OnClickListener() {
        	
        	public void onClick(View v) {
        		Intent OptionsIntent = new Intent(Menu.this,Options.class);
        		startActivity(OptionsIntent);
        	}
        });
        
        Button CreditsButton = (Button)findViewById(R.id.Credits);
        CreditsButton.setOnClickListener(new OnClickListener() {
        	
        	public void onClick(View v) {
        		Intent CreditsIntent= new Intent(Menu.this,Credits.class);
        		startActivity(CreditsIntent);
        	}
        });
        
        Button PlayersButton = (Button)findViewById(R.id.Players);
        PlayersButton.setOnClickListener(new OnClickListener() {
        	
        	public void onClick(View v) {
        		Intent PlayersIntent= new Intent(Menu.this,Players.class);
        		startActivity(PlayersIntent);
        	}
        });
        
        Button HighscoresButton = (Button)findViewById(R.id.Highscores);
        HighscoresButton.setOnClickListener(new OnClickListener() {
        	
        	public void onClick(View v) {
        		Intent HighscoresIntent= new Intent(Menu.this,Highscores.class);
        		startActivity(HighscoresIntent);
        	}
        });
    }
}