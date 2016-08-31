######################################################################
-- Each row in this table should contain complete information about a particular (course edition – user name pair). The column headers are as follows (be precise):

  Course number (with department code)
  
  Course start date
  
  Course end date
  
  Time of day
  
  Total number of students (in the course edition)
  
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

  List of topics learned in the course: in form of topic-interest before-interest after, delimited by |

######################################################################
The following shows the build-up of each additional item in our query,
like an evolutionary process..
######################################################################
-- Course number (with department code)
-- Edition.dept_code + Edition.courseno
SELECT dept_code || courseno as course
FROM edition;

-- Course start date
-- Edition.start_date
SELECT dept_code || courseno as course, start_date
FROM edition;

-- Course end date
-- Edition.end_date
SELECT dept_code || courseno as course, start_date, end_date
FROM edition;

-- Time of day
-- Edition.offer_time
SELECT dept_code || courseno as course, start_date, end_date, offer_time
FROM edition;

-- Total number of students
-- select Count(Takes.sid)
-- from takes natural join edition
-- group by eid
SELECT eid, dept_code || courseno as course, start_date, end_date, offer_time, enrollno
FROM edition;

-- Name of the course instructor(s): one or many delimited by |
-- select Teaches.instr_name
-- from teaches
-- where eid=___
SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
FROM edition
JOIN teaches USING(eid)
GROUP BY eid
ORDER BY eid;

-- Student user name
-- Takes.sid
SELECT *
-- information on course editions
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- ..join with the takes table (courses students took)...
JOIN (
    SELECT eid, sid
    FROM takes
) USING (eid);


-- Course grade
-- Takes.finalGrade
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.


-- Student age
-- SELECT strftime('%Y', 'now') - birth_year as age

DROP VIEW IF EXISTS editions_students;
CREATE VIEW editions_students AS
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.

-- Join...
SELECT *
FROM editions_students
-- Join...
JOIN (
    SELECT sid, strftime('%Y', 'now') - birth_year as age
    FROM student
) USING(sid);  -- join by the student id.



-- Student year and month of birth, space delimited
-- Student.birth_year, Student.birth_month
-- We use COALESCE() in case its null.

DROP VIEW IF EXISTS editions_students;
CREATE VIEW editions_students AS
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.

-- Join...
SELECT *
FROM editions_students
-- Join...
JOIN (
    SELECT sid, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob
    FROM student
) USING(sid);  -- join by the student id.



-- Student gender
-- Student.gender
DROP VIEW IF EXISTS editions_students;
CREATE VIEW editions_students AS
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.

-- Join...
SELECT *
FROM editions_students
-- Join...
JOIN (
    SELECT sid, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob, gender
    FROM student
) USING(sid);  -- join by the student id.



-- Student country of birth
-- Student.country

DROP VIEW IF EXISTS editions_students;
CREATE VIEW editions_students AS
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.

-- Join...
SELECT *
FROM editions_students
-- Join...
JOIN (
    SELECT sid, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob, gender, country
    FROM student
) USING(sid);  -- join by the student id.


-- List of skills acquired outside academia in form of skill-rank pair, delimited by |
-- select Employs.skill
-- from Employs
-- where sid=_____

DROP VIEW IF EXISTS editions_students;
CREATE VIEW editions_students AS
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.

-- Join...
SELECT *
FROM editions_students
-- Join...
JOIN (
    SELECT sid, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob, gender, country
    FROM student
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, GROUP_CONCAT(skill, '|') as skills
    FROM Employs
    GROUP BY sid
) USING(sid);  -- join by the student id.



-- Student start date at the University
-- Student.startDate
-- SELECT sid, start_year || '-' || start_month as uni_start_date
-- FROM student;

DROP VIEW IF EXISTS editions_students;
CREATE VIEW editions_students AS
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.

-- Join the VIEW with new tables...
SELECT *
FROM editions_students
-- Join...
JOIN (
    SELECT sid, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob, gender, country
    FROM student
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, GROUP_CONCAT(skill, '|') as skills
    FROM Employs
    GROUP BY sid
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, start_year || '-' || start_month as uni_start_date
    FROM student
) USING(sid);  -- join by the student id.




-- Course satisfaction
-- Experiences.overall_sat
-- ...where sid=___

-- SELECT sid, eid, skill, start_year || '-' || start_month as uni_start_date, overall_sat
-- FROM student
-- JOIN experiences USING(sid);

DROP VIEW IF EXISTS editions_students;
CREATE VIEW editions_students AS
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.

-- Join the VIEW with new tables...
SELECT *
FROM editions_students
-- Join...
JOIN (
    SELECT sid, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob, gender, country
    FROM student
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, GROUP_CONCAT(skill, '|') as skills
    FROM Employs
    GROUP BY sid
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, start_year || '-' || start_month as uni_start_date
    FROM student
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT DISTINCT eid, sid, overall_sat
    FROM experiences
) USING(sid, eid);  -- join by the 'satisfaction' per student in an edition.


-- Instructor ranking
-- Experiences.instr_sat
-- ...where sid=___

DROP VIEW IF EXISTS editions_students;
CREATE VIEW editions_students AS
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.

-- Join the VIEW with new tables...
SELECT *
FROM editions_students
-- Join...
JOIN (
    SELECT sid, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob, gender, country
    FROM student
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, GROUP_CONCAT(skill, '|') as skills
    FROM Employs
    GROUP BY sid
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, start_year || '-' || start_month as uni_start_date
    FROM student
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT DISTINCT eid, sid, overall_sat, instr_sat
    FROM experiences
) USING(sid, eid);  -- join by the 'satisfaction' per student in an edition.

-----------------------------------------------------------------------------

-- List of skills learned in the course: in form of skill - rank before- rank after, delimited by |
-- select Experiences.skill
-- from Acquires, Experiences
-- where sid=____

DROP VIEW IF EXISTS editions_students;
CREATE VIEW editions_students AS
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.

-- Join the VIEW with new tables...
SELECT *
FROM editions_students
-- Join...
JOIN (
    SELECT sid, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob, gender, country
    FROM student
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, GROUP_CONCAT(skill, '|') as skills
    FROM Employs
    GROUP BY sid
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, start_year || '-' || start_month as uni_start_date
    FROM student
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT DISTINCT eid, sid, overall_sat, instr_sat
    FROM experiences
) USING(sid, eid)  -- join by the 'satisfaction' per student (sid) in an edition (eid).
-- Join...
JOIN (
    SELECT sid, eid, GROUP_CONCAT(skills_rank, '|') as all_skills
    FROM (
        SELECT sid, eid, skill || '-' || skill_before || '-' || skill_after as skills_rank
        FROM experiences
    )
    GROUP BY sid, eid
) USING(sid, eid);  -- join by student (sid) in an edition (eid).


-- List of topics learned in the course: in form of topic-interest_before-interest_after, delimited by |
-- select Covers.topic
-- from Covers, Experiences
-- where depCode=____, courseNo=___

DROP VIEW IF EXISTS editions_students;
CREATE VIEW editions_students AS
SELECT *
FROM (
    SELECT eid, dept_code || courseno as course, start_date as course_start, end_date as course_end, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
    FROM edition
    JOIN teaches USING(eid)
    GROUP BY eid
    ORDER BY eid
)
-- Join...
JOIN (
    SELECT eid, sid, final_grade
    FROM takes
) USING (eid);  -- join by the course edition.

-- Join the VIEW with new tables...
-- this select below is just to remove the eid at the end ._.
SELECT course, course_start, course_end, offer_time, enrollno, instr_names, sid, final_grade, age, dob, gender, country, skills, uni_start_date, overall_sat, instr_sat, all_skills_rankings, all_topics_rankings
FROM editions_students
-- Join...
JOIN (
    SELECT sid, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob, gender, country
    FROM student
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, GROUP_CONCAT(skill, '|') as skills
    FROM Employs
    GROUP BY sid
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT sid, start_year || '-' || start_month as uni_start_date
    FROM student
) USING(sid)  -- join by the student id.
-- Join...
JOIN (
    SELECT DISTINCT eid, sid, overall_sat, instr_sat
    FROM experiences
) USING(sid, eid)  -- join by the 'satisfaction' per student (sid) in an edition (eid).
-- Join...
JOIN (
    SELECT sid, eid, GROUP_CONCAT(skills_rank, '|') as all_skills_rankings
    FROM (
        SELECT sid, eid, skill || '-' || skill_before || '-' || skill_after as skills_rank
        FROM experiences
    )
    GROUP BY sid, eid
) USING(sid, eid)  -- join by student (sid) in an edition (eid).
-- Join...
JOIN (
    -- Group topic_formatted for each course edition (eid).
    SELECT sid, eid, GROUP_CONCAT(topic_formatted, '|') as all_topics_rankings
    FROM (
        -- Format into: topic-interest_before-interest_after, delimited by |
        SELECT DISTINCT sid, eid, topic || '-' || interest_before || '-' || interest_after as topic_formatted
        FROM (
            -- Table combines: course, student, skills, interest ratings, topic.
            SELECT *
            FROM covers, experiences
            WHERE SUBSTR(eid, 1, 6) = dept_code || courseno
        )
    )
    GROUP BY sid, eid
) USING(sid, eid);  -- join by student (sid) in an edition (eid).

######################################################################