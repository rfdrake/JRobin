package JRobin::Header;

use strict;
use warnings;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $input = shift;

    my $h = {
        signature => '',
        lastUpdateTime => '',
        step => '',
        dsCount => '',
        arcCount => '',
    };

    ($h->{signature},$h->{step},$h->{dsCount},$h->{arcCount},$h->{lastUpdateTime},$h->{rest}) = unpack("a40Q>NNQ>A*", $input);

    bless($h,$class);
    return $h;
}

1;

