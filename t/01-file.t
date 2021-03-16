#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Iterator::Records::Lines;
use Data::Dumper;

# Basic file line iterator
my $i = Iterator::Records::Lines->new(file => 't/test.txt');
isa_ok ($i, 'Iterator::Records::Lines');

is_deeply ($i->fields, ['type', 'lno', 'indent', 'len', 'text']);

# Basic iteration.
my $iter = $i->iter();
is_deeply ($iter->(), ['line', 1, 0, 20, 'This is a test file.']);
is_deeply ($iter->(), ['line', 2, 0, 30, 'It has a total of three lines.']);
is_deeply ($iter->(), ['line', 3, 4, 27, 'The third line is indented.']);
is_deeply ($iter->(), ['blank', 4, 0, 0, '']);
is_deeply ($iter->(), ['line', 5, 0, 51, 'Oh, wait. Five lines, the fourth of which is blank.']);
my $last = $iter->();
ok (not defined $last);

# Raw-content file line iterator
$i = Iterator::Records::Lines->new(file => 't/test.txt', 1);
isa_ok ($i, 'Iterator::Records::Lines');

is_deeply ($i->fields, ['type', 'lno', 'indent', 'len', 'text']);

# Basic iteration.
$iter = $i->iter();
is_deeply ($iter->(), ['line', 1, 0, 20, 'This is a test file.']);
is_deeply ($iter->(), ['line', 2, 0, 30, 'It has a total of three lines.']);
is_deeply ($iter->(), ['line', 3, 0, 31, '    The third line is indented.']);
is_deeply ($iter->(), ['line', 4, 0, 0, '']);
is_deeply ($iter->(), ['line', 5, 0, 51, 'Oh, wait. Five lines, the fourth of which is blank.']);
$last = $iter->();
ok (not defined $last);

# Test that we can repeat the iteration (meaning open the file and read it again).
$iter = $i->iter();
is_deeply ($iter->(), ['line', 1, 0, 20, 'This is a test file.']);
is_deeply ($iter->(), ['line', 2, 0, 30, 'It has a total of three lines.']);
is_deeply ($iter->(), ['line', 3, 0, 31, '    The third line is indented.']);
is_deeply ($iter->(), ['line', 4, 0, 0, '']);
is_deeply ($iter->(), ['line', 5, 0, 51, 'Oh, wait. Five lines, the fourth of which is blank.']);
$last = $iter->();
ok (not defined $last);

# Repeat the iteration, and also verify that the full itrecs machinery is available.
$iter = $i->select('lno', 'text')->iter();
is_deeply ($iter->(), [1, 'This is a test file.']);
is_deeply ($iter->(), [2, 'It has a total of three lines.']);
is_deeply ($iter->(), [3, '    The third line is indented.']);
is_deeply ($iter->(), [4, '']);
is_deeply ($iter->(), [5, 'Oh, wait. Five lines, the fourth of which is blank.']);
$last = $iter->();
ok (not defined $last);

# Let's try one with a file that doesn't exist.
$i = Iterator::Records::Lines->new(file => 't/not-test.txt');
ok (not $i->{file_error});  # File is not checked until we actually iterate.
$iter = $i->iter();
ok ($i->{file_error});
$last = $iter->(); # But we still have a working iterator that returns zero records.
ok (not defined $last);



done_testing();
