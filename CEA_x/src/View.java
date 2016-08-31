//import javax.swing.*;

import javax.swing.*;
//import javax.swing.border.TitledBorder;
//import javax.swing.event.ChangeEvent;
//import javax.swing.event.ChangeListener;
import java.awt.*;
import java.awt.event.*;
//import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.Locale;

// set location on screen
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.Rectangle;


/**
 * TODO: merge into the main CEA.app view.
 *
 * Export View: one button to export a .csv file on the combined tables.
 *
 */
//@SuppressWarnings("Duplicates")
public class View {

    // GUI components
    private JFrame frame;  // The main frame window (aka pane).
    private JPanel mainPanel;  // Add components to main panel in the window.

    /**
     * Invoke the view methods in the constructor.
     */
    public View() {
        Log.info("Creating the Export View.");
        createView();
    }


    /**
     * Create the view components.
     */
    private void createView() {

        frame = new JFrame(ExportCEA.getProgramName());
        // Note: JFrame provides addWindowListener(), and maybe others.
        frame.addWindowListener(onWindowClose());
        frame.setMinimumSize(new Dimension(200, 200));

        // Setup
        mainPanel = new JPanel();
        // BoxLayout either stacks its components on top of each other.
        // [alternate: LINE_AXIS]
        // https://docs.oracle.com/javase/tutorial/uiswing/layout/box.html
        mainPanel.setLayout(new BoxLayout(mainPanel, BoxLayout.PAGE_AXIS));

        // Button ==============================================================
        JPanel buttonPanel = new JPanel();
        buttonPanel.setLayout(new GridLayout());  // empty is full width/height.
        JButton button = new JButton("CLICK TO EXPORT");
        button.addActionListener(buttonListener());
        buttonPanel.add(button);
        mainPanel.add(buttonPanel);

        // Render/Show =========================================================
        renderFrame();
    }


    /**
     * Wrap the JPanel in a scrollable panel.
     * Add to JFrame.
     * Show it.
     */
    private void renderFrame() {
        JScrollPane wrapper = new JScrollPane(mainPanel);  // Make scrollable.

        // add all the components.
        frame.getContentPane().add(wrapper);

        // Size the frame so all contents are at or above their preferred sizes.
        // Layout manager adjusts size to platform dependencies.
        // [Alternatives: setSize or setBounds.]
        frame.pack();

        // Set location on screen (top-right)
        GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
        GraphicsDevice defaultScreen = ge.getDefaultScreenDevice();
        Rectangle rect = defaultScreen.getDefaultConfiguration().getBounds();
        int x = (int) rect.getMaxX() - frame.getWidth();
        int y = 0;
        frame.setLocation(x, y);

        // Make the frame appear onscreen. [Equivalent: show()]
        frame.setVisible(true);
    }


    /**
     * Listener for certain component(s) in the GUI.
     * Button event checks if all fields are set in GUI, and tries to invoke
     * with database logic.
     *
     * @return  ret     an ActionListener with the event logic
     */
    private ActionListener buttonListener() {
        ActionListener ret = new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                // Invoke the export logic.
                int result = ExportCEA.exportController();
                if (result > 0) {
                    String successMsg = "Successfully wrote " + result +
                            " rows to file.";
                    Log.info(successMsg);
                    JOptionPane.showMessageDialog(frame, successMsg);
                } else {
                    String failMsg = "File Write Failed: " + result;
                    Log.error(failMsg);
                    JOptionPane.showMessageDialog(frame, failMsg);
                }
            }
        };
        return ret;
    }


    /**
     * When window closes: close connection, exit application.
     *
     * https://docs.oracle.com/javase/8/docs/api/java/awt/Window.html
     * #addWindowListener-java.awt.event.WindowListener-
     *
     * https://docs.oracle.com/javase/8/docs/api/java/awt/event/WindowListener.html
     * #windowClosing-java.awt.event.WindowEvent-
     *
     * @return  the WindowAdapter object with overridden methods to handle
     *          window events.
     */
    private WindowAdapter onWindowClose() {
        WindowAdapter ret = new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                Log.info("Closing the window.");
                ExportCEA.disconnectDB();

                // Quit the Java app when window closes.
                System.exit(0);
            }
        };
        return ret;
    }

}
