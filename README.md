# mdout

Shell script for exporting Markdown to .docx via `pandoc`, to be copied into PDF publishing software.

This is full of filthy hacks to get around not having a coherent pipeline from plaintext .md into afpub.

It runs `sed` a bunch of times to preserve MD/HTML styling by dropping special chars into the text, so that a search-and-replace can apply styles.

## requirements

* pandoc
* Affinity Publisher for now. Which means OSX.
* LibreOffice or whatever to handle .docx

## run

```sh
./mdout/run.sh 01.foo.md
```

Output will be in a /tmp/foo.docx file opened by `open`.

See procedure.md
