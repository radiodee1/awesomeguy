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
import java.util.Hashtable;
import java.util.List;
import java.util.Scanner;
import java.util.StringTokenizer;
//import ;

public class convert_tiles{
	
	public static String OPTION_VISIBLE = "visible";
	public static String OPTION_INVISIBLE = "invisible";
	
	public static int MAX_TILES_PALLATE = 450;
	
	public static int  B_NONE = -1 ;
	public static int  B_START = 17 ;
	public static int  B_GUN = 16;
	public static int  B_SPACE = 0 ;
	public static int  B_LADDER = 25 ;
	public static int  B_BLOCK = 23 ;
	public static int  B_GOAL = 27 ;
	public static int  B_KEY = 26 ; 
	public static int  B_PRIZE =  28 ;
	public static int  B_MONSTER = 24 ;
	public static int  B_MARKER = 22 ; 
	public static int  B_DEATH = 20 ;
	public static int  B_ONEUP = 19 ;
	public static int  B_BIGPRIZE = 21 ;
	public static int  B_PLATFORM = 18 ; 
	public static int  B_TILES_PINK = 2;
	public static int  B_TILES_PURPLE = 8;
	public static int  B_TILES_GREEN = 1;
	public static int  B_START_SERIES_PINK = -2;
	public static int  B_START_SERIES_PURPLE = - 3;
	public static int  B_START_SERIES_GREEN = -4;
	public static int  B_STOP_SERIES =  -5;
	
	//final static String FILE_NAME = "C:\\Temp\\input.txt";
	final static String OUTPUT_FILE_NAME = ".output.txt";
	final static Charset ENCODING = StandardCharsets.UTF_8;
	
	public String myOutputPath = "./";
	public String myFileName = "";
	public ArrayList<String> myInputList = new ArrayList<String>();
	public ArrayList<String> myOutputList = new ArrayList<String>();
	
	
	//public ArrayList<String> myReplaceListVisible = new ArrayList<String>();
	//public ArrayList<String> myReplaceListInvisible = new ArrayList<String>();
	
	public Hashtable<Integer, Integer> myDict ;
	
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
		this.myDict = new Hashtable<Integer, Integer>();
		this.myDict.put(0, convert_tiles.B_SPACE);
		this.myDict.put(1, convert_tiles.B_NONE);
		this.myDict.put(5, convert_tiles.B_START);
		this.myDict.put(447, convert_tiles.B_PRIZE);
		this.myDict.put(446, convert_tiles.B_GOAL);
		this.myDict.put(445, convert_tiles.B_KEY);
		this.myDict.put(444, convert_tiles.B_LADDER);
		this.myDict.put(443, convert_tiles.B_MONSTER);
		this.myDict.put(442, convert_tiles.B_BLOCK);
		this.myDict.put(441, convert_tiles.B_MARKER);
		this.myDict.put(440, convert_tiles.B_ONEUP);//used twice
		this.myDict.put(439, convert_tiles.B_DEATH);
		this.myDict.put(438, convert_tiles.B_ONEUP);
		this.myDict.put(437, convert_tiles.B_MARKER);
	}
	
	public void convert_visible(String input){
		this.myInputList = this.inputAsList(input);
		System.out.println("visible "+input);
		this.processList(this.myDict);
		this.outputFromList("visible");
	}
	
	public void convert_invisible(String input) {
		this.myInputList = this.inputAsList(input);
		System.out.println("invisible "+ input);
		this.processList(this.myDict);
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
	
	public void processList(Hashtable<Integer, Integer> replaceList) {
		//this.myOutputList = this.myInputList;
		for(int x = 0; x < this.myInputList.size(); x ++){
			this.processLine(this.myInputList.get(x), replaceList);
		}
	}
	
	public void processLine(String in, Hashtable<Integer,Integer> list) {
		StringTokenizer st = new StringTokenizer(in,",");
		String line = new String();
		while (st.hasMoreTokens()) {
			String temp = st.nextToken();
			temp = temp.trim();
			Integer num = new Integer(temp).intValue();
			System.out.println(num);
			if (this.myDict.get(num) != null) {
				line = line + " " + this.myDict.get(num) + ",";
				//System.out.println("found");
			}
			else {
				//System.out.println("not found");
			}
		}
		System.out.println(line);
	}
}
