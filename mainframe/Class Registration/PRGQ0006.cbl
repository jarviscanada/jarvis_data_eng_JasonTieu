      *================================================================*
      *  PRGQ0006 - QUERY STUDENT RECORD BY ID                         *
      *  Uses VSAM random access to retrieve one student by ID.        *
      *                                                                *
      *  BACK TO MENU: At the opening prompt, typing N returns to the  *
      *  main menu immediately before the file is opened.              *
      *  Author: Jason Tieu
      *  STUDENT MANAGEMENT SYSTEM
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGQ0006.


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
       01  WS-ID-INPUT            PIC X(5)  VALUE SPACES.
       01  WS-INPUT-VALID         PIC X     VALUE 'N'.
       01  WS-ANOTHER             PIC X     VALUE SPACES.
       01  WS-CONTINUE            PIC X     VALUE 'Y'.
       01  WS-GO-BACK             PIC X     VALUE 'N'.
       01  WS-BACK-INPUT          PIC X     VALUE SPACES.
       01  WS-LINE                PIC X(78) VALUE ALL '-'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM 0500-CHECK-BACK
           IF WS-GO-BACK = 'N'
               PERFORM 1000-INIT
               PERFORM UNTIL WS-CONTINUE = 'N'
                   PERFORM 2000-GET-ID
                   PERFORM 3000-READ-AND-DISPLAY
                   PERFORM 3500-ASK-ANOTHER
               END-PERFORM
               PERFORM 4000-TERMINATE
           END-IF
           STOP RUN.

      *----------------------------------------------------------------*
       0500-CHECK-BACK.
           MOVE 'N' TO WS-INPUT-VALID
           DISPLAY SPACES
           DISPLAY '+-------------------------------------------+'
           DISPLAY '|   Q U E R Y   S T U D E N T   B Y   I D   |'
           DISPLAY '+-------------------------------------------+'
           DISPLAY SPACES
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'PROCEED TO QUERY A STUDENT BY ID?'
               DISPLAY '  Y = YES, CONTINUE'
               DISPLAY '  N = NO,  RETURN TO MAIN MENU'
               DISPLAY 'ENTER CHOICE >> '
               ACCEPT WS-BACK-INPUT
               EVALUATE TRUE
                   WHEN WS-BACK-INPUT = 'Y' OR WS-BACK-INPUT = 'y'
                       MOVE 'N' TO WS-GO-BACK
                       MOVE 'Y' TO WS-INPUT-VALID
                       MOVE 'Y' TO WS-CONTINUE
                   WHEN WS-BACK-INPUT = 'N' OR WS-BACK-INPUT = 'n'
                       DISPLAY SPACES
                       DISPLAY '*** RETURNING TO MAIN MENU ***'
                       DISPLAY SPACES
                       MOVE 'Y' TO WS-GO-BACK
                       MOVE 'Y' TO WS-INPUT-VALID
                   WHEN OTHER
                       DISPLAY '*** PLEASE ENTER Y OR N ***'
               END-EVALUATE
           END-PERFORM.

      *----------------------------------------------------------------*
       1000-INIT.
           OPEN INPUT VSAM-FILE
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               STOP RUN
           END-IF
           DISPLAY SPACES.

      *----------------------------------------------------------------*
       2000-GET-ID.
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'ENTER STUDENT ID (MAX 4 DIGITS) >>'
               ACCEPT WS-ID-INPUT
               EVALUATE TRUE
                   WHEN WS-ID-INPUT = SPACES
                       DISPLAY '*** ERROR: ID CANNOT BE BLANK. ***'
                   WHEN WS-ID-INPUT(5:1) NOT = SPACE
                       DISPLAY '*** ERROR: ID MUST BE MAX 4 DIGITS.'
                               ' PLEASE TRY AGAIN. ***'
                   WHEN WS-ID-INPUT(1:4) NOT NUMERIC
                       DISPLAY '*** ERROR: ID MUST BE NUMERIC.'
                               ' PLEASE TRY AGAIN. ***'
                   WHEN OTHER
                       MOVE FUNCTION NUMVAL(WS-ID-INPUT)
                           TO WS-SEARCH-ID
                       MOVE 'Y' TO WS-INPUT-VALID
               END-EVALUATE
           END-PERFORM.

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
               DISPLAY '*** STUDENT ID ' WS-SEARCH-ID
                       ' NOT FOUND. PLEASE TRY AGAIN. ***'
               DISPLAY SPACES
               PERFORM 2000-GET-ID
               PERFORM 3000-READ-AND-DISPLAY
           ELSE
               DISPLAY 'ERROR READING VSAM FILE: ' WS-VSAM-STATUS
           END-IF.

      *----------------------------------------------------------------*
       3500-ASK-ANOTHER.
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'DO YOU WANT TO QUERY ANOTHER STUDENT?'
               DISPLAY '  Y = YES'
               DISPLAY '  N = NO, RETURN TO MAIN MENU'
               DISPLAY 'ENTER CHOICE >> '
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

      *----------------------------------------------------------------*
       4000-TERMINATE.
           CLOSE VSAM-FILE.
           GOBACK.
