#!/bin/bash

# Write text to a file
echo "This is some text to write to the file...and cp somewhere else #^!&" > firsttext.txt

# Copy content of one file to another
cp firsttext.txt secondtext.txt

# Filter content of a file
file_name="firsttext.txt"

num_lines=$(wc -l < "$file_name")
num_dots=$(grep -o '\.' "$file_name" | wc -l)
num_words_starting_with_xyz=$(grep -o -w 'cifw\w*' "$file_name" | wc -l)
special_char=$(expr length "${text//[^\~!@#$&*()]/}")

# Count special characters
num_special_characters=$(tr -dc '~!@#$&*()' < "$file_name" | wc -c)

# Uppercase the content and save to a new file
uppercase_content=$(cat "$file_name" | tr 'a-z' 'A-Z')
echo "$uppercase_content" > uppercase_text.txt

# Calculate the average word length
total_words=$(wc -w < "$file_name")
total_word_length=$(grep -o -E '\w+' "$file_name" | awk '{ sum += length } END { print sum }')
average_word_length=$((total_word_length / total_words))

# Redirect the output to a file
{
    echo "Number of lines: $num_lines"
    echo "Number of dots: $num_dots"
    echo "Number of words starting with 'cifw': $num_words_starting_with_xyz"
    echo "Number of special characters: $num_special_characters"
    echo "Average word length: $average_word_length"
} > filtered_results.txt
