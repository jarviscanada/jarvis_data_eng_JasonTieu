      *================================================================*
      *  PRGV0001 - GENERATE VSAM FILE FROM SEQUENTIAL FILE           *
      *  Reads flat CSV-style input and loads records into VSAM KSDS  *
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGV0001.
       AUTHOR.     STUDENT MANAGEMENT SYSTEM.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

      *--- Sequential input file ---
           SELECT SEQ-FILE
               ASSIGN TO 'SEQFILE.DAT'
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE  IS SEQUENTIAL
               FILE STATUS  IS WS-SEQ-STATUS.

      *--- VSAM KSDS output file ---
           SELECT VSAM-FILE
               ASSIGN TO 'VSAMFILE'
               ORGANIZATION IS INDEXED
               ACCESS MODE  IS SEQUENTIAL
               RECORD KEY   IS SR-ID
               FILE STATUS  IS WS-VSAM-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  SEQ-FILE.
       01  SEQ-RECORD             PIC X(80).

       FD  VSAM-FILE.
       COPY 'STUDENT-RECORD'.

       WORKING-STORAGE SECTION.

       01  WS-SEQ-STATUS          PIC XX    VALUE SPACES.
       01  WS-VSAM-STATUS         PIC XX    VALUE SPACES.
       01  WS-EOF                 PIC X     VALUE 'N'.
       01  WS-COUNTER             PIC 9(4)  VALUE 0.
       01  WS-SKIP-HEADER         PIC X     VALUE 'Y'.

      *--- Date field ---
       01  WS-TODAY.
           05  WS-YEAR            PIC 9(4).
           05  WS-MONTH           PIC 9(2).
           05  WS-DAY             PIC 9(2).
       01  WS-INSERT-DATE         PIC 9(8)  VALUE 0.

      *--- Parsed fields from sequential record ---
       01  WS-PARSE-AREA.
           05  WS-P-ID            PIC X(4).
           05  WS-P-NAME          PIC X(25).
           05  WS-P-BIRTHDAY      PIC X(8).
           05  WS-P-COURSE        PIC X(15).

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM 1000-INIT
           PERFORM 2000-PROCESS UNTIL WS-EOF = 'Y'
           PERFORM 3000-TERMINATE
           STOP RUN.

      *----------------------------------------------------------------*
       1000-INIT.
           MOVE FUNCTION CURRENT-DATE(1:8) TO WS-INSERT-DATE
           OPEN INPUT  SEQ-FILE
           OPEN OUTPUT VSAM-FILE
           DISPLAY SPACES
           DISPLAY '*** PRGV0001 - GENERATING VSAM FILE ***'
           DISPLAY SPACES
           IF WS-SEQ-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING SEQUENTIAL FILE: ' WS-SEQ-STATUS
               STOP RUN
           END-IF
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               STOP RUN
           END-IF.

      *----------------------------------------------------------------*
       2000-PROCESS.
           READ SEQ-FILE INTO SEQ-RECORD
               AT END MOVE 'Y' TO WS-EOF
               NOT AT END
                   PERFORM 2100-LOAD-RECORD
           END-READ.

      *----------------------------------------------------------------*
       2100-LOAD-RECORD.
      *--- Skip the header line (ID,NAME,BIRTHDAY,COURSE) ---
           IF WS-SKIP-HEADER = 'Y'
               MOVE 'N' TO WS-SKIP-HEADER
               EXIT PARAGRAPH
           END-IF
      *--- Parse comma-delimited: ID,NAME,BIRTHDAY,COURSE ---
           UNSTRING SEQ-RECORD DELIMITED BY ','
               INTO WS-P-ID
                    WS-P-NAME
                    WS-P-BIRTHDAY
                    WS-P-COURSE
           END-UNSTRING
           INITIALIZE STUDENT-RECORD
           MOVE FUNCTION NUMVAL(WS-P-ID)  TO SR-ID
           MOVE FUNCTION TRIM(WS-P-NAME
               LEADING)                   TO SR-NAME
           MOVE FUNCTION NUMVAL(WS-P-BIRTHDAY) TO SR-BIRTHDAY
           MOVE FUNCTION TRIM(WS-P-COURSE
               LEADING)                   TO SR-COURSE
           MOVE WS-INSERT-DATE            TO SR-INSERT-DATE
           MOVE 0                         TO SR-UPDATE-DATE
           WRITE STUDENT-RECORD
           IF WS-VSAM-STATUS = '00'
               ADD 1 TO WS-COUNTER
               DISPLAY 'LOADED: ' SR-ID ' - ' SR-NAME
           ELSE
               DISPLAY 'ERROR WRITING RECORD - STATUS: '
                       WS-VSAM-STATUS
           END-IF.

      *----------------------------------------------------------------*
       3000-TERMINATE.
           CLOSE SEQ-FILE
           CLOSE VSAM-FILE
           DISPLAY SPACES
           DISPLAY '*** VSAM FILE GENERATED SUCCESSFULLY ***'
           DISPLAY 'TOTAL RECORDS LOADED: ' WS-COUNTER
           DISPLAY SPACES.
