import java.sql.*;
import java.util.ArrayList;
//import java.util.Collections;
import java.util.Map;


/**
 * Course Experience App (CEA), Summer 2016 CSC343.
 *
 * Usage instructions:
 * 1. Ensure the Student and Course tables have data in them.
 * 2. Create the executable from the command line: java -jar CEA.jar
 *
 * TODO: extract this database logic to a new 'Model' class.
 */
public class CEA {

    private static final String PROGRAM_NAME = "CEA";
    // A connection to the database
    private static Connection connection;
    // Reference to our data structure related by the GUI.
    private static Experience exp;

    /**
     * Find sqlite DMBS driver.
     */
    public CEA() {
        try {
            Class.forName("org.sqlite.JDBC");  // Driver name.
        } catch (ClassNotFoundException e) {
            Log.error("Failed to find JDBC sqlite driver. " +
                                e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Establishes a connection to be used for this session, assigning it to
     * the instance variable 'connection'.
     *
     * @param  url       the url to the database
     * @param  username  the username to connect to the database
     * @param  password  the password to connect to the database
     * @return           true if the connection is successful, false otherwise
     */
    public boolean connectDB(String url, String username, String password) {
        try {
            connection = DriverManager.getConnection(url, username, password);
            // Note if this was postgres, this is where we would execute,
            // 'SET search_path TO...'
        } catch (SQLException e) {
            Log.error("DB Connection Failed. " + e.getMessage());
            e.printStackTrace();
            return false;
        }
        System.out.println("Connected Successfully.");
        return true;
    }

    /**
     * Closes the database connection.
     *
     * @return true if the closing was successful, false otherwise
     */
    public static boolean disconnectDB() {
        try {
            connection.close();
        } catch (SQLException e) {
            Log.error("Close-connection Failed. " + e.getMessage());
            e.printStackTrace();
            return false;
        }
        return true;
    }


    /**
     * Returns a sorted list of the names of all Students in the database.
     * Returns false when there are no Students.
     *
     * NOTES:
     * 1. The names should be taken directly from the database,
     *    without any formatting. (So the form is 'Pitt, Brad')
     * 2. Use Collections.sort() to sort the names in ascending
     *    alphabetical order.
     *
     * @return         a sorted list of names of Students in the database.
     */
    public static String[] getStudents() {

        String[] ret = null;
        ArrayList<String> result = new ArrayList<String>();
        PreparedStatement ps = null;

        try {

            if (connection == null) {
                return ret;
            }
            String insertString = "SELECT DISTINCT sid " +
                                  "FROM Student;";
            ps = connection.prepareStatement(insertString);
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                String sid = rs.getString("sid");
                result.add(sid);
            }

            ret = arrListToStringArr(result);  // Downcast/Convert to String[]

        } catch (SQLException e) {
            Log.error("DB getStudents Failed. " + e.getMessage());
            e.printStackTrace();

        } finally {
            closePreparedStatement(ps);
        }

        return ret;
    }


    /**
     * Returns a sorted list of all available Course 'eid' for a student in the database.
     * Returns empty array when there are no Courses.
     *
     * NOTES:
     * 1. The courses should be taken directly from the database,
     *    without any formatting. (So the form is _________)
     * 2. Use Collections.sort() to sort the names in ascending
     *    alphabetical order.
     *
     * @param          sid of the student.
     * @return         a sorted list of names of Courses in the database.
     */
    public static String[] getCourses(String sid) {

        String[] ret = null;
        ArrayList<String> result = new ArrayList<String>();
        PreparedStatement ps = null;

        try {

            if (connection == null || sid.equals("")) {
                return ret;
            }
            String insertString = "SELECT DISTINCT eid " +
                                    "FROM Takes " +
                                    "WHERE sid = ?;";
            ps = connection.prepareStatement(insertString);
            ps.setString(1, sid);
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                result.add(rs.getString("eid"));
            }

            // Downcast/Convert to String[]
            ret = arrListToStringArr(result);  // Downcast/Convert to String[]

        } catch (SQLException e) {
            Log.error("DB getCourses Failed. " + e.getMessage());
            e.printStackTrace();
            ret = null;
        } finally {
            closePreparedStatement(ps);
        }

        return ret;
    }


    /**
     * Given the Course edition 'eid', we query the db and return a list of
     * skills for it.
     *
     * This method is invoked by a method in the 'Experience' class,
     * resetByCourses() when the course changes in the GUI.
     *
     * @return
     */
    public static String[] getSkills(String eid) {

        String[] ret = null;
        ArrayList<String> result = new ArrayList<String>();
        PreparedStatement ps = null;

        try {

            if (connection == null || eid.equals("")) {
                return ret;
            }
            String insertString = "SELECT DISTINCT skill " +
                    "FROM Acquires, Edition " +
                    "WHERE Acquires.dept_code = Edition.dept_code " +
                    "AND Acquires.courseno = Edition.courseno " +
                    "AND eid = ?;";

            ps = connection.prepareStatement(insertString);
            ps.setString(1, eid);
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                result.add(rs.getString("skill"));
            }

            ret = arrListToStringArr(result);  // Downcast/Convert to String[]

        } catch (SQLException e) {
            Log.error("DB getSkills Failed. " + e.getMessage());
            e.printStackTrace();
            ret = null;
        } finally {
            closePreparedStatement(ps);
        }

        return ret;
    }


    /**
     * INSERT INTO the Experiences table when the. Called from the GUI when
     * all fields are filled out, and ready to be inserted into the db.
     *
     * The 'Experience' data structure is used as an intermediate between the
     * GUI and the db.
     *
     * http://www.mkyong.com/jdbc/jdbc-preparedstatement-example-batch-update/
     *
     * @return  the number of skills inserted, if the operation was successful,
     *          or -1 otherwise.
     */
    public static int experience() {

        int count = 0;
        PreparedStatement ps = null;

        if (connection == null) {
            return -1;
        }

        try {

            String insertString = "INSERT INTO Experiences " +
                    "(sid, eid, skill, skill_before, skill_after, " +
                    "overall_sat, instr_sat, interest_before, interest_after) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            // Insert for every skill.
            String sid = exp.getSid();
            String eid = exp.getEid();
            Map<String, int[]> skills = exp.getSkillsFull();
            int overallSat = exp.getSatisfaction();
            int instrSat = exp.getInstructorRanking();
            int interestBefore = exp.getInterestBefore();
            int interestAfter = exp.getInterestAfter();

            ps = connection.prepareStatement(insertString);

            // For each skill in the Experience object.
            for ( String skillKey : skills.keySet() ) {
                int skillBefore = skills.get(skillKey)[0];
                int skillAfter = skills.get(skillKey)[1];

                ps.setString(1 , sid);
                ps.setString(2 , eid);
                ps.setString(3 , skillKey);
                ps.setInt(4 , skillBefore);
                ps.setInt(5 , skillAfter);
                ps.setInt(6 , overallSat);
                ps.setInt(7 , instrSat);
                ps.setInt(8 , interestBefore);
                ps.setInt(9 , interestAfter);

                // Add statement to be committed.
                ps.addBatch();
            }

            // https://docs.oracle.com/javase/8/docs/api/java/sql/Statement.html#executeBatch
            int[] successArrayCount = ps.executeBatch();

            for (int item : successArrayCount) {
                // A number greater than or equal to zero indicates that the
                // command was processed successfully.
                if (item > 0) {
                    count++;
                }
            }

        } catch (SQLException e) {
            Log.error("DB INSERT Failed. " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            closePreparedStatement(ps);
        }
        System.out.println("DB INSERT(s) Successful, count: " + count);
        return count;
    }


    /**
     * Getter to share the name of this app/program.
     * @return  PROGRAM_NAME  name of program.
     */
    public static String getProgramName() {
        return PROGRAM_NAME;
    }


    /**
     * Close PreparedStatement to prevent memory leakage.
     * Helper function for many methods.
     */
    private static void closePreparedStatement(PreparedStatement ps) {
        try {
            if (ps != null) {
                ps.close();
            }
        } catch (SQLException e) {
            Log.error("PreparedStatement Close Failed. " + e.getMessage());
            e.printStackTrace();
        }
    }


    /**
     * Helper function to Downcast/Convert to String[] array types.
     *
     * @param       input       ArrayList to convert to String[]
     * @return      ret         The new String[].
     */
    private static String[] arrListToStringArr(ArrayList<String> input) {
        String[] ret = new String[input.size()];  // Construct.
        ret = input.toArray(ret);  // Call ArrayList method.
        return ret;
    }


    public ArrayList<String> testQuery() {
        PreparedStatement pStatement = null;
        ResultSet rs;
        ArrayList<String> result = new ArrayList<String>();
        String queryString = "SELECT * FROM Course;";
        try {
            pStatement = connection.prepareStatement(queryString);
            rs = pStatement.executeQuery();
            // Iterate through the result set and append each tuple.
            while (rs.next()) {
                String dept_code = rs.getString("dept_code");
                int num = rs.getInt("courseno");
                result.add(dept_code + ":" + num + "\n");
            }
        } catch (SQLException e) {
            Log.error("Query Failed. " + e.getMessage());
            e.printStackTrace();
        } finally {
            closePreparedStatement(pStatement);
        }
        return result;
    }


    public void export() {
        /* to get all pairs of eid */
//        select sid, eid from takes

        /* let java to loop through each pair (eidi, sidi),
        and for each pair, do the following queries , then concat appropriately*/
//        select dept_code, courseno, start_date, end_date, offer_time, enrollno
//        from edition
//        where eid = "eidi";

//        select instr_name
//        from teaches
//        where eid = "eidi";

//        select final_grade
//        from takes
//        where eid = "eidi";

//        select age, birth_month, birth_year, gender, country
//        from student
//        where sid = "sidi";

//        select skill, sklevel
//        from employs
//        where sid = "sidi";

//        select start_month, start_year
//        from student
//        where sid = "sidi";

//        select overall_sat, instr_sat
//        from experiences
//        where sid = "sidi" and eid = "eidi";

//        select skill, skill_before, skill_after
//        from experiences
//        where sid = "sidi" and eid = "eidi";

    }


    /**
     * Experience object temporarily stores the data input from user.
     *
     * @return  Experience object.
     */
    public static Experience getExp() {
        return exp;
    }


    /**
     * Connect to the database, and create the GUI View.
     * @param args
     */
    public static void main(String[] args) {
        final String DB = "jdbc:sqlite:data/cea.db";
        final String USER = "";
        final String PASS = "";
        CEA cea = new CEA();
        boolean connSuccess = cea.connectDB(DB, USER, PASS);
        if (!connSuccess) {
            Log.error("Database Connection Failed.");
            System.exit(1);
        }

        Log.info("Creating the Experience object.");
        exp = new Experience();

        // Construct the UI View.
        View view = new View();
    }
}
