      *================================================================*
      *  PRGMENU - MAIN MENU PROGRAM                                   *
      *  This is the entry point of the entire system.                 *
      *  It displays a numbered menu and calls the appropriate         *
      *  sub-program based on the user's choice. It loops until        *
      *  the user selects option 9 (EXIT).                             *
      *  Author: Jason Tieu
      *  STUDENT MANAGEMENT SYSTEM
      *================================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGMENU.

       ENVIRONMENT DIVISION.
      *----------------------------------------------------------------*
      *  No files are needed here. PRGMENU is purely a dispatcher”    *
      *  all file I/O happens inside the called sub-programs.          *
      *----------------------------------------------------------------*

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *----------------------------------------------------------------*
      *  WS-OPTION      : Holds the menu choice typed by the user.     *
      *                   PIC 9 means it accepts a single digit (0-9). *
      *  WS-CONTINUE    : Loop control flag. While this is 'Y' the     *
      *                   menu keeps redisplaying. Option 9 sets it    *
      *                   to 'N' which breaks the loop and exits.      *
      *----------------------------------------------------------------*
       01  WS-OPTION              PIC 9       VALUE 0.
       01  WS-CONTINUE            PIC X       VALUE 'Y'.

       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       0000-MAIN.
      *  The entire system runs inside this PERFORM UNTIL loop.        *
      *  After each sub-program finishes and returns control here,     *
      *  the menu is displayed again automatically. The only way out   *
      *  is option 9, which sets WS-CONTINUE to 'N'.                  *
      *----------------------------------------------------------------*
           PERFORM UNTIL WS-CONTINUE = 'N'
               PERFORM 1000-DISPLAY-MENU
               PERFORM 2000-PROCESS-OPTION
           END-PERFORM
           STOP RUN.

      *----------------------------------------------------------------*
       1000-DISPLAY-MENU.
      *  Paints the menu on screen using sequential DISPLAY statements.*
      *  Each DISPLAY writes one line to standard output.              *
      *  ACCEPT WS-OPTION pauses execution and waits for the user to   *
      *  type a number and press Enter. The value is stored in         *
      *  WS-OPTION as a single digit.                                  *
      *----------------------------------------------------------------*
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
      *  EVALUATE is COBOL's switch/case. It compares WS-OPTION        *
      *  against each WHEN value and executes the matching branch.     *
      *                                                                *
      *  CALL transfers control to the named sub-program. That         *
      *  program runs fully, then returns here â€” execution resumes     *
      *  on the next line after the CALL, and the loop repeats.        *
      *                                                                *
      *  WHEN 9: instead of calling a sub-program, we set the loop     *
      *  flag to 'N' so the PERFORM UNTIL in 0000-MAIN stops.          *
      *                                                                *
      *  WHEN OTHER: catches any input that isn't 1-9 (e.g. 0 or a    *
      *  number > 9) and displays an error without crashing.           *
      *----------------------------------------------------------------*
           EVALUATE WS-OPTION
               WHEN 1
                   CALL 'PRGV0001'    *> Generate VSAM from flat file
               WHEN 2
                   CALL 'PRGI0002'    *> Insert new student
               WHEN 3
                   CALL 'PRGU0003'    *> Update existing student
               WHEN 4
                   CALL 'PRGD0004'    *> Delete a student
               WHEN 5
                   CALL 'PRGQ0005'    *> Query all students
               WHEN 6
                   CALL 'PRGQ0006'    *> Query one student by ID
               WHEN 7
                   CALL 'PRGQ0007'    *> Query students by insert date
               WHEN 8
                   CALL 'PRGR0008'    *> Sorted report with course break
               WHEN 9
      *            Set flag to 'N' the PERFORM UNTIL will stop
                   DISPLAY SPACES
                   DISPLAY '*** SYSTEM TERMINATED - GOODBYE ***'
                   DISPLAY SPACES
                   MOVE 'N' TO WS-CONTINUE
               WHEN OTHER
      *            Invalid input display warning and loop again
                   DISPLAY SPACES
                   DISPLAY '*** INVALID OPTION - PLEASE TRY AGAIN ***'
                   DISPLAY SPACES
           END-EVALUATE.
