package org.davidliebman.android.awesomeguy;

import android.app.Activity;
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
              
        SharedPreferences.Editor mCode = this.getSharedPreferences(Options.AWESOME_CODE, 0).edit();
        
    }
}