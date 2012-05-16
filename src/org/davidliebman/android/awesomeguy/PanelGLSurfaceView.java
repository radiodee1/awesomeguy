package org.davidliebman.android.awesomeguy;

import android.content.Context;
import android.opengl.GLSurfaceView;
import android.util.Log;
import android.view.MotionEvent;
import android.opengl.GLES20;

public class PanelGLSurfaceView extends GLSurfaceView {
	Panel mPanel; // this is our renderer!!

    public PanelGLSurfaceView(Context context,  GameValues gameValues, GameStart parent, MovementValues movementValues) {
        super(context);
        mPanel = new Panel(context, gameValues, parent, movementValues);
        //Log.e("PanelGLSurfaceView", "version" + mPanel.mSDKVersion);
        
        if (mPanel.mSDKVersion >= 10 ) {
        	setEGLContextClientVersion(2);
        }
        setRenderer(mPanel);

    }

    public boolean onTouchEvent(final MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            //nativePause();
        }
        return true;
    }

    public Panel getPanel() {
    	return mPanel;
    }

}