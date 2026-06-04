      *================================================================*
      *  PRGV0001 - GENERATE VSAM FILE FROM SEQUENTIAL FILE            *
      *  This program is run ONCE to bootstrap the system. It reads    *
      *  the comma-delimited flat file SEQFILE.DAT and loads each      *
      *  student record into the VSAM KSDS indexed file.               *
      *                                                                *
      *  WARNING: Opening VSAM as OUTPUT wipes any existing data.      *
      *  Do not run this again after the system is in use — all        *
      *  inserts, updates, and deletes from other programs will be     *
      *  lost and replaced with only the original 9 seed records.      *
      *  Author: Jason Tieu
      *  STUDENT MANAGEMENT SYSTEM
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGV0001.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

      *----------------------------------------------------------------*
      *  SEQ-FILE: The input flat file. LINE SEQUENTIAL means each     *
      *  record is terminated by a newline character, which is the     *
      *  standard format for text files on Linux/Windows.              *
      *  WS-SEQ-STATUS receives a 2-character code after every         *
      *  file operation: '00' = success, '10' = end of file,          *
      *  '35' = file not found, etc.                                   *
      *----------------------------------------------------------------*
           SELECT SEQ-FILE
               ASSIGN TO 'SEQFILE.DAT'
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE  IS SEQUENTIAL
               FILE STATUS  IS WS-SEQ-STATUS.

      *----------------------------------------------------------------*
      *  VSAM-FILE: The indexed output file. ORGANIZATION IS INDEXED   *
      *  tells GnuCOBOL this is a KSDS (Key Sequenced Data Set).       *
      *  RECORD KEY IS SR-ID declares which field is the primary key   *
      *  — VSAM builds and maintains the B-tree index on this field.   *
      *  Records are automatically stored in ascending key order.      *
      *----------------------------------------------------------------*
           SELECT VSAM-FILE
               ASSIGN TO 'VSAMFILE'
               ORGANIZATION IS INDEXED
               ACCESS MODE  IS SEQUENTIAL
               RECORD KEY   IS SR-ID
               FILE STATUS  IS WS-VSAM-STATUS.

       DATA DIVISION.
       FILE SECTION.

      *  FD = File Description. Defines the structure of each record   *
      *  in the sequential input file as a raw 80-character string.    *
       FD  SEQ-FILE.
       01  SEQ-RECORD             PIC X(80).

      *  The VSAM file record layout comes from the shared copybook.   *
      *  COPY inserts the 01 STUDENT-RECORD definition here at         *
      *  compile time, ensuring the layout matches all other programs. *
       FD  VSAM-FILE.
       COPY 'STUDENT-RECORD'.

       WORKING-STORAGE SECTION.

      *  File status fields — checked after every file operation.      *
      *  '00' means success. Anything else is an error or condition.   *
       01  WS-SEQ-STATUS          PIC XX    VALUE SPACES.
       01  WS-VSAM-STATUS         PIC XX    VALUE SPACES.

      *  WS-EOF: End-of-file flag. Set to 'Y' when the sequential      *
      *  READ returns AT END, stopping the main processing loop.       *
       01  WS-EOF                 PIC X     VALUE 'N'.

      *  WS-COUNTER: Counts successfully written VSAM records.         *
      *  Displayed in the final summary message.                       *
       01  WS-COUNTER             PIC 9(4)  VALUE 0.

      *  WS-SKIP-HEADER: The first line of SEQFILE.DAT is a column     *
      *  header (ID,NAME,BIRTHDAY,COURSE) not a data record. This flag *
      *  starts as 'Y' so the first line is skipped, then flips to 'N' *
      *  for all subsequent lines which are real student records.       *
       01  WS-SKIP-HEADER         PIC X     VALUE 'Y'.

      *  WS-INSERT-DATE: Today's date captured at program startup       *
      *  using FUNCTION CURRENT-DATE. Stamped on every loaded record   *
      *  as SR-INSERT-DATE. All 9 seed students share this same date.  *
       01  WS-INSERT-DATE         PIC 9(8)  VALUE 0.

      *  WS-PARSE-AREA: Temporary holding fields for the raw string     *
      *  pieces produced by UNSTRING before they are converted and      *
      *  moved into the typed STUDENT-RECORD fields.                    *
       01  WS-PARSE-AREA.
           05  WS-P-ID            PIC X(4).
           05  WS-P-NAME          PIC X(25).
           05  WS-P-BIRTHDAY      PIC X(8).
           05  WS-P-COURSE        PIC X(15).

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
      *  Standard three-phase structure: initialise, process, finish.  *
      *  PERFORM UNTIL keeps calling 2000-PROCESS until WS-EOF = 'Y', *
      *  which happens when the sequential file runs out of records.   *
      *----------------------------------------------------------------*
           PERFORM 1000-INIT
           PERFORM 2000-PROCESS UNTIL WS-EOF = 'Y'
           PERFORM 3000-TERMINATE
           STOP RUN.

      *----------------------------------------------------------------*
       1000-INIT.
      *  Capture today's date before opening files.                    *
      *  FUNCTION CURRENT-DATE returns a 21-character string:          *
      *    chars 1-4  = year, 5-6 = month, 7-8 = day (YYYYMMDD)       *
      *    chars 9-21 = time and timezone (not needed here)            *
      *  The (1:8) is reference modification — slice chars 1 through 8.*
      *                                                                *
      *  OPEN INPUT opens SEQ-FILE for reading only.                   *
      *  OPEN OUTPUT opens VSAM-FILE for writing — this ERASES any     *
      *  existing VSAM data and starts fresh from an empty file.       *
      *                                                                *
      *  Both file statuses are checked immediately. If either fails,  *
      *  the program displays the error code and stops. Running        *
      *  without valid files would cause unpredictable behaviour.      *
      *----------------------------------------------------------------*
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
      *  Reads one line from the sequential file on each call.         *
      *  AT END fires when there are no more records — it sets         *
      *  WS-EOF to 'Y' which causes the PERFORM UNTIL in 0000-MAIN    *
      *  to stop calling this paragraph.                               *
      *  NOT AT END is the normal path — a record was returned and     *
      *  2100-LOAD-RECORD is called to parse and write it.             *
      *----------------------------------------------------------------*
           READ SEQ-FILE INTO SEQ-RECORD
               AT END MOVE 'Y' TO WS-EOF
               NOT AT END
                   PERFORM 2100-LOAD-RECORD
           END-READ.

      *----------------------------------------------------------------*
       2100-LOAD-RECORD.
      *  SKIP HEADER: The first call hits this paragraph with          *
      *  WS-SKIP-HEADER still 'Y'. We flip it to 'N' and EXIT         *
      *  PARAGRAPH immediately — no parsing, no writing. The header    *
      *  line (ID,NAME,BIRTHDAY,COURSE) is discarded.                  *
      *                                                                *
      *  UNSTRING: Splits SEQ-RECORD on each comma ',' delimiter and   *
      *  deposits the pieces left-to-right into the INTO fields.       *
      *  For "0001,MATT THOMAS,19821209,ISPF-JCL" the result is:       *
      *    WS-P-ID       = '0001'                                      *
      *    WS-P-NAME     = 'MATT THOMAS'                               *
      *    WS-P-BIRTHDAY = '19821209'                                  *
      *    WS-P-COURSE   = 'ISPF-JCL'                                  *
      *                                                                *
      *  FUNCTION NUMVAL converts a character string like '0001' into  *
      *  the numeric value 1, which COBOL then stores as 0001 in the  *
      *  PIC 9(4) field SR-ID with automatic leading-zero padding.     *
      *                                                                *
      *  FUNCTION TRIM(...LEADING) strips any leading spaces that       *
      *  UNSTRING may have left before the text content.               *
      *                                                                *
      *  INITIALIZE blanks the entire STUDENT-RECORD before MOVEs so  *
      *  no leftover garbage from a previous iteration leaks into the  *
      *  new record.                                                    *
      *                                                                *
      *  WRITE hands the completed record to VSAM. Because SR-ID is    *
      *  the declared RECORD KEY, VSAM inserts it into the index at    *
      *  the correct sorted position automatically.                    *
      *  Status '00' = success. Any other status = write error.        *
      *----------------------------------------------------------------*
           IF WS-SKIP-HEADER = 'Y'
               MOVE 'N' TO WS-SKIP-HEADER
               EXIT PARAGRAPH
           END-IF

           UNSTRING SEQ-RECORD DELIMITED BY ','
               INTO WS-P-ID
                    WS-P-NAME
                    WS-P-BIRTHDAY
                    WS-P-COURSE
           END-UNSTRING

           INITIALIZE STUDENT-RECORD
           MOVE FUNCTION NUMVAL(WS-P-ID)       TO SR-ID
           MOVE FUNCTION TRIM(WS-P-NAME
               LEADING)                        TO SR-NAME
           MOVE FUNCTION NUMVAL(WS-P-BIRTHDAY) TO SR-BIRTHDAY
           MOVE FUNCTION TRIM(WS-P-COURSE
               LEADING)                        TO SR-COURSE
           MOVE WS-INSERT-DATE                 TO SR-INSERT-DATE
           MOVE 0                              TO SR-UPDATE-DATE

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
      *  Close both files to flush buffers and release OS file locks.  *
      *  Skipping CLOSE would cause the implicit-close warning from    *
      *  GnuCOBOL and could leave the VSAM index in an incomplete      *
      *  state. Always close files explicitly.                         *
      *----------------------------------------------------------------*
           CLOSE SEQ-FILE
           CLOSE VSAM-FILE
           DISPLAY SPACES
           DISPLAY '*** VSAM FILE GENERATED SUCCESSFULLY ***'
           DISPLAY 'TOTAL RECORDS LOADED: ' WS-COUNTER
           DISPLAY SPACES.
           GOBACK.
