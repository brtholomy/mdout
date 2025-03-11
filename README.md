# mdout

Shell script for exporting Markdown to .docx via `pandoc`, to be copied into PDF publishing software.

This is full of filthy hacks to get around not having a coherent pipeline from plaintext .md into afpub.

## special chars

After running `pandoc` to get HTML, the script runs `sed` repeatedly to preserve HTML styling by dropping special chars into the text, so that a search-and-replace can apply styles:

* ¢ : section
* ¥ : blockquote
* ₱ : blockquote source
* ¤ : superscript
* £ : h2

Then remove by searching for `¢` and replace with `\1`, which means "first group", but since there is no group `()` in the query, an empty string is inserted along with the styling, which is what we wanted.

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
