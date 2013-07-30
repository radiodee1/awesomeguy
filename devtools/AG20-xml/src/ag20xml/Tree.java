/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ag20xml;

import java.util.ArrayList;

/**
 *
 * @author dave
 */
public class Tree {
    public Info info = new Info("", 0);
    public ArrayList<String> position = new ArrayList<String>();
    public ArrayList<String> copy = new ArrayList<String>();
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
    
    public Tree() {
        clearList();
    }
    
    public void clearList() {
        this.position.clear();
    }
    public Info find(String c) {
        this.position.add(c);
        return find();
    }
    public Info find() {
        this.copy = (ArrayList<String>) this.position.clone();
        
        follow();
        return info;
    }
    
    public String next() {
        String val = new String();
        if (this.position.isEmpty()) {
            val = new String();
        }
        else {
            val = this.position.remove(0);
        }
        
        return val;
    }
    ////////////////// HERE STARTS PARSE ////////////////////////
    public void follow( ) {
        //Info val = new Info(new String(), Tree.C_NONE);
        String current = next();
        if (current.contentEquals(Tree.N_GAME)) {
            info = new Info(Tree.N_GAME, Tree.C_LIST, false);
            game();
        }
        
        
    }
    public void game() {
        String current = next();
        if (current.contentEquals(Tree.N_PLANET)) {
            info = new Info(Tree.N_PLANET, Tree.C_LIST, true);
            planet();
        }
    }
    public void planet() {
        String current = next();
        if (current.contentEquals(Tree.N_HORIZON)) {
            info = new Info(Tree.N_HORIZON, Tree.C_LIST, false);
            horizon();
        }
        if (current.contentEquals(Tree.N_MAZE)) {
            info = new Info(Tree.N_MAZE, Tree.C_LIST, true);
            maze();
        }
        if (current.contentEquals(Tree.N_SPECIAL)) {
            info = new Info(Tree.N_SPECIAL, Tree.C_LIST, true);
            special();
        }
        if (current.contentEquals(Tree.N_CHALLENGES)) {
            info = new Info(Tree.N_CHALLENGES, Tree.C_LIST, true);
            challenges();
        }
        if (current.contentEquals(Tree.N_TEXT)) {
            info = new Info(Tree.N_TEXT, Tree.C_LIST, false);
            text();
        }
    }
    public void text() {
        String current = next();
        if (current.contentEquals(Tree.N_MESSAGE)) {
            info = new Info(Tree.N_MESSAGE, Tree.C_STRING, true);
           
        }
    }
    
    
    public void maze() {
        String current = next();
        if (current.contentEquals(Tree.N_SPECIAL)) {
            info = new Info(Tree.N_SPECIAL, Tree.C_LIST, true);
            special();
        }
        if (current.contentEquals(Tree.N_CHALLENGES)) {
            info = new Info(Tree.N_CHALLENGES, Tree.C_LIST, true);
            challenges();
        }
        if (current.contentEquals(Tree.N_HORIZONTAL)) {
            info = new Info(Tree.N_HORIZONTAL, Tree.C_STRING, false);
        }
        if (current.contentEquals(Tree.N_VERTICAL)) {
            info = new Info(Tree.N_VERTICAL, Tree.C_STRING, false);
            
        }
        if (current.contentEquals(Tree.N_VISIBLE)) {
            info = new Info(Tree.N_VISIBLE, Tree.C_STRING, false);
            
        }
        if (current.contentEquals(Tree.N_INVISIBLE)) {
            info = new Info(Tree.N_INVISIBLE, Tree.C_STRING, false);
        }
    }
    
    public void horizon() {
        String current = next();
        if (current.contentEquals(Tree.N_HORIZONTAL)) {
            info = new Info(Tree.N_HORIZONTAL, Tree.C_STRING, false);
        }
        if (current.contentEquals(Tree.N_VERTICAL)) {
            info = new Info(Tree.N_VERTICAL, Tree.C_STRING, false);
            
        }
        if (current.contentEquals(Tree.N_VISIBLE)) {
            info = new Info(Tree.N_VISIBLE, Tree.C_STRING, false);
            
        }
        if (current.contentEquals(Tree.N_INVISIBLE)) {
            info = new Info(Tree.N_INVISIBLE, Tree.C_STRING, false);
        }
    }
    
    public void special() {
        String current = next();
        if (current.contentEquals(Tree.N_BLOCK)) {
            info = new Info(Tree.N_BLOCK, Tree.C_STRING, true);
        }
    }
    public void challenges() {
        String current = next();
        if (current.contentEquals(Tree.N_INVADERS)) {
            info = new Info(Tree.N_INVADERS, Tree.C_STRING, true);
        }
    }
}

class Info {
    public String name = new String();
    public int type = 0;
    public ArrayList<String> list = new ArrayList<String>();
    public boolean repetition = false;
    
    public Info(String n, int t) {
        this.name = n;
        this.list.add(n);
        this.type = t;
    }
    
    public Info(String n, int t, boolean r) {
        this.name = n;
        this.list.add(n);
        this.type = t;
        this.repetition = r;
    }
    public void clear() {
        this.list.clear();
    }
}