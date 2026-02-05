# Introduction

# SQL Queries

##### Table Setup (DDL)

```sql
CREATE TABLE cd.members
(
    memid INTEGER NOT NULL,
    surname VARCHAR(200) NOT NULL,
    firstname VARCHAR(200) NOT NULL,
    address VARCHAR(300) NOT NULL,
    zipcode INTEGER NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    recommendedby INTEGER NOT NULL,
    joindate TIMESTAMP NOT NULL,
    CONSTRAINT members_pk PRIMARY KEY (memid),
    CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommenedby),
        REFERENCES cd.members(memid) ON DELETE SET NULL
);

CREATE TABLE cd.facilities
(
    facid INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    membercost NUMERIC NOT NULL,
    guestcost NUMERIC NOT NULL,
    initialoutlay NUMERIC NOT NULL,
    monthlymaintenance NUMERIC NOT NULL,
    CONSTRAINT facid_pk PRIMARY KEY (facid)    
);

CREATE TABLE cd.bookings
(
    bookid INTEGER NOT NULL,
    facid INTEGER NOT NULL,
    memid INTEGER NOT NULL,
    starttime timestamp NOT NULL,
    slots INTEGER NOT NULL,
    CONSTRAINT bookid_pk PRIMARY KEY (bookid),
    CONSTRAINT fk_memid FOREIGN KEY (memid),
    CONSTRAINT fk_facid FOREIGN KEY (facid)
);
```

##### Question 1: Show all members

```sql
SELECT *
FROM cd.member
```

##### Question 2: Insert data into table

```sql 
INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT (SELECT max(facid) FROM cd.facilities)+1, 'Spa', 20, 30, 100000, 800;
```

##### Question 3: Update existing data

```sql
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1
```

##### Question 4: Update a row based on the contents of another row

```sql
UPDATE cd.facilities
SET
membercost = (SELECT membercost * 1.1 FROM cd.facilities WHERE facid = 0),
guestcost = (SELECT guestcost * 1.1 FROM cd.facilities WHERE facid = 0)
WHERE facid = 1;
```

##### Question 5: Delete all whole table

```sql
DELETE FROM cd.bookings
```

##### Question 6: Delete data with conditions

```sql
DELETE FROM cd.members
WHERE memid = 37
```

##### Question 7: Control which rows are retrieved

```sql
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0 and
(membercost < monthlymaintenance / 50)
```

##### Question 8: Basic string searches

```sql
SELECT * FROM cd.facilities
WHERE name like '%Tennis%'
```

##### Question 9: Matching against multiple possible values

```sql
SELECT * FROM cd.facilities
WHERE facid in (1,5)
```

##### Question 10: Working with dates

```sql
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= '2012-09-01';
```

##### Question 11: Combining results from multiple queries

```sql
SELECT surname FROM cd.members
UNION
SELECT name FROM cd.facilities
```

##### Question 12: Retrieve the start times of members' bookings

```sql
SELECT bks.starttime
FROM cd.bookings bks
INNER JOIN cd.members mem ON mem.memid = bks.memid
WHERE mem.firstname ='David' AND mem.surname = 'Farrell'
```

##### Question 13: Work out the start times of bookings for tennis courts

```sql
SELECT bks.starttime AS STARTTIME, fac.name AS NAME 
	FROM cd.facilities fac
	INNER JOIN cd.bookings bks
		ON fac.facid = bks.facid
	WHERE fac.name in ('Tennis Court 2','Tennis Court 1') and 
		bks.starttime >= '2012-09-21' and bks.starttime < '2012-09-22'
order by bks.starttime;
```

##### Question 14: Produce a list of all members, along with their recommender

```sql
SELECT
mem.firstname AS MemberName,mem.surname AS LastName,
ref.firstname AS ReferName, ref.surname AS ReferSurname
FROM cd.members mem
LEFT OUTER JOIN cd.members ref ON ref.memid = mem.recommendedby
ORDER BY lastname, membername
```

##### Question 15: Produce a list of all members who have recommended another member

```sql
SELECT DISTINCT ref.firstname AS FirstName, ref.surname AS Surname
FROM cd.members mem
INNER JOIN cd.members ref ON ref.memid = mem.recommendedby
ORDER BY surname, firstname
```

##### Question 16: Produce a list of all members, along with their recommender, using no joins.

```sql
SELECT DISTINCT mem.firstname || ' '  || mem.surname AS member,
(SELECT ref.firstname || ' ' || ref.surname AS reccomender
FROM cd.members ref
WHERE ref.memid = mem.recommendedby
)
FROM cd.members mem
ORDER BY member
```

##### Question 17: Count the number of recommendations each member makes.

```sql
SELECT recommendedby, COUNT(*)
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby
```

##### Question 18: List the total slots booked per facility

```sql
SELECT facid, SUM(slots)
FROM cd.bookings
GROUP BY facid
ORDER BY facid
```

##### Question 19: List the total slots booked per facility in a given month

```sql
SELECT facid, SUM(slots) AS "Totalslots"
FROM cd.bookings
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
GROUP BY bookings.facid
ORDER BY "Totalslots"
```

##### Question 20: List the total slots booked per facility per month

```sql
SELECT facid, EXTRACT(month from starttime) AS month, SUM(slots) AS "Totalslots"
FROM cd.bookings
WHERE EXTRACT(year from starttime) = 2012
GROUP BY facid, month
ORDER facid
```

##### Question 21: Find the count of members who have made at least one booking

```sql
SELECT COUNT(DISTINCT memid)
FROM cd.bookings
```

##### Question 22: List each member's first booking after September 1st 2012

```sql
SELECT m.surname, m.firstname, bk.memid, MIN(bk.starttime) AS starttimne
FROM cd.members m INNER JOIN cd.bookings bk ON bk.memid = m.memid
WHERE bk.starttime > '2012-09-01'
GROUP BY m.surname, m.firstname, bk.memid
ORDER BY bk.memid
```

##### Question 23: Produce a list of member names, with each row containing the total member count

```sql
SELECT COUNT(*) OVER(), firstname, surname
FROM cd.members
ORDER BY joindate
```

##### Question 24: Produce a numbered list of members

```sql
SELECT ROW_NUMBER() OVER(ORDER BY joindate), firstname, surname
FROM cd.members
```

##### Question 25: Output the facility id that has the highest number of slots booked

```sql
SELECT facid, total
FROM (
SELECT facid, SUM(slots) total, RANK() OVER(ORDER BY SUM(slots) DESC) AS rank
FROM bookings
GROUP BY facid
) Ranked
WHERE rank = 1
```

##### Question 26: Format the names of members

```sql
SELECT surname || ', ' || firstname
FROM cd.members
```

##### Question 27: Find telephone numbers with parentheses

```sql
SELECT telephone
FROM members
WHERE telephone ~ '[()]'
```

##### Question 28: Count the number of members whose surname starts with each letter of the alphabet

```sql
SELECT SUBSTR(surname, 1 , 1) AS letter , COUNT(*) AS count
FROM cd.members
GROUP BY letter
ORDER BY letter
```
