use Test;
use Junction::Guts;

my @junctions = &any, &all, &one, &none;

plan +@junctions;

is .(^10).&Junction::Guts::type, .name, "{.name}() type"
    for @junctions;
