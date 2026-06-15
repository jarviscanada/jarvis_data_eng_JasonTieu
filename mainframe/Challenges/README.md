# COBOL Challenges

A collection of practical COBOL programming challenges covering fundamental concepts and real-world scenarios.

---

## 📁 Challenge Overview

### 1. BMI Challenge
**File:** `BmiCalulator.cbl`

A body mass index (BMI) calculator that accepts user input and computes BMI with health classification.

**Features:**
- Supports both metric (kg/cm) and imperial (lbs/inches) units
- Automatic BMI calculation
- Health classification output:
  - Underweight (BMI < 18.5)
  - Normal weight (18.5 ≤ BMI < 25)
  - Overweight (25 ≤ BMI < 30)
  - Obese (BMI ≥ 30)

**Skills Covered:**
- User input and validation
- Conditional logic (EVALUATE/WHEN)
- Arithmetic computation
- Output formatting

---

### 2. Cash Register Challenge
**Files:** `petstorereport.cbl`, `petstorechallenge`

A retail sales data processing system for a pet store that reads transaction data and generates comprehensive sales reports.

**Features:**
- File I/O (sequential file processing)
- Multi-item customer transactions (3 items per customer)
- Sales calculation (price × quantity)
- Aggregation and reporting:
  - Customer-level subtotals
  - Item-level totals
  - Overall sales summary
- Formatted report generation

**Input/Output:**
- Input: `PETSTORESALES.DAT` (customer and item details)
- Output: `PETSTOREREPORT.DAT` (formatted sales report)

**Skills Covered:**
- Sequential file organization
- Record structure definition
- OCCURS clause for array-like handling
- Accumulation and subtotaling
- Report formatting

---

### 3. Payroll Challenge
**Files:** `employeePay.cbl`, `employeeraise`, `employeeRaise.cbl`, `solution.cbl`

A complete payroll processing system that calculates employee compensation and generates payroll reports.

**Features:**
- Employee master file processing
- Hourly wage calculation (hours worked × hourly rate)
- Department tracking
- Gender-based considerations
- Payroll generation and reporting

**Input/Output:**
- Input: `EMPFILE.DAT` (employee master records)
- Output: `PAYROLLIN.DAT` (calculated payroll)

**Record Structure:**
- Employee ID, Name, Start Date
- Hours Worked, Hourly Rate
- Department, Gender

**Skills Covered:**
- File status checking
- REDEFINES clause
- Structured record definition
- Payroll calculations
- Data validation and error handling

---

### 4. Sales Commission Challenge
**File:** `SalesCommissionReport.cbl`

A sales commission calculation system that processes salesperson data and computes region-based commissions.

**Features:**
- Salesperson data processing
- Yearly sales aggregation
- Region-based commission calculation (5% standard rate)
- Regional sales tracking (East, North, West, South)
- Commission total reporting

**Input/Output:**
- Input: `SALES.DAT` (salesperson and sales data)
- Output: `COMMISSIONREPORT5.DAT` (commission report)

**Skills Covered:**
- Commission rate calculations
- Regional sales accumulation
- COMP-3 packed decimal for efficiency
- File organization and sequencing

---

## 🛠️ Compilation

### Prerequisites
- GnuCOBOL (cobc) installed
- Free-form COBOL compatible compiler

### Compile Individual Program
```bash
cobc -x -free -o [program_name] [program_name].cbl
```

Example:
```bash
cobc -x -free -o BmiCalulator BmiCalulator.cbl
cobc -x -free -o SalesCommissionReport SalesCommissionReport.cbl
```

### Run Programs
```bash
./[program_name]
```

---

## 📊 Program Dependencies

| Challenge | Input Files | Output Files | Input Method |
|-----------|------------|------------|--------------|
| BMI | None | Console | User prompt |
| Cash Register | PETSTORESALES.DAT | PETSTOREREPORT.DAT | File |
| Payroll | EMPFILE.DAT | PAYROLLIN.DAT | File |
| Sales Commission | SALES.DAT | COMMISSIONREPORT5.DAT | File |

---

## 📚 Learning Progression

Recommended order for learning:

1. **BMI Challenge** — Start here for basic I/O and conditional logic
2. **Cash Register Challenge** — Learn file processing and record structures
3. **Payroll Challenge** — Master complex record definitions and calculations
4. **Sales Commission** — Apply all concepts to a real-world business scenario

---

## 🔍 Key COBOL Concepts Demonstrated

- **IDENTIFICATION DIVISION** — Program naming and metadata
- **ENVIRONMENT DIVISION** — File definitions and organization
- **DATA DIVISION** — Record structure, working storage, field definitions
- **PROCEDURE DIVISION** — Business logic and processing
- **File I/O** — Sequential file handling, record reading/writing
- **Calculations** — Arithmetic operations (COMPUTE, addition, multiplication)
- **Conditionals** — EVALUATE/WHEN statements and decision logic
- **Record Definition** — PIC clauses, REDEFINES, OCCURS
- **Output Formatting** — Display statements and report generation

---

## 📝 Author
**Jason Tieu** — May 2026

---

## 💡 Tips

- All programs compile with the free-form COBOL syntax (`-free` flag)
- Ensure input data files exist in the program directory before running file-based challenges
- Check the `bin/` directory for compiled executables
- Review program headers for author, date, and purpose information
