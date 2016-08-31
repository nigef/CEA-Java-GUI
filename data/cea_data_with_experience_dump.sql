
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE Department(
	dept_code varchar(3) PRIMARY KEY,
	name varchar(20) NOT NULL
);
INSERT INTO "Department" VALUES('CSC','Computer Science');
INSERT INTO "Department" VALUES('STA','Statistics');
INSERT INTO "Department" VALUES('MAT','Mathematics');
INSERT INTO "Department" VALUES('ECO','Economics');
CREATE TABLE Course(
	dept_code varchar(3) REFERENCES Department(dept_code),
	courseno int,
	area varchar(50) NOT NULL,
	CHECK (courseno >= 100 and courseno <= 500),
	PRIMARY KEY(dept_code, courseno)
);
INSERT INTO "Course" VALUES('CSC',209,'Sciences');
INSERT INTO "Course" VALUES('CSC',148,'Sciences');
INSERT INTO "Course" VALUES('CSC',165,'Sciences');
INSERT INTO "Course" VALUES('CSC',207,'Sciences');
INSERT INTO "Course" VALUES('STA',247,'Sciences');
INSERT INTO "Course" VALUES('STA',302,'Sciences');
INSERT INTO "Course" VALUES('MAT',223,'Sciences');
INSERT INTO "Course" VALUES('ECO',105,'Arts');
CREATE TABLE Covers(
	dept_code varchar(3),
	courseno int,
	topic varchar(50),
	PRIMARY KEY(dept_code, courseno, topic),
	FOREIGN KEY (dept_code, courseno) REFERENCES Course(dept_code, courseno)
);
INSERT INTO "Covers" VALUES('CSC',209,'c programming');
INSERT INTO "Covers" VALUES('CSC',209,'networks programming');
INSERT INTO "Covers" VALUES('CSC',209,'shell commands');
INSERT INTO "Covers" VALUES('STA',247,'probability');
INSERT INTO "Covers" VALUES('STA',247,'statistical distribution');
INSERT INTO "Covers" VALUES('CSC',165,'induction proofs');
INSERT INTO "Covers" VALUES('CSC',207,'software engineering');
INSERT INTO "Covers" VALUES('CSC',207,'java programming');
INSERT INTO "Covers" VALUES('ECO',105,'supply and demand');
INSERT INTO "Covers" VALUES('ECO',105,'market forces');
INSERT INTO "Covers" VALUES('CSC',148,'algorithms');
INSERT INTO "Covers" VALUES('CSC',148,'recursion');
INSERT INTO "Covers" VALUES('CSC',148,'programming');
INSERT INTO "Covers" VALUES('CSC',309,'javascript');
INSERT INTO "Covers" VALUES('CSC',309,'servers');
INSERT INTO "Covers" VALUES('CSC',309,'design');
CREATE TABLE Acquires(
	dept_code varchar(3),
	courseno int,
	skill varchar(120),
	PRIMARY KEY(dept_code, courseno, skill),
	FOREIGN KEY (dept_code, courseno) REFERENCES Course(dept_code, courseno)
);
INSERT INTO "Acquires" VALUES('CSC',209,'c programming skills');
INSERT INTO "Acquires" VALUES('CSC',209,'shell programming skills');
INSERT INTO "Acquires" VALUES('CSC',209,'networks knowledge and design');
INSERT INTO "Acquires" VALUES('STA',247,'probability theory and application skills');
INSERT INTO "Acquires" VALUES('STA',247,'general statistical analysis');
INSERT INTO "Acquires" VALUES('STA',247,'statistics and calculus (integration)');
INSERT INTO "Acquires" VALUES('CSC',207,'teamwork skills');
INSERT INTO "Acquires" VALUES('CSC',165,'predicate logic');
INSERT INTO "Acquires" VALUES('CSC',165,'induction');
INSERT INTO "Acquires" VALUES('CSC',165,'proof structure');
INSERT INTO "Acquires" VALUES('ECO',105,'supply and demand');
INSERT INTO "Acquires" VALUES('ECO',105,'market forces');
INSERT INTO "Acquires" VALUES('CSC',207,'java');
INSERT INTO "Acquires" VALUES('CSC',207,'design principles');
INSERT INTO "Acquires" VALUES('CSC',207,'android');
INSERT INTO "Acquires" VALUES('CSC',148,'sorting');
INSERT INTO "Acquires" VALUES('CSC',148,'recursion');
INSERT INTO "Acquires" VALUES('CSC',148,'simple data structures');
INSERT INTO "Acquires" VALUES('CSC',148,'unit testing');
INSERT INTO "Acquires" VALUES('CSC',309,'javascript');
INSERT INTO "Acquires" VALUES('CSC',309,'node');
INSERT INTO "Acquires" VALUES('CSC',309,'full stack');
CREATE TABLE Prereq(
	dept_code varchar(3),
	courseno int,
	dept_code_req varchar(3),
	courseno_req int,
	PRIMARY KEY(dept_code, courseno, dept_code_req, courseno_req),
	FOREIGN KEY (dept_code, courseno) REFERENCES Course(dept_code, courseno),
	FOREIGN KEY (dept_code_req, courseno_req) REFERENCES Course(dept_code, courseno),
	CHECK (dept_code != dept_code_req OR courseno != courseno_req)
);
INSERT INTO "Prereq" VALUES('CSC',209,'CSC',207);
INSERT INTO "Prereq" VALUES('STA',247,'CSC',165);
CREATE TABLE Excludes(
	dept_code varchar(3),
	courseno int,
	dept_code_exc varchar(3),
	courseno_exc int,
	PRIMARY KEY(dept_code, courseno, dept_code_exc, courseno_exc),
	FOREIGN KEY (dept_code, courseno) REFERENCES Course(dept_code, courseno),
	FOREIGN KEY (dept_code_exc, courseno_exc) REFERENCES Course(dept_code, courseno),
	CHECK (dept_code != dept_code_exc OR courseno != courseno_exc)
);
INSERT INTO "Excludes" VALUES('CSC',148,'CSC',207);
CREATE TABLE Edition(
	eid varchar(8) PRIMARY KEY,
	dept_code varchar(3) NOT NULL,
	courseno int NOT NULL,
	start_date date NOT NULL,
	end_date date NOT NULL,
	offer_time varchar(8) NOT NULL, /*('morning', 'day', 'evening')*/
	enrollno int NOT NULL,
	FOREIGN KEY (dept_code, courseno) REFERENCES Course(dept_code, courseno),
	CHECK (end_date > start_date),
	CHECK (enrollno >=0 and enrollno <= 2000),
	CHECK (offer_time = 'morning' OR offer_time = 'day' OR offer_time = 'evening'),
	CHECK (enrollno >= 0)
);
INSERT INTO "Edition" VALUES('CSC209SM','CSC',209,'2016-01-01','2016-04-30','morning',200);
INSERT INTO "Edition" VALUES('CSC209FE','CSC',209,'2015-09-01','2015-12-30','evening',200);
INSERT INTO "Edition" VALUES('STA247FD','STA',247,'2015-09-01','2015-12-30','day',500);
INSERT INTO "Edition" VALUES('CSC165SM','CSC',165,'2016-01-01','2016-04-30','morning',100);
INSERT INTO "Edition" VALUES('ECO105YM','ECO',105,'2015-09-01','2016-04-30','morning',450);
INSERT INTO "Edition" VALUES('CSC207FD','CSC',207,'2015-09-01','2015-12-30','day',150);
INSERT INTO "Edition" VALUES('CSC148FD','CSC',148,'2015-09-01','2015-12-30','day',120);
INSERT INTO "Edition" VALUES('CSC309SE','CSC',309,'2015-09-01','2015-12-30','evening',100);
CREATE TABLE Student(
	sid varchar(8) PRIMARY KEY,
	birth_month int NOT NULL, 
	/* not using type "date" because we want year and month only*/
	birth_year int NOT NULL,
	gender varchar(1) NOT NULL,
	country varchar(15) NOT NULL,
	start_month int NOT NULL,
	start_year int NOT NULL,
	CHECK (birth_year >= 1930 and birth_year <= 2010),
	CHECK (birth_month >= 1 and birth_month <= 12),
	CHECK (birth_year >= 1930 and birth_year <= 2010),
	CHECK (birth_month >= 1 and birth_month <= 12),
	CHECK (gender = 'F' OR gender = 'M')
);
INSERT INTO "Student" VALUES('student1',8,1992,'M','United States',9,2013);
INSERT INTO "Student" VALUES('student2',6,1995,'M','Canada',9,2014);
CREATE TABLE Takes(
	sid varchar(8) REFERENCES Student(sid),
	eid varchar(8) REFERENCES Edition(eid),
	final_grade int,
	PRIMARY KEY (sid, eid),
	CHECK (final_grade >= 0 and final_grade <= 100)
);
INSERT INTO "Takes" VALUES('student1','CSC209FE',85);
INSERT INTO "Takes" VALUES('student1','CSC165SM',92);
INSERT INTO "Takes" VALUES('student1','ECO105YM',82);
INSERT INTO "Takes" VALUES('student1','CSC148FD',82);
INSERT INTO "Takes" VALUES('student1','CSC207FD',82);
INSERT INTO "Takes" VALUES('student2','CSC165SM',88);
INSERT INTO "Takes" VALUES('student2','CSC207FD',80);
INSERT INTO "Takes" VALUES('student2','STA247FD',90);
INSERT INTO "Takes" VALUES('student2','CSC148FD',77);
INSERT INTO "Takes" VALUES('student2','CSC309SE',96);
CREATE TABLE Experiences(
	sid varchar(8),
	eid varchar(8),
	skill varchar(120),
	overall_sat int NOT NULL,
	instr_sat int NOT NULL,
	skill_before int NOT NULL,
	skill_after int NOT NULL,
	interest_before int NOT NULL,
	interest_after int NOT NULL,
	CHECK (overall_sat <= 5 and overall_sat >=1),
	CHECK (instr_sat <= 5 and instr_sat >= 1),
	CHECK (interest_after <= 5 and interest_after >= 1),
	CHECK (interest_before <= 5 and interest_before >=1),
	CHECK (skill_after <= 5 and skill_after >= 1),
	CHECK (skill_before <= 5 and skill_before >=1),
	PRIMARY KEY (sid, eid, skill),
	FOREIGN KEY(sid, eid) REFERENCES Takes(sid, eid)
);
INSERT INTO "Experiences" VALUES('student1','ECO105YM','supply and demand',3,4,4,4,3,4);
INSERT INTO "Experiences" VALUES('student1','ECO105YM','market forces',3,4,3,4,3,4);
INSERT INTO "Experiences" VALUES('student1','CSC148FD','simple data structures',5,5,2,5,3,4);
INSERT INTO "Experiences" VALUES('student1','CSC148FD','sorting',5,5,2,4,3,4);
INSERT INTO "Experiences" VALUES('student1','CSC148FD','unit testing',5,5,2,4,3,4);
INSERT INTO "Experiences" VALUES('student1','CSC148FD','recursion',5,5,2,5,3,4);
INSERT INTO "Experiences" VALUES('student1','CSC165SM','induction',4,4,1,5,3,4);
INSERT INTO "Experiences" VALUES('student1','CSC165SM','proof structure',4,4,4,5,3,4);
INSERT INTO "Experiences" VALUES('student1','CSC165SM','predicate logic',4,4,4,5,3,4);
INSERT INTO "Experiences" VALUES('student1','CSC207FD','java',5,5,3,4,4,4);
INSERT INTO "Experiences" VALUES('student1','CSC207FD','android',5,5,1,3,4,4);
INSERT INTO "Experiences" VALUES('student1','CSC207FD','teamwork skills',5,5,4,5,4,4);
INSERT INTO "Experiences" VALUES('student1','CSC207FD','design principles',5,5,2,4,4,4);
INSERT INTO "Experiences" VALUES('student1','CSC209FE','c programming skills',3,4,3,4,4,4);
INSERT INTO "Experiences" VALUES('student1','CSC209FE','shell programming skills',3,4,2,4,4,4);
INSERT INTO "Experiences" VALUES('student1','CSC209FE','networks knowledge and design',3,4,2,4,4,4);
INSERT INTO "Experiences" VALUES('student2','CSC148FD','simple data structures',4,4,2,5,4,5);
INSERT INTO "Experiences" VALUES('student2','CSC148FD','sorting',4,4,2,5,4,5);
INSERT INTO "Experiences" VALUES('student2','CSC148FD','unit testing',4,4,3,5,4,5);
INSERT INTO "Experiences" VALUES('student2','CSC148FD','recursion',4,4,1,4,4,5);
INSERT INTO "Experiences" VALUES('student2','CSC165SM','induction',4,5,1,4,4,5);
INSERT INTO "Experiences" VALUES('student2','CSC165SM','proof structure',4,5,2,4,4,5);
INSERT INTO "Experiences" VALUES('student2','CSC165SM','predicate logic',4,5,4,5,4,5);
INSERT INTO "Experiences" VALUES('student2','CSC207FD','java',4,5,1,4,4,4);
INSERT INTO "Experiences" VALUES('student2','CSC207FD','android',4,5,1,4,4,4);
INSERT INTO "Experiences" VALUES('student2','CSC207FD','teamwork skills',4,5,4,5,4,4);
INSERT INTO "Experiences" VALUES('student2','CSC207FD','design principles',4,5,3,4,4,4);
INSERT INTO "Experiences" VALUES('student2','STA247FD','general statistical analysis',3,3,2,4,3,3);
INSERT INTO "Experiences" VALUES('student2','STA247FD','statistics and calculus (integration)',3,3,3,4,3,3);
INSERT INTO "Experiences" VALUES('student2','STA247FD','probability theory and application skills',3,3,4,4,3,3);
INSERT INTO "Experiences" VALUES('student2','CSC309SE','node',5,5,2,5,5,5);
INSERT INTO "Experiences" VALUES('student2','CSC309SE','full stack',5,5,4,5,5,5);
INSERT INTO "Experiences" VALUES('student2','CSC309SE','javascript',5,5,4,5,5,5);
CREATE TABLE Instructor(
	name varchar(20) PRIMARY KEY,
	gender varchar(1) NOT NULL,
	age int NOT NULL,
	CHECK (age >= 0 and age <= 100),
	CHECK (gender = 'F' or gender = 'M')
);
INSERT INTO "Instructor" VALUES('Brian Harrington','M',35);
INSERT INTO "Instructor" VALUES('Diane Horton','F',32);
INSERT INTO "Instructor" VALUES('David Liu','M',28);
INSERT INTO "Instructor" VALUES('Luai Al Labadi','M',40);
INSERT INTO "Instructor" VALUES('Avi Cohen','M',65);
INSERT INTO "Instructor" VALUES('Abdallah Farraj','M',32);
CREATE TABLE InstrExpertises(
	instr_name varchar(20) REFERENCES Instructor(name),
	expertise_area varchar(30),
	PRIMARY KEY(instr_name, expertise_area)
);
CREATE TABLE Freelancer(
	name varchar(20) PRIMARY KEY REFERENCES Instructor(name)
);
INSERT INTO "Freelancer" VALUES('Abdallah Farraj');
CREATE TABLE FacultyMember(
	name varchar(20) PRIMARY KEY REFERENCES Instructor(name),
	start_year int NOT NULL
);
INSERT INTO "FacultyMember" VALUES('Luai Al Labadi',2014);
INSERT INTO "FacultyMember" VALUES('David Liu',2013);
INSERT INTO "FacultyMember" VALUES('Brian Harrington',2012);
INSERT INTO "FacultyMember" VALUES('Diane Horton',2011);
INSERT INTO "FacultyMember" VALUES('Avi Cohen',2000);
CREATE TABLE FacultyResearcher(
	name varchar(20) PRIMARY KEY REFERENCES Instructor(name)
);
INSERT INTO "FacultyResearcher" VALUES('Brian Harrington');
INSERT INTO "FacultyResearcher" VALUES('David Liu');
INSERT INTO "FacultyResearcher" VALUES('Diane Horton');
CREATE TABLE FacultyTeacher(
	name varchar(20) PRIMARY KEY REFERENCES Instructor(name)
);
INSERT INTO "FacultyTeacher" VALUES('Luai Al Labadi');
INSERT INTO "FacultyTeacher" VALUES('Avi Cohen');
CREATE TABLE InterestedIn(
	researcher_name varchar(20) REFERENCES FacultyResearcher(name),
	researcher_int varchar(50),
	PRIMARY KEY(researcher_name, researcher_int)
);
CREATE TABLE Teaches(
	instr_name varchar(20) REFERENCES Instructor(name),
	eid varchar(8) REFERENCES Edition(eid),
	PRIMARY KEY(instr_name, eid)
);
INSERT INTO "Teaches" VALUES('Diane Horton','CSC207FD');
INSERT INTO "Teaches" VALUES('Abdallah Farraj','CSC165SM');
INSERT INTO "Teaches" VALUES('David Liu','CSC209FE');
INSERT INTO "Teaches" VALUES('Michelle Craig','CSC209SM');
INSERT INTO "Teaches" VALUES('Luai Al Labadi','STA247FD');
INSERT INTO "Teaches" VALUES('Avi Cohen','ECO105YM');
INSERT INTO "Teaches" VALUES('Brian Harrington','CSC148FD');
INSERT INTO "Teaches" VALUES('Karen Reid','CSC309SE');
INSERT INTO "Teaches" VALUES('Additional Person','CSC309SE');
CREATE TABLE Employs(
	company_name varchar(30),
	sid varchar(8) REFERENCES Student(sid),
	jobtitle varchar(50),
	start_date date,
	end_date date,
	skill varchar(120),
	sklevel int, 
	CHECK (sklevel <= 5 and sklevel >= 2),
	CHECK (end_date > start_date),
	PRIMARY KEY(company_name, sid, jobtitle, start_date, end_date, skill, sklevel)
);
INSERT INTO "Employs" VALUES('apple','student1','programmer intern','2014-05-05','2014-08-31','c programming skills',3);
INSERT INTO "Employs" VALUES('pizzahut','student2','cashier','2015-09-01','2016-04-30','teamwork skills',2);
INSERT INTO "Employs" VALUES('cern','student2','research','2015-11-01','2016-09-22','particle physics',5);
CREATE TABLE compExpertises(
	company_name varchar(30),
	expertise_area varchar(30),
	PRIMARY KEY(company_name, expertise_area)
);
CREATE VIEW edition_info AS
SELECT eid, dept_code || courseno as course, start_date, end_date, offer_time, enrollno
FROM edition;
CREATE VIEW editions AS
SELECT edition.eid, dept_code || courseno as course, start_date, end_date, offer_time, enrollno, GROUP_CONCAT(instr_name, '|') as instr_names
FROM edition, teaches
WHERE edition.eid=teaches.eid
GROUP BY edition.eid
ORDER BY edition.eid;
CREATE VIEW editions_students AS
SELECT eid, course, start_date, end_date, offer_time, enrollno, instr_names, sid, final_grade, strftime('%Y', 'now') - birth_year as age, COALESCE(birth_year, '') || ' ' || COALESCE(birth_month, '') as dob, gender, country
FROM takes
JOIN editions USING(eid)
JOIN student USING(sid);
CREATE VIEW class_ratings AS
SELECT sid, eid, skill, start_year || '-' || start_month as uni_start_date, overall_sat, instr_sat
FROM student
JOIN experiences USING(sid);
CREATE VIEW student_skills AS
SELECT sid, eid, GROUP_CONCAT(skills_rank, '|') as all_skills
FROM (
SELECT sid, eid, skill || '-' || skill_before || '-' || skill_after as skills_rank
FROM experiences)
GROUP BY eid;
COMMIT;
