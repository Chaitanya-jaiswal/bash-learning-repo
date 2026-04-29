# Exercise Set 2: Variables and User Input

**Topic**: Variables and User Input  
**Difficulty**: ⭐⭐ (Easy)  
**Time**: 45-60 minutes  
**Prerequisites**: Complete [Topic 1](../topics/01-intro-basics.md) and [Topic 2](../topics/02-variables.md)

---

## Instructions

1. **Create a new directory** for your exercises:
   ```bash
   mkdir -p ~/bash-exercises/set-2
   cd ~/bash-exercises/set-2
   ```

2. **For each exercise**:
   - Read the description
   - Write your script
   - Make it executable: `chmod +x script.sh`
   - Run and test it
   - Compare with the solution

3. **Test with different inputs** to make sure it works properly

---

## Exercise 2.1: Personal Information

**Description**: Create a script that stores and displays personal information using variables.

**Requirements**:
- Create at least 5 variables (name, age, city, job, hobby)
- Display each variable clearly
- Use string concatenation to create a summary

**Example Output**:
```
Name: Alice
Age: 25
City: New York
Job: Software Engineer
Hobby: Reading

Summary: Alice is a 25-year-old Software Engineer from New York who enjoys Reading.
```

**Test it**:
```bash
./exercise-2-1.sh
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Personal Information Script

# Create variables with personal info
name="Alice"
age=25
city="New York"
job="Software Engineer"
hobby="Reading"

# Display each piece of information
echo "=== Personal Information ==="
echo "Name: $name"
echo "Age: $age"
echo "City: $city"
echo "Job: $job"
echo "Hobby: $hobby"
echo ""

# Create summary using concatenation
summary="$name is a $age-year-old $job from $city who enjoys $hobby."
echo "Summary: $summary"
```

</details>

---

## Exercise 2.2: Calculator with Variables

**Description**: Create a simple calculator that performs arithmetic operations using variables.

**Requirements**:
- Create 2 number variables
- Perform at least 4 operations (+, -, *, /)
- Display all operations with results
- Use proper formatting

**Example Output**:
```
Number 1: 20
Number 2: 4

Addition: 20 + 4 = 24
Subtraction: 20 - 4 = 16
Multiplication: 20 * 4 = 80
Division: 20 / 4 = 5
Remainder: 20 % 4 = 0
```

**Test it**:
```bash
./exercise-2-2.sh
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Simple Calculator Script

# Define numbers
num1=20
num2=4

# Perform calculations
add=$(( num1 + num2 ))
subtract=$(( num1 - num2 ))
multiply=$(( num1 * num2 ))
divide=$(( num1 / num2 ))
modulo=$(( num1 % num2 ))

# Display results
echo "=== Simple Calculator ==="
echo "Number 1: $num1"
echo "Number 2: $num2"
echo ""

echo "Addition: $num1 + $num2 = $add"
echo "Subtraction: $num1 - $num2 = $subtract"
echo "Multiplication: $num1 * $num2 = $multiply"
echo "Division: $num1 / $num2 = $divide"
echo "Remainder: $num1 % $num2 = $modulo"
```

</details>

---

## Exercise 2.3: Command-Line Arguments

**Description**: Create a script that accepts command-line arguments and displays them.

**Requirements**:
- Accept at least 3 arguments
- Display each argument separately
- Show total number of arguments
- Show script name

**Running examples**:
```bash
./exercise-2-3.sh apple banana cherry
./exercise-2-3.sh "John Doe" "123 Main St" "New York"
```

**Example Output** (with 3 arguments):
```
Script name: exercise-2-3.sh
Total arguments: 3

Argument 1: apple
Argument 2: banana
Argument 3: cherry

All arguments: apple banana cherry
```

**Test it**:
```bash
./exercise-2-3.sh John Doe "New York"
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Command-Line Arguments Display Script

# Check if arguments provided
if [ $# -eq 0 ]; then
    echo "ERROR: Please provide arguments!"
    echo "Usage: $0 <arg1> <arg2> [arg3] ..."
    exit 1
fi

# Display script info
echo "=== Argument Information ==="
echo "Script name: $0"
echo "Total arguments: $#"
echo ""

# Display each argument
echo "Individual arguments:"
for i in $(seq 1 $#); do
    arg_var=\$"$i"
    eval echo "Argument $i: \$$i"
done

echo ""
echo "All arguments together: $@"
```

</details>

---

## Exercise 2.4: Interactive Registration Form

**Description**: Create an interactive registration script that collects user information.

**Requirements**:
- Ask for at least 4 pieces of information
- Use `read -p` for prompts
- Store all information in variables
- Display a formatted confirmation

**Example Interaction**:
```
=== User Registration ===

Enter your full name: Alice Smith
Enter your email: alice@example.com
Enter your age: 25
Enter your city: New York

=== Registration Confirmation ===
Name: Alice Smith
Email: alice@example.com
Age: 25
City: New York

Thank you for registering!
```

**Test it**:
```bash
./exercise-2-4.sh
# Then provide inputs as prompted
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# User Registration Script

echo "=== Library User Registration ==="
echo ""

# Collect user information
read -p "Enter your full name: " full_name
read -p "Enter your email address: " email
read -p "Enter your age: " age
read -p "Enter your city: " city
read -p "Enter your favorite book genre: " genre

# Display confirmation
echo ""
echo "=== Registration Confirmation ==="
echo "Name: $full_name"
echo "Email: $email"
echo "Age: $age"
echo "City: $city"
echo "Favorite Genre: $genre"
echo ""
echo "Thank you for registering, $full_name!"
```

</details>

---

## Exercise 2.5: Command Arguments + User Input

**Description**: Create a script that combines both command-line arguments AND user input.

**Requirements**:
- Accept at least 1 argument (library ID or similar)
- Validate that argument is provided
- Ask user for additional information
- Combine and display all information

**Running it**:
```bash
./exercise-2-5.sh library1
# Then provide inputs
```

**Example Output**:
```
Library ID: library1

Enter your username: alice
Enter book title: The Great Gatsby

=== Borrow Request =====
Library: library1
User: alice
Book: The Great Gatsby
```

**Test it**:
```bash
./exercise-2-5.sh "Central Library"
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Library Borrow Request Script

# Validate that library ID is provided
if [ $# -lt 1 ]; then
    echo "ERROR: Library ID is required!"
    echo "Usage: $0 <library_id>"
    exit 1
fi

# Get library ID from argument
library_id="$1"

echo "=== Book Borrow System ==="
echo "Library: $library_id"
echo ""

# Get user information
read -p "Enter your username: " username
read -p "Enter book title: " book_title
read -p "Enter author name: " author
read -p "Enter publication year: " year

# Display borrow request
echo ""
echo "========== Borrow Request =========="
echo "Library ID: $library_id"
echo "Username: $username"
echo "Book Title: $book_title"
echo "Author: $author"
echo "Year: $year"
echo "===================================="
echo ""
echo "Request submitted successfully!"
```

</details>

---

## Challenge Exercise: Library Query System

**Description**: Create a more complex script that mimics a library search/query system.

**Requirements**:
- Accept library ID as argument
- Ask user for search type (title, author, year)
- Ask for search query
- Ask if they want to continue searching
- Validate all inputs

**Bonus Features**:
- Use variables for library info
- Format output nicely
- Handle multiple searches in one run
- Show search history

**Starter Code**:
```bash
#!/bin/bash

# Validate library ID
if [ $# -lt 1 ]; then
    echo "Usage: $0 <library_id>"
    exit 1
fi

library_id="$1"
search_count=0

echo "=== Library Search System ==="

# Main search loop
while true; do
    read -p "Search by (title/author/year): " search_type
    read -p "Enter search query: " query
    
    search_count=$(( search_count + 1 ))
    
    echo "Searching library $library_id for $search_type: '$query'"
    echo ""
    
    read -p "Search again? (yes/no): " continue_search
    
    if [ "$continue_search" != "yes" ]; then
        break
    fi
done

echo ""
echo "Total searches performed: $search_count"
```

---

## Completion Checklist

- [ ] Exercise 2.1: Personal Information ✓
- [ ] Exercise 2.2: Calculator ✓
- [ ] Exercise 2.3: Command-Line Arguments ✓
- [ ] Exercise 2.4: Interactive Registration ✓
- [ ] Exercise 2.5: Combined Arguments + Input ✓
- [ ] Challenge Exercise (Optional) ✓

---

## Testing Tips

Test your scripts thoroughly:

```bash
# Test with no arguments (should fail)
./exercise-2-3.sh

# Test with different inputs
./exercise-2-3.sh arg1
./exercise-2-3.sh arg1 arg2 arg3

# Test user input with different values
./exercise-2-4.sh
# Try entering: Alice, alice@example.com, 25, New York

# Test with special characters and spaces
./exercise-2-5.sh "My Library"
```

---

## Common Issues

| Problem | Solution |
|---------|----------|
| Script not executable | Run `chmod +x script.sh` |
| Variables not working | Remember `$` when using variables |
| Arguments empty | Check script is called with arguments |
| Input not reading | Make sure to use `read -p "Prompt: " var` |

---

## Next Steps

Once you've completed all exercises:

1. ✅ Review your solutions
2. ✅ Compare with provided solutions
3. ✅ Modify exercises to add new features
4. ✅ Move to **Topic 3: Control Flow**

---

**Difficulty**: ⭐⭐ (Easy - Building on Basics)

**Time to Complete**: 45-60 minutes

**When Ready**: [Go to Topic 3 →](../topics/03-control-flow.md)
