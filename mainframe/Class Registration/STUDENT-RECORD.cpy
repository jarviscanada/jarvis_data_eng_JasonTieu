      *================================================================*
      *  STUDENT-RECORD.cpy                                           *
      *  Copybook: VSAM KSDS student record layout                    *
      *  Include in all programs with: COPY 'STUDENT-RECORD'.         *
      *================================================================*
       01  STUDENT-RECORD.
           05  SR-ID              PIC 9(4).
           05  SR-NAME            PIC X(25).
           05  SR-BIRTHDAY        PIC 9(8).
           05  SR-COURSE          PIC X(15).
           05  SR-INSERT-DATE     PIC 9(8).
           05  SR-UPDATE-DATE     PIC 9(8).
