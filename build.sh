#!/bin/sh

INTERMEDIATE_MD_FILENAME='complete_markdown.md'
PDF_FILE_NAME='built_file.pdf'
BASE_DIR=$(pwd)

cleanup() {
    rm $INTERMEDIATE_MD_FILENAME 2> /dev/null || true
    rm -r $BASE_DIR/plantuml-images/ 2> /dev/null || true
    rm -r $BASE_DIR/tex* 2> /dev/null || true
}

cleanup

for file in *.md
do
    x=`tail -n 1 $file`
    if [ "$x" != "" ]; then echo "" >> $file; fi
done

find . -maxdepth 1 -type f -name "[0-9]*.md" | sort -V | xargs cat > $INTERMEDIATE_MD_FILENAME

# replace all includes to have absolute path, because PDF generation doesn't resolve the relative paths
sed -i -e "s|!include .|!include ${BASE_DIR}|g" $INTERMEDIATE_MD_FILENAME

pandoc -s --pdf-engine xelatex --filter=pandoc-plantuml --from=markdown $INTERMEDIATE_MD_FILENAME --output=$PDF_FILE_NAME

cleanup
