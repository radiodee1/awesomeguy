/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ag20xml;

import java.util.ArrayList;
import java.util.StringTokenizer;

/**
 *
 * @author dave
 */
public class AG20jFrameList extends javax.swing.JFrame {

    String title = new String();
    ArrayList<String> list = new ArrayList<String>();
    ArrayList<String> returnList = new ArrayList<String>();
    public AG20jFrame frame;

    
    /**
     * Creates new form AG20jFrameList
     */
    public AG20jFrameList(String title, ArrayList<String> list, AG20jFrame frame) {
        initComponents();
        this.setBounds(0, 0, 375, 300);
        this.title = title;
        this.list = list;
        this.copyToWindow();
        this.setTitle();
        this.frame = frame;
    }
    
    public void copyToWindow() {
        String text = new String();
        for (int j = 0; j < list.size(); j ++) {
            text = text.concat(list.get(j) + "\n");
        }
        if (text.isEmpty() && this.title.equalsIgnoreCase("challenge")) { 
            text = "5,1,1,2,1,1,0,0 ,0,0,0,0,0,0,0,1";
        }
        this.jEditorPane1.setText(text);
    }

    public void setTitle() {
        this.jLabel1.setText(title + ": " + list.size());
    }
    public void copyFromWindow() {
        returnList = new ArrayList<String>();
        StringTokenizer mToken = new StringTokenizer(this.jEditorPane1.getText().trim(),"\n");
	int mTotalTokens = mToken.countTokens();
        for(int j = 0; j < mTotalTokens; j ++) {
            if (mToken.hasMoreTokens()) {
                returnList.add(mToken.nextToken());
            }
        }
        this.setVisible(false);
    }
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jEditorPane1 = new javax.swing.JEditorPane();
        jButton1 = new javax.swing.JButton();

        setTitle("List Manager");
        addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                formFocusGained(evt);
            }
        });

        jLabel1.setText("jLabel1");

        jScrollPane1.setViewportView(jEditorPane1);

        jButton1.setText("SAVE CHANGES");
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
                    .addComponent(jScrollPane1)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel1)
                            .addComponent(jButton1))
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 224, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton1)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton1MouseClicked
        // TODO add your handling code here: CLOSE
        this.copyFromWindow();
        this.frame.collectContents();
    }//GEN-LAST:event_jButton1MouseClicked

    private void formFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_formFocusGained
        // TODO add your handling code here:
        //this.list = this.returnList;
        //this.copyToWindow();
        //this.setTitle();
    }//GEN-LAST:event_formFocusGained

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
            java.util.logging.Logger.getLogger(AG20jFrameList.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(AG20jFrameList.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(AG20jFrameList.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(AG20jFrameList.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                //new AG20jFrameList("", new ArrayList<String>()).setVisible(true);
            }
        });
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JEditorPane jEditorPane1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JScrollPane jScrollPane1;
    // End of variables declaration//GEN-END:variables
}
