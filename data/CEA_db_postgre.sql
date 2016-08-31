DROP SCHEMA IF EXISTS ceadata CASCADE;
CREATE SCHEMA ceadata;
SET SEARCH_PATH TO ceadata;

CREATE DOMAIN valid_deptcode AS varchar(3)
CHECK(
   VALUE ~ '[A-Z]{3}'
);

DROP TABLE IF EXISTS Department CASCADE;

CREATE TABLE Department(
	dept_code valid_deptcode PRIMARY KEY,
	name varchar(20) NOT NULL
);

CREATE DOMAIN valid_courseno AS varchar(3)
CHECK(
   VALUE ~ '^\d{3}$'
   OR VALUE ~ '^\d{4}$'
);

DROP TABLE IF EXISTS Course CASCADE;

CREATE TABLE Course(
	dept_code valid_deptcode REFERENCES Department(dept_code),
	courseno valid_courseno,
	area varchar(50) NOT NULL,
	PRIMARY KEY(dept_code, courseno)
);

DROP TABLE IF EXISTS Covers CASCADE;

CREATE TABLE Covers(
	dept_code valid_deptcode,
	courseno valid_courseno,
	topic varchar(50),
	PRIMARY KEY(dept_code, courseno, topic),
	FOREIGN KEY (dept_code, courseno) REFERENCES Course(dept_code, courseno)
);


DROP TABLE IF EXISTS Acquires CASCADE;

CREATE TABLE Acquires(
	dept_code valid_deptcode,
	courseno valid_courseno,
	skill varchar(120),
	PRIMARY KEY(dept_code, courseno, skill),
	FOREIGN KEY (dept_code, courseno) REFERENCES Course(dept_code, courseno)
);


DROP TABLE IF EXISTS Prereq CASCADE;

CREATE TABLE Prereq(
	dept_code valid_deptcode,
	courseno valid_courseno,
	dept_code_req valid_deptcode,
	courseno_req valid_courseno,
	PRIMARY KEY(dept_code, courseno, dept_code_req, courseno_req),
	FOREIGN KEY (dept_code, courseno) REFERENCES Course(dept_code, courseno),
	FOREIGN KEY (dept_code_req, courseno_req) REFERENCES Course(dept_code, courseno),
	CHECK (dept_code != dept_code_req OR courseno != courseno_req)
);

DROP TABLE IF EXISTS Excludes CASCADE;

CREATE TABLE Excludes(
	dept_code valid_deptcode,
	courseno valid_courseno,
	dept_code_exc valid_deptcode,
	courseno_exc valid_courseno,
	PRIMARY KEY(dept_code, courseno, dept_code_exc, courseno_exc),
	FOREIGN KEY (dept_code, courseno) REFERENCES Course(dept_code, courseno),
	FOREIGN KEY (dept_code_exc, courseno_exc) REFERENCES Course(dept_code, courseno),
	CHECK (dept_code != dept_code_exc OR courseno != courseno_exc)
);

DROP TABLE IF EXISTS Edition CASCADE;

CREATE TYPE section AS ENUM('morning', 'day', 'evening');

CREATE TABLE Edition(
	eid varchar(8) PRIMARY KEY,
	dept_code valid_deptcode NOT NULL,
	courseno valid_courseno NOT NULL,
	start_date date NOT NULL,
	end_date date NOT NULL,
	offer_time section NOT NULL,
	enrollno int NOT NULL,
	FOREIGN KEY (dept_code, courseno) REFERENCES Course(dept_code, courseno),
	CHECK (end_date > start_date),
	CHECK (enrollno >=0 and enrollno <= 2000),
	CHECK (enrollno >= 0)
);

DROP TABLE IF EXISTS Student CASCADE;

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

DROP TABLE IF EXISTS Takes CASCADE;

CREATE TABLE Takes(
	sid varchar(8) REFERENCES Student(sid),
	eid varchar(8) REFERENCES Edition(eid),
	final_grade int NOT NULL,
	PRIMARY KEY (sid, eid),
	CHECK (final_grade >= 0 and final_grade <= 100)
);

DROP TABLE IF EXISTS Experiences CASCADE;

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

DROP TABLE IF EXISTS Instructor CASCADE;

CREATE TABLE Instructor(
	name varchar(20) PRIMARY KEY,
	gender varchar(1) NOT NULL,
	age int NOT NULL,
	CHECK (age >= 0 and age <= 100),
	CHECK (gender = 'F' or gender = 'M')  -- note this is not very accepting.
);

DROP TABLE IF EXISTS Expertizes_instr CASCADE;

CREATE TABLE Expertises_instr(
	instr_name varchar(20) REFERENCES Instructor(name),
	expertise_area varchar(50),
	PRIMARY KEY(instr_name, expertise_area)
);

DROP TABLE IF EXISTS Freelancer CASCADE;

CREATE TABLE Freelancer(
	name varchar(20) PRIMARY KEY REFERENCES Instructor(name)
);

DROP TABLE IF EXISTS FacultyMember CASCADE;

CREATE TABLE FacultyMember(
	name varchar(20) PRIMARY KEY REFERENCES Instructor(name),
	start_year int NOT NULL
);

DROP TABLE IF EXISTS FacultyResearcher CASCADE;

CREATE TABLE FacultyResearcher(
	name varchar(20) PRIMARY KEY REFERENCES Instructor(name)
);

DROP TABLE IF EXISTS FacultyTeacher CASCADE;

CREATE TABLE FacultyTeacher(
	name varchar(20) PRIMARY KEY REFERENCES Instructor(name)
);

DROP TABLE IF EXISTS InterestedIn CASCADE;

CREATE TABLE InterestedIn(
	researcher_name varchar(20) REFERENCES FacultyResearcher(name),
	researcher_int varchar(50),
	PRIMARY KEY(researcher_name, researcher_int)
);

DROP TABLE IF EXISTS Teaches CASCADE;

CREATE TABLE Teaches(
	instr_name varchar(20) REFERENCES Instructor(name),
	eid varchar(8) REFERENCES Edition(eid),
	PRIMARY KEY(instr_name, eid)
);

DROP TABLE IF EXISTS Employs CASCADE;

CREATE TABLE Employs(
	company_name varchar(30),
	sid varchar(8) REFERENCES Student(sid),
	jobtitle varchar(20),
	start_date date,
	end_date date,
	skill varchar(120),
	sklevel int,
	CHECK (sklevel <= 5 and sklevel >= 2),
	CHECK (end_date > start_date),
	PRIMARY KEY(company_name, sid, jobtitle, start_date, end_date, skill, sklevel)
);

DROP TABLE IF EXISTS Expertizes_comp CASCADE;

CREATE TABLE Expertises_comp(
	company_name varchar(30),
	expertise_area varchar(50),
	PRIMARY KEY(company_name, expertise_area)
);