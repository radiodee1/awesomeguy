package org.davidliebman.android.awesomeguy;

import android.app.ListActivity;
import android.os.Bundle;


public class Highscores extends ListActivity {

	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.highscores);      

	}
}
