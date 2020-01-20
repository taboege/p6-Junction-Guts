NAME
====

Junction::Guts - Access the storage and type of a Junction under Rakudo

SYNOPSIS
========

Junction::Guts grants access to the carefully tucked away *storage* and *type* attributes of a Junction as implemented currently in Rakudo.

``` perl6
use Junction::Guts;

say any(1...10).&Junction::Guts::list; #= (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
say ([^] 1..10).&Junction::Guts::type; #= one
```

DESCRIPTION
===========

First of all, know that the guts of a Junction are not meant to be exposed by the Raku language. This module relies on Rakudo-specific internals and may stop working (and stop being repairable) any moment.

This module provides two subs `list` and `type` which return a list of the eigenstates and the type as a string, respectively, of the argument junction.

Both subs are `our`-scoped inside `Junction::Guts`. We neither `augment` the Junction class nor export any subs. This is to avoid messing with the Junction autothreading. As soon as a multi sub has a candidate that successfully matches `Junction`, every junction is sucked into this candidate and it can't forward the sub call to its eigenstates, making junctions useless for all other candidates of that sub. See the [Junction documentation](https://docs.perl6.org/type/Junction) for details.

Also see the [ADMONITION](#ADMONITION) section below the detailed module description for why this rather ugly interface is not all too bad.

our sub list
------------

``` perl6
our sub list (Junction:D \junc --> List:D)
```

Return the eigenstates of the Junction as a list.

our sub type
------------

``` perl6
our sub type (Junction:D \junc --> Str:D)
```

Return the Junction type as a string, e.g. `"all"`, `"any"`, ….

ADMONITION
==========

Consider this statement from the "Warning" section of Moritz Lenz' [Perl 5 to 6 article on junctions](https://perlgeek.de/blog-en/perl-5-to-6/08-junctions.html):

    Junctions are not sets; if you try to extract items from a junction,
    you are doing it wrong, and should be using a Set instead.

The basis of this admonition is, paraphrasing the [documentation](https://docs.perl6.org/type/Junction), the understanding that a junction is actually (supposed to be thought of as) a superposition, a simultaneous occurrence, of zero or more values known as the *eigenstates* of the junction. Picture one scalar that is in constant flux between its characteristic or *eigen*-states and acts like it is `any`, `all`, `one` or `none` of them at any time.

This module breaks this beautiful capsule by exposing a not so surprising implementation detail of Junctions in the Rakudo Perl 6 compiler: a junction actually just stores a buffer of the eigenstates. (Because how else would you implement it on a digital computer?)

RATIONALE
=========

So why does this module exist after all? Firstly, ever since reading Moritz' warning, I had this morbid feeling that it had to be written at some point.

Secondly, junctions are first-class Perl 6 citizens sporting beautiful syntaxes for representing a collection of values with an associated Boolification mode (`any` / `all` / `one` / `none`).

Under special circumstances, you might be tempted to use these built-in syntaxes and treat the Junction objects as a data store for these two parts. One such circumstance is writing a query compiler, which may turn an idiomatic `:keyword(any «nice easy»)` Perl 6 expression into the SQL clause `keyword='nice' OR keyword='easy'`.

SEE ALSO
========

About the Nature Of The Junction and why the attributes exposed by this module are hidden in the first place:

  * Outdated Exegesis 06 design document: [http://www.perl6.org/archive/doc/design/exe/E06.html](http://www.perl6.org/archive/doc/design/exe/E06.html).

  * From a Perl 5 to 6 perspective: [https://perlgeek.de/blog-en/perl-5-to-6/08-junctions.html](https://perlgeek.de/blog-en/perl-5-to-6/08-junctions.html).

  * The current Perl 6 documentation: [https://docs.perl6.org/type/Junction](https://docs.perl6.org/type/Junction).

AUTHOR
======

Tobias Boege <tobs@taboege.de>

COPYRIGHT AND LICENSE
=====================

Copyright 2019 Tobias Boege

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
