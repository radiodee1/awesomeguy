package org.davidliebman.android.awesomeguy;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URI;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.HTTP;

import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;

public class WebScoreUpload {

	public static final String MY_URL = new String("http://10.0.2.2:8888/game.html");
	
	private String url = MY_URL;
	
	private long key;
	private String message = new String();
	private int serverVersion;
	private int errorCode;
	private String raw = new String();
	
	private String packageName = new String();
	
	public WebScoreUpload(Context context) {
		packageName = context.getPackageName();
	}
	
	public String prepareAndSendRecord(RecordJson rec)  {
		
//		Gson gson = new Gson();
//		String cmd = gson.toJson(rec);
//        String res = null;
        String keyString = null;
        String msg = null;
        try {
        		ReturnJson result = sendRecord(rec);

//                res = sendToJsonClient(cmd);
//                Gson gsonResult = new Gson();
//                ReturnJson result = gsonResult.fromJson(res, ReturnJson.class);
                keyString = new String(new Long(result.getKey()).toString());
                msg = new String(result.getMessage());
                
//                this.key = result.getKey();
//                this.errorCode = result.getError();
//                this.message = result.getMessage();
//                this.serverVersion = result.getVersion();
                
                
                
        } catch (Exception e) {
                e.printStackTrace();
                return new String(raw);
        }
        return keyString + " - "+ msg;
        
	}

	public ReturnJson sendRecord(RecordJson rec) {
		this.clearVars();
		
		rec.setAndroidAppname(packageName);
		
		Gson gson = new Gson();
		String cmd = gson.toJson(rec);
        String res = null;
        //String keyString = null;
        //String msg = null;
        ReturnJson result = null;
        try {
                res = sendToJsonClient(cmd);
                Gson gsonResult = new Gson();
                result = gsonResult.fromJson(res, ReturnJson.class);
                //keyString = new String(new Long(result.getKey()).toString());
                //msg = new String(result.getMessage());
                
                this.raw = res;
                this.key = result.getKey();
                this.errorCode = result.getError();
                this.message = result.getMessage();
                this.serverVersion = result.getVersion();
                
        } catch (Exception e) {
                e.printStackTrace();
                return null;
        }
        return result;
		
	}
	
	public String sendToJsonClient(String cmd) throws Exception{
		String responseString = new String();

		
		//Log.e("org.davidliebman", "command="+cmd);

		
		HttpClient httpclient = new DefaultHttpClient();
		
		HttpPost httppost = new HttpPost();
		httppost.setURI(new URI(url));

		//httppost.setHeader("User-Agent", "");
		httppost.setHeader("Content-type", "application/json");
		StringEntity entity = new StringEntity(cmd,HTTP.UTF_8 );
		
		httppost.setEntity(entity);
		
	    HttpResponse response = httpclient.execute(httppost);//?command="+cmd));
	    StatusLine statusLine = response.getStatusLine();
	    if(statusLine.getStatusCode() == HttpStatus.SC_OK){
	        ByteArrayOutputStream out = new ByteArrayOutputStream();
	        response.getEntity().writeTo(out);
	        out.close();
	        responseString = out.toString();
	        //..more logic
	    } else{
	        //Closes the connection.
	        response.getEntity().getContent().close();
	        throw new IOException(statusLine.getReasonPhrase());
	    }		
	    
	    
	    return responseString;
	}

	public long getKey() {
		return key;
	}

	public void setKey(long key) {
		this.key = key;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public int getServerVersion() {
		return serverVersion;
	}

	public void setServerVersion(int serverVersion) {
		this.serverVersion = serverVersion;
	}

	public int getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
	
	
	
	public String getPackageName() {
		return packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}

	public String getRaw() {
		return raw;
	}

	public void clearVars() {
		this.errorCode = 0;
		this.key = 0;
		this.message = new String();
		this.raw = new String();
	}
	
}
