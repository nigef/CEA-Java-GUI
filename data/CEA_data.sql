INSERT INTO department(dept_code, name) VALUES ('CSC', 'Computer Science');
INSERT INTO department(dept_code, name) VALUES ('STA', 'Statistics');
INSERT INTO department(dept_code, name) VALUES ('MAT', 'Mathematics');
INSERT INTO department(dept_code, name) VALUES ('ECO', 'Economics');

INSERT INTO course(dept_code, courseno, area) VALUES  ('CSC', '209', 'Sciences');
INSERT INTO course(dept_code, courseno, area) VALUES  ('CSC', '148', 'Sciences');
INSERT INTO course(dept_code, courseno, area) VALUES  ('CSC', '165', 'Sciences');
INSERT INTO course(dept_code, courseno, area) VALUES  ('CSC', '207', 'Sciences');
INSERT INTO course(dept_code, courseno, area) VALUES  ('STA', '247', 'Sciences');
INSERT INTO course(dept_code, courseno, area) VALUES  ('STA', '302', 'Sciences');
INSERT INTO course(dept_code, courseno, area) VALUES  ('MAT', '223', 'Sciences');
INSERT INTO course(dept_code, courseno, area) VALUES  ('ECO', '105', 'Arts');

INSERT INTO instructor(name, gender, age) VALUES ('Brian Harrington', 'M', '35');
INSERT INTO instructor(name, gender, age) VALUES ('Diane Horton', 'F', '32');
INSERT INTO instructor(name, gender, age) VALUES ('David Liu', 'M', '28');
INSERT INTO instructor(name, gender, age) VALUES ('Luai Al Labadi', 'M', '40');
INSERT INTO instructor(name, gender, age) VALUES ('Avi Cohen', 'M', '65');
INSERT INTO instructor(name, gender, age) VALUES ('Abdallah Farraj', 'M', '32');
INSERT INTO freelancer(name) VALUES ('Abdallah Farraj');
INSERT INTO facultymember(name, start_year) VALUES ('Luai Al Labadi', '2014');
INSERT INTO facultymember(name, start_year) VALUES ('David Liu', '2013');
INSERT INTO facultymember(name, start_year) VALUES ('Brian Harrington', '2012');
INSERT INTO facultymember(name, start_year) VALUES ('Diane Horton', '2011');
INSERT INTO facultymember(name, start_year) VALUES ('Avi Cohen', '2000');
INSERT INTO facultyteacher(name) VALUES ('Luai Al Labadi');
INSERT INTO facultyteacher(name) VALUES ('Avi Cohen');
INSERT INTO facultyresearcher(name) VALUES ('Brian Harrington');
INSERT INTO facultyresearcher(name) VALUES ('David Liu');
INSERT INTO facultyresearcher(name) VALUES ('Diane Horton');

INSERT INTO edition(eid, dept_code, courseno, start_date, end_date, offer_time, enrollno)
VALUES ('CSC209SM', 'CSC', '209', '2016-01-01', '2016-04-30', 'morning', '200');
INSERT INTO edition(eid, dept_code, courseno, start_date, end_date, offer_time, enrollno)
VALUES ('CSC209FE', 'CSC', '209', '2015-09-01', '2015-12-30', 'evening', '200');
INSERT INTO edition(eid, dept_code, courseno, start_date, end_date, offer_time, enrollno)
VALUES ('STA247FD', 'STA', '247', '2015-09-01', '2015-12-30', 'day', '500');
INSERT INTO edition(eid, dept_code, courseno, start_date, end_date, offer_time, enrollno)
VALUES ('CSC165SM', 'CSC', '165', '2016-01-01', '2016-04-30', 'morning', '100');
INSERT INTO edition(eid, dept_code, courseno, start_date, end_date, offer_time, enrollno)
VALUES ('ECO105YM', 'ECO', '105', '2015-09-01', '2016-04-30', 'morning', '450');
INSERT INTO edition(eid, dept_code, courseno, start_date, end_date, offer_time, enrollno)
VALUES ('CSC207FD', 'CSC', '207', '2015-09-01', '2015-12-30', 'day', '150');
INSERT INTO edition(eid, dept_code, courseno, start_date, end_date, offer_time, enrollno)
VALUES ('CSC148FD', 'CSC', '148', '2015-09-01', '2015-12-30', 'day', '120');
INSERT INTO edition(eid, dept_code, courseno, start_date, end_date, offer_time, enrollno)
VALUES ('CSC309SE', 'CSC', '309', '2015-09-01', '2015-12-30', 'evening', '100');


INSERT INTO student(sid, birth_month, birth_year, gender, country, start_month, start_year)
VALUES ('student1', '8', '1992', 'M', 'United States', '9', '2013');
INSERT INTO student(sid, birth_month, birth_year, gender, country, start_month, start_year)
VALUES ('student2', '6', '1995', 'M', 'Canada', '9', '2014');

INSERT INTO employs(company_name, sid, jobtitle, start_date, end_date, skill, sklevel)
VALUES ('apple', 'student1', 'programmer intern', '2014-05-05', '2014-08-31', 'c programming skills', 3);
INSERT INTO employs(company_name, sid, jobtitle, start_date, end_date, skill, sklevel)
VALUES ('pizzahut', 'student2', 'cashier', '2015-09-01', '2016-04-30', 'teamwork skills', 2);
INSERT INTO employs(company_name, sid, jobtitle, start_date, end_date, skill, sklevel)
VALUES ('cern', 'student2', 'research', '2015-11-01', '2016-09-22', 'particle physics', 5);

INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '209', 'c programming');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '209', 'networks programming');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '209', 'shell commands');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('STA', '247', 'probability');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('STA', '247', 'statistical distribution');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '165', 'induction proofs');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '207', 'software engineering');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '207', 'java programming');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('ECO', '105', 'supply and demand');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('ECO', '105', 'market forces');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '148', 'algorithms');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '148', 'recursion');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '148', 'programming');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '309', 'javascript');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '309', 'servers');
INSERT INTO covers(dept_code, courseno, topic) VALUES ('CSC', '309', 'design');

INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '209', 'c programming skills');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '209', 'shell programming skills');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '209', 'networks knowledge and design');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('STA', '247', 'probability theory and application skills');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('STA', '247', 'general statistical analysis');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('STA', '247', 'statistics and calculus (integration)');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '207', 'teamwork skills');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '207', 'java');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '207', 'design principles');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '207', 'android');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '165', 'predicate logic');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '165', 'induction');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '165', 'proof structure');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('ECO', '105', 'supply and demand');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('ECO', '105', 'market forces');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '148', 'sorting');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '148', 'recursion');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '148', 'simple data structures');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '148', 'unit testing');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '309', 'javascript');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '309', 'node');
INSERT INTO acquires(dept_code, courseno, skill) VALUES ('CSC', '309', 'full stack');

INSERT INTO teaches(instr_name, eid) VALUES ('Diane Horton', 'CSC207FD');
INSERT INTO teaches(instr_name, eid) VALUES ('Abdallah Farraj', 'CSC165SM');
INSERT INTO teaches(instr_name, eid) VALUES ('David Liu', 'CSC209FE');
INSERT INTO teaches(instr_name, eid) VALUES ('Michelle Craig', 'CSC209SM');
INSERT INTO teaches(instr_name, eid) VALUES ('Luai Al Labadi', 'STA247FD');
INSERT INTO teaches(instr_name, eid) VALUES ('Avi Cohen', 'ECO105YM');
INSERT INTO teaches(instr_name, eid) VALUES ('Brian Harrington', 'CSC148FD');
INSERT INTO teaches(instr_name, eid) VALUES ('Karen Reid', 'CSC309SE');
INSERT INTO teaches(instr_name, eid) VALUES ('Additional Person', 'CSC309SE');


INSERT INTO prereq(dept_code, courseno, dept_code_req, courseno_req)
VALUES ('CSC', '209', 'CSC', '207');
INSERT INTO prereq(dept_code, courseno, dept_code_req, courseno_req)
VALUES ('STA', '247', 'CSC', '165');
INSERT INTO excludes(dept_code, courseno, dept_code_exc, courseno_exc)
VALUES ('CSC', '148', 'CSC', '207');

INSERT INTO takes(sid, eid, final_grade) VALUES ('student1', 'CSC209FE', '85');
INSERT INTO takes(sid, eid, final_grade) VALUES ('student1', 'CSC165SM', '92');
INSERT INTO takes(sid, eid, final_grade) VALUES ('student1', 'ECO105YM', '82');
INSERT INTO takes(sid, eid, final_grade) VALUES ('student1', 'CSC148FD', '82');
INSERT INTO takes(sid, eid, final_grade) VALUES ('student1', 'CSC207FD', '82');
INSERT INTO takes(sid, eid, final_grade) VALUES ('student2', 'CSC165SM', '88');
INSERT INTO takes(sid, eid, final_grade) VALUES ('student2', 'CSC207FD', '80');
INSERT INTO takes(sid, eid, final_grade) VALUES ('student2', 'STA247FD', '90');
INSERT INTO takes(sid, eid, final_grade) VALUES ('student2', 'CSC148FD', '77');
INSERT INTO takes(sid, eid, final_grade) VALUES ('student2', 'CSC309SE', '96');
