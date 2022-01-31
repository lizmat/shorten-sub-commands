[![Actions Status](https://github.com/lizmat/shorten-sub-commands/workflows/test/badge.svg)](https://github.com/lizmat/shorten-sub-commands/actions)

NAME
====

shorten-sub-commands - allow partial specification of sub-commands

SYNOPSIS
========

```raku
# in script "frobnicate"
multi sub MAIN("foozle")  { say "foozle"  }
multi sub MAIN("barabas") { say "barabas" }
multi sub MAIN("bazzie")  { say "bazzie"  }
use shorten::sub::commands &MAIN;

    $ raku frobnicate foo
    foozle
    $ raku frobnicate ba
    'ba' is ambiguous, matches: barabas bazzie
    $ raku frobnicate bar
    barabas
```

DESCRIPTION
===========

shorten::sub::commands is a helper module intended to be used for command-line application that have a sub-command structure (in which the first positional parameter indicates what needs to be done, and there is a separate candidate to handle execution of that command).

When used **after** all `MAIN` candidates have been defined, it will add another candidate that will allow to shorten the command names to be as short as possible (e.g. just "foo" in the example above, or even just "f" as there is only one candidate that starts with "f".

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/shorten-sub-commands . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

