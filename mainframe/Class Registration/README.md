# COBOL Student Management System

A VSAM KSDS-based student management system written in COBOL. The main menu (`PRGMENU`) dispatches to 8 sub-programs covering VSAM creation, full CRUD operations, queries, and reporting.

---

## 📁 File Structure

| File | Description |
|------|-------------|
| `PRGMENU.cbl` | Main menu dispatcher — entry point |
| `PRGV0001.cbl` | Load sequential flat file into VSAM KSDS |
| `PRGI0002.cbl` | Insert new student record |
| `PRGU0003.cbl` | Update student record by ID |
| `PRGD0004.cbl` | Delete student record by ID |
| `PRGQ0005.cbl` | Query all students (full class report) |
| `PRGQ0006.cbl` | Query one student by ID |
| `PRGQ0007.cbl` | Query students by date of inclusion |
| `PRGR0008.cbl` | Sorted report with course control break |
| `STUDENT-RECORD.cpy` | Shared copybook — VSAM record layout |
| `SEQFILE.DAT` | Initial seed data (input to `PRGV0001`) |

---

## 🗂️ VSAM Record Layout

Defined in `STUDENT-RECORD.cpy` and shared by all programs via `COPY`.

| Field | Picture | Description |
|-------|---------|-------------|
| `SR-ID` | `PIC 9(4)` | Primary key — VSAM B-tree index key |
| `SR-NAME` | `PIC X(25)` | Student full name |
| `SR-BIRTHDAY` | `PIC 9(8)` | Date of birth — `YYYYMMDD` |
| `SR-COURSE` | `PIC X(15)` | Enrolled course name |
| `SR-INSERT-DATE` | `PIC 9(8)` | Record creation date — `YYYYMMDD` |
| `SR-UPDATE-DATE` | `PIC 9(8)` | Last update date — `00000000` means never updated |

**Total record length: 68 bytes**

---

## 🔄 Program Flow

```
PRGMENU
  │
  ├── Option 1 ──► PRGV0001   reads SEQFILE.DAT, WRITE to VSAM
  ├── Option 2 ──► PRGI0002   prompts input, WRITE new record
  ├── Option 3 ──► PRGU0003   prompts ID, REWRITE existing record
  ├── Option 4 ──► PRGD0004   prompts ID, DELETE record
  ├── Option 5 ──► PRGQ0005   sequential READ all, display report
  ├── Option 6 ──► PRGQ0006   random READ by ID, display record
  ├── Option 7 ──► PRGQ0007   sequential READ, filter by insert date
  ├── Option 8 ──► PRGR0008   SORT by course, control break report
  └── Option 9 ──► EXIT
```

---

## ✅ Features

- **Input validation** — all fields check for blank input, max length, and correct data type before accepting
- **Continue prompts** — after each action, the user is asked whether to perform another operation or return to the menu
- **Back to menu** — each sub-program opens with a Y/N confirmation so the user can return immediately if they selected the wrong option
- **Auto ID generation** — `PRGI0002` scans for the highest existing ID and assigns the next one automatically
- **Date formatting** — `PRGQ0007` uses `REDEFINES` to display dates as `MM/DD/YYYY` without string parsing
- **Control break reporting** — `PRGR0008` uses the COBOL `SORT` verb with `INPUT PROCEDURE` / `OUTPUT PROCEDURE` to group students by course

---

## 🛠️ Compilation & Setup

### GnuCOBOL (Open-source, free)

#### 1. Install GnuCOBOL

```bash
# Ubuntu / Debian
sudo apt install gnucobol

# macOS
brew install gnucobol

# Windows
# Use WSL (Windows Subsystem for Linux) or download the GnuCOBOL installer
```

#### 2. Compile — single executable (recommended)

Compile all programs into one binary from the project directory:

```bash
cobc -x -free -I . -o PRGMENU \
  PRGMENU.cbl \
  PRGV0001.cbl \
  PRGI0002.cbl \
  PRGU0003.cbl \
  PRGD0004.cbl \
  PRGQ0005.cbl \
  PRGQ0006.cbl \
  PRGQ0007.cbl \
  PRGR0008.cbl
```

> The `-I .` flag tells the compiler to look for `STUDENT-RECORD.cpy` in the current directory.  
> Remove `-free` if using fixed-format COBOL (columns 7–72).

#### 3. Compile — separate shared modules (optional)

```bash
# Compile each sub-program as a shared library
cobc -m -free -I . -o PRGV0001.so PRGV0001.cbl
cobc -m -free -I . -o PRGI0002.so PRGI0002.cbl
cobc -m -free -I . -o PRGU0003.so PRGU0003.cbl
cobc -m -free -I . -o PRGD0004.so PRGD0004.cbl
cobc -m -free -I . -o PRGQ0005.so PRGQ0005.cbl
cobc -m -free -I . -o PRGQ0006.so PRGQ0006.cbl
cobc -m -free -I . -o PRGQ0007.so PRGQ0007.cbl
cobc -m -free -I . -o PRGR0008.so PRGR0008.cbl

# Compile the main menu as the executable entry point
cobc -x -free -I . -o PRGMENU PRGMENU.cbl

# Run with the module path pointing to the current directory
COB_LIBRARY_PATH=. ./PRGMENU
```

#### 4. Run

```bash
# Make sure SEQFILE.DAT is in the same directory, then run
./PRGMENU
```

On first launch, select **Option 1** to load `SEQFILE.DAT` into the VSAM file. All other options are available after that.

> ⚠️ **Warning:** Running Option 1 again will wipe all existing VSAM data and reload only the original 9 seed records.

---

### IBM z/OS (Mainframe)

#### JCL Compile Step

```jcl
//COBRUN   EXEC IGYWCL
//COBOL.SYSIN  DD DSN=YOUR.HLQ.SOURCE(PRGMENU),DISP=SHR
//LKED.SYSLMOD DD DSN=YOUR.HLQ.LOAD(PRGMENU),DISP=SHR
```

#### VSAM Cluster Definition (IDCAMS)

```jcl
//DEFINE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEFINE CLUSTER (NAME(YOUR.HLQ.VSAMFILE)     -
                  INDEXED                      -
                  KEYS(4 0)                    -
                  RECORDSIZE(68 68)            -
                  TRACKS(5 5)                  -
                  SHAREOPTIONS(1))             -
         DATA  (NAME(YOUR.HLQ.VSAMFILE.DATA)) -
         INDEX (NAME(YOUR.HLQ.VSAMFILE.INDEX))
/*
```

#### Record Length Breakdown

| Field | Length |
|-------|--------|
| `SR-ID` | 4 bytes |
| `SR-NAME` | 25 bytes |
| `SR-BIRTHDAY` | 8 bytes |
| `SR-COURSE` | 15 bytes |
| `SR-INSERT-DATE` | 8 bytes |
| `SR-UPDATE-DATE` | 8 bytes |
| **Total** | **68 bytes** |

---

## 🐛 Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `cannot find module 'PRGV0001'` | Sub-programs not linked | Compile all `.cbl` files together with one `cobc` command |
| `ERROR OPENING SEQUENTIAL FILE: 35` | `SEQFILE.DAT` not found | Run the program from the same directory as `SEQFILE.DAT` |
| `Implicit CLOSE warning` | Program stopped before `CLOSE` ran | Usually a symptom of another error — fix the root cause first |
| File not found for VSAM | Wrong working directory | Set `DD_VSAMFILE=/full/path/VSAMFILE` or run from project folder |

---

## 📝 Notes

- GnuCOBOL maps `ORGANIZATION IS INDEXED` to Berkeley DB (BDB) automatically — no manual VSAM setup needed on Linux/macOS.
- All programs use `FUNCTION CURRENT-DATE(1:8)` to capture today's date in `YYYYMMDD` format for insert and update timestamps.
- The `SORT` verb in `PRGR0008` uses `INPUT PROCEDURE` / `OUTPUT PROCEDURE` sections — these must be `SECTION`s, not plain paragraphs.