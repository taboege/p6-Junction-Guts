use Test;
use Junction::Guts;

my @junctions = &any, &all, &one, &none;
my @vectors =
    [1..10],
    [1, 5, 3, 2, 4],
    ["mixed", 42, π, now],
    [],
;

plan +@junctions;

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
