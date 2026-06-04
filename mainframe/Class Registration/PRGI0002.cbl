      *================================================================*
      *  PRGI0002 - INSERT NEW STUDENT RECORD INTO VSAM                *
      *  Prompts the user for name, birthday, and course. The student  *
      *  ID is assigned automatically by scanning the VSAM file to     *
      *  find the current highest ID and adding 1.                     *
      *                                                                *
      *  BACK TO MENU: At the opening prompt, typing B returns to the  *
      *  main menu immediately before any file is opened.              *
      *  Author: Jason Tieu
      *  STUDENT MANAGEMENT SYSTEM
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGI0002.


       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT VSAM-FILE
               ASSIGN TO 'VSAMFILE'
               ORGANIZATION IS INDEXED
               ACCESS MODE  IS DYNAMIC
               RECORD KEY   IS SR-ID
               FILE STATUS  IS WS-VSAM-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  VSAM-FILE.
       COPY 'STUDENT-RECORD'.

       WORKING-STORAGE SECTION.

       01  WS-VSAM-STATUS         PIC XX    VALUE SPACES.
       01  WS-INSERT-DATE         PIC 9(8)  VALUE 0.
       01  WS-MAX-ID              PIC 9(4)  VALUE 0.
       01  WS-NEW-ID              PIC 9(4)  VALUE 0.
       01  WS-EOF                 PIC X     VALUE 'N'.
       01  WS-NEW-NAME            PIC X(26) VALUE SPACES.
       01  WS-NEW-BIRTHDAY        PIC X(9)  VALUE SPACES.
       01  WS-NEW-COURSE          PIC X(16) VALUE SPACES.
       01  WS-INPUT-VALID         PIC X     VALUE 'N'.
       01  WS-ANOTHER             PIC X     VALUE SPACES.
       01  WS-CONTINUE            PIC X     VALUE 'Y'.

      *  WS-GO-BACK: set to 'Y' if the user chooses to return to the   *
      *  main menu. Checked in 0000-MAIN to skip all processing.       *
       01  WS-GO-BACK             PIC X     VALUE 'N'.

      *  WS-BACK-INPUT: raw input for the back-to-menu prompt.         *
       01  WS-BACK-INPUT          PIC X     VALUE SPACES.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM 0500-CHECK-BACK
      *    Only proceed if the user did not choose to go back.         *
           IF WS-GO-BACK = 'N'
               PERFORM 1000-INIT
               PERFORM 1500-GET-MAX-ID
               PERFORM UNTIL WS-CONTINUE = 'N'
                   PERFORM 2000-GET-INPUT
                   PERFORM 3000-WRITE-RECORD
                   PERFORM 3500-ASK-ANOTHER
               END-PERFORM
               PERFORM 4000-TERMINATE
           END-IF
           STOP RUN.

      *----------------------------------------------------------------*
       0500-CHECK-BACK.
      *  Shown before opening any file. Gives the user a chance to     *
      *  return to the main menu if they selected this program by      *
      *  mistake. Only Y/y proceeds; B/b or N/n returns immediately.  *
      *  Any other input re-prompts.                                   *
           MOVE 'N' TO WS-INPUT-VALID
           DISPLAY SPACES
           DISPLAY '+-----------------------------------+'
           DISPLAY '|   A D D   N E W   S T U D E N T   |'
           DISPLAY '+-----------------------------------+'
           DISPLAY SPACES
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'PROCEED TO INSERT A NEW STUDENT?'
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
           MOVE FUNCTION CURRENT-DATE(1:8) TO WS-INSERT-DATE
           OPEN I-O VSAM-FILE
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               STOP RUN
           END-IF
           DISPLAY SPACES.

      *----------------------------------------------------------------*
       1500-GET-MAX-ID.
           MOVE 0   TO WS-MAX-ID
           MOVE 'N' TO WS-EOF
           START VSAM-FILE KEY >= SR-ID
           PERFORM UNTIL WS-EOF = 'Y'
               READ VSAM-FILE NEXT
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       IF SR-ID > WS-MAX-ID
                           MOVE SR-ID TO WS-MAX-ID
                       END-IF
               END-READ
           END-PERFORM
           ADD 1 TO WS-MAX-ID GIVING WS-NEW-ID.

      *----------------------------------------------------------------*
       2000-GET-INPUT.
      *--- NAME -------------------------------------------------------*
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'ENTER FULL NAME (MAX 25 CHARS) >>'
               ACCEPT WS-NEW-NAME
               EVALUATE TRUE
                   WHEN WS-NEW-NAME = SPACES
                       DISPLAY '*** ERROR: NAME CANNOT BE BLANK.'
                               ' PLEASE TRY AGAIN. ***'
                   WHEN WS-NEW-NAME(26:1) NOT = SPACE
                       DISPLAY '*** ERROR: NAME EXCEEDS 25 CHARACTERS.'
                               ' PLEASE TRY AGAIN. ***'
                   WHEN OTHER
                       MOVE 'Y' TO WS-INPUT-VALID
               END-EVALUATE
           END-PERFORM

      *--- BIRTHDAY ---------------------------------------------------*
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'ENTER BIRTHDAY (YYYYMMDD) >>'
               ACCEPT WS-NEW-BIRTHDAY
               EVALUATE TRUE
                   WHEN WS-NEW-BIRTHDAY = SPACES
                       DISPLAY '*** ERROR: BIRTHDAY CANNOT BE BLANK.'
                               ' PLEASE TRY AGAIN. ***'
                   WHEN WS-NEW-BIRTHDAY(9:1) NOT = SPACE
                       DISPLAY '*** ERROR: BIRTHDAY MUST BE 8 DIGITS'
                               ' (YYYYMMDD). PLEASE TRY AGAIN. ***'
                   WHEN WS-NEW-BIRTHDAY(1:8) NOT NUMERIC
                       DISPLAY '*** ERROR: BIRTHDAY MUST BE NUMERIC'
                               ' (YYYYMMDD). PLEASE TRY AGAIN. ***'
                   WHEN OTHER
                       MOVE 'Y' TO WS-INPUT-VALID
               END-EVALUATE
           END-PERFORM

      *--- COURSE -----------------------------------------------------*
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'ENTER COURSE (MAX 15 CHARS) >>'
               ACCEPT WS-NEW-COURSE
               EVALUATE TRUE
                   WHEN WS-NEW-COURSE = SPACES
                       DISPLAY '*** ERROR: COURSE CANNOT BE BLANK.'
                               ' PLEASE TRY AGAIN. ***'
                   WHEN WS-NEW-COURSE(16:1) NOT = SPACE
                       DISPLAY '*** ERROR: COURSE EXCEEDS 15 CHARACTERS'
                               '. PLEASE TRY AGAIN. ***'
                   WHEN OTHER
                       MOVE 'Y' TO WS-INPUT-VALID
               END-EVALUATE
           END-PERFORM.

      *----------------------------------------------------------------*
       3000-WRITE-RECORD.
           INITIALIZE STUDENT-RECORD
           MOVE WS-NEW-ID                    TO SR-ID
           MOVE WS-NEW-NAME(1:25)            TO SR-NAME
           MOVE FUNCTION NUMVAL(
               WS-NEW-BIRTHDAY(1:8))         TO SR-BIRTHDAY
           MOVE WS-NEW-COURSE(1:15)          TO SR-COURSE
           MOVE WS-INSERT-DATE               TO SR-INSERT-DATE
           MOVE 0                            TO SR-UPDATE-DATE
           WRITE STUDENT-RECORD
           IF WS-VSAM-STATUS = '00'
               DISPLAY SPACES
               DISPLAY '<<--- STUDENT INSERTED SUCCESSFULLY --->> '
               DISPLAY 'NEW STUDENT ID ASSIGNED: ' WS-NEW-ID
               DISPLAY SPACES
           ELSE
               DISPLAY 'ERROR WRITING RECORD - STATUS: '
                       WS-VSAM-STATUS
           END-IF.

      *----------------------------------------------------------------*
       3500-ASK-ANOTHER.
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'DO YOU WANT TO INSERT ANOTHER STUDENT?'
               DISPLAY '  Y = YES'
               DISPLAY '  N = NO, RETURN TO MAIN MENU'
               DISPLAY 'ENTER CHOICE >> '
               ACCEPT WS-ANOTHER
               EVALUATE TRUE
                   WHEN WS-ANOTHER = 'Y' OR WS-ANOTHER = 'y'
                       ADD 1 TO WS-NEW-ID
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
