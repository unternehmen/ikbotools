# ikbotools
ikbotools is a set of programs which translate text to and from Ikbo (a
language game in the same vein as Pig Latin) into the original language,
primarily English.

## The Scheme Version: `ikbo2eng.scm`
The Scheme script contains functions that can be used to translate text
from Ikbo into English.  The functions are meant to be run directly from
the REPL, so no command-line interface was included.  In a nutshell,
you translate text like this:

    (translate-text "Ye ikembo biz fikriidubom.")

which would return:

    "I am without freedom."

## License
ikbotools is licensed under the Unlicense.  For more information, see
the LICENSE file included in the source tree.
