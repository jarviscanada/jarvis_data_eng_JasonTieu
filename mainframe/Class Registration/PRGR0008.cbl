      *================================================================*
      *  PRGR0008 - REPORT FILE WITH COURSE BREAK                      *
      *  Sorts VSAM data by course then generates a grouped report.    *
      *                                                                *
      *  ENHANCEMENT:                                                  *
      *  - After the report is printed, asks the user if they want     *
      *    to run it again or return to the main menu.                 *
      *  Author: Jason Tieu
      *  STUDENT MANAGEMENT SYSTEM
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGR0008.


       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT VSAM-FILE
               ASSIGN TO 'VSAMFILE'
               ORGANIZATION IS INDEXED
               ACCESS MODE  IS SEQUENTIAL
               RECORD KEY   IS SR-ID
               FILE STATUS  IS WS-VSAM-STATUS.

           SELECT SORT-WORK
               ASSIGN TO 'SORTWORK'.

           SELECT SORT-OUT-FILE
               ASSIGN TO 'SORTOUT.DAT'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS  IS WS-SORT-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  VSAM-FILE.
       COPY 'STUDENT-RECORD'.

       SD  SORT-WORK.
       01  SORT-RECORD.
           05  SORT-COURSE        PIC X(15).
           05  SORT-ID            PIC 9(4).
           05  SORT-NAME          PIC X(25).
           05  SORT-BIRTHDAY      PIC 9(8).
           05  SORT-INSERT-DATE   PIC 9(8).
           05  SORT-UPDATE-DATE   PIC 9(8).

       FD  SORT-OUT-FILE.
       01  SORT-OUT-RECORD        PIC X(78).

       WORKING-STORAGE SECTION.

       01  WS-VSAM-STATUS         PIC XX    VALUE SPACES.
       01  WS-SORT-STATUS         PIC XX    VALUE SPACES.
       01  WS-EOF                 PIC X     VALUE 'N'.
       01  WS-TOTAL-COUNTER       PIC 9(4)  VALUE 0.
       01  WS-BREAK-COUNTER       PIC 9(4)  VALUE 0.
       01  WS-CURRENT-COURSE      PIC X(15) VALUE SPACES.
       01  WS-FIRST-RECORD        PIC X     VALUE 'Y'.
       01  WS-ANOTHER             PIC X     VALUE SPACES.
       01  WS-CONTINUE            PIC X     VALUE 'Y'.
       01  WS-INPUT-VALID         PIC X     VALUE 'N'.
       01  WS-LINE                PIC X(75) VALUE ALL '-'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
      *  The SORT verb runs the full pipeline each time through the     *
      *  loop. Each iteration re-reads VSAM, re-sorts, and re-prints.  *
           PERFORM UNTIL WS-CONTINUE = 'N'
               SORT SORT-WORK
                   ASCENDING KEY SORT-COURSE
                   ASCENDING KEY SORT-ID
                   INPUT PROCEDURE  1000-LOAD-SORT
                   OUTPUT PROCEDURE 2000-PRODUCE-REPORT
               PERFORM 2500-ASK-ANOTHER
           END-PERFORM
           GOBACK.

      *----------------------------------------------------------------*
       1000-LOAD-SORT SECTION.
       1000-LOAD-SORT-START.
           OPEN INPUT VSAM-FILE
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               GO TO 1000-LOAD-SORT-END
           END-IF
           MOVE 'N' TO WS-EOF
           PERFORM UNTIL WS-EOF = 'Y'
               READ VSAM-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       MOVE SR-COURSE       TO SORT-COURSE
                       MOVE SR-ID           TO SORT-ID
                       MOVE SR-NAME         TO SORT-NAME
                       MOVE SR-BIRTHDAY     TO SORT-BIRTHDAY
                       MOVE SR-INSERT-DATE  TO SORT-INSERT-DATE
                       MOVE SR-UPDATE-DATE  TO SORT-UPDATE-DATE
                       RELEASE SORT-RECORD
               END-READ
           END-PERFORM
           CLOSE VSAM-FILE.
       1000-LOAD-SORT-END.
           EXIT.

      *----------------------------------------------------------------*
       2000-PRODUCE-REPORT SECTION.
       2000-PRODUCE-REPORT-START.
      *  Reset all counters and flags before producing the report      *
      *  so repeated runs (from the continue loop) start clean.        *
           MOVE 'N'    TO WS-EOF
           MOVE 'Y'    TO WS-FIRST-RECORD
           MOVE SPACES TO WS-CURRENT-COURSE
           MOVE 0      TO WS-TOTAL-COUNTER

           DISPLAY SPACES
           DISPLAY WS-LINE
           DISPLAY '                      C L A S S   R E P O R T'

           PERFORM UNTIL WS-EOF = 'Y'
               RETURN SORT-WORK
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       PERFORM 2100-PROCESS-SORT-RECORD
               END-RETURN
           END-PERFORM

           IF WS-FIRST-RECORD = 'N'
               DISPLAY WS-LINE
           END-IF
           DISPLAY WS-LINE
           DISPLAY 'TOTAL STUDENTS : ' WS-TOTAL-COUNTER
           DISPLAY SPACES.

       2000-PRODUCE-REPORT-END.
           EXIT.

      *----------------------------------------------------------------*
       2100-PROCESS-SORT-RECORD.
           IF SORT-COURSE NOT = WS-CURRENT-COURSE
               IF WS-FIRST-RECORD = 'N'
                   DISPLAY WS-LINE
               END-IF
               MOVE SORT-COURSE  TO WS-CURRENT-COURSE
               MOVE 'N'          TO WS-FIRST-RECORD
               MOVE 0            TO WS-BREAK-COUNTER
               DISPLAY SPACES
               DISPLAY '   COURSE: ' WS-CURRENT-COURSE
               DISPLAY WS-LINE
               DISPLAY ' ID  | STUDENT NAME      | BIRTHDAY |'
                       ' INSERT DATE | UPDATE DATE'
               DISPLAY WS-LINE
           END-IF
           ADD 1 TO WS-TOTAL-COUNTER
           ADD 1 TO WS-BREAK-COUNTER
           DISPLAY SORT-ID ' | '
                   SORT-NAME ' | '
                   SORT-BIRTHDAY ' | '
                   SORT-INSERT-DATE ' | '
                   SORT-UPDATE-DATE.

      *----------------------------------------------------------------*
       2500-ASK-ANOTHER.
      *  After the report prints, ask if the user wants to run it      *
      *  again or return to the menu. Validates Y or N only.           *
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'DO YOU WANT TO RUN THE REPORT AGAIN?'
                       ' (Y/N) >>'
               ACCEPT WS-ANOTHER
               EVALUATE TRUE
                   WHEN WS-ANOTHER = 'Y' OR WS-ANOTHER = 'y'
                       MOVE 'Y' TO WS-CONTINUE
                       MOVE 'Y' TO WS-INPUT-VALID
                   WHEN WS-ANOTHER = 'N' OR WS-ANOTHER = 'n'
                       MOVE 'N' TO WS-CONTINUE
                       MOVE 'Y' TO WS-INPUT-VALID
                   WHEN OTHER
                       DISPLAY '*** PLEASE ENTER Y OR N ***'
               END-EVALUATE
           END-PERFORM.
