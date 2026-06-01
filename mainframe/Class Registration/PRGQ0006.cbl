      *================================================================*
      *  PRGQ0006 - QUERY STUDENT RECORD BY ID                        *
      *  Uses VSAM random access to retrieve a specific student       *
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGQ0006.
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
       01  WS-LINE                PIC X(78) VALUE ALL '-'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM 1000-INIT
           PERFORM 2000-GET-ID
           PERFORM 3000-READ-AND-DISPLAY
           PERFORM 4000-TERMINATE
           STOP RUN.

      *----------------------------------------------------------------*
       1000-INIT.
           OPEN INPUT VSAM-FILE
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               STOP RUN
           END-IF
           DISPLAY SPACES
           DISPLAY '+-------------------------------------------+'
           DISPLAY '|   Q U E R Y   S T U D E N T   B Y   I D   |'
           DISPLAY '+-------------------------------------------+'
           DISPLAY SPACES.

      *----------------------------------------------------------------*
       2000-GET-ID.
           DISPLAY 'ENTER STUDENT ID (MAX 4 DIGITS) >>'
           ACCEPT WS-SEARCH-ID.

      *----------------------------------------------------------------*
       3000-READ-AND-DISPLAY.
           MOVE WS-SEARCH-ID TO SR-ID
           READ VSAM-FILE
           IF WS-VSAM-STATUS = '00'
               DISPLAY SPACES
               DISPLAY WS-LINE
               DISPLAY ' ID  | STUDENT NAME      | BIRTHDAY |'
                       ' COURSE         | INSERT DATE | UPDATE DATE'
               DISPLAY WS-LINE
               DISPLAY SR-ID ' | '
                       SR-NAME ' | '
                       SR-BIRTHDAY ' | '
                       SR-COURSE ' | '
                       SR-INSERT-DATE ' | '
                       SR-UPDATE-DATE
               DISPLAY WS-LINE
               DISPLAY SPACES
           ELSE IF WS-VSAM-STATUS = '23'
               DISPLAY SPACES
               DISPLAY 'STUDENT ID ' WS-SEARCH-ID ' NOT FOUND.'
               DISPLAY SPACES
           ELSE
               DISPLAY 'ERROR READING VSAM FILE: ' WS-VSAM-STATUS
           END-IF.

      *----------------------------------------------------------------*
       4000-TERMINATE.
           CLOSE VSAM-FILE.
