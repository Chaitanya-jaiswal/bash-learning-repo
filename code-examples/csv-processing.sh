#!/bin/bash
# CSV Processing Example
# Demonstrates working with CSV files (like books.csv for your project)

echo "=== CSV Processing for Library Catalog ==="
echo ""

# Create sample books.csv
cat > books.csv << EOF
1984,George Orwell,1949
Alice in Wonderland,Lewis Carroll,1865
The Great Gatsby,F. Scott Fitzgerald,1925
Brave New World,Aldous Huxley,1932
The Hobbit,J.R.R. Tolkien,1937
To Kill a Mockingbird,Harper Lee,1960
Pride and Prejudice,Jane Austen,1813
EOF

echo "Books catalog (books.csv):"
cat books.csv
echo ""

# Function to search books
search_books() {
    local search_term=$1
    echo "=== Search Results for: $search_term ==="
    grep -i "$search_term" books.csv || echo "No results found"
}

# Function to list books by year range
books_by_year_range() {
    local start=$1
    local end=$2
    echo "=== Books from $start to $end ==="
    awk -F',' -v start="$start" -v end="$end" \
        '$3 >= start && $3 <= end {print $1, "(" $3 ")"}' books.csv
}

# Function to get all authors
list_authors() {
    echo "=== All Authors ==="
    cut -d',' -f2 books.csv | sort
}

# Function to count total books
count_books() {
    local count=$(wc -l < books.csv)
    echo "Total books in catalog: $count"
}

# Function to get book details
book_details() {
    local title=$1
    echo "=== Book Details ==="
    grep -i "$title" books.csv | while IFS=',' read -r name author year; do
        echo "Title: $name"
        echo "Author: $author"
        echo "Year: $year"
    done
}

# Use the functions
count_books
echo ""

search_books "Austen"
echo ""

books_by_year_range 1900 1970
echo ""

list_authors
echo ""

book_details "1984"
echo ""

# Generate report
echo "=== Library Report ==="
echo "Total books: $(wc -l < books.csv)"
echo "Oldest book: $(awk -F',' '{print $3}' books.csv | sort -n | head -1)"
echo "Newest book: $(awk -F',' '{print $3}' books.csv | sort -n | tail -1)"

# Create output file with filtered data
echo ""
echo "=== Creating filtered catalog (modern books) ==="
awk -F',' '$3 >= 1900 {print}' books.csv > modern_books.csv
echo "Modern books (1900+) saved to modern_books.csv:"
cat modern_books.csv

# Clean up
rm books.csv modern_books.csv
