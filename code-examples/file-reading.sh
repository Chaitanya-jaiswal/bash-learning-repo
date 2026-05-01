#!/bin/bash
# File Reading Example
# Demonstrates different ways to read files

echo "=== File Reading Examples ==="
echo ""

# Create a sample file
cat > sample.txt << EOF
1984,George Orwell,1949
Alice in Wonderland,Lewis Carroll,1865
The Great Gatsby,F. Scott Fitzgerald,1925
Brave New World,Aldous Huxley,1932
EOF

echo "--- Method 1: Read entire file with cat ---"
cat sample.txt

echo ""
echo "--- Method 2: Read line by line ---"
while IFS= read -r line; do
    echo "Line: $line"
done < sample.txt

echo ""
echo "--- Method 3: Read CSV and parse ---"
while IFS=',' read -r title author year; do
    echo "Book: $title by $author ($year)"
done < sample.txt

echo ""
echo "--- Method 4: Show first 2 lines ---"
head -2 sample.txt

echo ""
echo "--- Method 5: Show last 2 lines ---"
tail -2 sample.txt

echo ""
echo "--- Method 6: Count lines ---"
echo "Total lines: $(wc -l < sample.txt)"

# Clean up
rm sample.txt
