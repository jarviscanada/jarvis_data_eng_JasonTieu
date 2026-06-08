=================================================================
  COBOL STUDENT MANAGEMENT SYSTEM - PROJECT README
=================================================================

OVERVIEW
--------
A VSAM KSDS-based student management system written in COBOL.
The main menu (PRGMENU) dispatches to 8 sub-programs covering
VSAM creation, CRUD operations, queries, and reporting.

FILE STRUCTURE
--------------
  PRGMENU.cbl       - Main menu dispatcher (entry point)
  PRGV0001.cbl      - Load sequential file into VSAM KSDS
  PRGI0002.cbl      - Insert new student record
  PRGU0003.cbl      - Update student record by ID
  PRGD0004.cbl      - Delete student record by ID
  PRGQ0005.cbl      - Query all students (full class report)
  PRGQ0006.cbl      - Query one student by ID
  PRGQ0007.cbl      - Query students by date of inclusion
  PRGR0008.cbl      - Sorted report with course break
  STUDENT-RECORD.cpy - Shared copybook (VSAM record layout)
  SEQFILE.DAT       - Initial data file (input to PRGV0001)

VSAM RECORD LAYOUT (STUDENT-RECORD.cpy)
-----------------------------------------
  SR-ID              PIC 9(4)   - Primary key
  SR-NAME            PIC X(25)
  SR-BIRTHDAY        PIC 9(8)   - YYYYMMDD
  SR-COURSE          PIC X(15)
  SR-INSERT-DATE     PIC 9(8)   - YYYYMMDD
  SR-UPDATE-DATE     PIC 9(8)   - YYYYMMDD (00000000 = never updated)

=================================================================
  COMPILATION & RUN - GnuCOBOL (Open-source, free)
=================================================================

1. INSTALL GnuCOBOL
   Ubuntu/Debian:  sudo apt install gnucobol
   macOS:          brew install gnucobol
   Windows:        Use WSL or download GnuCOBOL installer

2. DEFINE VSAM-EQUIVALENT (GnuCOBOL uses ISAM via BDB/VBISAM)
   GnuCOBOL maps ORGANIZATION IS INDEXED to Berkeley DB automatically.
   No manual VSAM definition is needed.

3. COMPILE ALL PROGRAMS
   Run from the project directory:

   cobc -x -free -o PRGV0001 PRGV0001.cbl
   cobc -x -free -o PRGI0002 PRGI0002.cbl
   cobc -x -free -o PRGU0003 PRGU0003.cbl
   cobc -x -free -o PRGD0004 PRGD0004.cbl
   cobc -x -free -o PRGQ0005 PRGQ0005.cbl
   cobc -x -free -o PRGQ0006 PRGQ0006.cbl
   cobc -x -free -o PRGQ0007 PRGQ0007.cbl
   cobc -x -free -o PRGR0008 PRGR0008.cbl

   Compile main menu last (it calls the others):
   cobc -x -free -o PRGMENU PRGMENU.cbl

   NOTE: If using fixed-format COBOL (columns 7-72), remove -free.

4. COMPILE WITH COPYBOOK PATH
   If STUDENT-RECORD.cpy is in the same directory, add:
   cobc -x -free -I . -o PRGV0001 PRGV0001.cbl

5. FIRST RUN - GENERATE VSAM FROM SEQFILE
   ./PRGMENU          <- launches the menu
   Choose option 1    <- runs PRGV0001 to load SEQFILE.DAT into VSAM

6. SUBSEQUENT RUNS
   ./PRGMENU          <- all options now available

=================================================================
  COMPILATION - IBM z/OS (Mainframe)
=================================================================

  JCL COMPILE STEP EXAMPLE:
  //COBRUN   EXEC IGYWCL
  //COBOL.SYSIN  DD DSN=YOUR.HLQ.SOURCE(PRGMENU),DISP=SHR
  //LKED.SYSLMOD DD DSN=YOUR.HLQ.LOAD(PRGMENU),DISP=SHR

  VSAM DEFINITION (IDCAMS):
  //DEFINE   EXEC PGM=IDCAMS
  //SYSPRINT DD SYSOUT=*
  //SYSIN    DD *
    DEFINE CLUSTER (NAME(YOUR.HLQ.VSAMFILE)     -
                    INDEXED                      -
                    KEYS(4 0)                    -
                    RECORDSIZE(61 61)            -
                    TRACKS(5 5)                  -
                    SHAREOPTIONS(1))             -
           DATA  (NAME(YOUR.HLQ.VSAMFILE.DATA)) -
           INDEX (NAME(YOUR.HLQ.VSAMFILE.INDEX))
  /*

  RECORD LENGTH BREAKDOWN:
    SR-ID           4 bytes
    SR-NAME        25 bytes
    SR-BIRTHDAY     8 bytes  (COMP-3 = 5 bytes, or DISPLAY = 8)
    SR-COURSE      15 bytes
    SR-INSERT-DATE  8 bytes
    SR-UPDATE-DATE  8 bytes
    TOTAL          68 bytes (display) or adjust for packed decimal

=================================================================
  PROGRAM FLOW
=================================================================

  PRGMENU
    |
    +-- Option 1 --> PRGV0001  (reads SEQFILE.DAT, writes VSAM)
    +-- Option 2 --> PRGI0002  (prompts input, WRITE to VSAM)
    +-- Option 3 --> PRGU0003  (prompts ID, REWRITE to VSAM)
    +-- Option 4 --> PRGD0004  (prompts ID, DELETE from VSAM)
    +-- Option 5 --> PRGQ0005  (sequential READ all, display)
    +-- Option 6 --> PRGQ0006  (random READ by ID, display)
    +-- Option 7 --> PRGQ0007  (sequential READ, filter by date)
    +-- Option 8 --> PRGR0008  (SORT by course, control break report)
    +-- Option 9 --> EXIT

=================================================================
