# Topic 5: File Operations & I/O

**Status**: ✅ Ready to Learn  
**Duration**: 2-3 hours  
**Prerequisites**: [Topic 4: Functions](04-functions.md)  
**Next Topic**: [Topic 6: IPC (Coming Soon)](06-ipc.md)

---

## Table of Contents

- [What Is File I/O?](#what-is-file-io)
- [Reading Files](#reading-files)
- [Writing to Files](#writing-to-files)
- [Appending to Files](#appending-to-files)
- [File Permissions](#file-permissions)
- [Input/Output Redirection](#inputoutput-redirection)
- [Pipes](#pipes)
- [Text Processing (grep, sed, awk)](#text-processing)
- [Working with CSV Files](#working-with-csv-files)
- [Practice Exercises](#practice-exercises)
- [Common Pitfalls](#common-pitfalls)
- [Summary](#summary)

---

## What Is File I/O?

**File I/O** means reading from and writing to files. For your library project, you need to:
- **Read** books.csv to load the catalog
- **Write** to user registration files
- **Append** to transaction logs
- **Process** and organize data

---

## Reading Files

### Simple Read: Display Entire File

```bash
#!/bin/bash

# Method 1: cat (concatenate)
cat filename.txt

# Method 2: less (view with pagination)
less filename.txt

# Method 3: head (first 10 lines)
head filename.txt

# Method 4: tail (last 10 lines)
tail filename.txt
```

### Read Line by Line

```bash
#!/bin/bash

# Read file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < "filename.txt"
```

### Read CSV Line by Line

```bash
#!/bin/bash

# Read CSV with comma separator
while IFS=',' read -r title author year; do
    echo "Book: $title by $author ($year)"
done < "books.csv"
```

### Read Specific Lines

```bash
#!/bin/bash

# Get line 5
sed -n '5p' filename.txt

# Get lines 1-10
sed -n '1,10p' filename.txt

# Get all lines matching pattern
grep "pattern" filename.txt
```

### Count Lines in File

```bash
#!/bin/bash

# Count total lines
wc -l filename.txt

# Count lines matching pattern
grep -c "pattern" filename.txt
```

---

## Writing to Files

### Create New File (Overwrite if Exists)

```bash
#!/bin/bash

# Using echo with > redirection
echo "First line" > filename.txt
echo "Second line" > filename.txt  # Overwrites!

# Using cat with here-document
cat > filename.txt << EOF
Line 1
Line 2
Line 3
EOF

# Using printf
printf "Name: %s\n" "Alice" > filename.txt
```

### Example: Create User Registration File

```bash
#!/bin/bash

username="alice"
email="alice@example.com"
date_registered=$(date +%Y-%m-%d)

echo "username=$username" > user_$username.txt
echo "email=$email" >> user_$username.txt
echo "date=$date_registered" >> user_$username.txt
```

---

## Appending to Files

### Add to End of File (Don't Overwrite)

```bash
#!/bin/bash

# Append single line
echo "New line" >> filename.txt

# Append multiple lines
cat >> filename.txt << EOF
Line 1
Line 2
EOF
```

### Example: Log Transactions

```bash
#!/bin/bash

# Log file for book borrowing
log_file="transactions.log"

borrow_book() {
    local username=$1
    local book=$2
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Append transaction log
    echo "$timestamp | $username borrowed '$book'" >> "$log_file"
}

# Use it
borrow_book "alice" "1984"
borrow_book "bob" "The Great Gatsby"
```

File `transactions.log`:
```
2026-05-01 10:30:45 | alice borrowed '1984'
2026-05-01 10:31:20 | bob borrowed 'The Great Gatsby'
```

---

## File Permissions

### View Permissions

```bash
#!/bin/bash

# See file permissions
ls -l filename.txt

# Output: -rw-r--r-- 1 user group 1024 May 1 10:00 filename.txt
#         ^          ^                 meaning: owner can read/write, others can read
```

### Change Permissions

```bash
#!/bin/bash

# Make file readable/writable by owner only
chmod 600 filename.txt

# Make file executable
chmod +x script.sh

# Make readable by all
chmod 644 filename.txt

# Make readable/writable by all
chmod 666 filename.txt
```

### Check If File Is Readable/Writable

```bash
#!/bin/bash

# Check if file exists
if [ -f "filename.txt" ]; then
    echo "File exists"
fi

# Check if readable
if [ -r "filename.txt" ]; then
    echo "File is readable"
fi

# Check if writable
if [ -w "filename.txt" ]; then
    echo "File is writable"
fi

# Check if executable
if [ -x "script.sh" ]; then
    echo "Script is executable"
fi
```

---

## Input/Output Redirection

### Redirect Output to File

```bash
#!/bin/bash

# Overwrite file
echo "Hello" > output.txt

# Append to file
echo "World" >> output.txt

# Redirect errors to file
command 2> errors.txt

# Redirect both output and errors
command > output.txt 2>&1
```

### Redirect Input from File

```bash
#!/bin/bash

# Read input from file
while read line; do
    echo "Processing: $line"
done < input.txt

# Use file as stdin for command
grep "pattern" < filename.txt
```

### Redirect to /dev/null (Discard Output)

```bash
#!/bin/bash

# Suppress output
command > /dev/null

# Suppress errors
command 2> /dev/null

# Suppress everything
command > /dev/null 2>&1
```

---

## Pipes

A **pipe** (`|`) sends output of one command to another command.

```bash
#!/bin/bash

# Basic pipe
command1 | command2

# Example: count how many users
grep "^" users.txt | wc -l

# Example: find and display
grep "alice" books.csv | head -5

# Chain multiple pipes
cat filename.txt | grep "pattern" | wc -l
```

### Common Pipe Examples

```bash
#!/bin/bash

# Count total lines in file
wc -l < books.csv

# Find specific book and show details
grep "1984" books.csv | cut -d',' -f1-2

# Sort and remove duplicates
sort users.txt | uniq

# Count occurrences of pattern
grep "borrowed" transactions.log | wc -l
```

---

## Text Processing

### grep (Find Patterns)

```bash
#!/bin/bash

# Find exact line
grep "^alice$" users.txt

# Find lines containing pattern
grep "alice" users.txt

# Count matches
grep -c "pattern" filename.txt

# Invert match (lines NOT containing)
grep -v "pattern" filename.txt

# Case insensitive
grep -i "ALICE" users.txt

# Show line numbers
grep -n "pattern" filename.txt
```

### sed (Stream Editor - Replace Text)

```bash
#!/bin/bash

# Replace first occurrence on each line
sed 's/old/new/' filename.txt

# Replace all occurrences on each line
sed 's/old/new/g' filename.txt

# Replace and save to file
sed 's/old/new/g' filename.txt > newfile.txt

# Delete lines matching pattern
sed '/pattern/d' filename.txt

# Show only lines matching pattern
sed -n '/pattern/p' filename.txt
```

### awk (Text Processing)

```bash
#!/bin/bash

# Print specific field (comma-separated)
awk -F',' '{print $1}' books.csv

# Print with condition
awk -F',' '$3 > 1950 {print $1}' books.csv

# Count records
awk -F',' 'END {print NR}' books.csv

# Sum a field
awk -F',' '{sum += $3} END {print sum}' filename.csv
```

### cut (Extract Columns)

```bash
#!/bin/bash

# Get first field (comma-separated)
cut -d',' -f1 books.csv

# Get fields 1 and 3
cut -d',' -f1,3 books.csv

# Get characters 1-10
cut -c1-10 filename.txt
```

---

## Working with CSV Files

### Your Library Project: books.csv

File format:
```
Title,Author,Year
1984,George Orwell,1949
Alice in Wonderland,Lewis Carroll,1865
The Great Gatsby,F. Scott Fitzgerald,1925
```

### Read and Process CSV

```bash
#!/bin/bash

# Count total books
wc -l < books.csv

# Find book by title
grep "1984" books.csv

# Extract just titles
cut -d',' -f1 books.csv

# List books after 1900
awk -F',' '$3 > 1900 {print $1}' books.csv

# Count books by author (if you have repeated authors)
cut -d',' -f2 books.csv | sort | uniq -c
```

### Split CSV into Multiple Files

```bash
#!/bin/bash

# Split books.csv by author (example for 2 libraries)
awk -F',' 'NR % 2 == 0' books.csv > library1.csv
awk -F',' 'NR % 2 == 1' books.csv > library2.csv
```

### Process CSV Line by Line

```bash
#!/bin/bash

# Your bootstrap.sh pattern (from earlier)
while IFS=',' read -r title author year; do
    echo "Processing: $title"
    # Do something with each book
done < "books.csv"
```

---

## Practice Exercises

### Exercise 5.1: Read and Display File

**Description**: Create a script that reads a file and displays it.

**Requirements**:
- Accept filename as argument
- Check if file exists
- Display file contents with line numbers

**Solution**:
```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1

if [ ! -f "$filename" ]; then
    echo "Error: File not found"
    exit 1
fi

cat -n "$filename"
```

---

### Exercise 5.2: Write and Append

**Description**: Create a script that writes to a file and appends data.

**Requirements**:
- Create a new file with initial data
- Append more data
- Display final file

**Solution**:
```bash
#!/bin/bash

filename="output.txt"

# Create with initial data
echo "Created: $(date)" > "$filename"
echo "User: $USER" >> "$filename"
echo "Host: $(hostname)" >> "$filename"

# Display
echo "=== File Contents ==="
cat "$filename"
```

---

### Exercise 5.3: Process CSV File

**Description**: Read a CSV file and display specific columns.

**Requirements**:
- Read books.csv (create sample file)
- Extract and display specific fields
- Count total records

**Solution**:
```bash
#!/bin/bash

books_file="books.csv"

if [ ! -f "$books_file" ]; then
    echo "Error: $books_file not found"
    exit 1
fi

echo "=== Books in Library ==="
# Skip header, display title and author
tail -n +2 "$books_file" | cut -d',' -f1,2

echo ""
echo "Total books: $(tail -n +2 "$books_file" | wc -l)"
```

---

### Exercise 5.4: Search and Filter

**Description**: Search files and display matching records.

**Requirements**:
- Use grep to find matching lines
- Display with context
- Count matches

**Solution**:
```bash
#!/bin/bash

search_term=$1
filename="books.csv"

if [ -z "$search_term" ]; then
    echo "Usage: $0 <search_term>"
    exit 1
fi

echo "Searching for: $search_term"
echo ""

# Find and display matching lines
grep -i "$search_term" "$filename"

echo ""
echo "Matches found: $(grep -ic "$search_term" "$filename")"
```

---

### Exercise 5.5: Create Transaction Log

**Description**: Write a function that logs transactions to a file.

**Requirements**:
- Create log file with timestamp
- Append new transactions
- Display last N transactions

**Solution**:
```bash
#!/bin/bash

log_file="transactions.log"

# Log a transaction
log_transaction() {
    local action=$1
    local details=$2
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    echo "$timestamp | $action | $details" >> "$log_file"
}

# Display last 5 transactions
show_recent() {
    echo "=== Recent Transactions ==="
    tail -5 "$log_file"
}

# Use it
log_transaction "BORROW" "alice borrowed 1984"
log_transaction "RETURN" "bob returned The Great Gatsby"
log_transaction "REGISTER" "charlie registered"

show_recent
```

---

### Challenge Exercise: CSV Data Management

**Description**: Create a complete data management system for library books.

**Requirements**:
- Load books from CSV
- Search by title/author
- Generate reports
- Export filtered data

**Starter Code**:
```bash
#!/bin/bash

books_file="books.csv"

# Function to search by title
search_title() {
    local search=$1
    grep -i "$search" "$books_file"
}

# Function to search by author
search_author() {
    local search=$1
    awk -F',' -v search="$search" \
        'tolower($2) ~ tolower(search) {print}' "$books_file"
}

# Function to list books by year range
books_by_year() {
    local start=$1
    local end=$2
    awk -F',' -v start="$start" -v end="$end" \
        '$3 >= start && $3 <= end {print}' "$books_file"
}

# Function to generate report
generate_report() {
    echo "=== Library Report ==="
    echo "Total books: $(tail -n +2 "$books_file" | wc -l)"
    echo "Authors: $(cut -d',' -f2 "$books_file" | sort | uniq | wc -l)"
    echo ""
    echo "Books by century:"
    awk -F',' 'NR > 1 {
        year = $3
        if (year < 1900) century = "1800s"
        else if (year < 2000) century = "1900s"
        else century = "2000s"
        count[century]++
    }
    END {
        for (c in count) print "  " c ": " count[c]
    }' "$books_file"
}

# Menu
while true; do
    echo ""
    echo "=== Library Data Management ==="
    echo "1. Search by title"
    echo "2. Search by author"
    echo "3. Books by year range"
    echo "4. Generate report"
    echo "5. Exit"
    
    read -p "Choose: " choice
    
    case $choice in
        1)
            read -p "Title search: " term
            search_title "$term"
            ;;
        2)
            read -p "Author search: " term
            search_author "$term"
            ;;
        3)
            read -p "Start year: " start
            read -p "End year: " end
            books_by_year "$start" "$end"
            ;;
        4)
            generate_report
            ;;
        5)
            exit 0
            ;;
    esac
done
```

---

## Common Pitfalls

### ❌ Pitfall 1: Overwriting Instead of Appending

**Wrong**:
```bash
echo "Line 1" > file.txt
echo "Line 2" > file.txt  # Overwrites!
```

**Right**:
```bash
echo "Line 1" > file.txt
echo "Line 2" >> file.txt  # Appends
```

---

### ❌ Pitfall 2: Not Checking If File Exists

**Wrong**:
```bash
cat "$filename"  # What if file doesn't exist?
```

**Right**:
```bash
if [ -f "$filename" ]; then
    cat "$filename"
else
    echo "Error: File not found"
fi
```

---

### ❌ Pitfall 3: Not Quoting Variables with Spaces

**Wrong**:
```bash
cat $filename  # Breaks if filename has spaces
```

**Right**:
```bash
cat "$filename"
```

---

### ❌ Pitfall 4: Ignoring CSV Header Row

**Wrong**:
```bash
while IFS=',' read -r title author year; do
    echo "$title"  # Prints "Title" for first line!
done < "books.csv"
```

**Right**:
```bash
tail -n +2 "books.csv" | while IFS=',' read -r title author year; do
    echo "$title"
done
```

---

### ❌ Pitfall 5: Not Handling Empty Files

**Wrong**:
```bash
grep "pattern" file.txt
# No error if file is empty or doesn't exist
```

**Right**:
```bash
if [ -f "$file" ] && [ -s "$file" ]; then  # -s = file is not empty
    grep "pattern" "$file"
else
    echo "File is empty or not found"
fi
```

---

## Summary

### What You Learned

| Concept | Key Points |
|---------|-----------|
| **Reading** | cat, head, tail, while loop |
| **Writing** | `>` (overwrite), `>>` (append) |
| **CSV** | IFS=',', cut, awk |
| **Permissions** | chmod, test operators (-r, -w, -x) |
| **Redirection** | `>`, `>>`, `<`, `2>&1` |
| **Pipes** | `\|` chains commands |
| **grep** | Find patterns in files |
| **sed** | Replace text |
| **awk** | Process columns and records |

### You Can Now

✅ Read files line by line  
✅ Write and append to files  
✅ Process CSV files  
✅ Search files with grep  
✅ Replace text with sed  
✅ Use pipes and redirection  
✅ Handle file permissions  

### Real Project Application

For your **Library System**:
- **bootstrap.sh**: Read books.csv, write to library catalogs
- **user.sh**: Read user registrations, append borrow records
- **manage.sh**: Search logs, generate reports
- **All scripts**: Use pipes, redirection, text processing

---

## Quick Reference

```bash
# Reading
cat file.txt
head -5 file.txt
tail -5 file.txt
grep "pattern" file.txt

# Writing
echo "text" > file.txt      # Overwrite
echo "text" >> file.txt     # Append

# CSV Processing
while IFS=',' read -r f1 f2 f3; do
    echo "$f1"
done < "file.csv"

# Pipes
cat file.txt | grep "pattern" | wc -l

# Check file
[ -f file.txt ]   # Exists?
[ -r file.txt ]   # Readable?
[ -w file.txt ]   # Writable?
[ -s file.txt ]   # Not empty?
```

---

**Ready to move on?** Go to [Topic 6: IPC](#) 🚀

**Need to review Topic 4?** Go back to [Topic 4: Functions](04-functions.md)
