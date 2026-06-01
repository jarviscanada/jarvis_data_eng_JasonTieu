      *================================================================*
      *  PRGQ0005 - CLASS QUERY - DISPLAY ALL STUDENTS                *
      *  Reads entire VSAM file sequentially and displays all records *
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGQ0005.
       AUTHOR.     STUDENT MANAGEMENT SYSTEM.

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
       01  WS-LINE                PIC X(78) VALUE ALL '-'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM 1000-INIT
           PERFORM 2000-PROCESS UNTIL WS-EOF = 'Y'
           PERFORM 3000-TERMINATE
           STOP RUN.

      *----------------------------------------------------------------*
       1000-INIT.
           OPEN INPUT VSAM-FILE
           IF WS-VSAM-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING VSAM FILE: ' WS-VSAM-STATUS
               STOP RUN
           END-IF
           DISPLAY SPACES
           DISPLAY WS-LINE
           DISPLAY '              C L A S S   R E P O R T'
           DISPLAY WS-LINE
           DISPLAY ' ID  | STUDENT NAME      | BIRTHDAY |'
                   ' COURSE         | INSERT DATE | UPDATE DATE'
           DISPLAY WS-LINE.

      *----------------------------------------------------------------*
       2000-PROCESS.
           READ VSAM-FILE
               AT END MOVE 'Y' TO WS-EOF
               NOT AT END
                   PERFORM 2100-DISPLAY-RECORD
           END-READ.

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
       3000-TERMINATE.
           DISPLAY WS-LINE
           DISPLAY 'TOTAL STUDENTS : ' WS-COUNTER
           DISPLAY SPACES
           CLOSE VSAM-FILE.
