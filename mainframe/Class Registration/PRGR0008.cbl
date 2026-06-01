      *================================================================*
      *  PRGR0008 - REPORT FILE WITH COURSE BREAK                     *
      *  Reads VSAM sequentially; prints subtotals at each new course *
      *  Note: VSAM is keyed by ID, not course. For a proper course   *
      *  break report the VSAM must be sorted by course first, or a   *
      *  sort work file used. This version does a pass-through and    *
      *  groups by detecting course changes in sequence.              *
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGR0008.
       AUTHOR.     STUDENT MANAGEMENT SYSTEM.

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
       01  WS-LINE                PIC X(75) VALUE ALL '-'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
      *--- Sort VSAM output by course then ID ---
           SORT SORT-WORK
               ASCENDING KEY SORT-COURSE
               ASCENDING KEY SORT-ID
               INPUT PROCEDURE  1000-LOAD-SORT
               OUTPUT PROCEDURE 2000-PRODUCE-REPORT
           STOP RUN.

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

      *--- Print final group ---
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
      *--- Control break: new course detected ---
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
      *--- Print the student line ---
           ADD 1 TO WS-TOTAL-COUNTER
           ADD 1 TO WS-BREAK-COUNTER
           DISPLAY SORT-ID ' | '
                   SORT-NAME ' | '
                   SORT-BIRTHDAY ' | '
                   SORT-INSERT-DATE ' | '
                   SORT-UPDATE-DATE.
