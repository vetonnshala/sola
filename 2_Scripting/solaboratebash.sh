#!/bin/bash

# Write text to a file
echo "Hello, this is some text to write to the file...and cp somewhere else" > firsttext.txt

# Copy content of one file to another
cp firsttext.txt secondtext.txt

# Filter content of a file
file_name="firsttext.txt"

num_lines=$(wc -l < "$file_name")
num_dots=$(grep -o '\.' "$file_name" | wc -l)
num_words_starting_with_xyz=$(grep -o -w 'cifw\w*' "$file_name" | wc -l)
special_char=$(expr length "${text//[^\~!@#$&*()]/}")


# Redirect the output to a file
{
    echo "Number of lines: $num_lines"
    echo "Number of dots: $num_dots"
    echo "Number of words starting with 'cifw': $num_words_starting_with_xyz"
} > filtered_results.txt

