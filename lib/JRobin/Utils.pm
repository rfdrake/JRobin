package JRobin::Utils;

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw ( parse_double fix_jrd_string );

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

=head2 fix_jrd_string

    my $string = fix_jrd_string ($string);

The JRD file strings have padding between their characters.  Each Letter
has a binary zero preceeding it.  This strips those characters.

=cut

sub fix_jrd_string {
    for(@_) {
        s/.(.)/$1/g;
        s/\s+$//;
    }
    return $_[0];
}

1;

