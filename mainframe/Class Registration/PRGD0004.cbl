      *================================================================*
      *  PRGD0004 - DELETE STUDENT RECORD FROM VSAM                   *
      *  Reads student by ID, shows record, confirms before deleting  *
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGD0004.
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
       01  WS-CONFIRM             PIC X     VALUE SPACES.
       01  WS-LINE                PIC X(78) VALUE ALL '-'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM 1000-INIT
           PERFORM 2000-GET-ID
           PERFORM 3000-READ-RECORD
           PERFORM 4000-CONFIRM-DELETE
           PERFORM 5000-TERMINATE
           STOP RUN.

      *----------------------------------------------------------------*
       1000-INIT.
           OPEN I-O VSAM-FILE
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               STOP RUN
           END-IF
           DISPLAY SPACES
           DISPLAY '+-------------------------------------------------+'
           DISPLAY '|   D E L E T E   S T U D E N T   D E T A I L S   |'
           DISPLAY '+-------------------------------------------------+'
           DISPLAY SPACES.

      *----------------------------------------------------------------*
       2000-GET-ID.
           DISPLAY 'ENTER STUDENT ID (MAX 4 DIGITS) >>'
           ACCEPT WS-SEARCH-ID.

      *----------------------------------------------------------------*
       3000-READ-RECORD.
           MOVE WS-SEARCH-ID TO SR-ID
           READ VSAM-FILE
           IF WS-VSAM-STATUS = '00'
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
       4000-CONFIRM-DELETE.
           DISPLAY 'ARE YOU SURE YOU WISH TO DELETE THE ABOVE'
                   ' STUDENT (Y/N)? >>'
           ACCEPT WS-CONFIRM
           IF WS-CONFIRM = 'Y' OR WS-CONFIRM = 'y'
               DELETE VSAM-FILE
               IF WS-VSAM-STATUS = '00'
                   DISPLAY SPACES
                   DISPLAY '<<----- DELETED THE ABOVE STUDENT ----->> '
                   DISPLAY SPACES
               ELSE
                   DISPLAY 'ERROR DELETING RECORD - STATUS: '
                           WS-VSAM-STATUS
               END-IF
           ELSE
               DISPLAY SPACES
               DISPLAY '*** DELETE CANCELLED ***'
               DISPLAY SPACES
           END-IF.

      *----------------------------------------------------------------*
       5000-TERMINATE.
           CLOSE VSAM-FILE.
