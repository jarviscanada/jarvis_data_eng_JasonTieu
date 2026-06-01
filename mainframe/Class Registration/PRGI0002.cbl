      *================================================================*
      *  PRGI0002 - INSERT NEW STUDENT RECORD INTO VSAM               *
      *  Prompts user for name, birthday, course; auto-assigns ID     *
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGI0002.
       AUTHOR.     STUDENT MANAGEMENT SYSTEM.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT VSAM-FILE
               ASSIGN TO 'VSAMFILE'
               ORGANIZATION IS INDEXED
               ACCESS MODE  IS DYNAMIC
               RECORD KEY   IS SR-ID
               FILE STATUS  IS WS-VSAM-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  VSAM-FILE.
       COPY 'STUDENT-RECORD'.

       WORKING-STORAGE SECTION.

       01  WS-VSAM-STATUS         PIC XX    VALUE SPACES.
       01  WS-NEW-NAME            PIC X(25) VALUE SPACES.
       01  WS-NEW-BIRTHDAY        PIC 9(8)  VALUE 0.
       01  WS-NEW-COURSE          PIC X(15) VALUE SPACES.
       01  WS-MAX-ID              PIC 9(4)  VALUE 0.
       01  WS-NEW-ID              PIC 9(4)  VALUE 0.
       01  WS-INSERT-DATE         PIC 9(8)  VALUE 0.
       01  WS-EOF                 PIC X     VALUE 'N'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM 1000-INIT
           PERFORM 1500-GET-MAX-ID
           PERFORM 2000-GET-INPUT
           PERFORM 3000-WRITE-RECORD
           PERFORM 4000-TERMINATE
           STOP RUN.

      *----------------------------------------------------------------*
       1000-INIT.
           MOVE FUNCTION CURRENT-DATE(1:8) TO WS-INSERT-DATE
           OPEN I-O VSAM-FILE
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               STOP RUN
           END-IF
           DISPLAY SPACES
           DISPLAY '+-----------------------------------+'
           DISPLAY '|   A D D   N E W   S T U D E N T   |'
           DISPLAY '+-----------------------------------+'
           DISPLAY SPACES.

      *----------------------------------------------------------------*
      *  Read all records sequentially to find the highest existing ID *
      *----------------------------------------------------------------*
       1500-GET-MAX-ID.
           MOVE 0    TO WS-MAX-ID
           MOVE 'N'  TO WS-EOF
           START VSAM-FILE KEY >= SR-ID
           PERFORM UNTIL WS-EOF = 'Y'
               READ VSAM-FILE NEXT
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       IF SR-ID > WS-MAX-ID
                           MOVE SR-ID TO WS-MAX-ID
                       END-IF
               END-READ
           END-PERFORM
           ADD 1 TO WS-MAX-ID GIVING WS-NEW-ID.

      *----------------------------------------------------------------*
       2000-GET-INPUT.
           DISPLAY 'ENTER FULL NAME (MAX 25 CHARS) >>'
           ACCEPT WS-NEW-NAME
           DISPLAY 'ENTER BIRTHDAY (YYYYMMDD) >>'
           ACCEPT WS-NEW-BIRTHDAY
           DISPLAY 'ENTER COURSE (MAX 15 CHARS) >>'
           ACCEPT WS-NEW-COURSE.

      *----------------------------------------------------------------*
       3000-WRITE-RECORD.
           INITIALIZE STUDENT-RECORD
           MOVE WS-NEW-ID          TO SR-ID
           MOVE WS-NEW-NAME        TO SR-NAME
           MOVE WS-NEW-BIRTHDAY    TO SR-BIRTHDAY
           MOVE WS-NEW-COURSE      TO SR-COURSE
           MOVE WS-INSERT-DATE     TO SR-INSERT-DATE
           MOVE 0                  TO SR-UPDATE-DATE
           WRITE STUDENT-RECORD
           IF WS-VSAM-STATUS = '00'
               DISPLAY SPACES
               DISPLAY '<<----- STUDENT INSERTED SUCCESSFULLY ----->> '
               DISPLAY 'NEW STUDENT ID: ' WS-NEW-ID
               DISPLAY SPACES
           ELSE
               DISPLAY 'ERROR WRITING RECORD - STATUS: '
                       WS-VSAM-STATUS
           END-IF.

      *----------------------------------------------------------------*
       4000-TERMINATE.
           CLOSE VSAM-FILE.
