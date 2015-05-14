package JRobin::Datasource;

use strict;
use warnings;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $fh = shift;
    sysread $fh, my $buffer, hsize() or die "Couldn't read file: $!";

    my $packstring = 'a40a40Q>a8a8a8a8Q>';

    my $ds = {
        dsName => '',
        dsType => '',
        heartbeat => '',
        minValue => '',
        maxValue => '',
        lastValue => '',
        accumValue => '',
        nanSeconds => '',
    };

    ($ds->{dsName},$ds->{dsType},$ds->{heartbeat},$ds->{minValue},$ds->{maxValue},$ds->{lastValue},$ds->{accumValue},$ds->{nanSeconds}) = unpack($packstring, $buffer);

    bless($ds,$class);
    return $ds;
}

=head2 hsize

    my $size = hsize();

Returns 128.  This is the number of bytes the JRobin Datasource uses.

=cut

sub hsize {
    40 + 40 + 8 + 8 + 8 + 8 + 8 + 8;
}


1;

