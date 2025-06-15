# csi-sql-week4
Hii, Welcome to one of the interesting and real life practical project "Student-alotment".

# Student Subject Allotment (SQL)

This project implements a stored procedure to automatically allot elective subjects to students based on their GPA and preferences.

## 📋 Tables

- `StudentDetails`
- `SubjectDetails`
- `StudentPreference`
- `Allotments`
- `UnallotedStudents`

## 🚀 Features

- Top GPA students are processed first
- Each student is allotted their highest available preference
- Unallotted students are recorded separately

## 💻 How to Run

1. Create a new database (e.g., `StudentAllotment`)
2. Import the `student_allotment.sql` file into MySQL Workbench
3. Run the procedure:

```sql
CALL AllocateSubjects();

Now you might be thinking, how do we see results?? , no worries just type the script
SELECT * FROM Allotments;
SELECT * FROM UnallotedStudents;


That's It, Good to go!!
