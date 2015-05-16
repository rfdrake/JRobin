use lib qw(lib);
use Test::More;
plan tests => 13;
use JRobin::Double;

# this normally takes a packed 8 byte string but we just need to initialize it
# for some equality tests.  The number can be anything for our purposes.
my $double = new JRobin::Double(12345);
my $double2 = new JRobin::Double(12345);
my $double3 = new JRobin::Double(12344);

is($double > $double2, 0, 'greater than test of same values');
is($double < $double2, 0, 'less than test of same values');
is($double >= $double2, 1, 'greater than or equal test of same values');
is($double <= $double2, 1, 'less than or equal test of same values');
is($double == $double2, 1, 'equality test of same values');
is($double != $double2, 0, 'not equal test of same values');
is($double == $double3, 0, 'equality test of different values');
is($double == 4, 0, 'equality test of value with numeric');
is($double >= 4, 1, 'greater than or equal test of static number');
is($double, 12345, 'value stringify overload test');
is($double + 4, 12349, 'numerical addition test');
is($double % 4, 1, 'modulus test');
is($double + $double2, 24690, 'object addition test');
