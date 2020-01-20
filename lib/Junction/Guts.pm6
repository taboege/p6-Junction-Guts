=begin pod

=head1 NAME

Junction::Guts - Access the storage and type of a Junction

=head1 SYNOPSIS

Junction::Guts grants access to the carefully tucked away I<storage>
and I<type> attributes of a Junction.

  use Junction::Guts;

  say any(1...10).&Junction::Guts::list; #= (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
  say ([^] 1..10).&Junction::Guts::type; #= one

=head1 DESCRIPTION

This module provides two subs C<list> and C<type> which return a list of
the eigenstates and the type as a string, respectively, of the argument
junction.

Both subs are C<our>-scoped inside C<Junction::Guts>. We neither C<augment>
the Junction class nor export any subs. This is to avoid messing with the
Junction autothreading. As soon as a multi sub has a candidate that
successfully matches C<Junction>, every junction is sucked into this
candidate and it can't forward the sub call to its eigenstates, making
junctions useless for all other candidates of that sub. See the
L<Junction documentation|https://docs.perl6.org/type/Junction> for details.

Also see the L<ADMONITION|#ADMONITION> section below the detailed module
description for why this rather ugly interface is not all too bad.

=end pod

unit module Junction::Guts:ver<0.0.1>:auth<github:taboege>:api<0>;

use nqp; # how all the good modules start

=begin pod

=head2 our sub list

=for code
our sub list (Junction:D \junc --> List:D)

Return the eigenstates of the Junction as a list.

=end pod

our sub list (Junction:D \junc --> List:D) {
    my $it := nqp::iterator(nqp::getattr(junc,Junction,'$!storage'));
    List.new: |gather {
        take nqp::shift($it) while $it;
    }
}

=begin pod

=head2 our sub type

=for code
our sub type (Junction:D \junc --> Str:D)

Return the Junction type as a string, e.g. C<"all">, C<"any">, ….

=end pod

our sub type (Junction:D \junc --> Str:D) {
    nqp::box_s(
        nqp::getattr(junc,Junction,'$!type'),
        'Str'
    )
}

=begin pod

=head1 ADMONITION

Consider this statement from the "Warning" section of Moritz Lenz'
L<Perl 5 to 6 article on junctions|https://perlgeek.de/blog-en/perl-5-to-6/08-junctions.html>:

    Junctions are not sets; if you try to extract items from a junction,
    you are doing it wrong, and should be using a Set instead.

The basis of this admonition is, paraphrasing the L<documentation|https://docs.perl6.org/type/Junction>,
the understanding that a junction is actually (supposed to be thought of as)
a superposition, a simultaneous occurrence, of zero or more values known as
the I<eigenstates> of the junction. Picture one scalar that is in constant
flux between its characteristic or I<eigen>-states and acts like it is
C<any>, C<all>, C<one> or C<none> of them at any time.

This module breaks this beautiful capsule by exposing a not so surprising
implementation detail of Junctions in the Rakudo Perl 6 compiler: a junction
actually just stores a buffer of the eigenstates. (Because how else would
you implement it on a digital computer?)

=head1 RATIONALE

So why does this module exist after all? Firstly, ever since reading
Moritz' warning, I had this morbid feeling that it had to be written
at some point.

Secondly, junctions are first-class Perl 6 citizens sporting beautiful
syntaxes for representing a collection of values with an associated
Boolification mode (C<any> / C<all> / C<one> / C<none>).

Under special circumstances, you might be tempted to use these
built-in syntaxes and treat the Junction objects as a data store for
these two parts. One such circumstance is writing a query compiler,
which may turn an idiomatic C<<:keyword(any «nice easy»)>> Perl 6
expression into the SQL clause C<keyword='nice' OR keyword='easy'>.

=head1 SEE ALSO

About the Nature Of The Junction and why the attributes exposed
by this module are hidden in the first place:

=item Outdated Exegesis 06 design document: L<http://www.perl6.org/archive/doc/design/exe/E06.html>.
=item From a Perl 5 to 6 perspective: L<https://perlgeek.de/blog-en/perl-5-to-6/08-junctions.html>.
=item The current Perl 6 documentation: L<https://docs.perl6.org/type/Junction>.

An alternative module that implements a Junction-lookalike class
that is explicitly intended to allow access to its eigenstates,
but which lacks the autothreading feature, if you can afford to
change your code to use it:

=item (NYI)

=head1 AUTHOR

Tobias Boege <tobs@taboege.de>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Tobias Boege

This library is free software; you can redistribute it
and/or modify it under the Artistic License 2.0.

=end pod
