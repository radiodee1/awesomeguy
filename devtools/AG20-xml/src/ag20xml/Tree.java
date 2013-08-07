/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ag20xml;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;

/**
 *
 * @author dave
 */
public class Tree {
    public Info info = new Info("", 0);
    public ArrayList<String> position = new ArrayList<String>();
    public ArrayList<String> copy = new ArrayList<String>();
    public ArrayList<String> test = new ArrayList<String>();
    public Info head = new Info("", 0);
    public Info last = new Info("", 0);
    public String val = new String();
    public boolean printOption = true;
    public boolean addToFormOption = true;
    
    public XmlPullParser mXpp;
    public boolean readXML = true;
    public int eventType = 0;
    public String mXMLFilename = new String("awesomeguy.xml");
    
    public Info interest ;
    public int l_planet = 0;
    public int l_maze = 0;
    public int l_type = 0;
    public static int TYPE_ABOVE_GROUND = 1;
    public static int TYPE_BELOW_GROUND = 2;
    
    public String newFileName = new String();
    public BufferedWriter out;
    
    public static int C_LIST = 1;
    public static int C_COMPONENT = 2;
    public static int C_STRING = 3;
    public static int C_NONE = 0;
    
    public static String N_GAME = "game";
    public static String N_HORIZON = "horizon";
    public static String N_PLANET = "planet";
    public static String N_VERTICAL = "vertical";
    public static String N_HORIZONTAL = "horizontal";
    public static String N_VISIBLE = "visible";
    public static String N_INVISIBLE = "invisible";
    public static String N_MAZE = "maze";
    public static String N_SPECIAL = "special";
    public static String N_CHALLENGES = "challenges";
    public static String N_INVADERS = "invaders";
    public static String N_BLOCK = "block";
    public static String N_TEXT = "text";
    public static String N_MESSAGE = "message";
    public static String N_NUMBER = "number";
    public static String N_UNDERGROUND ="underground";
    
    public Tree(String fileName) {
        
        this.mXMLFilename = fileName;
        try {
            setXmlPullParser();
        } catch (Exception ex) {
            ex.printStackTrace();
        } 
        
        newFileName = fileName.trim() + ".mod.xml";
        
        System.out.println(newFileName);
        this.writeOutputFile();
        
        this.showTree(head, 0, 0, Tree.TYPE_ABOVE_GROUND, Tree.N_VISIBLE);
        //System.out.println("------- " + head.name);
        this.showList(this.interest);
        
        //this.showTree(interest, null);
    }
    public static void main( String args[]) {
        Tree test = new Tree(new String());
        
    }
    
    public Info getHead() {
        //return head;
        //System.out.println("get head!!");
        return head;
    }
    
    public int getPlanets() {
        return this.l_planet;
    }
    
    
    public void writeOutputFile() {
        this.printOption = true;
        try{
          // Create file 
          FileWriter fstream = new FileWriter(newFileName);
          out = new BufferedWriter(fstream);
          out.write("<?xml version=\"1.0\" ?>\n");
          out.write("<!-- awesomeguy.xml file 2.0 -->\n");
          
          //this.printXml();
          this.follow();
          
          //Close the output stream
          if (out != null) {
                    out.flush();
                    out.close();
                    //System.out.println("--end--");
          }
          else {
              System.out.println("--out is null--");
              throw new Exception();
          }
          
          //out.close();
        }catch (Exception e){//Catch exception if any
          System.err.println("Error: " + e.getMessage());
          e.printStackTrace();
        }
    }
    
    
    public boolean setXmlPullParser() throws XmlPullParserException, IOException{
			
				
       XmlPullParserFactory factory = XmlPullParserFactory.newInstance();
       factory.setNamespaceAware(false);
       mXpp = factory.newPullParser(); 	

       FileInputStream fstream = new FileInputStream(mXMLFilename);
       DataInputStream in = new DataInputStream(fstream);
       int BUFFER_SIZE = 8192;

       BufferedReader br = new BufferedReader(new InputStreamReader(in), BUFFER_SIZE);


       mXpp.setInput(br);
       //mXpp.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES, false);

        return true;
    }
    ////////////////// recursive tree stuff ////////////////////////////
    
    public boolean showTree(Info i, int planet, int maze, int type, String record) {
        if (record != null && i.name.contentEquals(record) &&
                planet == i.l_planet && maze == i.l_maze && type == i.l_type) {
            interest = i;
            return true;
        }
        for(int j = 0; j < i.list.size(); j ++) {
            showTree(i.list.get(j), record);
            //System.out.println(i.name + " - " +  i.content+ " - "+ i.list.size() + " - " + i.num);
            //showTree(i.list.get(j));
        }
        return false;
    }
    
    public void showTree(Info i , String record) {
        if (record != null && i.name.contentEquals(record) ) {
            interest = i;
            return;
        }
        for(int j = 0; j < i.list.size(); j ++) {
            showTree(i.list.get(j), record);
            //System.out.println(i.name + " - " +  i.content+ " - "+ i.list.size() + " - " + i.num);
            //showTree(i.list.get(j));
        }
    }

    public void showList(Info i) {
        for(int j = 0; j < i.list.size(); j ++) {
            //System.out.println("list " +i.name + " - " +  i.content+ " - "+ i.list.size());
            
        }
    }
    //////////////////////// xml stuff /////////////////////////////////
    public int getNumber() throws XmlPullParserException, IOException {
        int num = 0;
        if (mXpp.getAttributeCount() > 0) {
            if(mXpp.getAttributeName(0).contentEquals(Tree.N_NUMBER)) {
                num = new Integer(mXpp.getAttributeValue(0).toString().trim()).intValue();
                
                //System.out.println("----- number here " + num + " ------");
            }
        }
        return num;
    }
    
    public int skipWhitespace() throws XmlPullParserException, IOException {
        
            eventType = mXpp.next();
            while(eventType == XmlPullParser.TEXT &&  mXpp.isWhitespace()) {   // skip whitespace
                eventType = mXpp.next();
                //System.out.println("skipping");
            }
            if (eventType != XmlPullParser.START_TAG &&  eventType != XmlPullParser.END_TAG) {
                //throw new XmlPullParserException("expected start or end tag", this, null);
            }

        return eventType;
    }
    
    public String next() {
        
        if( this.readXML) {// XML READER SECTION
            try {
                
                val = new String("");
                eventType = mXpp.getEventType();
                if (eventType == XmlPullParser.START_TAG) {
                    val = mXpp.getName();
                    //System.out.println(val + " start tag");
                    
                }
                else {
                    if (eventType != XmlPullParser.START_TAG && 
                            eventType != XmlPullParser.END_TAG) {
                        this.skipWhitespace();
                    }
                    
                    val = mXpp.getName();// remove me??!!
                }
                if (eventType == XmlPullParser.END_DOCUMENT) {
                    //System.out.println("end of doc");
                    
                }
            } catch (Exception ex) {
                Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        this.showType();
        //System.out.println(val + " at next");
        return val;
    }
    
    public void pop(Info i) {
        int j = 0;
        
        if ( true || this.readXML)  {
            try {
               
                while ( eventType != XmlPullParser.START_TAG ) {
                    //eventType = mXpp.next();
                    this.skipWhitespace();
 
                }
                i.num = this.getNumber();
                if(i.name.contentEquals(mXpp.getName()) && 
                        eventType == XmlPullParser.START_TAG) {
                    //System.out.println(i.name + " proper pop");
                }
                else {
                    //System.out.println(eventType + " bad pop");
                }
                this.skipWhitespace();
                
                //eventType = mXpp.getEventType();
            } catch (XmlPullParserException ex) {
                Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
    
    public void closePop(Info i) {
        if (this.readXML) {
            try {
                if (eventType == XmlPullParser.END_DOCUMENT) {
                    //System.out.println("end");
                    //System.exit(0);
                }
                if ( eventType == XmlPullParser.END_TAG ) { //3
                    
                    //mXpp.next();
                    
                    //System.out.println(eventType + " -- closePop (is 3?)");
                    this.showType();
                }
                if (eventType == XmlPullParser.TEXT ) {
                    //System.out.println(" -- skip whitespace");
                    this.skipWhitespace();
                    
                }
                if (eventType == XmlPullParser.END_TAG && 
                        i.name.contentEquals(mXpp.getName())) {
                    
                    //System.out.println(mXpp.getName() + " at close pop");
                    mXpp.next();
                }
                //out.flush();
                //System.out.println(eventType + " -- close");
            } catch (XmlPullParserException ex) {
                Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
    
    public void doPrintOrParse(Info i)  {
        
        
        if (this.printOption) {
            try {
                out.write("<" + i.name + ">\n");
            } catch (Exception ex) {
                ex.printStackTrace();
                //Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if(true) {
            
            last.add(i, 0); // alsways add node
            i.parent = last;
            last = i;
            
            i.l_planet = this.l_planet;
            i.l_maze = this.l_maze;
            i.l_type = this.l_type;
        }
        pop(i);
        if (this.eventType != XmlPullParser.END_TAG) {
            //System.out.println("bad close tag");
        }
        if (this.eventType == XmlPullParser.TEXT) {
            try {
                //System.out.println("bad text status");
                //this.parse.mXpp.nextTag();
                i.content = this.mXpp.getText();
                //this.parse.mXpp.nextTag();
                //System.out.println(i.content);
                out.write(i.content);
            } catch (Exception ex) {
                Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        
        //System.out.println("at    > " + i.name );
    }
    
    public void closePrintOrParse(Info i) {
        try {
            if (this.printOption || true) {
                try {
                    out.write("</" + i.name+ ">\n");
                    //System.out.println("</" + i.name + ">\n");
                } catch (IOException ex) {
                    ex.printStackTrace();
                
                    
                }
            }
            if (this.readXML || true) {
                this.last = i.parent;
                
                closePop(i);
            }
            out.flush();
            //System.out.println("close > " + i.name);
        } catch (IOException ex) {
            Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void showType() {
        String val = new String();
        switch(eventType) {
            case XmlPullParser.COMMENT :
                val = "comment";
                break;
            case XmlPullParser.START_DOCUMENT:
                val = "start document";
                break;
            case XmlPullParser.START_TAG:
                val = "start tag";
                break;
            case XmlPullParser.TEXT:
                val = "text";
                break;
            case XmlPullParser.END_TAG:
                val = "end tag";
                break;
            case XmlPullParser.END_DOCUMENT:
                val = "end document";
                break;
            default:
                val = "default";
                break;
        }
        //System.out.println(val + " " + eventType);
    }
    ////////////////// HERE STARTS PARSE ////////////////////////
    public void follow( ) {
        
        
        while (eventType == XmlPullParser.START_DOCUMENT ||
                eventType != XmlPullParser.START_TAG) {
            try {
                eventType = mXpp.next();
                
                
            } catch (Exception ex) {
                Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            } 
        }
        
        if (this.next().contentEquals(Tree.N_GAME)) {
            Info info = new Info(Tree.N_GAME, Tree.C_LIST, false);
            head = last;
            doPrintOrParse(info);
            //System.out.println("game ---");
            game();
            closePrintOrParse(info);
        }
        
        
    }
    public void game() {
        //String current = next();
        while(next().contentEquals(Tree.N_PLANET)) {
            if (this.next().contentEquals(Tree.N_PLANET)) {
                Info info = new Info(Tree.N_PLANET, Tree.C_LIST, true);
                this.l_type = Tree.TYPE_ABOVE_GROUND;
                doPrintOrParse(info);
                //this.l_planet ++;
                planet();
                
                this.l_planet ++;

                closePrintOrParse(info);
            }
        }
        //this.closePrintOrParse(info);
    }
    public void planet() {
        //String current = next();
        while(this.next().contentEquals(Tree.N_HORIZON) ||
                this.next().contentEquals(Tree.N_UNDERGROUND) ||
                this.next().contentEquals(Tree.N_SPECIAL) ||
                this.next().contentEquals(Tree.N_CHALLENGES) ||
                this.next().contentEquals(Tree.N_TEXT) ||
                this.next().contentEquals(Tree.N_HORIZONTAL) ||
                this.next().contentEquals(Tree.N_VERTICAL)) {
            
            this.l_maze = 0;
            if (this.next().contentEquals(Tree.N_HORIZONTAL)) {
                Info info = new Info(Tree.N_HORIZONTAL, Tree.C_STRING, false);
                doPrintOrParse(info);
                //System.out.println("horizontal ---");

                horizontal(info);
                closePrintOrParse(info);
            }
            
            
            if (this.next().contentEquals(Tree.N_VERTICAL)) {
                Info info = new Info(Tree.N_VERTICAL, Tree.C_STRING, false);
                doPrintOrParse(info);
                //System.out.println("vertical ---");
                
                vertical(info);
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_HORIZON)) {

                Info info = new Info(Tree.N_HORIZON, Tree.C_LIST, false);
                doPrintOrParse(info);
                horizon();
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_UNDERGROUND)) {
                Info info = new Info(Tree.N_UNDERGROUND, Tree.C_LIST, true);
                doPrintOrParse(info);
                //this.l_type = Tree.TYPE_BELOW_GROUND;
                underground();
                //this.l_type = Tree.TYPE_ABOVE_GROUND;
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_SPECIAL)) {
                Info info = new Info(Tree.N_SPECIAL, Tree.C_LIST, true);
                doPrintOrParse(info);
                special();
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_CHALLENGES)) {
                Info info = new Info(Tree.N_CHALLENGES, Tree.C_LIST, true);
                doPrintOrParse(info);
                challenges();
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_TEXT)) {
                Info info = new Info(Tree.N_TEXT, Tree.C_LIST, false);
                doPrintOrParse(info);
                text();
                closePrintOrParse(info);
            }
        }
        
    }
    public void text() {
        
        while (this.next().contentEquals(Tree.N_MESSAGE)) {
            Info info = new Info(Tree.N_MESSAGE, Tree.C_STRING, true);
            doPrintOrParse(info);
            this.message(info);
            closePrintOrParse(info);
        }
    }
    
    public void underground() {
        this.l_type = Tree.TYPE_BELOW_GROUND;
        this.l_maze = 0;
        while (this.next().contentEquals(Tree.N_MAZE)) {
            Info info = new Info(Tree.N_MAZE, Tree.C_STRING, true);
            doPrintOrParse(info);
            this.maze();
            this.l_maze ++;
            closePrintOrParse(info);
        }
        this.l_type = Tree.TYPE_ABOVE_GROUND;
    }
    
    public void maze() {
        //String current = next();
        
        while(this.next().contentEquals(Tree.N_SPECIAL) ||
                this.next().contentEquals(Tree.N_HORIZONTAL) ||
                this.next().contentEquals(Tree.N_CHALLENGES) ||
                this.next().contentEquals(Tree.N_VERTICAL) ||
                this.next().contentEquals(Tree.N_VISIBLE) ||
                this.next().contentEquals(Tree.N_INVISIBLE)) {
            
            //System.out.println("while maze");
            if (this.next().contentEquals(Tree.N_SPECIAL) ) {
                Info info = new Info(Tree.N_SPECIAL, Tree.C_LIST, true);
                doPrintOrParse(info);
                special();
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_CHALLENGES)) {
                Info info = new Info(Tree.N_CHALLENGES, Tree.C_LIST, true);
                doPrintOrParse(info);
                challenges();
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_HORIZONTAL)) {
                Info info = new Info(Tree.N_HORIZONTAL, Tree.C_STRING, false);
                info.content = new String("number");
                //System.out.println(info.content);
                doPrintOrParse(info);
                this.horizontal(info);
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_VERTICAL)) {
                Info info = new Info(Tree.N_VERTICAL, Tree.C_STRING, false);
                info.content = new String("number");
                doPrintOrParse(info);
                this.vertical(info);
                closePrintOrParse(info);

            }
            if (this.next().contentEquals(Tree.N_VISIBLE)) {
                Info info = new Info(Tree.N_VISIBLE, Tree.C_STRING, false);
                doPrintOrParse(info);
                //System.out.println("visible ---");
                visible(info);
                closePrintOrParse(info);

            }
            if (this.next().contentEquals(Tree.N_INVISIBLE)) {
                Info info = new Info(Tree.N_INVISIBLE, Tree.C_STRING, false);
                doPrintOrParse(info);
                invisible(info);
                //System.out.println("invisible ---");
                closePrintOrParse(info);
            }
        }
        
    }
    
    public void horizon() {
        //String current = next();
        while (this.next().contentEquals(Tree.N_VISIBLE) ||
                this.next().contentEquals(Tree.N_INVISIBLE)) {
            
            //System.out.println("while horizon");
            
            if (this.next().contentEquals(Tree.N_VISIBLE)) {
                Info info = new Info(Tree.N_VISIBLE, Tree.C_STRING, false);
                doPrintOrParse(info);
                this.visible(info);
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_INVISIBLE)) {
                Info info = new Info(Tree.N_INVISIBLE, Tree.C_STRING, false);
                doPrintOrParse(info);
                this.invisible(info);
                closePrintOrParse(info);
            }
        }
    }
    
    public void special() {
        while (this.next().contentEquals(Tree.N_BLOCK)) {
            this.showType();
            if (this.next().contentEquals(Tree.N_BLOCK)) {
                Info info = new Info(Tree.N_BLOCK, Tree.C_STRING, true);
                doPrintOrParse(info);
                block(info);
                closePrintOrParse(info);
                
            }
        }
    }
    
    public void block(Info i) {
        
        this.content(i);
            
    }
    public void challenges() {
        while(this.next().contentEquals(Tree.N_INVADERS)) {
            if (this.next().contentEquals(Tree.N_INVADERS)) {
                Info info = new Info(Tree.N_INVADERS, Tree.C_STRING, true);
                doPrintOrParse(info);
                invaders(info);
                closePrintOrParse(info);
            }
        }
    }
    public void invaders(Info i) {
        
        this.content(i);
            
    }
    
    public void horizontal(Info info) {
        
        this.content(info);
        
    }
    public void vertical(Info info) {

        this.content(info);
            
    }
    
    public void visible(Info i) {
       
        this.content(i);
        
    }
    
    public void invisible(Info i) {
        
        this.content(i);
        
    }
    
    public void message(Info i) {
        
        this.content(i);
           
    }
    
    public void content(Info i) {
        try {        
            Info info = new Info(i.name, Tree.C_STRING, false);
            i.add(info, info.num);
            
            info.content = mXpp.getText();
            
            //System.out.println(info.content + " end of tree. (content)");
            
        } catch (Exception ex) {
            Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            ex.printStackTrace();
        } 
        
    }
}

class Info {
    public String name = new String();
    public int type = 0;
    public String content = new String();
    public ArrayList<Info> list = new ArrayList<Info>();
    public ArrayList<Integer> nums = new ArrayList<Integer>();
    public boolean repetition = false;
    public boolean endNode = false;
    public Info parent ;
    public int num = 0;
    
    public int l_planet = 0;
    public int l_maze = 0;
    public int l_type = 0;
    
    public Info(String n, int t) {
        this.name = n;
        
        this.type = t;
    }
    
    public Info(String n, int t, boolean r) {
        this.name = n;
        
        this.type = t;
        this.repetition = r;
        if (this.repetition) endNode = false;
        if (type == Tree.C_STRING) endNode = true;
    }
    
    public void clearObjects() {
        this.list.clear();
        this.nums.clear();
    }
    
    public void add(Info i, int n) {
        this.list.add(i);
        this.nums.add(n);
    }
    public Info clone() {
        Info temp = new Info("", Tree.C_NONE);
        temp.content = new String (this.content);
        temp.endNode = this.endNode;
        temp.l_maze = this.l_maze;
        temp.l_planet = this.l_planet;
        temp.l_type = this.l_type;
        temp.list = (ArrayList<Info>) this.list.clone();
        temp.name = this.name;
        temp.num = this.num;
        temp.nums = (ArrayList<Integer>) this.nums.clone();
        temp.parent = this.parent;
        temp.repetition = this.repetition;
        temp.type = this.type;
        
        return temp;
    }
}