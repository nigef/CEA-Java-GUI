/**
 * Custom log class, to control logging levels, and use statically.
 *
 * Levels in order: Error, Warning, Info.
 */
public class Log {

    // Only log this level or higher. Error, Warning, Info.
    private static final String level = "Info";

    public static void error(String string) {
        System.out.println("ERROR: " + string);
    }

    public static void warn(String string) {
        if (level != "Error") {
            System.out.println("Warning: " + string);
        }
    }

    public static void info(String string) {
        if (level != "Error" && level != "Warn") {
            System.out.println(string);
        }
    }
}
