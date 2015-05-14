package JRobin::Robins;

use strict;
use warnings;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $fh = shift;
    my $rows = shift;

    my $hsize = 4+8*$rows;
    sysread $fh, my $buffer, $hsize or die "Couldn't read file: $!";

    my $packstring = 'N'. 'a8' x $rows;

    my $r = {
        values => [],          # array of values
        rows => $rows,
    };
    ($r->{ptr}, @{$r->{values}}) = unpack($packstring, $buffer);

    bless($r,$class);
    return $r;
}

1;

