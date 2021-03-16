#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Iterator::Records::Lines;
use Data::Dumper;

# Basic string line iterator
my $i = Iterator::Records::Lines->new(string => <<EOF);
This is a test string.
Also a total of five lines.
   With the third indented.
   
And the fourth blank.
EOF

isa_ok ($i, 'Iterator::Records::Lines');

is_deeply ($i->fields, ['type', 'lno', 'indent', 'len', 'text']);

# Basic iteration.
my $iter = $i->iter();
is_deeply ($iter->(), ['line', 1, 0, 22, 'This is a test string.']);
is_deeply ($iter->(), ['line', 2, 0, 27, 'Also a total of five lines.']);
is_deeply ($iter->(), ['line', 3, 3, 24, 'With the third indented.']);
is_deeply ($iter->(), ['blank', 4, 0, 0, '']);
is_deeply ($iter->(), ['line', 5, 0, 21, 'And the fourth blank.']);
my $last = $iter->();
ok (not defined $last);



done_testing();
