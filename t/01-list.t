use Test;
use Junction::Guts;

my @junctions = &any, &all, &one, &none;
my @vectors =
    [1..10],
    [1, 5, 3, 2, 4],
    ["mixed", 42, π, now],
    [],
;

plan +@junctions + 1;

for @junctions -> &junc {
    subtest "list on {&junc.name}() junctions" => {
        plan +@vectors;
        for @vectors {
            # We test for .Bag because junctions are explicitly
            # *unordered* collections of eigenstates, as per the
            # documenation. Currently it seems like order is
            # preserved in Rakudo, though.
            is-deeply
                &junc(|$_).&Junction::Guts::list.Bag,
                .Bag, .gist;
        }
    }
}

multi prefix:<±> (Numeric:D \a) is tighter(&infix:<+>) {
    any(a, -a)
}

my $j := ±10 + ±90;
# $j is any(any(-80, 100), any(80, -100)), so we need two levels of guts
# and Slip to remove itemization.
my @got = $j.&Junction::Guts::list».&{ .&Junction::Guts::list.Slip };
is-deeply @got.flat.sort, (-100, -80, 80, 100), '±10 + ±90';
