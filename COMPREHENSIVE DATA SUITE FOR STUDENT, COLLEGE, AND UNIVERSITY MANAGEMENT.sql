-- ADD A NEW COLUMN FOR FEES TO THE STUDENT TABLE
ALTER TABLE Student
ADD Fees NUMBER(10, 2);

-- RENAME COLUMN FEES TO BALANCE_FEES IN THE STUDENT TABLE
ALTER TABLE STUDENT 
RENAME COLUMN FEES TO BALANCE_FEES;

-- UPDATE BALANCE_FEES FOR A SPECIFIC STUDENT
UPDATE Student
SET BALANCE_FEES = 55500
WHERE Student_id = 1050;

-- RETRIEVE STUDENT RECORDS WITH BALANCE_FEES GREATER THAN 40000
SELECT * FROM STUDENT
WHERE BALANCE_FEES > 40000;

-- CALCULATE NEW BALANCE FOR A SPECIFIC STUDENT
SELECT 50000-1000 AS NEW_BALANCE FROM STUDENT
WHERE STUDENT_ID = 1001;

-- CONCATENATE STUDENT NAME WITH BALANCE FEES
SELECT STUDENT_NAME || q'( 'S BALANCE FEES IS  )' || BALANCE_FEES FROM STUDENT;

-- RETRIEVE STUDENT NAMES AND BALANCE FEES
SELECT STUDENT_NAME, 
/*AGE, 
GENDER, 
CITY, 
EMAIL, 
PHONE_NUMBER, 
ENROLLMENT_DATE, 
COLLEGE_ID */
BALANCE_FEES 
FROM STUDENT;

-- RETRIEVE STUDENT NAMES AND BALANCE FEES FOR COLLEGE_ID LESS THAN OR EQUAL TO 105
SELECT STUDENT_NAME,  BALANCE_FEES FROM STUDENT
WHERE  COLLEGE_ID <= 105;

-- RETRIEVE STUDENT RECORDS WITH BALANCE_FEES NOT BETWEEN 40000 AND 50000
SELECT * FROM STUDENT 
WHERE BALANCE_FEES NOT BETWEEN 40000 AND 50000;

--RETRIEVE AND TRANSFORM STUDENT DATA WITH ENHANCED DETAILS AND FORMATTED OUTPUTS

SELECT STUDENT_ID, 
UPPER(STUDENT_NAME) AS UPPERCASE_NAME,
LENGTH(STUDENT_NAME) AS NAME_LENGTH,
TO_CHAR(ENROLLMENT_DATE, 'YYYY') AS YEAR,
LPAD(PHONE_NUMBER, 13, '+91') AS STUDENT_PHONE_NUMBER, 
CONCAT(STUDENT_NAME, ' HAS NEW EMAIL') AS NEW_EMAIL,
SUBSTR ('ragul5@gmail.com', 1, INSTR('ragul5@gmail.com', '@')-3) AS SUBSTRING,
REPLACE (UPPER(STUDENT_NAME), 'RAGU', 'RAGULAN') REPLACE_NAME,
NVL(BALANCE_FEES,0) BALANCE,
NVL2(BALANCE_FEES, 'PENDING', 'PAID') PENDING_FEES
FROM STUDENT 
WHERE INSTR(Student_name, 'RAGUL') < 5;

-- COUNT TOTAL STUDENTS IN EACH COLLEGE (MULTI-ROW FUNCTION)

SELECT College_id, COUNT(*) AS Total_Students
FROM Student
GROUP BY College_id;

--DISPLAY STUDENTS ENROLLED IN THE LAST N YEARS (SINGLE-ROW AND MULTI-ROW COMBINATION)

SELECT Student_id, Student_name, Enrollment_date FROM Student
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM Enrollment_date) <= 5;

--FIND COLLEGES WITH THE LONGEST NAME (MULTI-ROW FUNCTION)

SELECT College_name, LENGTH(College_name) AS Name_Length
FROM College
WHERE LENGTH(College_name) = (
SELECT MAX(LENGTH(College_name)) FROM College
);

--FIND THE MINIMUM ENROLLMENT DATE ACROSS ALL STUDENTS (MULTI-ROW FUNCTION)

SELECT MIN(Enrollment_date) AS Earliest_Enrollment

--VIEW TO RETRIEVE TOP 2 STUDENTS WITH HIGHEST BALANCE FEES FOR EACH COLLEGE

CREATE OR REPLACE VIEW TOP_2_BALANCE AS
SELECT S.STUDENT_ID, S.STUDENT_NAME, S.PHONE_NUMBER, S.BALANCE_FEES, S.COLLEGE_ID, C.COLLEGE_NAME
FROM 
(
  SELECT S.STUDENT_ID, S.STUDENT_NAME, S.PHONE_NUMBER, S.BALANCE_FEES, S.COLLEGE_ID, 
  RANK() OVER (PARTITION BY S.COLLEGE_ID ORDER BY S.BALANCE_FEES DESC) AS RANK
  FROM STUDENT S
) S 
INNER JOIN COLLEGE C ON S.COLLEGE_ID = C.COLLEGE_ID
WHERE S.RANK <= 2
ORDER BY S.COLLEGE_ID, S.RANK WITH READ ONLY;

SELECT * FROM TOP_2_BALANCE;

--DECODE FOR CITY TO PINCODE

SELECT CITY,
DECODE (CITY, 'KARUR', '639002', 'CHENNAI', '639001', 'THENI', '625531', 'MADURAI', '625001', 'SALEM', '636001') PINCODE
FROM STUDENT;

--CASE FOR STUDENT BALANCE_FEES AS PENDING_STATUS

SELECT STUDENT_ID, STUDENT_NAME, BALANCE_FEES,
CASE 
WHEN BALANCE_FEES < 10000 THEN 'LOW_BALANCE'
WHEN BALANCE_FEES >= 10000 AND BALANCE_FEES <30000 THEN 'AVERAGE_BALANCE'
ELSE 'HIGH_BALANCE' END PENDING_STATUS
FROM STUDENT;

--USING JOINS INSERT LOCATION FROM UNIVERSITY TABLE TO STUDENT TABLE;

SELECT * FROM STUDENT;
SELECT * FROM UNIVERSITY;

SELECT
S.STUDENT_NAME,
S.AGE,
S.GENDER,
S.CITY,
S.EMAIL,
S.PHONE_NUMBER,
S.ENROLLMENT_DATE,
S.COLLEGE_ID,
U.LOCATION
FROM  STUDENT S, UNIVERSITY U
WHERE S.COLLEGE_ID=U.COLLEGE_ID;

--INNER JOIN;

SELECT S.STUDENT_ID, C.COLLEGE_ID
FROM STUDENT S
JOIN COLLEGE C
ON S.COLLEGE_ID = C.COLLEGE_ID;

--LEFT OUTER JOIN;

SELECT C.COLLEGE_ID, U.UNIVERSITY_ID, C.COLLEGE_NAME, C.CITY, C.STATE, C.INSTITUTION_TYPE
FROM COLLEGE C
LEFT JOIN UNIVERSITY U
ON C.COLLEGE_ID = U.UNIVERSITY_ID 
WHERE C.COLLEGE_NAME IS NOT NULL;

--RIGHT OUTER JOIN;

SELECT C.COLLEGE_ID, U.UNIVERSITY_ID, C.COLLEGE_NAME, C.CITY, C.STATE, C.INSTITUTION_TYPE
FROM COLLEGE C
RIGHT JOIN UNIVERSITY U
ON C.COLLEGE_ID = U.UNIVERSITY_ID 
WHERE C.COLLEGE_NAME IS NULL;

--FULL OUTER JOIN;

SELECT C.COLLEGE_ID, U.UNIVERSITY_ID, C.COLLEGE_NAME, C.CITY, C.STATE, C.INSTITUTION_TYPE
FROM COLLEGE C
FULL JOIN UNIVERSITY U
ON C.COLLEGE_ID = U.UNIVERSITY_ID;

--VERIFY ESTABLISHED YEAR, LOCATION THROUGH JOINS;

SELECT 
S. STUDENT_NAME,
S. AGE,
S. GENDER,
S. CITY,
S. EMAIL,
S. PHONE_NUMBER,
S. ENROLLMENT_DATE,
S. COLLEGE_ID,
U. LOCATION,
U.ESTABLISHED_YEAR
FROM  STUDENT S JOIN UNIVERSITY U
ON S.COLLEGE_ID=U.COLLEGE_ID 
WHERE U.ESTABLISHED_YEAR <=1999 AND U.LOCATION = 'TRICHY';

--USING  3 TABLES IN 1 TABLE  IN A JOIN;
--TYPE 1:

SELECT * FROM STUDENT S, COLLEGE C, UNIVERSITY U
WHERE S.COLLEGE_ID=C.COLLEGE_ID AND C.COLLEGE_ID = U.COLLEGE_ID;

--TYPE 2:

SELECT * FROM STUDENT S INNER JOIN COLLEGE C
ON S.COLLEGE_ID=C.COLLEGE_ID 
INNER JOIN UNIVERSITY U
ON C.COLLEGE_ID = U.COLLEGE_ID;

--RETRIEVE STUDENT DETAILS WITH COLLEGE AND UNIVERSITY INFORMATION

SELECT 
S. STUDENT_NAME,
S. CITY,
S. ENROLLMENT_DATE,
S. COLLEGE_ID,
C. COLLEGE_NAME,
U.UNIVERSITY_NAME,
U. LOCATION,
U.ESTABLISHED_YEAR
FROM STUDENT S 
INNER JOIN COLLEGE C
ON S.COLLEGE_ID = C.COLLEGE_ID
INNER JOIN UNIVERSITY U
ON C.COLLEGE_ID = U.COLLEGE_ID;

--CROSS JOIN THE STUDENT TABLE AND UNIVERSITY TABLE:

SELECT
S.STUDENT_NAME,
S.AGE,
S.GENDER,
S.CITY,
S.EMAIL,
S.PHONE_NUMBER,
S.ENROLLMENT_DATE,
S.COLLEGE_ID,
U.LOCATION
FROM  STUDENT S CROSS JOIN UNIVERSITY U;

--SELF JOIN FOR STUDENT_ID TO COLLEGE_ID;

SELECT 
    S1.STUDENT_ID AS STUDENTID,
    S1.STUDENT_Name AS STUDENTName,
    S2.COLLEGE_ID AS COLLEGEID
FROM 
    STUDENT S1
LEFT JOIN 
    STUDENT S2
ON 
    S1.COLLEGE_ID = S2.STUDENT_ID;

--USING A SUBQUERY IN A JOIN

SELECT 
    S.STUDENT_NAME,
    S.CITY,
    S.ENROLLMENT_DATE,
    S.BALANCE_FEES,
    C.COLLEGE_NAME,
    U.UNIVERSITY_NAME,
    U.LOCATION,
    U.ESTABLISHED_YEAR
FROM STUDENT S
INNER JOIN ( SELECT COLLEGE_ID, COLLEGE_NAME, CITY, INSTITUTION_TYPE FROM COLLEGE ) C
ON S.COLLEGE_ID = C.COLLEGE_ID
JOIN UNIVERSITY U
ON C.COLLEGE_ID = U.COLLEGE_ID
WHERE U.UNIVERSITY_NAME = 'BHARATHIAR UNIVERSITY' 
AND S.BALANCE_FEES < 50000;

--USING SINGLE ROW SUBQUERY 

SELECT * FROM STUDENT S
WHERE BALANCE_FEES >= (SELECT BALANCE_FEES FROM STUDENT S1 
WHERE S.STUDENT_ID = S1.STUDENT_ID 
AND S1.STUDENT_NAME = 'RAGU');

SELECT * FROM STUDENT WHERE BALANCE_FEES >ANY (SELECT MAX (BALANCE_FEES) FROM STUDENT GROUP BY COLLEGE_ID);

--USING MULTI ROW SUBQUERY 

-- TYPE 1:
SELECT * FROM STUDENT 
WHERE BALANCE_FEES <ANY (
SELECT MIN (BALANCE_FEES) 
FROM STUDENT 
GROUP BY COLLEGE_ID, CITY, STUDENT_NAME
HAVING STUDENT_NAME = 'RAGU'
)
ORDER BY COLLEGE_ID;

--TYPE 2:
SELECT * FROM STUDENT 
WHERE BALANCE_FEES IN (
SELECT DISTINCT BALANCE_FEES 
FROM STUDENT 
WHERE BALANCE_FEES IS NOT NULL);

--TYPE 3:
SELECT * FROM STUDENT S
JOIN(
SELECT * FROM COLLEGE WHERE COLLEGE_ID IN (101, 110)) C
ON S.COLLEGE_ID = C.COLLEGE_ID
WHERE S.BALANCE_FEES <ANY(
SELECT BALANCE_FEES FROM STUDENT S1
WHERE S1.STUDENT_NAME = 'RAGU');

--FILTER STUDENTS BASED ON COLLEGE AFFILIATION AND EXCLUDE SPECIFIC CONDITIONS USING EXISTS AND NOT EXISTS :

SELECT * FROM STUDENT S
WHERE EXISTS (
SELECT 1 
FROM COLLEGE C
WHERE C.COLLEGE_ID IN (101, 110)
AND S.COLLEGE_ID = C.COLLEGE_ID
)
AND S.BALANCE_FEES < ANY (
SELECT BALANCE_FEES 
FROM STUDENT S1
WHERE S1.STUDENT_NAME = 'RAGUL'
)
AND NOT EXISTS (
SELECT 1
FROM STUDENT S2
WHERE S2.STUDENT_ID = S.STUDENT_ID
AND S2.BALANCE_FEES < 0
);

--LIST OF STUDENTS WITH MAXIMUM BALANCE FEES GREATER THAN 50,000

SELECT STUDENT_ID, MAX(BALANCE_FEES) MAX_BALANCE FROM STUDENT 
GROUP BY STUDENT_ID 
HAVING MAX(BALANCE_FEES) < 50000 
ORDER BY STUDENT_ID;

--STUDENT FEES RANKING BY COLLEGE

SELECT S.STUDENT_ID, S.STUDENT_NAME, S.PHONE_NUMBER, S.BALANCE_FEES, S.COLLEGE_ID, C.COLLEGE_NAME, 
RANK() OVER (PARTITION BY S.COLLEGE_ID ORDER BY S.BALANCE_FEES DESC) AS RANK,
DENSE_RANK() OVER (PARTITION BY S.COLLEGE_ID ORDER BY S.BALANCE_FEES DESC) AS DENSE_RANK
FROM STUDENT S
JOIN COLLEGE C ON S.COLLEGE_ID = C.COLLEGE_ID
ORDER BY S.COLLEGE_ID, RANK;

--STUDENTS WITH BALANCE FEES RANKING (TOP 5 PER COLLEGE)

SELECT * FROM 
(
SELECT S.STUDENT_ID, S.STUDENT_NAME, S.PHONE_NUMBER, S.BALANCE_FEES, S.COLLEGE_ID, C.COLLEGE_NAME, 
RANK() OVER (PARTITION BY S.COLLEGE_ID ORDER BY S.BALANCE_FEES DESC) AS RANK
FROM STUDENT S
JOIN COLLEGE C ON S.COLLEGE_ID = C.COLLEGE_ID
)
WHERE RANK <= 2
ORDER BY COLLEGE_ID, RANK;

--TOP 2 STUDENTS WITH HIGHEST BALANCE FEES BY COLLEGE

SELECT S.STUDENT_ID, S.STUDENT_NAME, S.PHONE_NUMBER, S.BALANCE_FEES, S.COLLEGE_ID, C.COLLEGE_NAME
FROM 
(
  SELECT S.STUDENT_ID, S.STUDENT_NAME, S.PHONE_NUMBER, S.BALANCE_FEES, S.COLLEGE_ID, 
  RANK() OVER (PARTITION BY S.COLLEGE_ID ORDER BY S.BALANCE_FEES DESC) AS RANK
  FROM STUDENT S
) S 
INNER JOIN COLLEGE C ON S.COLLEGE_ID = C.COLLEGE_ID
WHERE S.RANK <= 2
ORDER BY S.COLLEGE_ID, S.RANK;

--RETRIEVE STUDENT INFORMATION WITH LEAD AND LAG AND LISTAGG FUNCTIONS WITHOUT USING JOIN

SELECT S.STUDENT_ID, S.STUDENT_NAME, S.PHONE_NUMBER, S.BALANCE_FEES, S.ENROLLMENT_DATE, S.COLLEGE_ID, 
(SELECT C.COLLEGE_NAME FROM COLLEGE C WHERE C.COLLEGE_ID = S.COLLEGE_ID) AS "COLLEGE_NAME",
LEAD (S.ENROLLMENT_DATE) OVER (ORDER BY S.ENROLLMENT_DATE) AS "AFTER_ENROLL_DATE",
LEAD (S.STUDENT_NAME) OVER (ORDER BY S.ENROLLMENT_DATE) AS "AFTER_ENROLL_NAME",
LAG (S.ENROLLMENT_DATE) OVER (ORDER BY S.ENROLLMENT_DATE) AS "BEFORE_ENROLL_DATE",
LAG (S.STUDENT_NAME) OVER (ORDER BY S.ENROLLMENT_DATE) AS "BEFORE_ENROLL_NAME",
LISTAGG(S.STUDENT_NAME, ', ') WITHIN GROUP (ORDER BY S.ENROLLMENT_DATE) AS "AGGREGATED_NAMES"
FROM STUDENT S
GROUP BY S.STUDENT_ID, S.STUDENT_NAME, S.PHONE_NUMBER, S.BALANCE_FEES, S.ENROLLMENT_DATE, S.COLLEGE_ID;

--AUTOMATIC STUDENT SEQUENCE INITIALIZED: CONFIGURED TO START AT 1001 AND CYCLE WITH A MAX CAP OF 1050

CREATE SEQUENCE SEQ_STUDENT
START WITH 1051
INCREMENT BY 1
MINVALUE 1051
MAXVALUE 9999
NOCYCLE
CACHE 100;

--FORMULA FOR CALCULATING CACHE

SELECT (CEIL (1050-1))/ABS(1) AS CACHE FROM DUAL;

--INSERT VALUES IN SEQUENCE

INSERT INTO STUDENT (STUDENT_ID, STUDENT_NAME, PHONE_NUMBER, EXAM_ID)
VALUES (SEQ_STUDENT.NEXTVAL, 'RAGU', '1234567890', 'A1001');

INSERT INTO STUDENT (STUDENT_ID, STUDENT_NAME, PHONE_NUMBER, EXAM_ID)
VALUES (SEQ_STUDENT.NEXTVAL, 'GANESH', '1234567891', 'A1002');

SELECT * FROM STUDENT;

SELECT SEQ_STUDENT.NEXTVAL FROM STUDENT;

SELECT SEQ_STUDENT.CURRVAL FROM STUDENT;

-- CREATE SYNONYM FOR STUDENT TABLE AND SELECT ALL RECORDS

CREATE SYNONYM S FOR STUDENT;

SELECT * FROM S;

--CREATING AN OPTIMIZED INDEX FOR EFFICIENT MANAGEMENT OF STUDENT NAMES AND COLLEGE IDS IN THE STUDENT TABLE

CREATE INDEX IDX_STUDENT
ON STUDENT (INITCAP(STUDENT_NAME), COLLEGE_ID);

--RETRIEVING THE LIST OF INDEXES FOR THE STUDENT TABLE

SELECT INDEX_NAME
FROM USER_INDEXES
WHERE TABLE_NAME = 'STUDENT';

COMMIT;