package JRobin::Datasource;

use strict;
use warnings;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $input = shift;

    my $packstring = 'a40a40Q>a8a8a8a8Q>A*';

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

    ($ds->{dsName},$ds->{dsType},$ds->{heartbeat},$ds->{minValue},$ds->{maxValue},$ds->{lastValue},$ds->{accumValue},$ds->{nanSeconds}, $ds->{rest}) = unpack($packstring, $input);

    bless($ds,$class);
    return $ds;
}

1;

