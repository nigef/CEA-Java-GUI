//import javax.swing.*;
import javax.swing.JFrame;
import javax.swing.JComboBox;
import javax.swing.BorderFactory;
import javax.swing.border.TitledBorder;
import javax.swing.BoxLayout;
import javax.swing.JScrollPane;
//import javax.swing.event.*;
import javax.swing.event.ChangeEvent;
//import java.sql.*;
//import java.awt.*;
import javax.swing.JPanel;
import javax.swing.JLabel;
import javax.swing.JSlider;
import javax.swing.JButton;
import javax.swing.JOptionPane;

import javax.swing.event.ChangeListener;
import java.awt.GridLayout;
import java.awt.Component;
//import java.sql.Connection;
//import java.awt.BorderLayout;
import java.awt.Dimension;

import java.awt.event.*;  // WindowAdapter
import java.util.ArrayList;
import java.util.Locale;
//import java.sql.Connection;
//import java.util.ArrayList;
import java.util.Arrays;


/**
 * Created by nigel on 2016-07-02.
 *
 * JFrame provides addWindowListener(), and maybe others.
 */
public class View {

    private Experience exp;

    // GUI components
    private JFrame frame;  // The main frame window (aka pane).
    private JPanel mainPanel;  // Add components to main panel in the window.
    private JPanel studentPanel;
    private JPanel coursePanel;
    private int placeNum;  // Counter for component number in gui.

    /**
     * Invoke the view methods in the constructor.
     */
    public View() {
        // Get exp obj instance from CEA.
        exp = CEA.getExp();

        Log.info("Creating the View.");
        createView();
    }


    /**
     * Create the view components.
     */
    private void createView() {

        initCounter(0);

        frame = new JFrame(CEA.getProgramName());
        frame.addWindowListener(onWindowClose());
        frame.setMinimumSize(new Dimension(600, 680));

        // Setup
        mainPanel = new JPanel();
        studentPanel = new JPanel();
        coursePanel = new JPanel();
        // BoxLayout either stacks its components on top of each other.
        // [alternate: LINE_AXIS]
        // https://docs.oracle.com/javase/tutorial/uiswing/layout/box.html
        mainPanel.setLayout(new BoxLayout(mainPanel, BoxLayout.PAGE_AXIS));
        studentPanel.setLayout(new BoxLayout(studentPanel, BoxLayout.PAGE_AXIS));
        coursePanel.setLayout(new BoxLayout(coursePanel, BoxLayout.PAGE_AXIS));

        // Students ============================================================
        // List of students never changes once initialized.

        // uses students from database.
        mainPanel.add(
            dropPanel("Select Student (Demo, no login)",
                    CEA.getStudents(),
                    studentListener())
        );

        // Render/Show =========================================================
        renderFrame();
    }

    /**
     * Reset number of the components.
     * @param startNum
     */
    private void initCounter(int startNum) {
        placeNum = startNum;  // initialize counter
    }

    /**
     * Update components in View when Student changes.
     */
    private void setViewByStudent() {
        studentPanel.removeAll();
        initCounter(1);

        // Course, Edition =====================================================
        // uses courses from DB, by sid.
        studentPanel.add(
                dropPanel("Select Course",
                        CEA.getCourses(exp.getSid()),
                        courseEdListener())
        );

        // Set components
        setViewByCourse();
        studentPanel.add(coursePanel);
        mainPanel.add(studentPanel);
        studentPanel.revalidate();
    }

    /**
     * Update components in View when Course changes.
     */
    private void setViewByCourse() {
        coursePanel.removeAll();
        String eid = exp.getEid();
        initCounter(2);

        // Hide components when course is not selected.
        if (eid != null && eid != "") {
            // Course Satisfaction =================================================
            coursePanel.add(sliderPanel("Course Satisfaction", satisfactionListener()));

            // Instructor Ranking ==================================================
            coursePanel.add(sliderPanel("Instructor Ranking", instructorListener()));

            // Interest Before =====================================================
            coursePanel.add(sliderPanel("Interest Before Course", interestBeforeListener()));

            // Interest After ======================================================
            coursePanel.add(sliderPanel("Interest After Course", interestAfterListener()));

            // Skills ==============================================================
            // TODO: make skill sliders into dropdowns with options:
            // 1-zero knowledge, 2-beginner, 3-intermediate, 4-advanced, 5-professional
            setSkills();

            // Button ==============================================================
            JPanel buttonPanel = new JPanel();
            buttonPanel.setLayout(new GridLayout(2,0));  // full width; rows, cols.
            JButton button = new JButton("ENTER");
            button.addActionListener(buttonListener());
            buttonPanel.add(button);
            coursePanel.add(buttonPanel);
            coursePanel.revalidate();
        }
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

        // Center frame on screen.
        frame.setLocationRelativeTo(null);

        // Make the frame appear onscreen. [Equivalent: show()]
        frame.setVisible(true);
    }

    /**
     * Set the GUI components for each skill related to a Course Edition.
     */
    private void setSkills() {
        Log.info("Setting skills.");
        String[] skills = exp.getSkillsKeys();

        // Skills are only added to the view when a Course is selected in the gui.
        if (skills != null) {
            JPanel allSkillsPanel = new JPanel();
            allSkillsPanel.setLayout(new BoxLayout(allSkillsPanel, BoxLayout.PAGE_AXIS));
            String panelText = (++placeNum) + ") Rank Skills Before/After";
            allSkillsPanel.setBorder(BorderFactory.createTitledBorder(panelText));

            for (String skill : skills) {
                JPanel pairSkillsPanel = new JPanel();

                // Box layout, and inline:
                pairSkillsPanel.setLayout(new BoxLayout(pairSkillsPanel, BoxLayout.LINE_AXIS));

                // Border types: createLoweredBevelBorder, createEmptyBorder
                pairSkillsPanel.setBorder(BorderFactory.createTitledBorder(
                        BorderFactory.createEmptyBorder(),
                        skill,
                        TitledBorder.CENTER,
                        TitledBorder.DEFAULT_POSITION
                ));

                // ------ Before ------
                pairSkillsPanel.add(sliderPanel(skill, "Before", skillListener(), false));

                // ------ After ------
                pairSkillsPanel.add(sliderPanel(skill, "After", skillListener(), false));

                // Add this to the wrapper panel
                allSkillsPanel.add(pairSkillsPanel);
            }

            // Add skills to the main panel
            coursePanel.add(allSkillsPanel);
        }
    }

    /**
     * Generte the dropdowns from a given list, and attach the event listener.
     *
     * @param   dropString  the name of the panel
     * @param   example     the list of items to add to the dropdown
     * @param   listener    the listener logic
     * @return  tempPanel   the JPanel containing the dropdown component.
     */
    private JPanel dropPanel(String dropString, String[] example,
                                ItemListener listener) {

        //convert String[] to String<Integer>
        ArrayList<String> formattedExample = new ArrayList<String>(Arrays.asList(example));
        // Add empty space at top of dropdown, for a default field.
        formattedExample.add(0, "");

        JComboBox cBox = new JComboBox(formattedExample.toArray());
        cBox.addItemListener(listener);
        JPanel tempPanel = new JPanel();
        // GridLayout manager lays out components in a rectangular grid, divided
        // into equal-sized rectangles, and one component is placed in each
        // rectangle. Args: (int rows, int cols[, int hgap, int vgap])
        // https://docs.oracle.com/javase/7/docs/api/java/awt/GridLayout.html
        tempPanel.setLayout(new GridLayout(1,0));
        tempPanel.add(cBox);
        String panelText = (++placeNum) + ") " + dropString;
        tempPanel.setBorder(BorderFactory.createTitledBorder(panelText));
        return tempPanel;
    }

    /**
     * Set sliders. When function is called with the 'name' arg, it can be
     * used to check the name in a bound listener.
     *
     * Overloaded.
     *
     * @param   name            slider name, used in the listener.
     * @param   sliderString    text to add to header
     * @param   listener        the listener logic
     * @return  tempPanel       the JPanel containing the dropdown component.
     */
    private JPanel sliderPanel(String name, String sliderString, ChangeListener listener, boolean doNums) {
        // Create the label.
        JLabel sliderLabel = new JLabel(sliderString, JLabel.CENTER);
        sliderLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
        // Create the slider.
        // https://docs.oracle.com/javase/8/docs/api/javax/swing/JSlider.html
        int min = 1;
        int max = 5;
        int initial = 4;
        JSlider slider = new JSlider(min, max, initial);
        // Set name.
        slider.setName(name);
        slider.setLocale(new Locale(sliderString)); // "Before", or "After".
        // Turn on labels at major tick marks.
        slider.setMajorTickSpacing(1);
        slider.setSnapToTicks(true);
        slider.setPaintLabels(true);
        slider.addChangeListener(listener);

        JPanel tempPanel = new JPanel();
        tempPanel.setLayout(new BoxLayout(tempPanel, BoxLayout.PAGE_AXIS));
        tempPanel.setLayout(new GridLayout(1,0));
        tempPanel.add(slider);
        String headerText;
        if (doNums) {
            headerText = (++placeNum) + ") ";
        } else {
            headerText = "";
        }
        String panelText = headerText + sliderString;
        tempPanel.setBorder(BorderFactory.createTitledBorder(panelText));
        return tempPanel;
    }


    /**
     * Set sliders. Overloaded.
     *
     * @param   sliderString    text to add to header
     * @param   listener        the listener logic
     * @return  JPanel object   panel contains the slider component.
     */
    private JPanel sliderPanel(String sliderString, ChangeListener listener) {
        // the name is not important here.
        return sliderPanel("name", sliderString, listener, true);
    }


    /**
     * Listener for certain component(s) in the GUI.
     *
     * @return  ret     an ItemListener with the event logic
     */
    private ItemListener studentListener() {
        ItemListener ret = new ItemListener() {
            @Override
            public void itemStateChanged(ItemEvent e) {
                // ItemEvent is a selection event (not deselection).
                if (e.getStateChange() ==  ItemEvent.SELECTED) {
                    JComboBox drop = (JComboBox)e.getSource();
                    String sid = drop.getSelectedItem().toString();
                    Log.info("Student dropdown changed: " + sid);
                    exp.setSid(sid);
                    Log.info("Exp: " + CEA.getExp());

                    Log.info("Updating Student View.");
                    // Set components
                    setViewByStudent();
                    frame.repaint();
                }
            }
        };
        return ret;
    }

    /**
     * Listener for certain component(s) in the GUI.
     *
     * @return  ret     an ItemListener with the event logic
     */
    private ItemListener courseEdListener() {
        ItemListener ret = new ItemListener() {
            public void itemStateChanged(ItemEvent e) {
                // ItemEvent is a selection event (not deselection).
                if (e.getStateChange() ==  ItemEvent.SELECTED) {
                    JComboBox drop = (JComboBox)e.getSource();
                    String eid = drop.getSelectedItem().toString();
                    Log.info("Course Ed. dropdown changed: " + eid);

                    exp.setEid(eid);
                    Log.info("Exp: " + CEA.getExp());

                    Log.info("Updating Course View.");
                    // Set components
                    setViewByCourse();
                    frame.repaint();
                }
            }
        };
        return ret;
    }

    /**
     * Listener for certain component(s) in the GUI.
     *
     * @return  ret     an ChangeListener with the event logic
     */
    private ChangeListener satisfactionListener() {
        ChangeListener ret = new ChangeListener() {
            public void stateChanged(ChangeEvent e) {
                JSlider slider = (JSlider)e.getSource();
                if (!slider.getValueIsAdjusting()) {
                    int value = slider.getValue();
                    Log.info("Satisfaction Slider changed: " + value);
                    exp.setSatisfaction(value);
                    Log.info("Exp: " + CEA.getExp());

                }
            }
        };
        return ret;
    }

    /**
     * Listener for certain component(s) in the GUI.
     *
     * @return  ret     an ChangeListener with the event logic
     */
    private ChangeListener instructorListener() {
        ChangeListener ret = new ChangeListener() {
            public void stateChanged(ChangeEvent e) {
                JSlider slider = (JSlider)e.getSource();
                if (!slider.getValueIsAdjusting()) {
                    int value = slider.getValue();
                    Log.info("Instructor Slider changed: " + value);
                    exp.setInstructorRanking(value);
                    Log.info("Exp: " + CEA.getExp());

                }
            }
        };
        return ret;
    }

    /**
     * Listener for certain component(s) in the GUI.
     *
     * @return  ret     an ChangeListener with the event logic
     */
    private ChangeListener interestBeforeListener() {
        ChangeListener ret = new ChangeListener() {
            public void stateChanged(ChangeEvent e) {
                JSlider slider = (JSlider)e.getSource();
                if (!slider.getValueIsAdjusting()) {
                    int value = slider.getValue();
                    Log.info("interestBefore Slider changed: " + value);
                    exp.setInterestBefore(value);
                    Log.info("Exp: " + CEA.getExp());

                }
            }
        };
        return ret;
    }

    /**
     * Listener for certain component(s) in the GUI.
     *
     * @return  ret     an ChangeListener with the event logic
     */
    private ChangeListener interestAfterListener() {
        ChangeListener ret = new ChangeListener() {
            public void stateChanged(ChangeEvent e) {
                JSlider slider = (JSlider)e.getSource();
                if (!slider.getValueIsAdjusting()) {
                    int value = slider.getValue();
                    Log.info("interestAfter Slider changed: " + value);
                    exp.setInterestAfter(value);
                    Log.info("Exp: " + CEA.getExp());

                }
            }
        };
        return ret;
    }

    /**
     * Listener for certain component(s) in the GUI.
     *
     * @return  ret     an ChangeListener with the event logic
     */
    private ChangeListener skillListener() {
        ChangeListener ret = new ChangeListener() {
            public void stateChanged(ChangeEvent e) {
                JSlider slider = (JSlider)e.getSource();
                String name = slider.getName();
                if (!slider.getValueIsAdjusting()) {
                    int value = slider.getValue();
                    Log.info("skillListener Slider [" + name + ", " +
                                    slider.getLocale() + "] changed: " + value);
                    exp.setSkill(name, slider.getLocale().toString(), value);
                    Log.info("Exp: " + CEA.getExp());
                }
            }
        };
        return ret;
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
                // JButton source = (JButton)e.getSource();
                Log.info("Exp: " + CEA.getExp());
                // When all values are set..
                if (exp.isAllSet()) {
                    // Call DB methods..
                    // TODO: return the array, and log the number of unsuccessful to show.
                    int insertCount = CEA.experience();
                    if (insertCount == -1) {
                        JOptionPane.showMessageDialog(frame, "Insert Failed.");
                    } else {
                        JOptionPane.showMessageDialog(frame, "Number of items " +
                                "successfully inserted: " + insertCount);
                        Log.info("ENTER: Success, All Fields Set, inserted: " +
                                insertCount);
                    }
                } else {
                    JOptionPane.showMessageDialog(frame, "Some is Data Missing.");
                    Log.info("ENTER: Fail, cannot enter, some fields not set in GUI.");
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
                CEA.disconnectDB();

                // Quit the Java app when window closes.
                System.exit(0);
            }
        };
        return ret;
    }

}
