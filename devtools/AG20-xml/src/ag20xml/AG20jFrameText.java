/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ag20xml;

import java.io.*;
import java.util.*;
import javax.swing.*;
/**
 *
 * @author dave
 */
public class AG20jFrameText extends javax.swing.JFrame {

    public static String TILES_LEVEL = "Message Info: ";

    
   static String windowName = new String();
   public int frameNumber = 0;
   public ArrayList<String> mList;
   public ArrayList<Integer> mNums;
   public String mTitle ;
   
   public ArrayList<String> returnListText;
   public ArrayList<Integer> returnListNums;
    /**
     * Creates new form FlyerjFrame
     */
    public AG20jFrameText(String t, ArrayList<String> l, ArrayList<Integer> n) {
        mList = l;
        mNums = n;
        mTitle = t;
        
        initComponents();
        this.parseXML();

    }
    public void parseXML() {
        this.frameNumber = 0;
        jLabel1.setText("Text Messages: ");// + windowName);
        this.jLabel2.setText(AG20jFrameText.TILES_LEVEL);
//        this.jLabel3.setText(FlyerjFrame.TILES_OBJECTS);
//        try {
//            InitBackground.ParseXML backgroundParse = new InitBackground.ParseXML(true, windowName);
            //mList = backgroundParse.getLevelList(true);
            if (mList.size() >= 1) {
                this.copyToWindows(frameNumber);
            }
            else if (mList.size() == 0) {
                mList = new ArrayList<String>();
                mNums = new ArrayList<Integer>();
                this.copyToWindows(frameNumber);
            }
//        }
//        catch (Exception e) {
//            
//        }
    }
    
    public void copyToWindows(int num) {
      this.jEditorPane1.setText(mList.get(num)); 
      //this.jEditorPane2.setText(mList.getObjectTiles(num));
      this.jTextField1.setText(new Integer(mNums.get(num)).toString());
    }
    
    public void copyFromWindows(int num) {
        
        this.mList.set(num, this.jEditorPane1.getText());
        this.mNums.set(num, Integer.parseInt(this.jTextField1.getText().trim()) );
        //System.out.println("#"+ mList.getNum(num) + "#");
    }
    
    public void incrementFrameNum() {
        this.copyFromWindows(frameNumber);
        if (frameNumber + 1 == mList.size()) return;
        frameNumber ++;
        this.copyToWindows(frameNumber);
        this.jLabel2.setText(AG20jFrameText.TILES_LEVEL);
        //this.jLabel3.setText(FlyerjFrame.TILES_OBJECTS);
    }

    public void decrementFrameNum() {
        this.copyFromWindows(frameNumber);
        if (frameNumber == 0) return;
        frameNumber --;
        this.copyToWindows(frameNumber);
        this.jLabel2.setText(AG20jFrameText.TILES_LEVEL);
        //this.jLabel3.setText(FlyerjFrame.TILES_OBJECTS);
    }
    
    public void clearLevelTiles() {
        this.jEditorPane1.setText("");
        this.jLabel2.setText(AG20jFrameText.TILES_LEVEL);
        this.copyFromWindows(frameNumber);
    }
    

    public void saveOutput() {
        this.returnListText = this.mList;
        this.returnListNums = this.mNums;
        this.dispose();
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
        jButton3 = new javax.swing.JButton();
        jButton4 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jEditorPane1 = new javax.swing.JEditorPane();
        jTextField1 = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();

        setTitle("Awesome Flyer XML");
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosed(java.awt.event.WindowEvent evt) {
                formWindowClosed(evt);
            }
        });

        jLabel2.setText("Level Info:");

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

        jButton5.setText("SAVE");
        jButton5.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton5MouseClicked(evt);
            }
        });

        jLabel1.setText("jLabel1");

        jScrollPane1.setViewportView(jEditorPane1);

        jTextField1.setText("      ");

        jLabel4.setText("Frame:");

        jButton1.setText("NEW");
        jButton1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton1MouseClicked(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addGap(0, 0, Short.MAX_VALUE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(96, 96, 96))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel4)
                        .addGap(98, 98, 98))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 118, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton1)
                        .addContainerGap())))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jLabel1)
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jLabel4))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 73, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton3)
                    .addComponent(jButton4)
                    .addComponent(jButton5)
                    .addComponent(jButton1))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton3MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton3MouseClicked
        this.decrementFrameNum();
    }//GEN-LAST:event_jButton3MouseClicked

    private void jButton4MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton4MouseClicked
        this.incrementFrameNum();
    }//GEN-LAST:event_jButton4MouseClicked

    private void jButton5MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton5MouseClicked
        this.saveOutput();
    }//GEN-LAST:event_jButton5MouseClicked

    private void formWindowClosed(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosed
        // TODO add your handling code here:
        this.returnListText = this.mList;
        this.returnListNums = this.mNums;
    }//GEN-LAST:event_formWindowClosed

    private void jButton1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton1MouseClicked
        // TODO add your handling code here: NEW
    }//GEN-LAST:event_jButton1MouseClicked

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
            java.util.logging.Logger.getLogger(AG20jFrameText.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(AG20jFrameText.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(AG20jFrameText.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(AG20jFrameText.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        if (args.length > 0) {
            windowName = new String( args[0].toString());
        }
        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new AG20jFrameText("TEXT",new ArrayList<String>(), new ArrayList<Integer>()).setVisible(true);
            }
        });
        //FlyerjFrame F = new FlyerjFrame();
        
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JEditorPane jEditorPane1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTextField jTextField1;
    // End of variables declaration//GEN-END:variables
}
