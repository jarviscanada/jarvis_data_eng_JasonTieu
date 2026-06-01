      *================================================================*
      *  PRGMENU - MAIN MENU PROGRAM                                  *
      *  Displays the main menu and calls the appropriate sub-program  *
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGMENU.
       AUTHOR.     STUDENT MANAGEMENT SYSTEM.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-OPTION              PIC 9       VALUE 0.
       01  WS-CONTINUE            PIC X       VALUE 'Y'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
           PERFORM UNTIL WS-CONTINUE = 'N'
               PERFORM 1000-DISPLAY-MENU
               PERFORM 2000-PROCESS-OPTION
           END-PERFORM
           STOP RUN.

      *----------------------------------------------------------------*
       1000-DISPLAY-MENU.
           MOVE 0 TO WS-OPTION
           DISPLAY SPACES
           DISPLAY '+-----------------------------------+'
           DISPLAY '|          M A I N   M E N U        |'
           DISPLAY '+-----------------------------------+'
           DISPLAY '|               OPTIONS             |'
           DISPLAY '+-----------------------------------+'
           DISPLAY '|  1 - GENERATE VSAM FILE           |'
           DISPLAY '|  2 - INSERT STUDENT DATA          |'
           DISPLAY '|  3 - UPDATE STUDENT DATA          |'
           DISPLAY '|  4 - DELETE STUDENT DATA          |'
           DISPLAY '|  5 - CLASS QUERY (ALL STUDENTS)   |'
           DISPLAY '|  6 - QUERY STUDENT BY ID          |'
           DISPLAY '|  7 - QUERY BY DATE OF INCLUSION   |'
           DISPLAY '|  8 - REPORT FILE WITH DATE BREAK  |'
           DISPLAY '|  9 - EXIT                         |'
           DISPLAY '+-----------------------------------+'
           DISPLAY SPACES
           DISPLAY 'ENTER YOUR OPTION >> '
           ACCEPT WS-OPTION.

      *----------------------------------------------------------------*
       2000-PROCESS-OPTION.
           EVALUATE WS-OPTION
               WHEN 1
                   CALL 'PRGV0001'
               WHEN 2
                   CALL 'PRGI0002'
               WHEN 3
                   CALL 'PRGU0003'
               WHEN 4
                   CALL 'PRGD0004'
               WHEN 5
                   CALL 'PRGQ0005'
               WHEN 6
                   CALL 'PRGQ0006'
               WHEN 7
                   CALL 'PRGQ0007'
               WHEN 8
                   CALL 'PRGR0008'
               WHEN 9
                   DISPLAY SPACES
                   DISPLAY '*** SYSTEM TERMINATED - GOODBYE ***'
                   DISPLAY SPACES
                   MOVE 'N' TO WS-CONTINUE
               WHEN OTHER
                   DISPLAY SPACES
                   DISPLAY '*** INVALID OPTION - PLEASE TRY AGAIN ***'
                   DISPLAY SPACES
           END-EVALUATE.
