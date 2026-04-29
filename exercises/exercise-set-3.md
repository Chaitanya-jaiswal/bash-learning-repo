# Exercise Set 3: Control Flow (if/else, loops)

**Topic**: Control Flow (if/else, loops)  
**Difficulty**: ⭐⭐ (Easy-Intermediate)  
**Time**: 60-90 minutes  
**Prerequisites**: Complete [Topic 2](../topics/02-variables.md) and read [Topic 3](../topics/03-control-flow.md)

---

## Instructions

1. **Create a new directory**:
   ```bash
   mkdir -p ~/bash-exercises/set-3
   cd ~/bash-exercises/set-3
   ```

2. **For each exercise**:
   - Read the description
   - Write your script
   - Test it with different inputs
   - Compare with solution

3. **Test thoroughly** with edge cases!

---

## Exercise 3.1: Age Validator

**Description**: Check if user is an adult based on age input.

**Requirements**:
- Accept age as argument
- Check if age >= 18
- Display appropriate message
- Handle invalid input

**Test cases**:
```bash
./exercise-3-1.sh 25  # Adult
./exercise-3-1.sh 15  # Minor
./exercise-3-1.sh     # No argument
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Age Validator Script

if [ $# -eq 0 ]; then
    echo "ERROR: Age required!"
    echo "Usage: $0 <age>"
    exit 1
fi

age=$1

# Validate age is a number
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Age must be a number!"
    exit 1
fi

# Check age range
if [ $age -lt 0 ] || [ $age -gt 120 ]; then
    echo "ERROR: Invalid age!"
    exit 1
fi

# Determine age group
if [ $age -ge 18 ]; then
    echo "You are an adult"
else
    echo "You are a minor"
fi
```

</details>

---

## Exercise 3.2: Number Comparison

**Description**: Compare two numbers and determine which is larger.

**Requirements**:
- Accept two numbers as arguments
- Compare them (equal, greater, less)
- Display result with proper message
- Handle missing arguments

**Test cases**:
```bash
./exercise-3-2.sh 10 20   # 20 is larger
./exercise-3-2.sh 30 15   # 30 is larger
./exercise-3-2.sh 5 5     # Equal
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Number Comparison Script

if [ $# -lt 2 ]; then
    echo "ERROR: Two numbers required!"
    echo "Usage: $0 <num1> <num2>"
    exit 1
fi

num1=$1
num2=$2

# Validate both are numbers
if ! [[ "$num1" =~ ^[0-9]+$ ]] || ! [[ "$num2" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Both arguments must be numbers!"
    exit 1
fi

echo "Comparing: $num1 and $num2"

if [ $num1 -eq $num2 ]; then
    echo "They are EQUAL"
elif [ $num1 -gt $num2 ]; then
    echo "$num1 is GREATER than $num2"
else
    echo "$num2 is GREATER than $num1"
fi
```

</details>

---

## Exercise 3.3: String Validation

**Description**: Check if user is registered and book is available.

**Requirements**:
- Use logical operators (&&, ||)
- Check multiple conditions
- Display clear messages
- Use user input

**Test case**:
```bash
./exercise-3-3.sh
# Provide: yes/no for each prompt
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Book Borrowing Validator

echo "=== Book Borrowing System ==="
echo ""

read -p "Is book available? (yes/no): " available
read -p "Are you registered? (yes/no): " registered
read -p "Do you already have a borrowed book? (yes/no): " already_borrowed

if [ "$available" = "yes" ] && [ "$registered" = "yes" ] && [ "$already_borrowed" = "no" ]; then
    echo ""
    echo "✓ SUCCESS: You can borrow this book!"
else
    echo ""
    echo "✗ CANNOT BORROW: "
    
    if [ "$available" != "yes" ]; then
        echo "  - Book is not available"
    fi
    
    if [ "$registered" != "yes" ]; then
        echo "  - You are not registered"
    fi
    
    if [ "$already_borrowed" = "yes" ]; then
        echo "  - You already have a borrowed book"
    fi
fi
```

</details>

---

## Exercise 3.4: Simple Menu (case statement)

**Description**: Create a menu system for library operations.

**Requirements**:
- Display menu options
- Accept user choice
- Use case statement
- Handle each option
- Handle invalid input

**Test case**:
```bash
./exercise-3-4.sh
# Choose options 1-5
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Library Menu System

while true; do
    echo ""
    echo "=== Library Operations ==="
    echo "1. Search for book"
    echo "2. Borrow book"
    echo "3. Return book"
    echo "4. View catalog"
    echo "5. Exit"
    echo ""
    
    read -p "Choose operation (1-5): " choice
    
    case $choice in
        1)
            read -p "Search for: " query
            echo "Searching for: $query"
            ;;
        2)
            read -p "Book title: " title
            read -p "Your username: " user
            echo "✓ '$title' borrowed by $user"
            ;;
        3)
            read -p "Book title: " title
            echo "✓ '$title' returned successfully"
            ;;
        4)
            echo "Catalog:"
            echo "- 1984"
            echo "- Alice in Wonderland"
            echo "- The Great Gatsby"
            ;;
        5)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option! Please choose 1-5"
            ;;
    esac
done
```

</details>

---

## Exercise 3.5: for Loop - List Processing

**Description**: Loop through a list of books and number them.

**Requirements**:
- Create array of books
- Loop with for
- Display with numbers
- Accept book name as argument to search

**Test case**:
```bash
./exercise-3-5.sh
# Or with argument:
./exercise-3-5.sh "1984"
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Book Catalog Listing

books=("1984" "Alice in Wonderland" "The Great Gatsby" "Brave New World" "To Kill a Mockingbird")

echo "=== Library Catalog ==="
echo ""

if [ $# -gt 0 ]; then
    # Search mode
    search_term="$1"
    echo "Searching for: $search_term"
    echo ""
    
    found=false
    count=1
    
    for book in "${books[@]}"; do
        if [[ "$book" == *"$search_term"* ]]; then
            echo "$count. $book"
            found=true
            count=$(( count + 1 ))
        fi
    done
    
    if [ "$found" = false ]; then
        echo "No books found matching: $search_term"
    fi
else
    # Display all
    count=1
    for book in "${books[@]}"; do
        echo "$count. $book"
        count=$(( count + 1 ))
    done
fi
```

</details>

---

## Exercise 3.6: while Loop - User Input

**Description**: Keep asking user for book titles until they quit.

**Requirements**:
- Use while true loop
- Accept input until user types "quit"
- Count total entries
- Show summary

**Test case**:
```bash
./exercise-3-6.sh
# Enter: 1984
# Enter: Alice
# Enter: quit
```

<details>
<summary>✅ Click to reveal solution</summary>

```bash
#!/bin/bash
# Book Collection Builder

echo "=== Add Books to Collection ==="
echo "(Type 'quit' to finish)"
echo ""

books=()
count=0

while true; do
    read -p "Enter book title: " title
    
    if [ "$title" = "quit" ]; then
        break
    fi
    
    if [ -z "$title" ]; then
        echo "Please enter a book title"
        continue
    fi
    
    books+=("$title")
    count=$(( count + 1 ))
    echo "✓ Added: $title"
    echo ""
done

echo ""
echo "=== Your Books ==="
echo "Total books: $count"
echo ""

if [ $count -gt 0 ]; then
    num=1
    for book in "${books[@]}"; do
        echo "$num. $book"
        num=$(( num + 1 ))
    done
else
    echo "No books added"
fi
```

</details>

---

## Challenge Exercise: Library Management System

**Description**: Create an interactive library system combining if/else, case, and loops.

**Requirements**:
- Main menu with options (case statement)
- Search books (for loop through catalog)
- Borrow book (check conditions with if/else)
- Manage borrowed books (while loop for interaction)
- Keep running until user quits

**Features**:
- Menu-driven interface
- Book availability checking
- User registration validation
- Borrowed books tracking

**Starter Code**:
```bash
#!/bin/bash

# Catalog
catalog=("1984" "Alice in Wonderland" "The Great Gatsby" "Brave New World")
borrowed=()
users=()

# Main loop
while true; do
    echo ""
    echo "=== Library Management System ==="
    echo "1. Search books"
    echo "2. Register user"
    echo "3. Borrow book"
    echo "4. View borrowed"
    echo "5. Quit"
    echo ""
    
    read -p "Choose option: " choice
    
    case $choice in
        1)
            echo ""
            echo "--- Search Books ---"
            echo "Books in catalog:"
            num=1
            for book in "${catalog[@]}"; do
                echo "$num. $book"
                num=$(( num + 1 ))
            done
            ;;
        2)
            echo ""
            echo "--- Register User ---"
            read -p "Enter username: " username
            
            # Check if already registered
            registered=false
            for user in "${users[@]}"; do
                if [ "$user" = "$username" ]; then
                    registered=true
                fi
            done
            
            if [ "$registered" = "true" ]; then
                echo "✗ User already registered"
            else
                users+=("$username")
                echo "✓ User $username registered"
            fi
            ;;
        3)
            # Borrow book logic
            read -p "Enter book title: " book_title
            echo "Borrowing: $book_title"
            borrowed+=("$book_title")
            ;;
        4)
            echo ""
            echo "--- Borrowed Books ---"
            if [ ${#borrowed[@]} -eq 0 ]; then
                echo "No books borrowed"
            else
                for book in "${borrowed[@]}"; do
                    echo "- $book"
                done
            fi
            ;;
        5)
            echo "Thank you for using the library!"
            exit 0
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
done
```

---

## Completion Checklist

- [ ] Exercise 3.1: Age Validator ✓
- [ ] Exercise 3.2: Number Comparison ✓
- [ ] Exercise 3.3: String Validation ✓
- [ ] Exercise 3.4: Simple Menu ✓
- [ ] Exercise 3.5: for Loop ✓
- [ ] Exercise 3.6: while Loop ✓
- [ ] Challenge Exercise (Optional) ✓

---

## Testing Tips

Test edge cases:

```bash
# Invalid input
./exercise-3-1.sh abc
./exercise-3-1.sh -5

# Boundary values
./exercise-3-1.sh 0
./exercise-3-1.sh 18
./exercise-3-1.sh 120

# Empty input
./exercise-3-1.sh ""
```

---

## Next Steps

Once completed:
1. Review solutions
2. Try modifying exercises (add features, change logic)
3. Combine concepts (if/else + for loops, etc.)
4. Move to **Topic 4: Functions**

---

**Difficulty**: ⭐⭐ (Easy-Intermediate)

**Time**: 60-90 minutes

**When Ready**: [Go to Topic 4 →](../topics/04-functions.md)
