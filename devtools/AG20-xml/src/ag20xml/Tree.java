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
        newFileName = fileName.trim() + ".mod.xml";
        if (newFileName.contentEquals(".mod.xml")) {
            this.newFileName = new String("output.mod.xml");
        }
        System.out.println(newFileName);
        setupTest();
        find(test);
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
        
        try{
          // Create file 
          FileWriter fstream = new FileWriter(newFileName);
          out = new BufferedWriter(fstream);
          out.write("<?xml version=\"1.0\" ?>\n");
          out.write("<!-- awesomeguy.xml file -->\n");
          
          this.printXml();
          
          
          //Close the output stream
          out.close();
        }catch (Exception e){//Catch exception if any
          System.err.println("Error: " + e.getMessage());
        }
    }
    
    public void printXml() {
        
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
        if (this.position.isEmpty()) {
            val = new String();
        }
        else {
            //val = this.position.remove(0);
            val = this.position.get(0);
        }
        
        return val;
    }
    
    public void pop() {
        this.position.remove(0);
    }
    
    public void doPrintOrParse(Info i)  {
        if (this.printOption) {
            try {
                out.write("<" + i.name + ">\n");
            } catch (IOException ex) {
                ex.printStackTrace();
                //Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else {
            last.add(i, 0);
            last = i;
        }
        if (this.addToFormOption) {
            
        }
        pop();
        System.out.println("at > " + i.name);
    }
    
    public void closePrintOrParse(Info i) {
        if (this.printOption) {
            try {
                out.write("</" + i.name+ ">\n");
            } catch (IOException ex) {
                ex.printStackTrace();
                //Logger.getLogger(Tree.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
    }
    ////////////////// HERE STARTS PARSE ////////////////////////
    public void follow( ) {
        
        String current = next();
        if (current.contentEquals(Tree.N_GAME)) {
            info = new Info(Tree.N_GAME, Tree.C_LIST, false);
            head = last;
            doPrintOrParse(info);
            game();
            closePrintOrParse(info);
        }
        
        
    }
    public void game() {
        //String current = next();
        while(next().contentEquals(Tree.N_PLANET)) {
            
            info = new Info(Tree.N_PLANET, Tree.C_LIST, true);
            
            //head.add(info, 0);// head node
            //last = info;
            
            doPrintOrParse(info);
            planet();
            closePrintOrParse(info);
        }
    }
    public void planet() {
        //String current = next();
        if (this.next().contentEquals(Tree.N_HORIZON)) {
            
            info = new Info(Tree.N_HORIZON, Tree.C_LIST, false);
            doPrintOrParse(info);
            horizon();
            closePrintOrParse(info);
        }
        while (this.next().contentEquals(Tree.N_MAZE)) {
            info = new Info(Tree.N_MAZE, Tree.C_LIST, true);
            doPrintOrParse(info);
            maze();
            closePrintOrParse(info);
        }
        if (this.next().contentEquals(Tree.N_SPECIAL)) {
            info = new Info(Tree.N_SPECIAL, Tree.C_LIST, true);
            doPrintOrParse(info);
            special();
            closePrintOrParse(info);
        }
        if (this.next().contentEquals(Tree.N_CHALLENGES)) {
            info = new Info(Tree.N_CHALLENGES, Tree.C_LIST, true);
            doPrintOrParse(info);
            challenges();
            closePrintOrParse(info);
        }
        if (this.next().contentEquals(Tree.N_TEXT)) {
            info = new Info(Tree.N_TEXT, Tree.C_LIST, false);
            doPrintOrParse(info);
            text();
            closePrintOrParse(info);
        }
    }
    public void text() {
        String current = next();
        if (current.contentEquals(Tree.N_MESSAGE)) {
            info = new Info(Tree.N_MESSAGE, Tree.C_STRING, true);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
    }
    
    
    public void maze() {
        String current = next();
        if (current.contentEquals(Tree.N_SPECIAL)) {
            info = new Info(Tree.N_SPECIAL, Tree.C_LIST, true);
            doPrintOrParse(info);
            special();
            closePrintOrParse(info);
        }
        if (current.contentEquals(Tree.N_CHALLENGES)) {
            info = new Info(Tree.N_CHALLENGES, Tree.C_LIST, true);
            doPrintOrParse(info);
            challenges();
            closePrintOrParse(info);
        }
        if (current.contentEquals(Tree.N_HORIZONTAL)) {
            info = new Info(Tree.N_HORIZONTAL, Tree.C_STRING, false);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
        if (current.contentEquals(Tree.N_VERTICAL)) {
            info = new Info(Tree.N_VERTICAL, Tree.C_STRING, false);
            doPrintOrParse(info);
            closePrintOrParse(info);
            
        }
        if (current.contentEquals(Tree.N_VISIBLE)) {
            info = new Info(Tree.N_VISIBLE, Tree.C_STRING, false);
            doPrintOrParse(info);
            closePrintOrParse(info);
            
        }
        if (current.contentEquals(Tree.N_INVISIBLE)) {
            info = new Info(Tree.N_INVISIBLE, Tree.C_STRING, false);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
    }
    
    public void horizon() {
        String current = next();
        if (current.contentEquals(Tree.N_HORIZONTAL)) {
            info = new Info(Tree.N_HORIZONTAL, Tree.C_STRING, false);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
        if (current.contentEquals(Tree.N_VERTICAL)) {
            info = new Info(Tree.N_VERTICAL, Tree.C_STRING, false);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
        if (current.contentEquals(Tree.N_VISIBLE)) {
            info = new Info(Tree.N_VISIBLE, Tree.C_STRING, false);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
        if (current.contentEquals(Tree.N_INVISIBLE)) {
            info = new Info(Tree.N_INVISIBLE, Tree.C_STRING, false);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
    }
    
    public void special() {
        String current = next();
        if (current.contentEquals(Tree.N_BLOCK)) {
            info = new Info(Tree.N_BLOCK, Tree.C_STRING, true);
            doPrintOrParse(info);
            closePrintOrParse(info);
        }
    }
    public void challenges() {
        String current = next();
        if (current.contentEquals(Tree.N_INVADERS)) {
            info = new Info(Tree.N_INVADERS, Tree.C_STRING, true);
            doPrintOrParse(info);
            closePrintOrParse(info);
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