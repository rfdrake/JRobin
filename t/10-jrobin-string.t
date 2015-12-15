use lib qw(lib);
use Test::More;
use JRobin::String;

my $s = JRobin::String->new("\000H\000E\000L\000L\000O\000 \000W\000O\000R\000L\000D\000!");

cmp_ok($s, 'eq', 'HELLO WORLD!', 'testing overload eq');
cmp_ok($s, 'ne', 'WORLD!', 'testing overload ne');
is("$s",'HELLO WORLD!', 'testing overload string');
done_testing();
