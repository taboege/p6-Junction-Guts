use Test;
use Junction::Guts;

# Test that we do not impair junction functionality by augmenting
# or exporting routines which interefere autothreading.

class Y {
    has $.name;
    has $.type;
    has $.list;
    method Str     { $!name  }
    method Numeric { +$!list }
}

my @yy =
    Y.new(:name<a>, :type<1>, :list[1, 5, 4]),
    Y.new(:name<b>, :type<2>, :list[2, 5, 4]),
    Y.new(:name<c>, :type<3>, :list[3, 5, 6, 8]),
;

plan 7;

ok +one(@yy)     eqv  4,        'autothreading operator';
ok any(@yy)      eq  'c',       'autothreading string context';
ok any(@yy).name eq  'b',       'autothreading method call';
ok one(@yy).list eqv [2, 5, 4], 'autothreading over ｢list｣';
ok any(@yy).type eq  '1',       'autothreading over ｢type｣';
ok all(@yy).list ~~  Array,     'chained method call';
ok none(@yy).type eq 'x',       'and a none junction';
