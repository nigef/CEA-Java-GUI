import java.util.HashMap;
import java.util.Map;
//import java.util.ArrayList;

/**
 * An Experience object stores properties coming from our UI.
 */
public class Experience {

    private String sid = "";
    private String eid = "";
    // Initialized to certain value. Check is set when: value > 0
    private int SLIDER_INITIAL_VALUE_GUI = 4;
    private int satisfaction;
    private int instructorRanking;
    private int interestBefore;
    private int interestAfter;
    // skills are 1-based "indexes" (1 - 5) in skillLevels array.
    // A 2D array of skills initialized: ["skillname", skillBefore, skillAfter]
    // [["Skill1", 0, 0], ["Skill2", 0, 0], ["Skill3", 0, 0]]
    // .. which gets set when all values are non zero:
    Map<String, int[]> skills = null;
    String[] dbSkills = null;
    String[] skillLevels = new String[] {"zero knowledge", "beginner",
                                    "intermediate", "advanced", "professional"};

    /**
     * Initialize the values in the constructor.
     * Sometimes the GUI sets fields in dropdown to null. Other times we
     * set the fields to the empty string.
     */
    public Experience() {
        sid = "";
        eid = "";
        skills = null;
        dbSkills = null;

        resetCourseSliders();
    }

    public String getSid() {
        return sid;
    }

    public void setSid(String sid) {
        resetByStudent();
        this.sid = sid;
    }

    public String getEid() {
        return eid;
    }

    /**
     * Reset the course data according to new eid.
     * Get the new skills associated with the new eid.
     *
     * @param eid   the course/edition id.
     */
    public void setEid(String eid) {
        // Clear the data.
        resetByCourses();

        // set new eid.
        this.eid = eid;

        setSkills();
    }

    public int getSatisfaction() {
        return satisfaction;
    }

    public void setSatisfaction(int satisfaction) {
        this.satisfaction = satisfaction;
    }

    public int getInstructorRanking() {
        return instructorRanking;
    }

    public void setInstructorRanking(int instructorRanking) {
        this.instructorRanking = instructorRanking;
    }

    public String[] getSkillsKeys() {
        return dbSkills;
    }

    public Map<String, int[]> getSkillsFull() {
        return skills;
    }


    /**
     * Called when the Course edition eid is changed: setEid().
     */
    public void setSkills() {
        // TODO see if can be refactored because also called by resetByCourses.
        dbSkills = CEA.getSkills(eid);

        skills = new HashMap<String, int[]>();
        for (String skill : dbSkills) {
            // The sliders start on value 4.
            skills.put(skill, new int[] {SLIDER_INITIAL_VALUE_GUI, SLIDER_INITIAL_VALUE_GUI});
        }
    }

    /**
     *
     * @param skill  Name of skill.
     * @param type   Type of skill ranking, either: "before" or "after".
     */
    public void setSkill(String skill, String type, int value) {
        // Find the properties and set them.
        for ( String key : skills.keySet() ) {
            if (key.equals(skill)) {
                if (type.equals("before")) {
                    skills.put(key, new int[] {value, skills.get(key)[1]});
                } else if (type.equals("after")) {
                    skills.put(key, new int[] {skills.get(key)[0], value});
                } else {
                    Log.error("Unrecognized Skill Ranking Type.");
                }
                break;
            }
        }
    }

    public int getInterestBefore() {
        return interestBefore;
    }

    public void setInterestBefore(int interestBefore) {
        this.interestBefore = interestBefore;
    }

    public int getInterestAfter() {
        return interestAfter;
    }

    public void setInterestAfter(int interestAfter) {
        this.interestAfter = interestAfter;
    }

    /**
     * Check if all fields are set in the data structure for the GUI.
     */
    public boolean isAllSet() {

        // Check that every item in skills ["skillname", skillBefore, skillAfter]
        // is set to non-zero value.
        boolean areAllSkillsSet = true;
        if (skills != null) {
            for ( String key : skills.keySet() ) {
                if (key.equals("")) {
                    Log.error("Empty Skill String.");
                }
                // Log.info(key + ": " + skills.get(key)[0] + ", " + skills.get(key)[1]);
                if (skills.get(key)[0] == 0 || skills.get(key)[1] == 0) {
                    areAllSkillsSet = false;
                }
            }
        } else {
            areAllSkillsSet = false;
        }

        return sid != null && sid != "" && eid != null && eid != "" &&
                areAllSkillsSet && satisfaction != 0 &&
                instructorRanking != 0 && interestBefore != 0 &&
                interestAfter != 0;
    }

    /**
     * Reset data structure when student is changed in GUI.
     */
    public void resetByStudent() {
        eid = "";
        resetByCourses();
    }

    /**
     * Reset to our initial values, according to where the sliders start in
     * the GUI.
     */
    private void resetCourseSliders() {
        satisfaction = SLIDER_INITIAL_VALUE_GUI;
        instructorRanking = SLIDER_INITIAL_VALUE_GUI;
        interestBefore = SLIDER_INITIAL_VALUE_GUI;
        interestAfter = SLIDER_INITIAL_VALUE_GUI;
    }

    /**
     * Reset data structure when course is changed in GUI.
     */
    public void resetByCourses() {

        resetCourseSliders();

        // eid get set to null when student gui dropdown is changed.
        if (eid != "" && eid != null) {  // Course Edition unchanged.
            // set skills by the DB value
            String[] skills = CEA.getSkills(eid);
        } else {  // Changed Student.
            skills = null;
            dbSkills = null;
        }

    }

    @Override
    public String toString() {

        String printSkills = "";
        if (skills != null) {
            for ( String key : skills.keySet() ) {
                printSkills += "\t[" + key + ": " + skills.get(key)[0] +
                                    ", " + skills.get(key)[1] + "],\n";
            }
        } else {
            printSkills = "null";
        }

        return "{" +
                "sid=" + sid +
                ", courseEID=" + eid +
                ", satisfaction=" + satisfaction +
                ", instructorRanking=" + instructorRanking +
                ", interestBefore=" + interestBefore +
                ", interestAfter=" + interestAfter +
                ",\t\n skills=" + printSkills +
                "}\n";
    }
}
