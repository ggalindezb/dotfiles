find . -name '*.js' -o -name '*.jsx' -o -name '*.ts' -o -name '*.tsx' -exec cat \{\} \; | wc -l
