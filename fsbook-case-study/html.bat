xcopy /y images out\images\
pandoc -o fei/fsbook-case-study.html -V book="FreeSWITCH������ȫ" -V title="FreeSWITCH������ȫ"  --template cover.html preface.md chapter1.md chapterx.md postface.md
