      *================================================================*
      *  PRGU0003 - UPDATE STUDENT RECORD IN VSAM                      *
      *  Locates a student by ID, shows the current record, then       *
      *  prompts the user to change name, birthday, and/or course.     *
      *                                                                *
      *  BACK TO MENU: At the opening prompt, typing N returns to the  *
      *  main menu immediately before any file is opened.              *
      *  Author: Jason Tieu
      *  STUDENT MANAGEMENT SYSTEM
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGU0003.

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
       01  WS-NEW-NAME            PIC X(26) VALUE SPACES.
       01  WS-NEW-BIRTHDAY        PIC X(9)  VALUE SPACES.
       01  WS-NEW-COURSE          PIC X(16) VALUE SPACES.
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
                   PERFORM 3000-READ-RECORD
                   PERFORM 4000-GET-UPDATES
                   PERFORM 5000-REWRITE-RECORD
                   PERFORM 5500-ASK-ANOTHER
               END-PERFORM
               PERFORM 6000-TERMINATE
           END-IF
           STOP RUN.

      *----------------------------------------------------------------*
       0500-CHECK-BACK.
           MOVE 'N' TO WS-INPUT-VALID
           DISPLAY SPACES
           DISPLAY '+---------------------------------+'
           DISPLAY '|   U P D A T E   S T U D E N T   |'
           DISPLAY '+---------------------------------+'
           DISPLAY SPACES
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'PROCEED TO UPDATE A STUDENT RECORD?'
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
           MOVE FUNCTION CURRENT-DATE(1:8) TO WS-UPDATE-DATE
           OPEN I-O VSAM-FILE
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               STOP RUN
           END-IF
           DISPLAY SPACES.

      *----------------------------------------------------------------*
       2000-GET-ID.
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'ENTER THE 4 DIGIT STUDENT ID >>'
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
               DISPLAY '*** STUDENT ID ' WS-SEARCH-ID
                       ' NOT FOUND. PLEASE TRY AGAIN. ***'
               PERFORM 2000-GET-ID
               PERFORM 3000-READ-RECORD
           ELSE
               DISPLAY 'ERROR READING VSAM FILE: ' WS-VSAM-STATUS
               CLOSE VSAM-FILE
               STOP RUN
           END-IF.

      *----------------------------------------------------------------*
       4000-GET-UPDATES.
      *--- NAME -------------------------------------------------------*
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'NEW STUDENT NAME (MAX 25 CHAR)'
                       ' - SPACE TO SKIP >>'
               ACCEPT WS-NEW-NAME
               EVALUATE TRUE
                   WHEN WS-NEW-NAME = SPACES
                       MOVE 'Y' TO WS-INPUT-VALID
                   WHEN WS-NEW-NAME(26:1) NOT = SPACE
                       DISPLAY '*** ERROR: NAME EXCEEDS 25 CHARACTERS.'
                               ' PLEASE TRY AGAIN OR SPACE TO SKIP ***'
                   WHEN OTHER
                       MOVE WS-NEW-NAME(1:25) TO SR-NAME
                       MOVE 'Y' TO WS-INPUT-VALID
               END-EVALUATE
           END-PERFORM

      *--- BIRTHDAY ---------------------------------------------------*
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'NEW BIRTHDAY (YYYYMMDD) - SPACE TO SKIP >>'
               ACCEPT WS-NEW-BIRTHDAY
               EVALUATE TRUE
                   WHEN WS-NEW-BIRTHDAY = SPACES
                       MOVE 'Y' TO WS-INPUT-VALID
                   WHEN WS-NEW-BIRTHDAY(9:1) NOT = SPACE
                       DISPLAY '*** ERROR: BIRTHDAY MUST BE 8 DIGITS'
                               '. PLEASE TRY AGAIN OR SPACE TO SKIP ***'
                   WHEN WS-NEW-BIRTHDAY(1:8) NOT NUMERIC
                       DISPLAY '*** ERROR: BIRTHDAY MUST BE NUMERIC'
                               '. PLEASE TRY AGAIN OR SPACE TO SKIP ***'
                   WHEN OTHER
                       MOVE FUNCTION NUMVAL(WS-NEW-BIRTHDAY(1:8))
                           TO SR-BIRTHDAY
                       MOVE 'Y' TO WS-INPUT-VALID
               END-EVALUATE
           END-PERFORM

      *--- COURSE -----------------------------------------------------*
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'NEW COURSE NAME (MAX 15 CHAR)'
                       ' - SPACE TO SKIP >>'
               ACCEPT WS-NEW-COURSE
               EVALUATE TRUE
                   WHEN WS-NEW-COURSE = SPACES
                       MOVE 'Y' TO WS-INPUT-VALID
                   WHEN WS-NEW-COURSE(16:1) NOT = SPACE
                       DISPLAY '*** ERROR: COURSE EXCEEDS 15 CHARACTERS'
                               '. PLEASE TRY AGAIN OR SPACE TO SKIP ***'
                   WHEN OTHER
                       MOVE WS-NEW-COURSE(1:15) TO SR-COURSE
                       MOVE 'Y' TO WS-INPUT-VALID
               END-EVALUATE
           END-PERFORM

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
       5500-ASK-ANOTHER.
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'DO YOU WANT TO UPDATE ANOTHER STUDENT?'
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
       6000-TERMINATE.
           CLOSE VSAM-FILE.
           GOBACK.

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
