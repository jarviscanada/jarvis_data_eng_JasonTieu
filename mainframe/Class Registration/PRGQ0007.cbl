      *================================================================*
      *  PRGQ0007 - QUERY STUDENTS BY DATE OF INCLUSION               *
      *  Sequential scan of VSAM; filters by matching INSERT-DATE     *
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGQ0007.
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

       DATA DIVISION.
       FILE SECTION.

       FD  VSAM-FILE.
       COPY 'STUDENT-RECORD'.

       WORKING-STORAGE SECTION.

       01  WS-VSAM-STATUS         PIC XX    VALUE SPACES.
       01  WS-EOF                 PIC X     VALUE 'N'.
       01  WS-COUNTER             PIC 9(4)  VALUE 0.
       01  WS-SEARCH-DATE         PIC 9(8)  VALUE 0.
       01  WS-LINE                PIC X(78) VALUE ALL '-'.

      *--- Formatted date for display (MM/DD/YYYY) ---
       01  WS-DISPLAY-DATE.
           05  WS-D-MM            PIC X(2).
           05  FILLER             PIC X     VALUE '/'.
           05  WS-D-DD            PIC X(2).
           05  FILLER             PIC X     VALUE '/'.
           05  WS-D-YYYY          PIC X(4).

      *--- Break down search date for formatting ---
       01  WS-SEARCH-DATE-X       REDEFINES WS-SEARCH-DATE.
           05  WS-SD-YYYY         PIC X(4).
           05  WS-SD-MM           PIC X(2).
           05  WS-SD-DD           PIC X(2).

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM 1000-INIT
           PERFORM 1500-GET-DATE
           PERFORM 2000-PROCESS UNTIL WS-EOF = 'Y'
           PERFORM 3000-TERMINATE
           STOP RUN.

      *----------------------------------------------------------------*
       1000-INIT.
           OPEN INPUT VSAM-FILE
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               STOP RUN
           END-IF
           DISPLAY SPACES
           DISPLAY '+-------------------------------------------------------------------+'
           DISPLAY '|   Q U E R Y   S T U D E N T   B Y   I N C L U S I O N   D A T E   |'
           DISPLAY '+-------------------------------------------------------------------+'
           DISPLAY SPACES.

      *----------------------------------------------------------------*
       1500-GET-DATE.
           DISPLAY 'ENTER THE DATE OF INCLUSION (YYYYMMDD) >>'
           ACCEPT WS-SEARCH-DATE
      *--- Format the date for display ---
           MOVE WS-SD-MM          TO WS-D-MM
           MOVE WS-SD-DD          TO WS-D-DD
           MOVE WS-SD-YYYY        TO WS-D-YYYY
           DISPLAY SPACES
           DISPLAY 'LIST OF STUDENTS INCLUDED ON: ' WS-DISPLAY-DATE
           DISPLAY WS-LINE
           DISPLAY ' ID  | STUDENT NAME      | BIRTHDAY |'
                   ' COURSE         | INSERT DATE | UPDATE DATE'
           DISPLAY WS-LINE.

      *----------------------------------------------------------------*
       2000-PROCESS.
           READ VSAM-FILE
               AT END MOVE 'Y' TO WS-EOF
               NOT AT END
                   PERFORM 2100-CHECK-AND-DISPLAY
           END-READ.

      *----------------------------------------------------------------*
       2100-CHECK-AND-DISPLAY.
           IF SR-INSERT-DATE = WS-SEARCH-DATE
               ADD 1 TO WS-COUNTER
               DISPLAY SR-ID ' | '
                       SR-NAME ' | '
                       SR-BIRTHDAY ' | '
                       SR-COURSE ' | '
                       SR-INSERT-DATE ' | '
                       SR-UPDATE-DATE
           END-IF.

      *----------------------------------------------------------------*
       3000-TERMINATE.
           DISPLAY WS-LINE
           DISPLAY 'TOTAL STUDENTS : ' WS-COUNTER
           DISPLAY SPACES
           CLOSE VSAM-FILE.
