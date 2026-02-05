-- Modifying Data
-- Question 1
INSERT into cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    VALUES (9, 'Spa', 20, 30, 100000, 800)

-- Question 2
INSERT INTO cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    SELECT (SELECT max(facid) FROM cd.facilities)+1, 'Spa', 20, 30, 100000, 800;

-- Question 3
UPDATE cd.facilities
    SET initialoutlay = 10000
    WHERE facid = 1

-- Question 4

UPDATE cd.facilities
    SET
        membercost = (SELECT membercost * 1.1 FROM cd.facilities WHERE facid = 0),
        guestcost = (SELECT guestcost * 1.1 FROM cd.facilities WHERE facid = 0)
WHERE facid = 1;

-- Question 5

DELETE FROM cd.bookings

-- Question 6

DELETE FROM cd.members
WHERE memid = 37

-- Question 7

SELECT facid, name, membercost, monthlymaintenance
    FROM cd.facilities
    WHERE membercost > 0 and
        (membercost < monthlymaintenance / 50)

-- Question 8

SELECT * FROM cd.facilities
    WHERE name like '%Tennis%'

-- Question 9

SELECT * FROM cd.facilities
WHERE facid in (1,5)

-- Question 10

SELECT memid, surname, firstname, joindate
    FROM cd.members
    WHERE joindate >= '2012-09-01';

-- Question 11

SELECT surname FROM cd.members
UNION
SELECT name FROM cd.facilities

-- Question 12

SELECT bks.starttime
FROM cd.bookings bks
    INNER JOIN cd.members mem ON mem.memid = bks.memid
WHERE mem.firstname ='David' AND mem.surname = 'Farrell'

-- Question 13

SELECT bks.starttime AS STARTTIME, fac.name AS NAME
FROM cd.facilities fac
         INNER JOIN cd.bookings bks
                    ON fac.facid = bks.facid
WHERE fac.name in ('Tennis Court 2','Tennis Court 1') AND
    bks.starttime >= '2012-09-21' AND bks.starttime < '2012-09-22'
ORDER BY bks.starttime;

-- Question 14

SELECT
    mem.firstname AS MemberName,mem.surname AS LastName,
    ref.firstname AS ReferName, ref.surname AS ReferSurname
FROM cd.members mem
    LEFT OUTER JOIN cd.members ref ON ref.memid = mem.recommendedby
ORDER BY lastname, membername

-- Question 15

SELECT DISTINCT ref.firstname AS FirstName, ref.surname AS Surname
FROM cd.members mem
    INNER JOIN cd.members ref ON ref.memid = mem.recommendedby
ORDER BY surname, firstname

-- Question 16

SELECT DISTINCT mem.firstname || ' '  || mem.surname AS member,
    (SELECT ref.firstname || ' ' || ref.surname AS reccomender
     FROM cd.members ref
     WHERE ref.memid = mem.recommendedby
    )
    FROM cd.members mem
ORDER BY member

-- Question 17

SELECT recommendedby, COUNT(*)
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby

-- Question 18

SELECT facid, SUM(slots)
FROM cd.bookings
GROUP BY facid
ORDER BY facid

-- Question 19

SELECT facid, SUM(slots) AS "Totalslots"
FROM cd.bookings
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
GROUP BY bookings.facid
ORDER BY "Totalslots"

-- Question 20

SELECT facid, EXTRACT(month from starttime) AS month, SUM(slots) AS "Totalslots"
FROM cd.bookings
WHERE EXTRACT(year from starttime) = 2012
GROUP BY facid, month
ORDER facid

-- Question 21

SELECT COUNT(DISTINCT memid)
FROM cd.bookings

-- Question 22

SELECT m.surname, m.firstname, bk.memid, MIN(bk.starttime) AS starttimne
FROM cd.members m INNER JOIN cd.bookings bk ON bk.memid = m.memid
WHERE bk.starttime > '2012-09-01'
GROUP BY m.surname, m.firstname, bk.memid
ORDER BY bk.memid

-- Question 23

SELECT COUNT(*) OVER(), firstname, surname
FROM cd.members
ORDER BY joindate

-- Question 24

SELECT ROW_NUMBER() OVER(ORDER BY joindate), firstname, surname
FROM cd.members

-- Question 25

SELECT facid, total
    FROM (
         SELECT facid, SUM(slots) total, RANK() OVER(ORDER BY SUM(slots) DESC) AS rank
         FROM bookings
         GROUP BY facid
     ) Ranked
WHERE rank = 1

-- Question 26

SELECT surname || ', ' || firstname
FROM cd.members

-- Question 27

SELECT telephone
FROM members
WHERE telephone ~ '[()]'

-- Question 28

SELECT SUBSTR(surname, 1 , 1) AS letter , COUNT(*) AS count
FROM cd.members
GROUP BY letter
ORDER BY letter
