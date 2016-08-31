import java.sql.*;
import java.util.ArrayList;
import java.util.Map;
import java.io.FileWriter;
import java.io.IOException;

//import java.util.Collections;


/**
 * Course Experience App (ExportCEA), Summer 2016 CSC343.
 *
 * Usage instructions:
 * 1. Ensure the Student and Course tables have data in them.
 * 2. Create the executable from the command line: java -jar ExportCEA.jar
 *
 * TODO: extract this database logic to a new 'Model' class.
 */
@SuppressWarnings("Duplicates")
public class ExportCEA {

    private static final String PROGRAM_NAME = "ExportCEA";
    private static final String CSV_EXPORT_FILENAME = "CEA_export.csv";
    // A connection to the database
    private static Connection connection;

    /**
     * On init, the constructor:
     * Find sqlite DMBS driver.
     */
    public ExportCEA() {
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
     * Logic to run all the logic to reduce spagetti code.
     */
    public static int exportController() {

        // Get the result of the query.
        ArrayList<String> exp_arr = export();

        // Invoke logic to export.
        // Return success-state to caller.
        return exportCSV(exp_arr);
    }


    /**
     * Returns a list of the result of a big export query across many tables
     * in the database.
     * Returns empty ArrayList when there are no Students.
     *
     * Row contents:
         Course number (with department code)
         Course start date
         Course end date
         Time of day
         Total number of students
         Name of the course instructor(s): one or many delimited by |
         Student user name
         Course grade
         Student age
         Student year and month of birth, space delimited
         Student gender
         Student country of birth
         List of skills acquired outside academia in form of skill-rank pair, delimited by |
         Student start date at the University
         Course satisfaction
         Instructor ranking
         List of skills learned in the course: in form of skill - rank before- rank after, delimited by |
         List of topics learned in the course: in form of topic-interest before-interest after,
         delimited by |
     *
     * @return         a sorted list of names of Students in the database.
     */
    public static ArrayList<String> export() {

        ArrayList<String> result = new ArrayList<String>();
        PreparedStatement ps = null;

        try {

            if (connection == null) {
                return result;
            }

            // Create the VIEW and enter it into the db.
            Log.info("Creating the VIEW first.");
            Statement view_stmt = connection.createStatement();

            String view_string = "DROP VIEW IF EXISTS editions_students;\n" +
            "CREATE VIEW editions_students AS\n" +
            "SELECT *\n" +
            "FROM (\n" +
            "    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names\n" +
            "    FROM edition\n" +
            "    JOIN teaches USING(eid)\n" +
            "    GROUP BY eid\n" +
            "    ORDER BY eid\n" +
            ")\n" +
            "-- Join...\n" +
            "JOIN (\n" +
            "    SELECT eid, sid, final_grade\n" +
            "    FROM takes\n" +
            ") USING (eid);  -- join by the course edition.";

            view_stmt.executeUpdate(view_string);

            // Then, we can use the VIEW in the following query.

            String query = "-- Join the VIEW with new tables...\n" +
            "-- this select below is just to remove the eid at the end ._.\n" +
            "SELECT course, course_start, course_end, offer_time, enrollno, " +
            "instr_names, sid, final_grade, age, dob, gender, country, " +
            "skills, uni_start_date, overall_sat, instr_sat, " +
            "all_skills_rankings, all_topics_rankings\n" +
            "FROM editions_students\n" +
            "-- Join...\n" +
            "JOIN (\n" +
            "    SELECT sid, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob, gender, country\n" +
            "    FROM student\n" +
            ") USING(sid)  -- join by the student id.\n" +
            "-- Join...\n" +
            "JOIN (\n" +
            "    SELECT sid, GROUP_CONCAT(skill, '|') as skills\n" +
            "    FROM Employs\n" +
            "    GROUP BY sid\n" +
            ") USING(sid)  -- join by the student id.\n" +
            "-- Join...\n" +
            "JOIN (\n" +
            "    SELECT sid, start_year || '-' || start_month as uni_start_date\n" +
            "    FROM student\n" +
            ") USING(sid)  -- join by the student id.\n" +
            "-- Join...\n" +
            "JOIN (\n" +
            "    SELECT DISTINCT eid, sid, overall_sat, instr_sat\n" +
            "    FROM experiences\n" +
            ") USING(sid, eid)  -- join by the 'satisfaction' per student (sid) in an edition (eid).\n" +
            "-- Join...\n" +
            "JOIN (\n" +
            "    SELECT sid, eid, GROUP_CONCAT(skills_rank, '|') as all_skills_rankings\n" +
            "    FROM (\n" +
            "        SELECT sid, eid, skill || '-' || skill_before || '-' || skill_after as skills_rank\n" +
            "        FROM experiences\n" +
            "    )\n" +
            "    GROUP BY sid, eid\n" +
            ") USING(sid, eid)  -- join by student (sid) in an edition (eid).\n" +
            "-- Join...\n" +
            "JOIN (\n" +
            "    -- Group topic_formatted for each course edition (eid).\n" +
            "    SELECT sid, eid, GROUP_CONCAT(topic_formatted, '|') as all_topics_rankings\n" +
            "    FROM (\n" +
            "        -- Format into: topic-interest_before-interest_after, delimited by |\n" +
            "        SELECT DISTINCT sid, eid, topic || '-' || interest_before || '-' || interest_after as topic_formatted\n" +
            "        FROM (\n" +
            "            -- Table combines: course, student, skills, interest ratings, topic.\n" +
            "            SELECT *\n" +
            "            FROM covers, experiences\n" +
            "            WHERE SUBSTR(eid, 1, 6) = dept_code || courseno\n" +
            "        )\n" +
            "    )\n" +
            "    GROUP BY sid, eid\n" +
            ") USING(sid, eid);  -- join by student (sid) in an edition (eid).";

            ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            // Iterate over ResultSet and print items, and add items to array.
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnsNumber = rsmd.getColumnCount();
            Log.info("columnsNumber: " + columnsNumber);
            Log.info("PRINTING QUERY...");
            while (rs.next()) {
                String line_item = "";
                for (int i = 1; i <= columnsNumber; i++) {
                    if (i > 1) line_item += ", ";
                    String columnValue = rs.getString(i);
                    Log.info(rsmd.getColumnName(i) + ": " + columnValue);
                    line_item += columnValue;
                }
                Log.info("\n");
                result.add(line_item);
            }

        } catch (SQLException e) {
            Log.error("DB getStudents Failed. " + e.getMessage());
            e.printStackTrace();
        } finally {
            closePreparedStatement(ps);
        }

        return result;
    }


    /**
     * Export all rows of a query to a CSV file: CEA_export.csv
     *
     * Returns the number of rows written to file, or -1 if none.
     *
     * Expects comma-separated items in the array.
     */
    public static int exportCSV(ArrayList<String> export_data) {

        FileWriter writer = null;
        int count = 0;

        try {
            // creates new file.
            writer = new FileWriter(CSV_EXPORT_FILENAME);

            // Write to the file.
            for (String str : export_data) {
                writer.write(str + "\n");
                count++;
            }
        } catch (IOException e) {
            Log.error("Failed to write to CSV file. " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            if (writer != null) {
                try {
                    writer.flush();
                    writer.close();
                } catch (IOException e) {
                    Log.error("Failed to close CSV file. " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }

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
     * Connect to the database, and create the GUI View.
     * @param args
     */
    public static void main(String[] args) {
        final String DB = "jdbc:sqlite:data/cea.db";
        final String USER = "";
        final String PASS = "";
        ExportCEA exportCea = new ExportCEA();
        boolean connSuccess = exportCea.connectDB(DB, USER, PASS);
        if (!connSuccess) {
            Log.error("Database Connection Failed.");
            System.exit(1);
        }

        // Construct the UI View.
        View view = new View();
    }
}
