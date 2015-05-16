package JRobin::Double;

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


sub value {
    $_[0]->[0];
}

sub realize {
    my $a = (UNIVERSAL::isa($_[0],__PACKAGE__)) ? $_[0]->value : $_[0];
    my $b = (UNIVERSAL::isa($_[1],__PACKAGE__)) ? $_[1]->value : $_[1];
    return ($a, $b);
}

use overload (
    '""'    => sub { $_[0]->value },
    '==' => sub { my ($a, $b) = &realize; $a eq $b ? 1 : 0; },
    '!=' => sub { my ($a, $b) = &realize; $a ne $b ? 1 : 0; },
    'eq' => sub { my ($a, $b) = &realize; $a eq $b ? 1 : 0; },
    'ne' => sub { my ($a, $b) = &realize; $a ne $b ? 1 : 0; },
    '>'  => sub { my ($a, $b) = &realize; $a > $b ? 1 : 0; },
    '<'  => sub { my ($a, $b) = &realize; $a < $b ? 1 : 0; },
    '<=' => sub { my ($a, $b) = &realize; $a <= $b ? 1 : 0; },
    '>=' => sub { my ($a, $b) = &realize; $a >= $b ? 1 : 0; },
    '+' => sub { my ($a, $b) = &realize; $a + $b; },
    '-' => sub { my ($a, $b) = &realize; $a - $b; },
    '*' => sub { my ($a, $b) = &realize; $a * $b; },
    '/' => sub { my ($a, $b) = &realize; $a / $b; },
    '%' => sub { my ($a, $b) = &realize; $a % $b; },
);


1;

