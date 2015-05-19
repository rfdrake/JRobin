use lib qw(lib);
use Test::More;
plan tests => 7;
use JRobin::Unpack;

my $string = 'a40a40Q>a8a8a8NNQ>';  # 128 bytes
my $string2 = 'a8a8a8a8a8a8a8a8';   # 64 bytes

my $buffer = 'z' x 256;
my $u = JRobin::Unpack->new($buffer);


is($u->size($string), 128, 'Does the packstring size match?');
my @output = $u->unpack($string);
is($#output, 8, 'does unpack (string) return 9 elements?');
is($output[3],'zzzzzzzz','is element 3 8 bytes long?');
is($u->size($string2), 64, 'Is size($string2) 64 bytes?');
is($u->finish, 0, 'is the buffer empty? (no)');
@output = $u->unpack($string2);
is($#output, 7, 'does unpack (string2) return 8 elements?');
$u->unpack($string2); # clear the remaining 64 bytes
is($u->finish(1), 1, 'is the buffer empty? (yes)');


