#!/usr/bin/env bash
set -eu

cp -r /var/doc/* .

INTERMEDIATE_MD_FILENAME='complete_markdown.md'
PDF_FILE_NAME='built_file.pdf'

# Add new line to every file if missing
for file in *.md
do
    x=`tail -n 1 "$file"`
    if [ "$x" != "" ]; then echo "" >> $file; fi
done

# Merge files
find . -maxdepth 1 -type f -name "[0-9]*.md" | sort -V | xargs cat > $INTERMEDIATE_MD_FILENAME

# replace all includes to have absolute path, because PDF generation doesn't resolve the relative paths
/var/relative_to_absolute_path.py

# Generate PDF
pandoc -s --pdf-engine xelatex --filter=pandoc-plantuml --from=markdown $INTERMEDIATE_MD_FILENAME --output=$PDF_FILE_NAME

mv $PDF_FILE_NAME ../doc
