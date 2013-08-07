/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ag20xml;


import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.ArrayList;

/**
 *
 * @author dave
 */
public class AG20XML {
    public String newFileName = new String();
    public LevelList mList = new LevelList();
    public BufferedWriter out;
    public String start1 = new String();
    public String start2 = new String();
    public String start3 = new String();
    public String start4 = new String();
    public String start5 = new String();
    public String start6 = new String();
    public String start7 = new String();
    public String start8 = new String();
    public String start9 = new String();
    public String start10 = new String();
    public String start11 = new String();
    public String start12 = new String();
    public String start13 = new String();
    public String start14 = new String();
    public String start15 = new String();
    
    public String stop1 = new String();
    public String stop2 = new String();
    public String stop3 = new String();
    public String stop4 = new String();
    public String stop5 = new String();
    public String stop6 = new String();
    public String stop7 = new String();
    public String stop8 = new String();
    public String stop9 = new String();
    public String stop10 = new String();
    public String stop11 = new String();
    public String stop12 = new String();
    public String stop13 = new String();
    public String stop14 = new String();
    public String stop15 = new String();
    
    public AG20XML(String fileName, LevelList mL){
        newFileName = fileName.trim() + ".mod.xml";
        if (newFileName.contentEquals(".mod.xml")) {
            this.newFileName = new String("output.mod.xml");
        }
        mList = mL;
        setupVars();
    }
    
    public void writeOutputFile() {
        
        try{
          // Create file 
          FileWriter fstream = new FileWriter(newFileName);
          out = new BufferedWriter(fstream);
          out.write("<?xml version=\"1.0\" ?>\n");
          out.write("<!-- awesomeflyer.xml file -->\n");
          out.write("<game>\n");
          this.printXml();
          
          out.write("</game>\n");
          //Close the output stream
          out.close();
        }catch (Exception e){//Catch exception if any
          System.err.println("Error: " + e.getMessage());
        }
    }
    private void printXml() {
        try {
            for (int x = 0; x < mList.size(); x ++ ) {
                out.write(this.start1);//planet - visible
                
                out.write(mList.getLevelTiles(x));
                out.write(this.start2); // visible - invisible
                out.write(this.mList.getObjectTiles(x));
                out.write(this.stop2); // invisible... horizon
                out.write(this.start3); // challenge
                for (int y = 0; y < this.mList.mList.get(x).mChallenge.size(); y ++) {
                    out.write(this.start4);
                    out.write(this.mList.mList.get(x).mChallenge.get(y));
                    out.write(this.stop4);
                }
                out.write(this.stop3); // challenge
                
                out.write(this.start15); // special
                for (int y = 0; y < this.mList.mList.get(x).mSpecial.size(); y ++) {
                    out.write(this.start14); // block
                    out.write(this.mList.mList.get(x).mSpecial.get(y));
                    out.write(this.stop14); // block
                }
                out.write(this.stop15); //special
                
                out.write(this.start5); // text
                for (int y = 0; y < this.mList.mList.get(x).mTextMessage.size(); y ++) {
                    out.write(this.start6); // message number =
                    out.write(this.mList.mList.get(x).mTextNum.get(y).toString());
                    out.write(this.start7); // close
                    out.write(this.mList.mList.get(x).mTextMessage.get(y));
                    out.write(this.stop6); // message
                }
                out.write(this.stop5); // text
                out.write ("<underground>\n");
                
                    for (int z = 0; z < this.mList.mList.get(x).mMazeData.size(); z ++) {
                        MazeData mm = this.mList.mList.get(x).mMazeData.get(z);
                        
                        out.write(this.start8);// maze number
                        out.write(mm.mNum.toString());
                        out.write(this.start9);// close maze
                        
                        out.write(this.start10);//horizontal
                        out.write(mm.mHorizontal.toString());                        
                        out.write(this.stop10);//close horizontal
                        
                        out.write(this.start11);//vertical
                        out.write(mm.mVertical.toString());
                        out.write(this.stop11);//vertical close
                        
                        out.write(this.start12); // visible
                        out.write(mm.mVisible);
                        out.write(this.stop12); // visible close
                        
                        out.write(this.start13); // invisible
                        out.write(mm.mInvisible);
                        out.write(this.stop13); // invisible close
                        
                        out.write(this.start3);// challenge
                        for (int a = 0; a < mm.mChallenge.size(); a ++) {
                            out.write(this.start4);// invaders
                            out.write(mm.mChallenge.get(a));
                            out.write(this.stop4);// invaders
                        }
                        out.write(this.stop3);//challenge close
                        
                        out.write(this.start15);// special
                        for (int a = 0; a< mm.mSpecial.size(); a++) {
                            out.write(this.start14); //block
                            out.write(mm.mSpecial.get(a));
                            out.write(this.stop14); // block
                        }
                        out.write(this.stop15); //special close
                        
                        out.write(this.stop8);//close maze
                    }
                
                out.write("</underground>\n");
                
                out.write(this.stop1);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void setupVars() {
        this.start1 = "<planet>\n"
                + "<horizontal>192</horizontal>\n"
                + "<vertical>32</vertical>\n"
                + "<horizon>\n"
                + "<visible>\n";
        this.stop1 = "</planet>\n";
        
        this.start2 = "</visible>\n" 
                + "<invisible>\n";
        
        this.stop2 = "</invisible>\n"
                + "</horizon>\n";
        
        this.start3 = "<challenge>\n";
        this.stop3 = "</challenge>\n";
        
        this.start4 = "<invaders>\n";
        this.stop4 = "</invaders>\n";
        
        this.start5 = "<text>\n";
        this.stop5 = "</text>\n";
        
        this.start6 = "<message number=\"";
        this.start7 = "\">\n";
        this.stop6 = "</message>\n";
        
        this.start8 = "<maze number=\"";
        this.start9 = "\">\n";
        this.stop8 = "</maze>\n";
        
        this.start10 = "<horizontal>\n";
        this.stop10 = "</horizontal>\n";
        this.start11 = "<vertical>\n";
        this.stop11 = "</vertical>\n";
        
        this.start12 = "<visible>\n";
        this.stop12 = "</visible>\n";
        
        this.start13 = "<invisible>\n";
        this.stop13 = "</invisible>\n";
        
        this.start14 = "<block>\n";
        this.stop14 = "</block>\n";
        
        this.start15 = "<special>\n";
        this.stop15 = "</special>\n";
    }
}
