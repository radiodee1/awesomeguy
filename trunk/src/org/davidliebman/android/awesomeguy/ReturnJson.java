package org.davidliebman.android.awesomeguy;

public class ReturnJson {

	public static final int ERROR_NONE = 1;
	public static final int ERROR_SERVER_STOPPED = 2;
	public static final int ERROR_SUBMISSION_OK = 3;
	public static final int ERROR_SUBMISSION_BAD = 4;
	
	private int version;
	private long key;
	private int error;
	private String message = new String();
	
	public ReturnJson() {
		version = 0;
		key = 1;
		message = "no error";
		error = ERROR_NONE;
	}
	
	public int getVersion() {
		return version;
	}
	public void setVersion(int version) {
		this.version = version;
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

	public int getError() {
		return error;
	}

	public void setError(int error) {
		this.error = error;
	}
	
	
}
