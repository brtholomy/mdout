# mdout

Shell script for exporting Markdown to `.docx` via `pandoc`, to be copied into PDF publishing software, where find-and-replace can be run to apply styles as derived from the Markdown. This depends on a feature of Affinity Publisher, where the replace step can simulaneously apply a style.

This is full of filthy hacks to get around not having a coherent pipeline from plaintext `.md` into `.afpub`.

## special chars

After running `pandoc` to get HTML, the script runs `sed` repeatedly to preserve HTML styling by dropping special chars into the text, so that a find-and-replace can apply styles:

* `¢` : section
* `¥` : blockquote
* `₱` : blockquote source
* `¤` : superscript
* `£` : h2

Then we remove these chars by searching for them as verbatim regex and replacing with `\1`, which means "first group": but since there is no group `()` in the regex, an empty string is inserted along with the styling, which is what we wanted.

## requirements

* pandoc
* Affinity Publisher for now. Which means OSX.
* LibreOffice or whatever to handle `.docx`

## run

1. Run from project root:

```sh
./mdout/run.sh 01.foo.md
```

Output will be `/tmp/foo.docx` opened by `open`.

2. Copy from the `.docx` file into afpub.

3. Find and replace in Publisher.

See ./procedure.md
