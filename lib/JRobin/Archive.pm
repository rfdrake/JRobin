package JRobin::Archive;

use strict;
use warnings;

use JRobin::ArcState;
use JRobin::Robins;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $input = shift;

    my $packstring = 'a40a8NNA*';

    my $arc = {
        consolFun => '',    # consolidation function
        xff => '',          # archive X-files factor (between 0 and 1)
        steps => '',        # pdp_per_row in XML.  This * $step = time between rows
        rows => '',
    };


    ($arc->{consolFun},$arc->{xff},$arc->{steps},$arc->{rows},$arc->{leftover}) = unpack($packstring, $input);
    $arc->{arcState} = JRobin::ArcState->new($arc->{leftover});
    $arc->{robins} = JRobin::Robins->new($arc->{arcState}->{leftover}, $arc->{rows});
    $arc->{leftover} = $arc->{robins}->{leftover};
    bless($arc,$class);
    return $arc;
}

sub dump {
    my $self = shift;
    my $ptr = $self->{robins}->{ptr};

    my $vals = [];
    for(my $i=0; $i<$self->{rows}; $i++) {
        push(@$vals, $self->{robins}->{values}->[$ptr]);
        $ptr = ($ptr + 1) % $self->{rows};
    }
    return $vals;
}

1;

