#!/bin/bash
# Text Processing Example
# Demonstrates grep, sed, awk, and pipes

echo "=== Text Processing Examples ==="
echo ""

# Create sample CSV file
cat > books.csv << EOF
Title,Author,Year
1984,George Orwell,1949
Alice in Wonderland,Lewis Carroll,1865
The Great Gatsby,F. Scott Fitzgerald,1925
Brave New World,Aldous Huxley,1932
The Hobbit,J.R.R. Tolkien,1937
EOF

echo "Original file:"
cat books.csv
echo ""

# grep examples
echo "--- grep: Find books with 'Alice' ---"
grep "Alice" books.csv

echo ""
echo "--- grep: Books published after 1900 (contains 19[2-9]) ---"
grep "19[2-9]" books.csv

echo ""
echo "--- grep: Count matching lines ---"
echo "Books by Tolkien: $(grep -c "Tolkien" books.csv)"

# sed examples
echo ""
echo "--- sed: Replace author names ---"
sed 's/George Orwell/G. Orwell/g' books.csv

echo ""
echo "--- sed: Show only titles and years ---"
sed '1d; s/,.*,/,/' books.csv | cut -d',' -f1,3

# awk examples
echo ""
echo "--- awk: Extract just titles ---"
awk -F',' 'NR > 1 {print $1}' books.csv

echo ""
echo "--- awk: Count books by century ---"
awk -F',' 'NR > 1 {
    year = $3
    if (year < 1900) century = "1800s"
    else century = "1900s"
    count[century]++
}
END {
    for (c in count) print c ": " count[c]
}' books.csv

# Pipe examples
echo ""
echo "--- Pipes: Count lines with word 'the' ---"
grep -i "the" books.csv | wc -l

echo ""
echo "--- Pipes: Find and show first book ---"
grep "Carroll" books.csv | cut -d',' -f1-2

# Complex example
echo ""
echo "--- Complex: List books, sorted by year ---"
tail -n +2 books.csv | sort -t',' -k3 -n | cut -d',' -f1,3

# Clean up
rm books.csv
