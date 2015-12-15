use lib qw(lib);
use Test::More;
use JRobin::Double;

my $value = '1700012331231.1';
my $packed_double = scalar reverse pack 'a*', pack('d', $value);

my $d = JRobin::Double->new($packed_double);

is("$d", '1700012331231.1', 'test overload string');
cmp_ok($d, '==', '1700012331231.1', 'JRobin::Double ==');
cmp_ok($d, '!=', '1', 'JRobin::Double !=');
cmp_ok($d, '==', '1700012331231.1', 'JRobin::Double eq');
cmp_ok($d, 'ne', '1', 'JRobin::Double ne');
cmp_ok($d, '>', '1', 'JRobin::Double >');
ok($d < 1700012331231.2, 'JRobin::Double <');
ok($d <= 11700012331231.1, 'JRobin::Double <= lt');
ok($d <= 1700012331231.1, 'JRobin::Double <= eq');
ok($d >= 1700012331231.0, 'JRobin::Double >= gt');
ok($d >= 1700012331231.1, 'JRobin::Double >= eq');
is($d + 1, 1700012331232.1, 'JRobin::Double +');
is($d - 1, 1700012331230.1, 'JRobin::Double -');
is($d * 1, 1700012331231.1, 'JRobin::Double *');
is($d / 5, 340002466246.22, 'JRobin::Double /');
is($d % 300, 231, 'JRobin::Double %');

done_testing();
