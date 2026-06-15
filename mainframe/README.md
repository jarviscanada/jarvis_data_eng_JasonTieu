# Mainframe Development Portfolio

A comprehensive collection of COBOL programs demonstrating fundamental and advanced mainframe programming concepts, including practical challenges and a full-featured student management system using VSAM.

## 🎯 Projects Overview

### 1️⃣ COBOL Challenges

A collection of **4 practical programming challenges** covering fundamental COBOL concepts and real-world business scenarios.

**Included Challenges:**
- **BMI Calculator** — Input validation, conditional logic, arithmetic computation
- **Cash Register (Pet Store)** — File I/O, sequential processing, report generation
- **Payroll System** — File handling, record structures, payroll calculations
- **Sales Commission** — Data aggregation, region-based calculations, reporting

**Key Skills:**
- User input and validation
- Sequential file processing
- Record structure definition
- Business logic and calculations
- Formatted report generation

📖 **Detailed documentation:** See [Challenges/README.md](Challenges/README.md)

---

### 2️⃣ Class Registration (Student Management System)

A **complete VSAM KSDS-based student management system** with a menu-driven interface. Demonstrates advanced COBOL features including file organization, indexing, CRUD operations, and report generation.

**Features:**
- ✅ Full CRUD operations (Create, Read, Update, Delete)
- 📋 Multiple query types (by ID, by date, all records)
- 📊 Sorted reporting with control break grouping
- 🔐 Input validation and error handling
- 🎯 Auto-generated student IDs
- 📅 Date formatting and manipulation

**Program Modules:**
| Program | Operation |
|---------|-----------|
| `PRGMENU` | Main menu dispatcher |
| `PRGV0001` | Initialize VSAM from flat file |
| `PRGI0002` | Insert new student records |
| `PRGU0003` | Update existing records |
| `PRGD0004` | Delete records by ID |
| `PRGQ0005` | Query all students |
| `PRGQ0006` | Query single student by ID |
| `PRGQ0007` | Query by date of inclusion |
| `PRGR0008` | Sorted report with course grouping |

**VSAM Record Structure:**
- Student ID (4 digits) — Primary key
- Name (25 characters)
- Birthday (YYYYMMDD)
- Course (15 characters)
- Insert date & update date (YYYYMMDD)

📖 **Detailed documentation:** See [Class Registration/README.md](Class%20Registration/README.md)

---

## 🛠️ Getting Started

### Requirements
- **GnuCOBOL** (free, open-source COBOL compiler)
- **Linux/Unix environment** or WSL on Windows
- **Bash shell** for running the programs

### Installation

**Ubuntu/Debian:**
```bash
sudo apt install gnucobol
```

**macOS:**
```bash
brew install gnucobol
```

**Windows:**
Use WSL (Windows Subsystem for Linux) or download the GnuCOBOL installer

### Compilation

Navigate to the desired project folder and compile:

**Challenges (individual programs):**
```bash
cd Challenges/BMI\ Challenge
cobc -x -free BmiCalulator.cbl -o BmiCalulator
./BmiCalulator
```

**Class Registration (complete system):**
```bash
cd Class\ Registration
cobc -x -free -I . -o PRGMENU \
  PRGMENU.cbl PRGV0001.cbl PRGI0002.cbl PRGU0003.cbl \
  PRGD0004.cbl PRGQ0005.cbl PRGQ0006.cbl PRGQ0007.cbl PRGR0008.cbl
./PRGMENU
```

---

## 📖 COBOL Concepts Covered

- **Data Types & Structures** — PIC clauses, RECORD definitions, OCCURS arrays
- **File Organization** — Sequential files, VSAM KSDS (indexed sequential)
- **CRUD Operations** — READ, WRITE, REWRITE, DELETE
- **Control Flow** — EVALUATE/WHEN conditionals, PERFORM loops
- **String & Date Handling** — REDEFINES, date formatting
- **Sorting & Reporting** — SORT verb, control break reporting
- **Input Validation** — Error handling, data type checking
- **Modular Programming** — Sub-programs, copybooks, shared structures

---

## 📝 Learning Path

**Beginner:**
1. BMI Calculator — Basic input/output and arithmetic
2. Cash Register Challenge — Introduce file I/O concepts

**Intermediate:**
3. Payroll Challenge — Complex record structures
4. Sales Commission Challenge — Multi-field aggregation

**Advanced:**
5. Class Registration System — VSAM, CRUD, sorting, and control break reporting

---

## 📚 Additional Resources

- [GNU COBOL Documentation](https://www.gnu-cobol.org/)
- [COBOL Reference Manual](https://gnucobol.sourceforge.io/doc/cobol.pdf)
- VSAM principles and file organization concepts

---

## 👤 Author

Part of the Jarvis Data Engineering bootcamp portfolio

