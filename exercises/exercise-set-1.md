# Exercise Set 1: Introduction to Bash

**Topic**: Introduction to Bash & Basic Syntax  
**Difficulty**: Beginner  
**Time**: 30-45 minutes  

---

## Instructions

1. **Create a new directory** for your exercises:
   ```bash
   mkdir -p ~/bash-exercises/set-1
   cd ~/bash-exercises/set-1
   ```

2. **For each exercise**:
   - Read the description
   - Write your script
   - Make it executable: `chmod +x script.sh`
   - Run and test it
   - Compare with the solution

3. **When finished**, mark exercises as complete below

---

## Exercise 1.1: Basic Greeting

**Description**: Create a script that prints a greeting with your name.

**Requirements**:
- Must have shebang
- Must use echo at least once
- Must be executable

**Example Output**:
```
Hello! My name is [Your Name]
```

**Test it**:
```bash
./exercise-1-1.sh
```

**Solution Template**:
```bash
#!/bin/bash
# Your greeting script

echo "Hello! My name is [Your Name]"
```

<details>
<summary>✅ Click to reveal full solution</summary>

```bash
#!/bin/bash
# A simple greeting script
# Author: [Your Name]

echo "Hello! My name is Alice"
```

</details>

---

## Exercise 1.2: Multiple Lines with Comments

**Description**: Create a script that prints 5 lines about yourself, with a comment for each line.

**Requirements**:
- At least 5 echo statements
- At least 5 comments
- Demonstrates understanding of comments

**Example Output**:
```
I am learning Bash
I am at [location]
Today is [day]
I enjoy programming
I will complete this project!
```

**Solution Template**:
```bash
#!/bin/bash
# Multiple lines about me

# First line about learning
echo "I am learning Bash"

# Add 4 more lines with comments...
```

<details>
<summary>✅ Click to reveal full solution</summary>

```bash
#!/bin/bash
# Tell the world about myself
# Date: April 28, 2026

# My learning goal
echo "I am learning Bash"

# My location
echo "I am studying Operating Systems"

# Current activity
echo "I am working on a Library System project"

# My feeling
echo "This is challenging but fun"

# My commitment
echo "I will complete this project!"
```

</details>

---

## Exercise 1.3: System Information Display

**Description**: Create a script that displays your system information in a formatted way.

**Requirements**:
- Show at least 3 system commands (whoami, pwd, date, etc.)
- Use nice formatting with separators
- Use at least 2 comments

**Example Output**:
```
=== My System Information ===
User: alice
Working Directory: /home/alice/bash-exercises
Date: Thu Apr 28 14:25:30 UTC 2026
===========================
```

**Solution Template**:
```bash
#!/bin/bash
# Show system information

echo "=== My System Information ==="
# Show username
echo "User: $(whoami)"

# Show current directory
echo "Working Directory: $(pwd)"

# Show date
echo "Date: $(date)"

echo "==========================="
```

<details>
<summary>✅ Click to reveal full solution</summary>

```bash
#!/bin/bash
# Display system information
# This script shows basic system details

echo "=== My System Information ==="
# Display the current username
echo "User: $(whoami)"

# Display the working directory
echo "Working Directory: $(pwd)"

# Display the current date and time
echo "Date: $(date)"

# Display hostname
echo "Hostname: $(hostname)"

echo "==========================="
```

</details>

---

## Exercise 1.4: File Operations

**Description**: Create a script that creates a directory and files.

**Requirements**:
- Create a directory using mkdir
- Create files using touch
- Show what was created with ls or echo

**Example Output**:
```
Created project structure:
- my_library_project/
- my_library_project/src/
- my_library_project/src/main.c
- my_library_project/README.md
```

**Solution Template**:
```bash
#!/bin/bash
# Create a project directory structure

# Create directories
mkdir -p my_library_project/src

# Create files
touch my_library_project/README.md
touch my_library_project/src/main.c

# Show what we created
echo "Created project structure:"
ls -la my_library_project/
```

<details>
<summary>✅ Click to reveal full solution</summary>

```bash
#!/bin/bash
# Create a project directory structure
# This demonstrates mkdir and touch

# Create the main project directory and subdirectory
mkdir -p my_library_project/src
mkdir -p my_library_project/include
mkdir -p my_library_project/data

# Create necessary files
touch my_library_project/README.md
touch my_library_project/Makefile
touch my_library_project/src/main.c
touch my_library_project/include/header.h
touch my_library_project/data/books.csv

# Display what was created
echo "Created project structure:"
ls -la my_library_project/
echo ""
echo "File structure:"
find my_library_project -type f
```

</details>

---

## Exercise 1.5: Commented Complex Script

**Description**: Write a script that does multiple things, fully commented.

**Requirements**:
- At least 10 lines of code
- At least 8 comments
- Multiple different commands
- Clear section headers in comments

**Example Operations**:
- Show date
- Create files
- List files
- Show current user
- Clean up (optional)

**Solution Template**:
```bash
#!/bin/bash
# A more complex script with many comments
# This demonstrates multiple operations

# ========== SECTION 1: Show Information ==========
# Display the current user
echo "User: $(whoami)"

# Display the current date
echo "Date: $(date)"

# ========== SECTION 2: Create Files ==========
# Create a new directory
mkdir -p test_directory

# Create files in the directory
touch test_directory/file1.txt
touch test_directory/file2.txt

# ========== SECTION 3: Verify ==========
# Show what was created
echo "Files created:"
ls -l test_directory/
```

<details>
<summary>✅ Click to reveal full solution</summary>

```bash
#!/bin/bash
# Complete Script Example
# This script demonstrates multiple operations
# with clear comments throughout

# ===== SECTION 1: Display System Information =====
# Print a header
echo "========== System Information =========="

# Show the current user running the script
echo "Current User: $(whoami)"

# Show the current working directory
echo "Working Directory: $(pwd)"

# Show the current date and time
echo "Date & Time: $(date)"

# Show the hostname
echo "Hostname: $(hostname)"

# ===== SECTION 2: Create Project Structure =====
echo ""
echo "========== Creating Project Files =========="

# Create the main project directory
mkdir -p bash_project

# Create subdirectories for organization
mkdir -p bash_project/scripts
mkdir -p bash_project/data
mkdir -p bash_project/output

# Create initial files
touch bash_project/README.md
touch bash_project/scripts/main.sh
touch bash_project/data/input.txt
touch bash_project/output/results.txt

# Print confirmation message
echo "Project structure created successfully!"

# ===== SECTION 3: Display Created Files =====
echo ""
echo "========== Project Structure =========="

# List the contents of the project directory
ls -la bash_project/

# Show the full directory tree
echo ""
echo "Full directory structure:"
find bash_project -type f
```

</details>

---

## Challenge Exercise (Optional)

**Description**: Create a script that creates a template for your Library System project.

**Requirements**:
- Create directories: `code`, `report`, `data`
- Create files: `bootstrap.sh`, `user.sh`, `library.c`, `manage.sh`
- Create a `books.csv` file with sample data
- Display the created structure

**Bonus Points**:
- Add comments explaining each part
- Use proper directory structure
- Make scripts executable in your script

**Example Output**:
```
Creating Library System project structure...
✓ Directories created
✓ Script files created  
✓ Data files created

Project ready for implementation!
```

---

## Completion Checklist

- [ ] Exercise 1.1: Basic Greeting ✓
- [ ] Exercise 1.2: Multiple Lines ✓
- [ ] Exercise 1.3: System Information ✓
- [ ] Exercise 1.4: File Operations ✓
- [ ] Exercise 1.5: Complex Script ✓
- [ ] Challenge Exercise (Optional) ✓

---

## Next Steps

Once you've completed all exercises:

1. ✅ Review solutions and compare with yours
2. ✅ Make sure you understand each concept
3. ✅ Ask questions if anything is unclear
4. ✅ Move to **Topic 2: Variables and User Input**

---

**Difficulty**: ⭐ (Very Easy - Building Foundations)

**Time to Complete**: 30-45 minutes

**When Ready**: [Go to Topic 2 →](../topics/02-variables.md)
