      ******************************************************************
      * Author:JASON TIEU
      * Date:05-06-2026
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BMI-CALULATOR.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01 WEIGHT PIC 999.
       01 HEIGHT PIC 999.
       01 BMI PIC 999V99.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
            DISPLAY "Welcome to the BMI Calculator".
            DISPLAY "Please enter your Weight in pounds: ".
            ACCEPT WEIGHT.
            DISPLAY "Please enter your height in inches: ".
            ACCEPT HEIGHT.
            COMPUTE BMI = WEIGHT * 703 / (HEIGHT * HEIGHT).
            DISPLAY "Your BMI is ", BMI, "%".

       STOP RUN.
       END PROGRAM BMI-CALULATOR.
