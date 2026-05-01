# Exercise Set 5: File Operations & I/O

**Topic**: File Operations & I/O  
**Difficulty**: ⭐⭐⭐ (Intermediate)  
**Time**: 60-90 minutes  
**Prerequisites**: Complete [Topic 4](../topics/04-functions.md) and read [Topic 5](../topics/05-file-operations.md)

---

## Instructions

1. **Create a new directory**:
   ```bash
   mkdir -p ~/bash-exercises/set-5
   cd ~/bash-exercises/set-5
   ```

2. **For each exercise**:
   - Read the description
   - Write your script
   - Create sample data files
   - Test thoroughly
   - Compare with solution

3. **Create test files** as needed for each exercise

---

## Exercise 5.1: Read and Display File

**Description**: Create a script that reads a file and displays it with line numbers.

**Requirements**:
- Accept filename as argument
- Check if file exists
- Display with line numbers
- Handle errors gracefully

**Test:**
```bash
# Create test file first
echo -e "apple\nbanana\ncherry" > fruits.txt

./exercise-5-1.sh fruits.txt
```

**Expected Output:**
```
     1	apple
     2	banana
     3	cherry
```

<details>
<summary>✅ Solution</summary>

```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1

if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found"
    exit 1
fi

if [ ! -r "$filename" ]; then
    echo "Error: File not readable"
    exit 1
fi

cat -n "$filename"
```

</details>

---

## Exercise 5.2: Write and Append

**Description**: Create a script that builds a file by writing and appending data.

**Requirements**:
- Create a new file with header
- Append user data
- Display final result
- Verify file contents

**Solution:**
```bash
#!/bin/bash

output_file="users.txt"

# Create file with header
echo "=== User Registration ===" > "$output_file"
echo "Registered on: $(date)" >> "$output_file"
echo "" >> "$output_file"

# Append user data
echo "alice,alice@example.com,2026-05-01" >> "$output_file"
echo "bob,bob@example.com,2026-05-01" >> "$output_file"
echo "charlie,charlie@example.com,2026-05-01" >> "$output_file"

# Display
echo "File created: $output_file"
echo ""
cat "$output_file"
```

---

## Exercise 5.3: Process CSV File

**Description**: Create a script to read and process a CSV file.

**Requirements**:
- Read books.csv
- Extract specific columns
- Display formatted output
- Count total records

**Test Setup:**
```bash
cat > books.csv << EOF
Title,Author,Year
1984,George Orwell,1949
Alice in Wonderland,Lewis Carroll,1865
The Great Gatsby,F. Scott Fitzgerald,1925
EOF
```

**Solution:**
```bash
#!/bin/bash

csv_file="books.csv"

if [ ! -f "$csv_file" ]; then
    echo "Error: $csv_file not found"
    exit 1
fi

echo "=== Library Catalog ==="
echo ""

# Skip header and display
tail -n +2 "$csv_file" | while IFS=',' read -r title author year; do
    echo "Title: $title"
    echo "Author: $author"
    echo "Year: $year"
    echo "---"
done

echo ""
echo "Total books: $(tail -n +2 "$csv_file" | wc -l)"
```

---

## Exercise 5.4: Search and Filter

**Description**: Create a script that searches files using grep and displays results.

**Requirements**:
- Search for pattern in file
- Display matching lines
- Show count of matches
- Case insensitive search

**Test:**
```bash
./exercise-5-4.sh "alice" books.csv
```

**Solution:**
```bash
#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <search_term> <filename>"
    exit 1
fi

search_term=$1
filename=$2

if [ ! -f "$filename" ]; then
    echo "Error: File not found"
    exit 1
fi

echo "=== Search Results for: $search_term ==="
echo ""

if grep -i "$search_term" "$filename"; then
    echo ""
    echo "Matches found: $(grep -ic "$search_term" "$filename")"
else
    echo "No matches found"
fi
```

---

## Exercise 5.5: Transaction Log

**Description**: Create a function that logs transactions with timestamps.

**Requirements**:
- Create log file with timestamps
- Append transactions
- Display recent entries
- Show total count

**Solution:**
```bash
#!/bin/bash

log_file="transactions.log"

# Function to log transaction
log_transaction() {
    local action=$1
    local details=$2
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    echo "$timestamp | $action | $details" >> "$log_file"
}

# Function to show recent transactions
show_recent() {
    local count=${1:-5}
    echo "=== Last $count Transactions ==="
    tail -n "$count" "$log_file"
}

# Function to count transactions
count_transactions() {
    local action=$1
    grep -c "$action" "$log_file"
}

# Use the functions
log_transaction "REGISTER" "alice registered"
log_transaction "BORROW" "alice borrowed 1984"
log_transaction "REGISTER" "bob registered"
log_transaction "RETURN" "alice returned 1984"

show_recent 4
echo ""
echo "Total registrations: $(count_transactions 'REGISTER')"
echo "Total borrows: $(count_transactions 'BORROW')"
```

---

## Challenge Exercise: Library Data Management

**Description**: Create a complete system to manage library data using files.

**Requirements**:
- Load books from CSV
- Search functionality (title, author, year)
- User registration system
- Transaction logging
- Report generation

**Starter Code:**
```bash
#!/bin/bash

books_file="books.csv"
users_file="users.txt"
log_file="transactions.log"

# Initialize files if they don't exist
initialize() {
    if [ ! -f "$books_file" ]; then
        cat > "$books_file" << EOF
1984,George Orwell,1949
Alice in Wonderland,Lewis Carroll,1865
The Great Gatsby,F. Scott Fitzgerald,1925
EOF
    fi
    
    if [ ! -f "$users_file" ]; then
        echo "# User Registration" > "$users_file"
    fi
    
    if [ ! -f "$log_file" ]; then
        echo "# Transaction Log" > "$log_file"
    fi
}

# Search books by title
search_title() {
    grep -i "$1" "$books_file"
}

# Register user
register_user() {
    local username=$1
    if grep -q "^$username$" "$users_file" 2>/dev/null; then
        echo "User already registered"
        return 1
    fi
    echo "$username" >> "$users_file"
    echo "$(date '+%Y-%m-%d %H:%M:%S') | REGISTER | $username" >> "$log_file"
    return 0
}

# Show statistics
show_stats() {
    echo "=== Library Statistics ==="
    echo "Total books: $(tail -n +2 "$books_file" 2>/dev/null | wc -l)"
    echo "Total users: $(tail -n +2 "$users_file" 2>/dev/null | wc -l)"
    echo "Total transactions: $(tail -n +2 "$log_file" 2>/dev/null | wc -l)"
}

# Main menu
initialize

while true; do
    echo ""
    echo "=== Library System ==="
    echo "1. Search books"
    echo "2. Register user"
    echo "3. Show statistics"
    echo "4. Exit"
    
    read -p "Choose: " choice
    
    case $choice in
        1)
            read -p "Search for: " term
            search_title "$term"
            ;;
        2)
            read -p "Username: " user
            register_user "$user"
            ;;
        3)
            show_stats
            ;;
        4)
            exit 0
            ;;
    esac
done
```

---

## Completion Checklist

- [ ] Exercise 5.1: Read and Display ✓
- [ ] Exercise 5.2: Write and Append ✓
- [ ] Exercise 5.3: Process CSV ✓
- [ ] Exercise 5.4: Search and Filter ✓
- [ ] Exercise 5.5: Transaction Log ✓
- [ ] Challenge Exercise (Optional) ✓

---

## Testing Tips

Create test data:
```bash
# Books catalog
cat > books.csv << EOF
1984,George Orwell,1949
Alice in Wonderland,Lewis Carroll,1865
The Great Gatsby,F. Scott Fitzgerald,1925
EOF

# Users file
cat > users.txt << EOF
alice
bob
charlie
EOF
```

Test your scripts:
```bash
./exercise-5-1.sh books.csv
./exercise-5-4.sh "Orwell" books.csv
```

---

## Next Steps

Once completed:
1. Review solutions
2. Try combining with functions from Topic 4
3. Move to **Topic 6: IPC (Interprocess Communication)**

---

**Difficulty**: ⭐⭐⭐ (Intermediate - File handling)

**Time**: 60-90 minutes

**When Ready**: [Go to Topic 6 →](../topics/06-ipc.md)
