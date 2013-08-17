/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ag20xml;

import java.io.*;
import java.util.*;
import javax.swing.*;
import flyerxml.FileLoader;
/**
 *
 * @author dave
 */
public class AG20jFrame extends javax.swing.JFrame {

    public static String TILES_VISIBLE = "Visible Info: ";
    public static String TILES_INVISIBLE = "Invisible Info: ";
    public static String STRING_GOOD = "GOOD";
    public static String STRING_BAD = "BAD";
    
   static String windowName = new String();
   public int frameNumber = 0;
   public LevelList mList = new LevelList();
   public Tree tree;
   public Info head;
   
   
    /**
     * Creates new form FlyerjFrame
     */
    public AG20jFrame() {
        initComponents();
        this.parseXML();

    }
    public void parseXML() {
        this.frameNumber = 0;
        jLabel1.setText("AG20-XML: ");// + windowName);
        this.jLabel2.setText(AG20jFrame.TILES_VISIBLE);
        this.jLabel3.setText(AG20jFrame.TILES_INVISIBLE);
        try {
            if (!windowName.isEmpty()) {
                tree = new Tree(windowName);
                Info head = tree.getHead();
                mList = new LevelList(head);
                
                
            }
            if (mList.size() >= 1) {
                this.jLabel1.setText("AG20-XML: " + mList.size() + " planets");
                this.copyToWindows(frameNumber);
            }
            else if (mList.size() == 0) {
                mList = new LevelList();
                mList.add("Level 1", 0);
                this.copyToWindows(frameNumber);
            }
        }
        catch (Exception e) {
            
        }
    }
    
    public void copyToWindows(int num) {
      this.jEditorPane1.setText(mList.getLevelTiles(num)); 
      this.jEditorPane2.setText(mList.getObjectTiles(num));
      //this.jTextField1.setText(new Integer(mList.getNum(num)).toString());
      this.jLabel5.setText(new Integer(num).toString());
    }
    
    public void copyFromWindows(int num) {
        this.mList.setTiles(num, this.jEditorPane1.getText(), this.jEditorPane2.getText());
        //this.mList.setLabelNumber(num, Integer.parseInt(this.jTextField1.getText().trim()) );
        // nothing needed for number!!
        // planets go in order...
    }
    
    public void incrementFrameNum() {
        this.collectContents();
        this.copyFromWindows(frameNumber);
        if (frameNumber + 1 == mList.size()) return;
        frameNumber ++;
        this.copyToWindows(frameNumber);
        this.jLabel2.setText(AG20jFrame.TILES_VISIBLE);
        this.jLabel3.setText(AG20jFrame.TILES_INVISIBLE);
    }

    public void decrementFrameNum() {
        this.collectContents();
        this.copyFromWindows(frameNumber);
        if (frameNumber == 0) return;
        frameNumber --;
        this.copyToWindows(frameNumber);
        this.jLabel2.setText(AG20jFrame.TILES_VISIBLE);
        this.jLabel3.setText(AG20jFrame.TILES_INVISIBLE);
    }
    
    public void clearLevelTiles() {
        this.jEditorPane1.setText("");
        this.jLabel2.setText(AG20jFrame.TILES_VISIBLE);
        this.copyFromWindows(frameNumber);
    }
    
    public void clearObjectTiles() {
        this.jEditorPane2.setText("");
        this.jLabel3.setText(AG20jFrame.TILES_INVISIBLE);
        this.copyFromWindows(frameNumber);
    }
    public void checkLevelTiles() {
        if(testContents(this.jEditorPane1.getText())){
            this.jLabel2.setText(TILES_VISIBLE + STRING_GOOD);
        }
        else {
            this.jLabel2.setText(TILES_VISIBLE + STRING_BAD);
        }
    }
    public void checkObjectTiles() {
        if(testContents(this.jEditorPane2.getText())){
            this.jLabel3.setText(TILES_INVISIBLE + STRING_GOOD);
        }
        else {
            this.jLabel3.setText(TILES_INVISIBLE + STRING_BAD);
        }
    }
    public void printOutput() {
        this.collectContents();
        FileLoader fileLoader = new FileLoader();
        fileLoader.setVisible(true);
        javax.swing.JFileChooser chooser = fileLoader.getFileChooser();
        
        int returnValue = chooser.showSaveDialog(this);//showOpenDialog(this);
        if (returnValue == JFileChooser.APPROVE_OPTION) {
            File file = chooser.getSelectedFile();
            
            windowName = file.getAbsolutePath();
            this.copyFromWindows(this.frameNumber);
            AG20XML printer = new AG20XML(this.windowName , mList);
            printer.writeOutputFile();
            
        } 
        else {
            System.out.println("File access cancelled by user.");
        }
        fileLoader.setVisible(false);
        
    }
    
    public void collectContents() {
        for(int j = 0; j < this.mList.size(); j ++) {
            if (this.mList.get(j).challengeList != null) {
                this.mList.get(j).mChallenge = this.mList.get(j).challengeList.returnList;
                this.mList.get(j).challengeList.dispose();
            }
            if (this.mList.get(j).specialList != null) {
                this.mList.get(j).mSpecial = this.mList.get(j).specialList.returnList;
                this.mList.get(j).specialList.dispose();
            }
            if (this.mList.get(j).mazeList != null) {
                this.mList.get(j).mMazeData = this.mList.get(j).mazeList.returnList;
                // collect maze data!!
                
                this.mList.get(j).mazeList.dispose();
            }
            if (this.mList.get(j).textList != null) {
                this.mList.get(j).mTextMessage = this.mList.get(j).textList.returnListText;
                this.mList.get(j).mTextNum = this.mList.get(j).textList.returnListNums;
                for (int q = 0; q<this.mList.get(j).mTextMessage.size() ; q ++) {
                    System.out.println(" message: " + this.mList.get(j).mTextMessage.get(q));
                }
                //this.mList.get(j).textList.dispose();
            }
        }
        

    }
    
    public boolean testContents( String testmeString) {
        boolean hasSize = false;
        StringTokenizer mObjectToken = new StringTokenizer(testmeString,",");
	int mTotalTokens = mObjectToken.countTokens();
        if ( mTotalTokens == 192*32) hasSize = true;
        return hasSize;
    }
    
    public void addFrame() {
        this.mList.add(new LevelData());
    }
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();
        jButton4 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jEditorPane1 = new javax.swing.JEditorPane();
        jScrollPane2 = new javax.swing.JScrollPane();
        jEditorPane2 = new javax.swing.JEditorPane();
        jButton6 = new javax.swing.JButton();
        jButton7 = new javax.swing.JButton();
        jLabel4 = new javax.swing.JLabel();
        jButton8 = new javax.swing.JButton();
        jButton9 = new javax.swing.JButton();
        jButton10 = new javax.swing.JButton();
        jButton11 = new javax.swing.JButton();
        jButton12 = new javax.swing.JButton();
        jLabel5 = new javax.swing.JLabel();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenuItem3 = new javax.swing.JMenuItem();
        jMenu2 = new javax.swing.JMenu();
        jMenuItem1 = new javax.swing.JMenuItem();
        jMenuItem2 = new javax.swing.JMenuItem();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("Awesomeguy 2.0 XML");

        jLabel2.setText("Level Info:");

        jLabel3.setText("Object Info:");

        jButton1.setText("Clear");
        jButton1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton1MouseClicked(evt);
            }
        });

        jButton2.setText("Clear");
        jButton2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton2MouseClicked(evt);
            }
        });

        jButton3.setText("^--UP--^");
        jButton3.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton3MouseClicked(evt);
            }
        });

        jButton4.setText("V-DOWN-V");
        jButton4.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton4MouseClicked(evt);
            }
        });

        jButton5.setText("OUTPUT");
        jButton5.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton5MouseClicked(evt);
            }
        });

        jLabel1.setText("jLabel1");

        jScrollPane1.setViewportView(jEditorPane1);

        jScrollPane2.setViewportView(jEditorPane2);

        jButton6.setText("Check");
        jButton6.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton6MouseClicked(evt);
            }
        });

        jButton7.setText("Check");
        jButton7.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton7MouseClicked(evt);
            }
        });

        jLabel4.setText("Frame:");

        jButton8.setText("MAZES");
        jButton8.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton8MouseClicked(evt);
            }
        });

        jButton9.setText("TEXT");
        jButton9.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton9MouseClicked(evt);
            }
        });

        jButton10.setText("CHALLENGE");
        jButton10.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton10MouseClicked(evt);
            }
        });

        jButton11.setText("SPECIAL");
        jButton11.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton11MouseClicked(evt);
            }
        });

        jButton12.setText("NEW");
        jButton12.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton12MouseClicked(evt);
            }
        });

        jLabel5.setText("0");

        jMenu1.setText("File");

        jMenuItem3.setText("open file");
        jMenuItem3.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jMenuItem3MouseReleased(evt);
            }
        });
        jMenu1.add(jMenuItem3);

        jMenuBar1.add(jMenu1);

        jMenu2.setText("Edit");

        jMenuItem1.setText("set size");
        jMenu2.add(jMenuItem1);

        jMenuItem2.setText("preferences");
        jMenu2.add(jMenuItem2);

        jMenuBar1.add(jMenu2);

        setJMenuBar(jMenuBar1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel2)
                            .addComponent(jLabel3))
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jLabel4)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel5)
                                .addGap(41, 41, 41))
                            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 378, Short.MAX_VALUE)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButton3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jButton8)
                                        .addGap(0, 0, Short.MAX_VALUE)))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButton4)
                                    .addComponent(jButton10))
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addGap(6, 6, 6)
                                        .addComponent(jButton9)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButton11))
                                    .addGroup(layout.createSequentialGroup()
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButton5)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButton12)))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButton2, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton6, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton7, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel1)
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel4)
                            .addComponent(jLabel5))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jButton1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButton6))
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 73, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(12, 12, 12)
                .addComponent(jLabel3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jButton2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButton7))
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 66, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton4)
                    .addComponent(jButton3)
                    .addComponent(jButton5)
                    .addComponent(jButton12))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton9)
                    .addComponent(jButton10)
                    .addComponent(jButton11)
                    .addComponent(jButton8))
                .addContainerGap(16, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton1MouseClicked
        this.clearLevelTiles();
    }//GEN-LAST:event_jButton1MouseClicked

    private void jButton2MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton2MouseClicked
        this.clearObjectTiles();
    }//GEN-LAST:event_jButton2MouseClicked

    private void jButton3MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton3MouseClicked
        this.decrementFrameNum();
    }//GEN-LAST:event_jButton3MouseClicked

    private void jButton4MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton4MouseClicked
        this.incrementFrameNum();
    }//GEN-LAST:event_jButton4MouseClicked

    private void jButton6MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton6MouseClicked
        this.checkLevelTiles();
    }//GEN-LAST:event_jButton6MouseClicked

    private void jButton7MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton7MouseClicked
        this.checkObjectTiles();
    }//GEN-LAST:event_jButton7MouseClicked

    private void jButton5MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton5MouseClicked
        this.printOutput();
    }//GEN-LAST:event_jButton5MouseClicked

    private void jMenuItem3MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenuItem3MouseReleased
        FileLoader fileLoader = new FileLoader();
        fileLoader.setVisible(true);
        javax.swing.JFileChooser chooser = fileLoader.getFileChooser();
        int returnValue = chooser.showOpenDialog(this);
        if (returnValue == JFileChooser.APPROVE_OPTION) {
            File file = chooser.getSelectedFile();
            
            windowName = file.getAbsolutePath();
            this.parseXML();

        } 
        else {
            System.out.println("File access cancelled by user.");
        }
        fileLoader.setVisible(false);
    }//GEN-LAST:event_jMenuItem3MouseReleased

    private void jButton8MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton8MouseClicked
        // TODO add your handling code here: MAZES
        if (this.mList.get(this.frameNumber).mazeList == null) {
            this.mList.get(this.frameNumber).mazeList = new AG20jFrameMaze( "Planet: "+ this.frameNumber + " MAZES ", 
                    this.mList.get(this.frameNumber).mMazeData, this);
        }

        this.mList.get(this.frameNumber).mazeList.setVisible(true);
    }//GEN-LAST:event_jButton8MouseClicked

    private void jButton10MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton10MouseClicked
        // TODO add your handling code here: CHALLENGE
        if (this.mList.get(this.frameNumber).challengeList == null) {
            this.mList.get(this.frameNumber).challengeList = new AG20jFrameList("Challenge", 
                    this.mList.get(this.frameNumber).mChallenge, this);
        }

        this.mList.get(this.frameNumber).challengeList.setVisible(true);
    }//GEN-LAST:event_jButton10MouseClicked

    private void jButton9MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton9MouseClicked
        // TODO add your handling code here: TEXT
        if (this.mList.get(this.frameNumber).textList == null) {
            this.mList.get(this.frameNumber).textList = new AG20jFrameText("TEXT", 
                    this.mList.get(this.frameNumber).mTextMessage, 
                    this.mList.get(this.frameNumber).mTextNum, this);
        }

        this.mList.get(this.frameNumber).textList.setVisible(true);
    }//GEN-LAST:event_jButton9MouseClicked

    private void jButton11MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton11MouseClicked
        // TODO add your handling code here: SPECIAL
        if (this.mList.get(this.frameNumber).specialList == null) {
            this.mList.get(this.frameNumber).specialList = new AG20jFrameList("Special", 
                    this.mList.get(this.frameNumber).mSpecial, this);
        }

        this.mList.get(this.frameNumber).specialList.setVisible(true);
    }//GEN-LAST:event_jButton11MouseClicked

    private void jButton12MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton12MouseClicked
        // TODO add your handling code here: NEW
        this.addFrame();
    }//GEN-LAST:event_jButton12MouseClicked

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(AG20jFrame.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(AG20jFrame.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(AG20jFrame.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(AG20jFrame.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        if (args.length > 0) {
            windowName = new String( args[0].toString());
        }
        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new AG20jFrame().setVisible(true);
            }
        });
        //FlyerjFrame F = new FlyerjFrame();
        
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton10;
    private javax.swing.JButton jButton11;
    private javax.swing.JButton jButton12;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButton8;
    private javax.swing.JButton jButton9;
    private javax.swing.JEditorPane jEditorPane1;
    private javax.swing.JEditorPane jEditorPane2;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem2;
    private javax.swing.JMenuItem jMenuItem3;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    // End of variables declaration//GEN-END:variables
}