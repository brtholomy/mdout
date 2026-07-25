echo pandoc filter, unzip, replace styles.xml, zip
pandoc 1786.mozi.md -o output.docx --lua-filter=mdout/filter.lua

# unzip everything
unzip -q output.docx -d docx

cp mdout/styles.xml docx/word/styles.xml
cd docx
# NOTE: the -u update option seems not to work:
zip -r ../output.docx ./*
cd ..
rm -rf docx
