/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ag20xml;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

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
    public boolean printOption = false;
    public boolean addToFormOption = true;
    
    public boolean readXML = true;
    public ParseXML parse ;
    public int eventType = 0;
    
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
    
    public Tree(String fileName) {
        clearList();
        parse = new ParseXML("awesomeguy.xml");
        try {
            parse.setXmlPullParser();
        } catch (Exception ex) {
            ex.printStackTrace();
        } 
        newFileName = fileName.trim() + ".mod.xml";
        if (newFileName.contentEquals(".mod.xml")) {
            this.newFileName = new String("output.mod.xml");
        }
        System.out.println(newFileName);
        this.writeOutputFile();
        find();
    }
    public static void main( String args[]) {
        Tree test = new Tree(new String());
        
    }
    
    public void setupTest() {
        test.add(Tree.N_GAME);
        test.add(Tree.N_PLANET);
        test.add(Tree.N_HORIZON);
        test.add(Tree.N_HORIZONTAL);
        test.add(Tree.N_VERTICAL);
        test.add(Tree.N_VISIBLE);
        test.add(Tree.N_INVISIBLE);
        test.add(Tree.N_MAZE);
        test.add(Tree.N_PLANET);
    }
    public void writeOutputFile() {
        this.printOption = true;
        try{
          // Create file 
          FileWriter fstream = new FileWriter(newFileName);
          out = new BufferedWriter(fstream);
          out.write("<?xml version=\"1.0\" ?>\n");
          out.write("<!-- awesomeguy.xml file 2.0 -->\n");
          
          this.printXml();
          
          
          //Close the output stream
          out.close();
        }catch (Exception e){//Catch exception if any
          System.err.println("Error: " + e.getMessage());
        }
    }
    
    public void printXml() {
        find();
    }
    
    public void clearList() {
        this.position.clear();
    }
    public Info find(ArrayList<String> i) {
        this.position = i;
        return find();
    }
    public Info find(String c) {
        this.position.add(c);
        return find();
    }
    public Info find() {
        this.copy = (ArrayList<String>) this.position.clone();
        
        follow();
        
        this.position = (ArrayList<String>) this.copy.clone();
        return info;
    }
    
    public String next() {
        String val = new String();
        if(! this.readXML) {
        
            if (this.position.isEmpty()) {
                val = new String();
            }
            else {
                //val = this.position.remove(0);
                val = this.position.get(0);
            }
        }
        else {
            try {
                
                while (eventType == XmlPullParser.START_DOCUMENT ) {
                    parse.mXpp.next();
                    eventType = parse.mXpp.getEventType();
                }
                eventType = parse.mXpp.getEventType();
                if (eventType != XmlPullParser.END_DOCUMENT) {
                    val = parse.mXpp.getName();
                }
                else {
                    val = new String();
                }
            } catch (Exception ex) {
                Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        System.out.println(val);
        return val;
    }
    
    public void pop() {
        if ( ! this.readXML) {
            this.position.remove(0);
        }
        else {
            try {
                while ( (eventType != XmlPullParser.START_TAG ||
                        eventType == XmlPullParser.TEXT) ) {
                    parse.mXpp.nextTag();
                    eventType = parse.mXpp.getEventType();
                }
                
                parse.mXpp.nextTag();
                eventType = parse.mXpp.getEventType();
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
            if( last.type != Tree.C_LIST) last = i;
        }
        //pop();
        if (this.eventType != XmlPullParser.END_TAG) {
            //System.out.println("bad close tag");
        }
        if (this.eventType == XmlPullParser.TEXT) {
            try {
                System.out.println("bad text status");
                //this.parse.mXpp.nextTag();
                i.content = this.parse.mXpp.getText();
                //this.parse.mXpp.nextTag();
                System.out.println(i.content);
            } catch (Exception ex) {
                Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        pop();
        System.out.println("at    > " + i.name );
    }
    
    public void closePrintOrParse(Info i) {
        if (this.printOption) {
            try {
                out.write("</" + i.name+ ">\n");
            } catch (IOException ex) {
                ex.printStackTrace();
                
            }
        }
        if (this.readXML) {

            
        }
        System.out.println("close > " + i.name);
    }
    
    
    ////////////////// HERE STARTS PARSE ////////////////////////
    public void follow( ) {
        
        
        if (this.next().contentEquals(Tree.N_GAME)) {
            Info info = new Info(Tree.N_GAME, Tree.C_LIST, false);
            head = last;
            doPrintOrParse(info);
            game();
            closePrintOrParse(info);
        }
        
        
    }
    public void game() {
        //String current = next();
        while(next().contentEquals(Tree.N_PLANET)) {
            
            Info info = new Info(Tree.N_PLANET, Tree.C_LIST, true);
            
            //head.add(info, 0);// head node
            //last = info;
            
            doPrintOrParse(info);
            planet();
            closePrintOrParse(info);
        }
    }
    public void planet() {
        //String current = next();
        while(this.next().contentEquals(Tree.N_HORIZON) ||
                this.next().contentEquals(Tree.N_MAZE) ||
                this.next().contentEquals(Tree.N_SPECIAL) ||
                this.next().contentEquals(Tree.N_CHALLENGES) ||
                this.next().contentEquals(Tree.N_TEXT) ||
                this.next().contentEquals(Tree.N_HORIZONTAL) ||
                this.next().contentEquals(Tree.N_VERTICAL)) {
            
            if (this.next().contentEquals(Tree.N_HORIZONTAL)) {
                Info info = new Info(Tree.N_HORIZONTAL, Tree.C_STRING, false);
                doPrintOrParse(info);
                horizontal(info);
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_VERTICAL)) {
                Info info = new Info(Tree.N_VERTICAL, Tree.C_STRING, false);
                doPrintOrParse(info);
                vertical(info);
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_HORIZON)) {

                Info info = new Info(Tree.N_HORIZON, Tree.C_LIST, false);
                doPrintOrParse(info);
                horizon();
                closePrintOrParse(info);
            }
            while (this.next().contentEquals(Tree.N_MAZE)) {
                Info info = new Info(Tree.N_MAZE, Tree.C_LIST, true);
                doPrintOrParse(info);
                maze();
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
        String current = next();
        if (current.contentEquals(Tree.N_MESSAGE)) {
            Info info = new Info(Tree.N_MESSAGE, Tree.C_STRING, true);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
    }
    
    
    public void maze() {
        String current = next();
        
        while(this.next().contentEquals(Tree.N_SPECIAL) ||
                this.next().contentEquals(Tree.N_HORIZONTAL) ||
                this.next().contentEquals(Tree.N_CHALLENGES) ||
                this.next().contentEquals(Tree.N_VERTICAL) ||
                this.next().contentEquals(Tree.N_VISIBLE) ||
                this.next().contentEquals(Tree.N_INVISIBLE)) {
            
            while (this.next().contentEquals(Tree.N_SPECIAL) ) {
                Info info = new Info(Tree.N_SPECIAL, Tree.C_LIST, true);
                doPrintOrParse(info);
                special();
                closePrintOrParse(info);
            }
            while (this.next().contentEquals(Tree.N_CHALLENGES)) {
                Info info = new Info(Tree.N_CHALLENGES, Tree.C_LIST, true);
                doPrintOrParse(info);
                challenges();
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_HORIZONTAL)) {
                Info info = new Info(Tree.N_HORIZONTAL, Tree.C_STRING, false);
                info.content = new String("number");
                doPrintOrParse(info);
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_VERTICAL)) {
                Info info = new Info(Tree.N_VERTICAL, Tree.C_STRING, false);
                info.content = new String("number");
                doPrintOrParse(info);
                closePrintOrParse(info);

            }
            if (this.next().contentEquals(Tree.N_VISIBLE)) {
                Info info = new Info(Tree.N_VISIBLE, Tree.C_STRING, false);
                doPrintOrParse(info);
                closePrintOrParse(info);

            }
            if (this.next().contentEquals(Tree.N_INVISIBLE)) {
                Info info = new Info(Tree.N_INVISIBLE, Tree.C_STRING, false);
                doPrintOrParse(info);
                closePrintOrParse(info);
            }
        }
    }
    
    public void horizon() {
        //String current = next();
        while (this.next().contentEquals(Tree.N_VISIBLE) ||
                this.next().contentEquals(Tree.N_INVISIBLE)) {
            
            
            
            if (this.next().contentEquals(Tree.N_VISIBLE)) {
                Info info = new Info(Tree.N_VISIBLE, Tree.C_STRING, false);
                doPrintOrParse(info);
                closePrintOrParse(info);
            }
            if (this.next().contentEquals(Tree.N_INVISIBLE)) {
                Info info = new Info(Tree.N_INVISIBLE, Tree.C_STRING, false);
                doPrintOrParse(info);
                closePrintOrParse(info);
            }
        }
    }
    
    public void special() {
        String current = next();
        if (current.contentEquals(Tree.N_BLOCK)) {
            Info info = new Info(Tree.N_BLOCK, Tree.C_STRING, true);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
    }
    public void challenges() {
        String current = next();
        if (current.contentEquals(Tree.N_INVADERS)) {
            Info info = new Info(Tree.N_INVADERS, Tree.C_STRING, true);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
    }
    public void horizontal(Info info) {
        
            Info i = new Info(Tree.N_HORIZONTAL,0);
            i.content = "numbers";
            info.add(i, 0);
            if (this.readXML) {
                //this.parse.mXpp.nextToken();
            }
            //doPrintOrParse(info);
            //closePrintOrParse(info);
        
    }
    public void vertical(Info info) {
        
            Info i = new Info(Tree.N_VERTICAL,0);
            i.content = "numbers";
            info.add(i, 0);
            doPrintOrParse(info);
            closePrintOrParse(info);
        
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
}