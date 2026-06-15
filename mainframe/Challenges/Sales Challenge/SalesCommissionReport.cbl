      ******************************************************************
      * Author: Jason Tieu
      * Date: 05-07-2026
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. COMMISSION-CHALLENGE.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.
       OBJECT-COMPUTER.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
         SELECT SALESFILE ASSIGN TO "SALES.DAT"
           ORGANIZATION IS LINE SEQUENTIAL.
         SELECT PRINT-FILE ASSIGN TO "COMMISSIONREPORT5.DAT"
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD SALESFILE.

       01  SALESDETAILS.
             88 ENDOFSALES VALUE HIGH-VALUES.
             05 SALESPERSON-ID   PIC 9(5).
             05 SALESPERSON-NAME.
                 10 LASTNAME     PIC X(20).
                 10 FIRSTNAME    PIC X(20).
             05 REGION           PIC X(5).
             05 YEARLYSALES      PIC 9(6) VALUE ZEROES.
             05 GENDER           PIC X.

       FD PRINT-FILE.

       01  PRINT-LINE            PIC X(150).


       WORKING-STORAGE SECTION.
       01  WS-FIELDS.
           05 WS-TOTAL-SALES       PIC 9(10) COMP-3 VALUE ZEROES.
           05 WS-COMMISSION-RATE   PIC V99   VALUE .05.
           05 WS-COMMISSION-AMT    PIC 9(10)V99 COMP-3.
           05 WS-COMMISSION-TOTAL  PIC 9(10)V99 COMP-3 VALUES ZEROES.

       01  WS-REGION-SALES.
           05  WS-EAST           PIC 9(7).
           05  WS-NORTH          PIC 9(7).
           05  WS-WEST           PIC 9(7).
           05  WS-SOUTH          PIC 9(7).

       01  HEADING-LINE.
           05 FILLER             PIC X(5)  VALUE SPACES.
           05 FILLER             PIC X(16) VALUE 'LAST NAME'.
           05 FILLER             PIC X(4)  VALUE SPACES.
           05 FILLER             PIC X(21) VALUE 'FIRST NAME'.
           05 FILLER             PIC X(6)  VALUE 'REGION'.
           05 FILLER             PIC X(21) VALUE SPACES.
           05 FILLER             PIC X(12) VALUE 'YEARLY SALES'.
           05 FILLER             PIC X(20) VALUE SPACES.
           05 FILLER             PIC X(20) VALUE 'COMMISSION EARNED'.

        01  UNDERLINE-ROW.
           05 FILLER             PIC X(5)  VALUE SPACES.
           05 FILLER             PIC X(10) VALUE '---------'.
           05 FILLER             PIC X(10) VALUE SPACES.
           05 FILLER             PIC X(21) VALUE '----------'.
           05 FILLER             PIC X(6)  VALUE '------'.
           05 FILLER             PIC X(21) VALUE SPACES.
           05 FILLER             PIC X(12) VALUE '------------'.
           05 FILLER             PIC X(20) VALUE SPACES.
           05 FILLER             PIC X(20) VALUE '-----------------'.

       01  DETAIL-LINE.
           05 FILLER             PIC X(5)  VALUE SPACES.
           05 DET-PERSON-NAME    PIC X(40).
           05 FILLER             PIC X(1) VALUE SPACES.
           05 DET-REGION         PIC X(5).
           05 FILLER             PIC X(22) VALUE SPACES.
           05 DET-YEARLYSALES    PIC $ZZZ,ZZZ,ZZ9.
           05 FILLER             PIC X(20) VALUE SPACES.
           05 DET-COMMISSIONTOT  PIC $ZZZ,ZZZ,ZZ9.99.

       01  TOTAL-LINE.
           05 FILLER             PIC X(5)  VALUE SPACES.
           05 FILLER             PIC X(10) VALUE SPACES.
           05 FILLER             PIC X(25) VALUE SPACES.
           05 FILLER             PIC X(20)  VALUE SPACES.
           05 FILLER             PIC X(13) VALUE 'TOTAL SALES'.
           05 TOTAL-YRLY-SALES   PIC $ZZZ,ZZZ,ZZ9.
           05 FILLER             PIC X(3)  VALUE SPACES.
           05 FILLER             PIC X(17) VALUE 'TOTAL COMMISSION'.
           05 TOTAL-COMP-AMT     PIC $ZZZ,ZZZ,ZZ9.99.


       PROCEDURE DIVISION.

       0050-OPEN-FILE.
           OPEN INPUT SALESFILE.
           OPEN OUTPUT PRINT-FILE.
           PERFORM 0100-PROCESS-RECORDS.
           PERFORM 0200-STOP-RUN.

        0100-PROCESS-RECORDS.

           PERFORM 0110-WRITE-HEADING-LINE.
           PERFORM 0115-WRITE-UNDERLINE-ROW.
           READ SALESFILE
                AT END SET ENDOFSALES TO TRUE
                END-READ.
           PERFORM UNTIL ENDOFSALES
            ADD YEARLYSALES TO WS-TOTAL-SALES
            MOVE SALESPERSON-NAME TO DET-PERSON-NAME
            MOVE REGION TO DET-REGION
            MOVE YEARLYSALES TO DET-YEARLYSALES
            COMPUTE WS-COMMISSION-AMT = WS-COMMISSION-RATE * YEARLYSALES
              DISPLAY FIRSTNAME SPACE WS-COMMISSION-AMT
            ADD WS-COMMISSION-AMT TO WS-COMMISSION-TOTAL
            MOVE WS-COMMISSION-AMT TO DET-COMMISSIONTOT
            PERFORM 0120-WRITE-DETAIL-LINE


            READ SALESFILE
            AT END SET ENDOFSALES TO TRUE
            END-READ
           END-PERFORM.
           PERFORM 0130-WRITE-TOTAL-LINE.

        0110-WRITE-HEADING-LINE.
            MOVE HEADING-LINE TO PRINT-LINE.
            WRITE PRINT-LINE AFTER ADVANCING 1 LINE.
            MOVE SPACES TO PRINT-LINE.
            WRITE PRINT-LINE.

        0115-WRITE-UNDERLINE-ROW.
            MOVE UNDERLINE-ROW TO PRINT-LINE.
            WRITE PRINT-LINE AFTER ADVANCING 1 LINE.
            MOVE SPACES TO PRINT-LINE.
            WRITE PRINT-LINE.

        0120-WRITE-DETAIL-LINE.
            MOVE DETAIL-LINE TO PRINT-LINE.
            WRITE PRINT-LINE AFTER ADVANCING 1 LINE.

        0130-WRITE-TOTAL-LINE.
            MOVE WS-TOTAL-SALES TO TOTAL-YRLY-SALES.
            MOVE WS-COMMISSION-TOTAL TO TOTAL-COMP-AMT.
            MOVE TOTAL-LINE TO PRINT-LINE.
            WRITE PRINT-LINE AFTER ADVANCING 1 LINE.

        0200-STOP-RUN.
           CLOSE SALESFILE.
           CLOSE PRINT-FILE.
           STOP RUN.

       END PROGRAM COMMISSION-CHALLENGE.
