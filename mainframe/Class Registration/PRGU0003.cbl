      *================================================================*
      *  PRGU0003 - UPDATE STUDENT RECORD IN VSAM                     *
      *  Reads student by ID, shows current data, applies changes     *
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGU0003.
       AUTHOR.     STUDENT MANAGEMENT SYSTEM.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT VSAM-FILE
               ASSIGN TO 'VSAMFILE'
               ORGANIZATION IS INDEXED
               ACCESS MODE  IS RANDOM
               RECORD KEY   IS SR-ID
               FILE STATUS  IS WS-VSAM-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  VSAM-FILE.
       COPY 'STUDENT-RECORD'.

       WORKING-STORAGE SECTION.

       01  WS-VSAM-STATUS         PIC XX    VALUE SPACES.
       01  WS-SEARCH-ID           PIC 9(4)  VALUE 0.
       01  WS-UPDATE-DATE         PIC 9(8)  VALUE 0.
       01  WS-NEW-NAME            PIC X(25) VALUE SPACES.
       01  WS-NEW-BIRTHDAY        PIC X(8)  VALUE SPACES.
       01  WS-NEW-COURSE          PIC X(15) VALUE SPACES.

      *--- Report header line ---
       01  WS-LINE                PIC X(78) VALUE ALL '-'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM 1000-INIT
           PERFORM 2000-GET-ID
           PERFORM 3000-READ-RECORD
           PERFORM 4000-GET-UPDATES
           PERFORM 5000-REWRITE-RECORD
           PERFORM 6000-TERMINATE
           STOP RUN.

      *----------------------------------------------------------------*
       1000-INIT.
           MOVE FUNCTION CURRENT-DATE(1:8) TO WS-UPDATE-DATE
           OPEN I-O VSAM-FILE
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               STOP RUN
           END-IF
           DISPLAY SPACES
           DISPLAY '+---------------------------------+'
           DISPLAY '|   U P D A T E   S T U D E N T   |'
           DISPLAY '+---------------------------------+'
           DISPLAY SPACES.

      *----------------------------------------------------------------*
       2000-GET-ID.
           DISPLAY 'ENTER THE 4 DIGIT STUDENT ID >>'
           ACCEPT WS-SEARCH-ID.

      *----------------------------------------------------------------*
       3000-READ-RECORD.
           MOVE WS-SEARCH-ID TO SR-ID
           READ VSAM-FILE
           IF WS-VSAM-STATUS = '00'
               DISPLAY SPACES
               DISPLAY '<--- STUDENT TO BE UPDATED --->'
               PERFORM 9000-DISPLAY-HEADER
               PERFORM 9100-DISPLAY-RECORD
               DISPLAY WS-LINE
               DISPLAY SPACES
           ELSE IF WS-VSAM-STATUS = '23'
               DISPLAY 'STUDENT ID ' WS-SEARCH-ID ' NOT FOUND.'
               CLOSE VSAM-FILE
               STOP RUN
           ELSE
               DISPLAY 'ERROR READING VSAM FILE: ' WS-VSAM-STATUS
               CLOSE VSAM-FILE
               STOP RUN
           END-IF.

      *----------------------------------------------------------------*
       4000-GET-UPDATES.
           DISPLAY 'ENTER THE DETAILS TO BE CHANGED'
           DISPLAY 'NEW STUDENT NAME (MAX 25 CHAR) - SPACE TO SKIP >>'
           ACCEPT WS-NEW-NAME
           IF WS-NEW-NAME NOT = SPACES
               MOVE WS-NEW-NAME TO SR-NAME
           END-IF

           DISPLAY 'NEW BIRTHDAY (YYYYMMDD) - SPACE TO SKIP >>'
           ACCEPT WS-NEW-BIRTHDAY
           IF WS-NEW-BIRTHDAY NOT = SPACES
               MOVE FUNCTION NUMVAL(WS-NEW-BIRTHDAY) TO SR-BIRTHDAY
           END-IF

           DISPLAY 'NEW COURSE NAME (MAX 15 CHAR) - SPACE TO SKIP >>'
           ACCEPT WS-NEW-COURSE
           IF WS-NEW-COURSE NOT = SPACES
               MOVE WS-NEW-COURSE TO SR-COURSE
           END-IF

           MOVE WS-UPDATE-DATE TO SR-UPDATE-DATE.

      *----------------------------------------------------------------*
       5000-REWRITE-RECORD.
           REWRITE STUDENT-RECORD
           IF WS-VSAM-STATUS = '00'
               DISPLAY SPACES
               DISPLAY '<--- UPDATED STUDENT DETAILS --->'
               PERFORM 9000-DISPLAY-HEADER
               PERFORM 9100-DISPLAY-RECORD
               DISPLAY WS-LINE
               DISPLAY SPACES
           ELSE
               DISPLAY 'ERROR REWRITING RECORD - STATUS: '
                       WS-VSAM-STATUS
           END-IF.

      *----------------------------------------------------------------*
       6000-TERMINATE.
           CLOSE VSAM-FILE.

      *----------------------------------------------------------------*
       9000-DISPLAY-HEADER.
           DISPLAY WS-LINE
           DISPLAY ' ID  | STUDENT NAME      | BIRTHDAY |'
                   ' COURSE         | INSERT DATE | UPDATE DATE'
           DISPLAY WS-LINE.

      *----------------------------------------------------------------*
       9100-DISPLAY-RECORD.
           DISPLAY SR-ID ' | '
                   SR-NAME ' | '
                   SR-BIRTHDAY ' | '
                   SR-COURSE ' | '
                   SR-INSERT-DATE ' | '
                   SR-UPDATE-DATE.
