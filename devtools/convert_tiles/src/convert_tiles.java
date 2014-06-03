//package ;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
//import ;

public class convert_tiles{
	
	public static String OPTION_VISIBLE = "visible";
	public static String OPTION_INVISIBLE = "invisible";
	
	//final static String FILE_NAME = "C:\\Temp\\input.txt";
	final static String OUTPUT_FILE_NAME = ".output.txt";
	final static Charset ENCODING = StandardCharsets.UTF_8;
	
	public String myOutputPath = "./";
	public String myFileName = "";
	public ArrayList<String> myInputList = new ArrayList<String>();
	public ArrayList<String> myOutputList = new ArrayList<String>();
	
	public ArrayList<String> myReplaceListVisible = new ArrayList<String>();
	public ArrayList<String> myReplaceListInvisible = new ArrayList<String>();
	
	public static void main(String[] args)  throws IOException {
		if (args.length < 2) System.exit(0);
		System.out.println(args[0]+" -- "+ args[1]);
		convert_tiles ct = new convert_tiles();
		
		ct.myFileName = args[1];
		
		if (args[0].equalsIgnoreCase(OPTION_VISIBLE)) {
			ct.convert_visible(ct.myFileName);
		}
		else if (args[0].equalsIgnoreCase(OPTION_INVISIBLE)) {
			ct.convert_invisible(ct.myFileName);
		}
	}
	
	public convert_tiles() {
	
	}
	
	public void convert_visible(String input){
		this.myInputList = this.inputAsList(input);
		System.out.println("visible "+input);
		this.processList(this.myReplaceListVisible);
		this.outputFromList("visible");
	}
	
	public void convert_invisible(String input) {
		this.myInputList = this.inputAsList(input);
		System.out.println("invisible "+ input);
		this.processList(this.myReplaceListInvisible);
		this.outputFromList("invisible");
	}
	
	public ArrayList<String> inputAsList(String in){
		ArrayList<String> myList = new ArrayList<String>();
		
		try {
			myList = (ArrayList<String>) this.readSmallTextFile(in);
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		
		return myList;
	}
	
	List<String> readSmallTextFile(String aFileName) throws IOException {
	    Path path = Paths.get(aFileName);
	    return Files.readAllLines(path, ENCODING);
	}
	  
	public void outputFromList(String label) {
		this.myFileName = this.processName(this.myFileName);

		try {
			this.writeSmallTextFile(this.myOutputList, this.myOutputPath + this.myFileName + "."+label + OUTPUT_FILE_NAME);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	void writeSmallTextFile(List<String> aLines, String aFileName) throws IOException {
	    Path path = Paths.get(aFileName);
	    Files.write(path, aLines, ENCODING);
	}
	
	public String processName(String in) {
		if (in.endsWith(".TXT") || in.endsWith(".txt")) {
			int x = in.lastIndexOf(".");
			in = in.substring(0, x);
		}
		return in;
	}
	
	public void processList(ArrayList<String> replaceList) {
		this.myOutputList = this.myInputList;
	}
}

