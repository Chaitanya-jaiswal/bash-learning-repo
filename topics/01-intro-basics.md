# Topic 1: Introduction to Bash & Basic Syntax

**Status**: ✅ Ready to Learn  
**Duration**: 1-2 hours  
**Prerequisites**: Basic terminal familiarity  
**Next Topic**: [Topic 2: Variables and User Input](02-variables.md)

---

## Table of Contents

- [What is Bash?](#what-is-bash)
- [Why Learn Bash?](#why-learn-bash)
- [Creating Your First Script](#creating-your-first-script)
- [Key Concepts](#key-concepts)
- [Common Commands](#common-commands)
- [Practice Exercises](#practice-exercises)
- [Common Pitfalls](#common-pitfalls)
- [Summary](#summary)

---

## What is Bash?

**Bash** stands for **Bourne Again Shell**. It's a command-line interpreter that processes commands you type and executes them on your system.

### Shell vs Script

| Term | Definition | Example |
|------|-----------|---------|
| **Shell** | Interactive command-line interpreter | You type commands one at a time |
| **Script** | File containing multiple commands | A `.sh` file with commands |
| **Bash** | Both a shell and a scripting language | Ubuntu's default shell |

### How Bash Works

```
You type a command → Bash interprets it → System executes it → Shows output
```

When you use a Bash **script**, the commands run automatically one after another, which is much more powerful than typing them individually.

---

## Why Learn Bash?

For your **Library System Project**, you need Bash to write:

1. **bootstrap.sh** - Initialize the library system with N libraries
2. **user.sh** - User interface to interact with libraries  
3. **manage.sh** - Management and monitoring scripts

Bash is perfect because it:
- ✅ Integrates easily with C programs
- ✅ Handles file operations naturally
- ✅ Manages processes and IPC
- ✅ Already installed on all Linux systems
- ✅ Lightweight and fast

---

## Creating Your First Script

### Step 1: Create a File

Open your terminal and create a new file:

```bash
touch hello.sh
```

Or use a text editor directly:

```bash
nano hello.sh
```

### Step 2: Add the Shebang

The first line of every Bash script must be the **shebang**:

```bash
#!/bin/bash
```

This tells the system: "Run this file using the Bash interpreter"

### Step 3: Add Your First Command

The `echo` command prints text to the terminal:

```bash
#!/bin/bash
echo "Hello, World!"
```

### Step 4: Make It Executable

Files need permission to be executed:

```bash
chmod +x hello.sh
```

The `chmod` command means "change mode" - we're adding execute permission (`+x`).

### Step 5: Run Your Script

```bash
./hello.sh
```

**Output:**
```
Hello, World!
```

Congratulations! You've written your first Bash script! 🎉

---

## Key Concepts

### 1. The Shebang (`#!/bin/bash`)

| Aspect | Details |
|--------|---------|
| **Name** | Shebang (or hashbang) |
| **What it does** | Tells system which interpreter to use |
| **Must be** | First line of the script |
| **Example** | `#!/bin/bash` |
| **Other examples** | `#!/bin/sh`, `#!/usr/bin/python3` |

### 2. Comments (`#`)

Comments explain your code and are ignored by Bash:

```bash
#!/bin/bash
# This is a comment
echo "Hello"  # End-of-line comment
# This line below prints a greeting
echo "How are you?"
```

**Best Practice**: Comment your code liberally!

### 3. The echo Command

`echo` prints text to the terminal:

```bash
# Basic echo
echo "Hello, World!"

# Echo with multiple words
echo "The current date is:" $(date)

# Echo with newlines (default adds one)
echo "Line 1"
echo "Line 2"
```

### 4. File Permissions

Bash scripts need **execute permission** to run:

```bash
# Add execute permission for everyone
chmod +x script.sh

# Show file permissions
ls -l script.sh

# Output example:
# -rwxr-xr-x user group 123 Apr 28 10:00 script.sh
# ^^^ execute permission added
```

### 5. Running Scripts

There are different ways to run a script:

```bash
# Most common: run with ./ when in same directory
./hello.sh

# Run from anywhere with full path
/home/user/hello.sh

# Run with bash explicitly (don't need chmod +x)
bash hello.sh

# Run with sh (less features, but more portable)
sh hello.sh
```

---

## Common Commands

Here are essential commands you'll use in Bash scripts:

### Output Commands

```bash
echo "Text"        # Print text with newline
echo -n "Text"     # Print without newline
printf "Text %s\n" # Formatted print
```

### File Commands

```bash
touch file.txt     # Create empty file
cat file.txt       # Display file contents
ls -la             # List files with details
mkdir dirname      # Create directory
rm file.txt        # Remove file (CAREFUL!)
cp file1 file2     # Copy file
mv file1 file2     # Move/rename file
```

### System Commands

```bash
pwd                # Print working directory
cd dirname         # Change directory
whoami             # Show current user
date               # Show current date/time
sleep 2            # Wait 2 seconds
exit 0             # Exit script (0 = success)
```

### Advanced (You'll use later)

```bash
grep "pattern" file    # Search in file
sed 's/old/new/' file  # Replace text
awk '{print $1}' file  # Process columns
pipe: cmd1 | cmd2      # Connect commands
```

---

## Practice Exercises

### Exercise 1.1: Hello Script

**Goal**: Create a script that prints your name

**Steps**:
1. Create file: `touch exercise1_1.sh`
2. Add shebang and echo statement
3. Make executable: `chmod +x exercise1_1.sh`
4. Run it: `./exercise1_1.sh`

**Solution**:
```bash
#!/bin/bash
echo "My name is John"
```

**Expected Output**:
```
My name is John
```

---

### Exercise 1.2: Multi-line Script

**Goal**: Create a script that prints 3 different lines

**Steps**:
1. Create the file
2. Add multiple echo statements
3. Make it executable
4. Run it

**Solution**:
```bash
#!/bin/bash
echo "Line 1: I am learning Bash"
echo "Line 2: This is fun"
echo "Line 3: I will master this"
```

**Expected Output**:
```
Line 1: I am learning Bash
Line 2: This is fun
Line 3: I will master this
```

---

### Exercise 1.3: Script with Comments

**Goal**: Create a script with helpful comments explaining each line

**Solution**:
```bash
#!/bin/bash
# My first commented script
# Author: [Your Name]
# Date: 2026-04-28

# Print a greeting message
echo "Welcome to Bash Programming!"

# Print a separator
echo "---"

# Print information
echo "This script demonstrates the use of comments"
```

**Expected Output**:
```
Welcome to Bash Programming!
---
This script demonstrates the use of comments
```

---

### Exercise 1.4: Directory and File Operations

**Goal**: Create a script that creates a directory and a file

**Solution**:
```bash
#!/bin/bash
# Create a project directory
mkdir -p my_project

# Create a file in that directory
touch my_project/notes.txt

# List what we created
echo "Created directory: my_project"
echo "Created file: my_project/notes.txt"
```

---

### Exercise 1.5: Using System Commands

**Goal**: Create a script that shows your system info

**Solution**:
```bash
#!/bin/bash
# System information script

echo "=== System Information ==="
echo "Current user: $(whoami)"
echo "Current directory: $(pwd)"
echo "Current date: $(date)"
echo "Files in this directory:"
ls -1
```

---

## Common Pitfalls

### ❌ Pitfall 1: Forgetting the Shebang

**Wrong**:
```bash
echo "Hello"
```

**Right**:
```bash
#!/bin/bash
echo "Hello"
```

**Why**: Without the shebang, the system might not know to use Bash.

---

### ❌ Pitfall 2: Not Making Script Executable

**Problem**: You run `./hello.sh` and get:
```
bash: ./hello.sh: Permission denied
```

**Solution**:
```bash
chmod +x hello.sh
```

---

### ❌ Pitfall 3: Spaces in Commands

**Wrong**:
```bash
echo"Hello"    # No space after echo - won't work
```

**Right**:
```bash
echo "Hello"   # Space after echo
```

---

### ❌ Pitfall 4: Using Wrong Quotes

**Wrong**:
```bash
echo 'Hello, $USER'   # Single quotes don't expand variables
```

**Right**:
```bash
echo "Hello, $USER"   # Double quotes allow expansion
```

(Don't worry about variables yet - you'll learn this in Topic 2)

---

### ❌ Pitfall 5: Forgetting Newlines in Output

```bash
echo -n "No newline"
echo "Yes newline"
```

**Output**:
```
No newlineYes newline    # First part has no newline!
```

---

## Summary

### What You Learned

| Concept | Key Points |
|---------|-----------|
| **Bash** | Command-line interpreter and scripting language |
| **Shebang** | `#!/bin/bash` on first line |
| **echo** | Print text to terminal |
| **chmod** | Change file permissions (add `+x` for execute) |
| **Running scripts** | Use `./script.sh` or `bash script.sh` |
| **Comments** | Use `#` to document your code |
| **Path** | Use `./` to run script in current directory |

### You Can Now

✅ Create a basic Bash script  
✅ Use the echo command  
✅ Make scripts executable  
✅ Add comments to explain code  
✅ Run scripts from the terminal  

### Next Steps

Once you've completed all exercises above, you're ready for:

**[Topic 2: Variables and User Input](02-variables.md)**

Where you'll learn:
- Creating and using variables
- Reading command-line arguments
- Getting user input
- Storing and modifying data

---

## Quick Reference

```bash
#!/bin/bash                    # Shebang (required)
# This is a comment            # Comments
echo "Hello, World!"           # Print text
chmod +x script.sh             # Make executable
./script.sh                    # Run script
bash script.sh                 # Run with bash
```

---

**Ready to move on?** Go to [Topic 2: Variables and User Input](02-variables.md) 🚀
