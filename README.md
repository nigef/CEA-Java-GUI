# Course Experience App (ExportCEA)

## Usage Instructions


## Update for the assignment, from the instructor
Due to a number of students that were unable to open ssh tunnel to dbserv1 and use it from their JDBC application, the solution is to develop your JDBC code using a local SQLite database (which is also required for this assignment), and then copy your code into home directory on cdf, and run it from dbserv1 for the final test. It should work exactly the same as for SQLite just using a different properties file. The connection string in postgre properties file still can refer to a localhost. This note does not apply to those who were able to run a JDBC application using SSH tunnel

Copy the `.sql` postgres file into the `.db` file that sqlite3 uses. cd into the dir and:

```bash
sqlite3 cea.db < CEA_db_sqlite.sql
```

Common way to start the GUI is to run the `main()` in `CEA.java` file in an IDE like IntelliJ.

Note you can dump the sqlite3 table at any time with the command:

```bash
sqlite3 cea.db .dump > cea_data_with_experience_dump.sql
```

## Sqlite3 in Terminal

To run an sqlite3 db just from the terminal:
```bash
sqlite3 <your_db_name.db>
```

then you can see all the tables (if any) with:
```bash
.tables

student1|CSC207FD|design principles|5|5|2|4|4|4
student1|CSC209FE|c programming skills|3|4|3|4|4|4
```

if you want to change the separators you can:
```bash
.separator ", "

student1, CSC207FD, design principles, 5, 5, 2, 4, 4, 4
student1, CSC209FE, c programming skills, 3, 4, 3, 4, 4, 4
```

for very many columns, you could use the line mode:
```bash
.mode line

            sid = student1
            eid = CSC209FE
          skill = c programming skills
    overall_sat = 3
      instr_sat = 4
   skill_before = 3
    skill_after = 4
interest_before = 4
 interest_after = 4
```

to turn on pretty-printed columns and headings:
```bash
.mode column    # options: list, line, column
.headers on

sid         eid         skill              overall_sat  instr_sat   skill_before  skill_after  interest_before  interest_after
----------  ----------  -----------------  -----------  ----------  ------------  -----------  ---------------  -------------- 
student1    CSC207FD    design principles  5            5           2             4            4                4             
student1    CSC209FE    c programming ski  3            4           3             4            4                4             
```

note that these settings can be persisted permanently in a file, `/Users/fong/.sqliterc`






## To Make a .jar File in IntelliJ

File -> Project Structure -> Project Settings -> Artifacts -> Click Plus -> type: Jar -> From modules with dependencies...

check build on make -- the box under directory.

Extract to the target Jar

OK

Build | Build Artifact

then have to do `Build >>> Make`


## Making the 'Export' .jar File in IntelliJ with a Different Module

Open the project you want to add a module to, and select File -> New -> Module...

We made the module `CEA_x` which uses the same `data/cea.db` database.

The `CEA_x.jar` writes the result of the export to the file `CEA_export.csv`



## Models
* Uses `sqlite3` database

## Views
* Uses `Java Swing` Library, which is based on `AWT`.

## Notes
- This app does not use packages or organize classes, since its so tiny.


## Improvements
- The app was meant to collect before/after ratings for each topic as well.
- Important (RE: database design): There should be a separate table to store the before/after ratings for each skill. And there should be a separate table to store the skills, where each skill is unique and has a numerical primary key. Then, the `Acquires` table can reference the numerical primary key from the new skill table. Therefore we wont have so many repeated attributes like in `Experiences(sid, eid, skill, skillBefore, skillAfter, overallSat, instrSat, InterestBefore, InterestAfter)` for each skill these are repeated: overallSat, instrSat, InterestBefore, InterestAfter
- Important (RE: portability): right now there are some DBMS-specific code in the JDBC, like the sqlite3 function, `GROUP_CONCAT()`. Anything like this that cannot be done with generic SQL in all common DBMS (like oracle, postres, sqlite, ...) should be done in Java.
- TODO: if student/edition already exists in `Experiences` table, entering again should do an sql UPDATE on that information.
- TODO: add the export code into the same CEA app view.
- TODO: make more descriptive 'fail' messages when the buttons are clicked.


## Extensions (Drivers)

Ensure the drivers are installed on the system.
In my system I had the following driver files in my path, `/Library/Java/Extensions`

- postgresql-8.4-703.jdbc4.jar
- sqlite-jdbc-3.8.11.2.jar



## Documentation

### Swing Components
http://www.java2s.com/Tutorial/Java/0240__Swing/Catalog0240__Swing.htm

### Tons of Oracle Pages (not shown..)
https://docs.oracle.com/javase/8/docs/api/java/sql/PreparedStatement.html

### Sqlite3
https://www.sqlite.org/cli.html

### Sqlite3 Commands
https://www.sqlite.org/cli.html#section_3

### Formatting sqlite3 Terminal Outputs
https://www.sqlite.org/sessions/sqlite.html




