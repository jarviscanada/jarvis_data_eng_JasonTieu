      *================================================================*
      *  PRGQ0005 - CLASS QUERY - DISPLAY ALL STUDENTS                 *
      *  Full sequential scan — prints every student with no filter.   *
      *                                                                *
      *  BACK TO MENU: At the opening prompt, typing N returns to the  *
      *  main menu immediately before the file is opened.              *
      *  Author: Jason Tieu
      *  STUDENT MANAGEMENT SYSTEM
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGQ0005.

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
       01  WS-ANOTHER             PIC X     VALUE SPACES.
       01  WS-CONTINUE            PIC X     VALUE 'Y'.
       01  WS-INPUT-VALID         PIC X     VALUE 'N'.
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
                   PERFORM 2000-RUN-REPORT
                   PERFORM 2500-ASK-ANOTHER
               END-PERFORM
               PERFORM 3000-TERMINATE
           END-IF
           STOP RUN.

      *----------------------------------------------------------------*
       0500-CHECK-BACK.
           MOVE 'N' TO WS-INPUT-VALID
           DISPLAY SPACES
           DISPLAY '+---------------------------------------+'
           DISPLAY '|   C L A S S   R E P O R T             |'
           DISPLAY '+---------------------------------------+'
           DISPLAY SPACES
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'PROCEED TO VIEW ALL STUDENTS?'
               DISPLAY '  Y = YES, SHOW REPORT'
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
       2000-RUN-REPORT.
           MOVE 0   TO WS-COUNTER
           MOVE 'N' TO WS-EOF
           CLOSE VSAM-FILE
           OPEN INPUT VSAM-FILE

           DISPLAY SPACES
           DISPLAY WS-LINE
           DISPLAY '              C L A S S   R E P O R T'
           DISPLAY WS-LINE
           DISPLAY ' ID  | STUDENT NAME      | BIRTHDAY |'
                   ' COURSE         | INSERT DATE | UPDATE DATE'
           DISPLAY WS-LINE

           PERFORM UNTIL WS-EOF = 'Y'
               READ VSAM-FILE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END
                       PERFORM 2100-DISPLAY-RECORD
               END-READ
           END-PERFORM

           DISPLAY WS-LINE
           DISPLAY 'TOTAL STUDENTS : ' WS-COUNTER
           DISPLAY SPACES.

      *----------------------------------------------------------------*
       2100-DISPLAY-RECORD.
           ADD 1 TO WS-COUNTER
           DISPLAY SR-ID ' | '
                   SR-NAME ' | '
                   SR-BIRTHDAY ' | '
                   SR-COURSE ' | '
                   SR-INSERT-DATE ' | '
                   SR-UPDATE-DATE.

      *----------------------------------------------------------------*
       2500-ASK-ANOTHER.
           MOVE 'N' TO WS-INPUT-VALID
           PERFORM UNTIL WS-INPUT-VALID = 'Y'
               DISPLAY 'DO YOU WANT TO RUN THE REPORT AGAIN?'
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
