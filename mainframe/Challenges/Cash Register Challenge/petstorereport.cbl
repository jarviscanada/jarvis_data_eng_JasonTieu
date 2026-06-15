******************************************************************
      * Author: Jason Tieu
      * Date: 05-07-2026
      * Purpose:
      * Tectonics: cobc
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. PETSTORECHALLENGE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT PETSALESFILE ASSIGN TO "PETSTORESALES.DAT"
           ORGANIZATION IS LINE SEQUENTIAL.
       SELECT PRINTFILE ASSIGN TO "PETSTOREREPORT.DAT"
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD PETSALESFILE.
       01 SALESDETAILS.
            88 ENDOFSALESFILE VALUE HIGH-VALUES.
            02 CUSTOMER-ID      PIC 9(7).
            02 CUSTOMERNAME.
               05  LASTNAME     PIC X(15).
               05  FIRSTNAME    PIC X(15).
            02 PETITEM OCCURS 3 TIMES.
               05 DESCRIPTION      PIC X(20).
               05 PRICE            PIC 999999V99.
               05 QUANTITY         PIC 99999.

       FD PRINTFILE.
       01 PRINT-LINE PIC X(150).

       WORKING-STORAGE SECTION.

       01  WS-FIELDS.
           05  WS-INDEX            PIC 99 USAGE IS COMP.
           05  WS-TOTAL-QUANT      PIC 9(6)    VALUE 0.
           05  WS-ITEM-TOTAL       PIC 9(7)V99 VALUE 0.
           05  WS-TOTAL-SALE       PIC 9(9)V99 VALUE 0.
           05  WS-CUST-QUANT       PIC 9(6)    VALUE 0.
           05  WS-CUST-SUBTOTAL    PIC 9(9)V99 VALUE 0.

       01  WS-DATE.
           05  WS-YEAR  PIC 99.
           05  WS-MONTH PIC 99.
           05  WS-DAY   PIC 99.

       01  STORE-LINE.
           05 FILLER               PIC X(45)  VALUE SPACES.
           05 FILLER               PIC X(21)  VALUE
                                           'PET SUPPLIES AND MORE'.

       01  HEADING-LINE.
            05 FILLER              PIC X(5)   VALUE SPACES.
            05 FILLER              PIC X(16)  VALUE 'ITEM DESCRIPTION'.
            05 FILLER              PIC X(13)  VALUE SPACES.
            05 FILLER              PIC X(9)   VALUE 'PRICE'.
            05 FILLER              PIC X(8)   VALUE SPACES.
            05 FILLER              PIC X(8)   VALUE 'QUANTITY'.
            05 FILLER              PIC X(5)   VALUE SPACES.
            05 FILLER              PIC X(5)   VALUE 'TOTAL'.

       01  DETAIL-LINE.
            05 FILLER              PIC X(5)   VALUE SPACES.
            05 DET-DESCRIPTION     PIC X(20).
            05 FILLER              PIC X(9)   VALUE SPACES.
            05 DET-PRICE           PIC $ZZ9.99.
            05 FILLER              PIC X(8)   VALUE SPACES.
            05 DET-QUANTITY        PIC ZZ9.
            05 FILLER              PIC X(12)   VALUE SPACES.
            05 DET-ITEM-TOTAL      PIC $ZZ9.99.

       01  SEPARATOR-LINE.
            05 FILLER              PIC X(20)  VALUE SPACES.
            05 FILLER              PIC X(60)  VALUE
           '=========================================================='.

       01  CUSTOMER-LINE.
           05 FILLER               PIC X(13)  VALUE SPACES.
           05 CUST-LASTNAME        PIC X(15).
           05 FILLER               PIC X(2)   VALUE SPACES.
           05 FILLER               PIC X(10)  VALUE 'QUANTITY: '.
           05 CUST-QUANT-OUT       PIC ZZZ9.
           05 FILLER               PIC X(4)   VALUE SPACES.
           05 FILLER               PIC X(13)  VALUE 'SUB-TOTAL : '.
           05 CUST-SUBTOTAL-OUT    PIC $$$,$$9.99.

       01  DETAIL-TOTAL-LINE.
            05 FILLER              PIC X(11)  VALUE SPACES.
            05 FILLER              PIC X(16)  VALUE 'TOTAL QUANTITY: '.
            05 DET-TOTAL-QUANT     PIC ZZZ9.
            05 FILLER              PIC X(2)   VALUE SPACES.
            05 FILLER              PIC X(8)   VALUE 'TOTAL   '.
            05 DET-TOT-SALES       PIC $$$,$$$,$$9.99.

       PROCEDURE DIVISION.
       0100-START.
           OPEN INPUT PETSALESFILE.
           OPEN OUTPUT PRINTFILE.
           READ PETSALESFILE
               AT END SET ENDOFSALESFILE TO TRUE
           END-READ.

           DISPLAY STORE-LINE.
           DISPLAY HEADING-LINE.
           MOVE STORE-LINE   TO PRINT-LINE.
           WRITE PRINT-LINE.
           MOVE HEADING-LINE TO PRINT-LINE.
           WRITE PRINT-LINE.

           PERFORM 0110-PROCESS UNTIL ENDOFSALESFILE.
           PERFORM 0290-PRINT-TOTAL.
           PERFORM 0300-STOP-RUN.
       0100-END.

       0110-PROCESS.
           MOVE 0 TO WS-CUST-QUANT.
           MOVE 0 TO WS-CUST-SUBTOTAL.

           PERFORM 0200-PROCESS-ITEMS VARYING WS-INDEX FROM 1
               BY 1 UNTIL WS-INDEX > 3.

           PERFORM 0220-PRINT-CUSTOMER.

           DISPLAY SPACES.
           DISPLAY SPACES.

           READ PETSALESFILE
               AT END SET ENDOFSALESFILE TO TRUE
           END-READ.

       0200-PROCESS-ITEMS.
           IF PRICE(WS-INDEX) NOT EQUAL ZEROS
               MOVE DESCRIPTION(WS-INDEX) TO DET-DESCRIPTION
               MOVE PRICE(WS-INDEX)       TO DET-PRICE
               MOVE QUANTITY(WS-INDEX)    TO DET-QUANTITY
               COMPUTE WS-ITEM-TOTAL    = PRICE(WS-INDEX) *
                                          QUANTITY(WS-INDEX)
               COMPUTE WS-TOTAL-SALE    = WS-TOTAL-SALE + WS-ITEM-TOTAL
               COMPUTE WS-TOTAL-QUANT   = WS-TOTAL-QUANT +
                                          QUANTITY(WS-INDEX)
               COMPUTE WS-CUST-SUBTOTAL = WS-CUST-SUBTOTAL +
                                          WS-ITEM-TOTAL
               COMPUTE WS-CUST-QUANT    = WS-CUST-QUANT +
                                          QUANTITY(WS-INDEX)
               MOVE WS-ITEM-TOTAL       TO DET-ITEM-TOTAL
               DISPLAY DETAIL-LINE
               MOVE DETAIL-LINE         TO PRINT-LINE
               WRITE PRINT-LINE
           END-IF.
       0200-END.

       0220-PRINT-CUSTOMER.
           DISPLAY SEPARATOR-LINE.
           MOVE LASTNAME         TO CUST-LASTNAME.
           MOVE WS-CUST-QUANT    TO CUST-QUANT-OUT.
           MOVE WS-CUST-SUBTOTAL TO CUST-SUBTOTAL-OUT.
           DISPLAY CUSTOMER-LINE.
           MOVE SEPARATOR-LINE   TO PRINT-LINE.
           WRITE PRINT-LINE.
           MOVE HEADING-LINE TO PRINT-LINE.
           WRITE PRINT-LINE.
           MOVE CUSTOMER-LINE    TO PRINT-LINE.
           WRITE PRINT-LINE.
           MOVE SPACES           TO PRINT-LINE.
           WRITE PRINT-LINE AFTER ADVANCING 1 LINE.
           WRITE PRINT-LINE AFTER ADVANCING 1 LINE.
       0220-END.

       0280-WRITE-TOTAL.
           MOVE DETAIL-TOTAL-LINE TO PRINT-LINE.
           WRITE PRINT-LINE AFTER ADVANCING 1 LINE.

       0290-PRINT-TOTAL.
           MOVE WS-TOTAL-QUANT TO DET-TOTAL-QUANT.
           MOVE WS-TOTAL-SALE  TO DET-TOT-SALES.
           DISPLAY DETAIL-TOTAL-LINE.
           PERFORM 0280-WRITE-TOTAL.
       0290-END.

       0300-STOP-RUN.
           CLOSE PETSALESFILE.
           CLOSE PRINTFILE.
           STOP RUN.

       END PROGRAM PETSTORECHALLENGE.
