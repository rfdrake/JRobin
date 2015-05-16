package JRobin::Double;

=head1 NAME

JRobin::Double - Object for JRobin double floating point values.

=cut

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw ( parse_double );

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;

    my $self = [ parse_double($_[0]), $_[0] ];

    bless $self, $class;
    return $self;
}

=head2 parse_double

    my $double = parse_double ($bytes);

This converts the JRD/Java double (eight bytes, the IEEE 754 "double
64" format) into a Perl double.

References:

    # http://www.lemoda.net/octave/binary64-to-perl/index.html
    # http://www.perlmonks.org/bare/?node_id=703222
    # http://en.wikipedia.org/wiki/Double_precision_floating-point_format
=cut

sub parse_double {
    return unpack 'd', scalar reverse pack 'a*', $_[0];
}

=head2 value

    my $double = $double->value;

Returns the perl double data value that has been generated for the JRobin
value.  This should normally not be needed because most access is done through
overloaded methods, but it's available if you need to access it directly.

=cut

sub value {
    $_[0]->[0];
}

# turn all objects into values before comparison
sub _realize {
    my $a = (UNIVERSAL::isa($_[0],__PACKAGE__)) ? $_[0]->value : $_[0];
    my $b = (UNIVERSAL::isa($_[1],__PACKAGE__)) ? $_[1]->value : $_[1];
    return ($a, $b);
}

use overload (
    '""'    => sub { $_[0]->value },
    '==' => sub { my ($a, $b) = &_realize; $a eq $b ? 1 : 0; },
    '!=' => sub { my ($a, $b) = &_realize; $a ne $b ? 1 : 0; },
    'eq' => sub { my ($a, $b) = &_realize; $a eq $b ? 1 : 0; },
    'ne' => sub { my ($a, $b) = &_realize; $a ne $b ? 1 : 0; },
    '>'  => sub { my ($a, $b) = &_realize; $a > $b ? 1 : 0; },
    '<'  => sub { my ($a, $b) = &_realize; $a < $b ? 1 : 0; },
    '<=' => sub { my ($a, $b) = &_realize; $a <= $b ? 1 : 0; },
    '>=' => sub { my ($a, $b) = &_realize; $a >= $b ? 1 : 0; },
    '+' => sub { my ($a, $b) = &_realize; $a + $b; },
    '-' => sub { my ($a, $b) = &_realize; $a - $b; },
    '*' => sub { my ($a, $b) = &_realize; $a * $b; },
    '/' => sub { my ($a, $b) = &_realize; $a / $b; },
    '%' => sub { my ($a, $b) = &_realize; $a % $b; },
);


1;

