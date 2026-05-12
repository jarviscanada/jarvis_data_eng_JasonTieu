      ******************************************************************
      * Author:JASON TIEU
      * Date:05-06-2026
      * Purpose: BMI Calculator
      * Tectonics: cobc
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. BMI-CALCULATOR.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 CHOICE PIC X.
       01 WEIGHT PIC 999.
       01 HEIGHT PIC 999V99.
       01 BMI PIC 999V99.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

            DISPLAY "Welcome to the BMI Calculator".
            DISPLAY "Metric or Imperial? (M/I): ".
            ACCEPT CHOICE.

            EVALUATE CHOICE

               WHEN "M"
               WHEN "m"

                    DISPLAY "Please enter your Weight in kilograms: "
                    ACCEPT WEIGHT

                    DISPLAY "Please enter your height in centimeters: "
                    ACCEPT HEIGHT

                    COMPUTE BMI = WEIGHT / (HEIGHT * HEIGHT) * 10000

                    DISPLAY "Your BMI is ", BMI

                    EVALUATE TRUE
                         WHEN BMI < 18.5
                              DISPLAY "You are underweight."

                         WHEN BMI < 25
                              DISPLAY "You are normal weight."

                         WHEN BMI < 30
                              DISPLAY "You are overweight."

                         WHEN OTHER
                              DISPLAY "You are obese."
                    END-EVALUATE

               WHEN "I"
               WHEN "i"

                    DISPLAY "Please enter your Weight in pounds: "
                    ACCEPT WEIGHT

                    DISPLAY "Please enter your height in inches: "
                    ACCEPT HEIGHT

                    COMPUTE BMI =
                        WEIGHT * 703 / (HEIGHT * HEIGHT)

                    DISPLAY "Your BMI is ", BMI

                    EVALUATE TRUE
                         WHEN BMI < 18.5
                              DISPLAY "You are underweight."

                         WHEN BMI < 25
                              DISPLAY "You are normal weight."

                         WHEN BMI < 30
                              DISPLAY "You are overweight."

                         WHEN OTHER
                              DISPLAY "You are obese."
                    END-EVALUATE

               WHEN OTHER
                    DISPLAY "Invalid Choice - Please select "
                    DISPLAY "M for Metric or I for Imperial."

            END-EVALUATE.

            STOP RUN.

       END PROGRAM BMI-CALCULATOR.
