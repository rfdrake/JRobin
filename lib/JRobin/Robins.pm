package JRobin::Robins;

use strict;
use warnings;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $input = shift;
    my $rows = shift;

    my $size = 8*$rows;
    my $packstring = "Na$size" . 'A*';

    my $r = {
        values => [],          # array of values
        rows => $rows,
    };
    my $temp;
    ($r->{ptr}, $temp, $r->{leftover}) = unpack($packstring, $input);

    @{$r->{values}} = unpack('a8' x $rows, $temp);

    bless($r,$class);
    return $r;
}

1;

