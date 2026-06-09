      *================================================================*
      *  STUDENT-RECORD.cpy - SHARED COPYBOOK                          *
      *  This copybook defines the VSAM KSDS record layout used by     *
      *  every program in the system. Including it with:               *
      *    COPY 'STUDENT-RECORD'.                                       *
      *  ensures all programs read and write identical record layouts,  *
      *  preventing data corruption from mismatched field sizes.        *
      *                                                                *
      *  VSAM KSDS key: SR-ID (first 4 bytes of the record).           *
      *  Total record length: 68 bytes.                                 *
      *================================================================*
       01  STUDENT-RECORD.
      *    SR-ID: 4-digit numeric primary key. VSAM uses this field     *
      *    to build the B-tree index and maintain records in ascending  *
      *    key order. Must be unique — duplicate keys are rejected.     *
           05  SR-ID              PIC 9(4).

      *    SR-NAME: Student full name, left-justified, space-padded.    *
           05  SR-NAME            PIC X(25).

      *    SR-BIRTHDAY: Date of birth stored as YYYYMMDD numeric.       *
      *    Example: 19821209 = December 9, 1982.                        *
           05  SR-BIRTHDAY        PIC 9(8).

      *    SR-COURSE: Course name the student is enrolled in.           *
           05  SR-COURSE          PIC X(15).

      *    SR-INSERT-DATE: Date this record was first created,          *
      *    stored as YYYYMMDD. Set by PRGV0001 on initial load or       *
      *    PRGI0002 on manual insert. Never changed after creation.     *
           05  SR-INSERT-DATE     PIC 9(8).

      *    SR-UPDATE-DATE: Date this record was last modified by        *
      *    PRGU0003. Stored as YYYYMMDD. Value 00000000 means the       *
      *    record has never been updated since it was created.          *
           05  SR-UPDATE-DATE     PIC 9(8).
