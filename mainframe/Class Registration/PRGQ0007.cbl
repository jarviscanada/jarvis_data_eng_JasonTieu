      *================================================================*
      *  PRGQ0007 - QUERY STUDENTS BY DATE OF INCLUSION                *
      *  Sequential scan of VSAM filtered by SR-INSERT-DATE.           *
      *                                                                *
      *  BACK TO MENU: At the opening prompt, typing N returns to the  *
      *  main menu immediately before the file is opened.              *
      *  Author: Jason Tieu
      *  STUDENT MANAGEMENT SYSTEM
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGQ0007.


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
       01  WS-INPUT-VALID         PIC X     VALUE 'N'.
       01  WS-ANOTHER             PIC X     VALUE SPACES.
       01  WS-CONTINUE            PIC X     VALUE 'Y'.
       01  WS-GO-BACK             PIC X     VALUE 'N'.
       01  WS-BACK-INPUT          PIC X     VALUE SPACES.
       01  WS-SEARCH-DATE         PIC 9(8)  VALUE 0.
       01  WS-SEARCH-DATE-X       REDEFINES WS-SEARCH-DATE.
           05  WS-SD-YYYY         PIC X(4).
           05  WS-SD-MM           PIC X(2).
           05  WS-SD-DD           PIC X(2).
       01  WS-MONTH-NUM           PIC 9(2)  VALUE 0.
       01  WS-DAY-NUM             PIC 9(2)  VALUE 0.
       01  WS-DATE-INPUT          PIC X(9)  VALUE SPACES.
       01  WS-DISPLAY-DATE.
           05  WS-D-MM            PIC X(2).
           05  FILLER             PIC X     VALUE '/'.
           05  WS-D-DD            PIC X(2).
           05  FILLER             PIC X     VALUE '/'.
           05  WS-D-YYYY          PIC X(4).
       01  WS-LINE                PIC X(78) VALUE ALL '-'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM 0500-CHECK-BACK
           IF WS-GO-BACK = 'N'
               PERFORM 1000-INIT
               PERFORM UNTIL WS-CONTINUE = 'N'
                   PERFORM 1500-GET-DATE
                   PERFORM 2000-SCAN-FILE
                   PERFORM 2500-ASK-ANOTHER
               END-PERFORM
               PERFORM 3000-TERMINATE
           END-IF
           STOP RUN.

      *----------------------------------------------------------------*
       0500-CHECK-BACK.
           MOVE 'N' TO WS-INPUT-VALID
           DISPLAY SPACES
           DISPLAY
           '+---------------------------------------------------------+'
           DISPLAY
           '| Q U E R Y   S T U D E N T   B Y   I N C L U S I O N     |'
           DISPLAY
           '| D A T E                                                 |'
           DISPLAY
           '+---------------------------------------------------------+'
           DISPLAY SPACES
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'PROCEED TO QUERY BY INCLUSION DATE?'
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
           END-IF.

      *----------------------------------------------------------------*
       1500-GET-DATE.
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'ENTER THE DATE OF INCLUSION (YYYYMMDD) >>'
               ACCEPT WS-DATE-INPUT
               EVALUATE TRUE
                   WHEN WS-DATE-INPUT = SPACES
                       DISPLAY '*** ERROR: DATE CANNOT BE BLANK.'
                               ' PLEASE TRY AGAIN. ***'
                   WHEN WS-DATE-INPUT(9:1) NOT = SPACE
                       DISPLAY '*** ERROR: DATE MUST BE EXACTLY 8'
                               ' DIGITS (YYYYMMDD). TOO MANY CHARS. ***'
                   WHEN WS-DATE-INPUT(1:8) NOT NUMERIC
                       DISPLAY '*** ERROR: DATE MUST BE ALL NUMERIC'
                               ' (YYYYMMDD). PLEASE TRY AGAIN. ***'
                   WHEN OTHER
                       MOVE FUNCTION NUMVAL(WS-DATE-INPUT(1:8))
                           TO WS-SEARCH-DATE
                       MOVE FUNCTION NUMVAL(WS-SD-MM) TO WS-MONTH-NUM
                       MOVE FUNCTION NUMVAL(WS-SD-DD) TO WS-DAY-NUM
                       EVALUATE TRUE
                           WHEN WS-MONTH-NUM < 1 OR > 12
                               DISPLAY '*** ERROR: MONTH MUST BE'
                                       ' 01-12. PLEASE TRY AGAIN. ***'
                           WHEN WS-DAY-NUM < 1 OR > 31
                               DISPLAY '*** ERROR: DAY MUST BE'
                                       ' 01-31. PLEASE TRY AGAIN. ***'
                           WHEN OTHER
                               MOVE 'Y' TO WS-INPUT-VALID
                       END-EVALUATE
               END-EVALUATE
           END-PERFORM
           MOVE WS-SD-MM   TO WS-D-MM
           MOVE WS-SD-DD   TO WS-D-DD
           MOVE WS-SD-YYYY TO WS-D-YYYY.

      *----------------------------------------------------------------*
       2000-SCAN-FILE.
           MOVE 0   TO WS-COUNTER
           MOVE 'N' TO WS-EOF
           CLOSE VSAM-FILE
           OPEN INPUT VSAM-FILE

           DISPLAY SPACES
           DISPLAY 'LIST OF STUDENTS INCLUDED ON: ' WS-DISPLAY-DATE
           DISPLAY WS-LINE
           DISPLAY ' ID  | STUDENT NAME      | BIRTHDAY |'
                   ' COURSE         | INSERT DATE | UPDATE DATE'
           DISPLAY WS-LINE

           PERFORM UNTIL WS-EOF = 'Y'
               READ VSAM-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       PERFORM 2100-CHECK-AND-DISPLAY
               END-READ
           END-PERFORM

           DISPLAY WS-LINE
           DISPLAY 'TOTAL STUDENTS FOUND: ' WS-COUNTER
           DISPLAY SPACES.

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
       2500-ASK-ANOTHER.
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'DO YOU WANT TO QUERY ANOTHER DATE?'
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
       3000-TERMINATE.
           CLOSE VSAM-FILE.
           GOBACK.
