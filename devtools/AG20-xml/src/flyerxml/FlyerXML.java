/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package flyerxml;
import java.io.*;

/**
 *
 * @author dave
 */
public class FlyerXML {

    public String newFileName = new String();
    public InitBackground.LevelList mList = new InitBackground.LevelList();
    public BufferedWriter out;
    public String outputPart1 = new String();
    public String outputPart2 = new String();
    public String outputPart3 = new String();
    public String outputPart4 = new String();
    
    public FlyerXML(String fileName, InitBackground.LevelList mL){
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
                out.write(this.outputPart1);
                out.write(new Integer(mList.getNum(x)).toString());
                out.write(this.outputPart2);
                out.write(mList.getLevelTiles(x));
                out.write(this.outputPart3);
                out.write(mList.getObjectTiles(x));
                out.write(this.outputPart4);
            }
        }
        catch (Exception e) {
            
        }
    }
    private void setupVars() {
        this.outputPart1 = new String("<level number=\"");
        this.outputPart2 = new String("\">\n" 
                + "<horizontal>192</horizontal>\n"
                + "<vertical>32</vertical>\n"
                + "<tiles_level>\n");
        this.outputPart3 = new String("\n</tiles_level>\n"
                + "<tiles_objects>\n");
        this.outputPart4 = new String("\n</tiles_objects>\n"
                + "<last_level>false</last_level>\n"
                + "</level>\n");
    }
}
