package JRobin::Header;

use strict;
use warnings;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $fh = shift;
    sysread $fh, my $buffer, hsize() or die "Couldn't read file: $!";

    my $h = {
        signature => '',
        lastUpdateTime => '',
        step => '',
        dsCount => '',
        arcCount => '',
    };

    ($h->{signature},$h->{step},$h->{dsCount},$h->{arcCount},$h->{lastUpdateTime}) = unpack("a40Q>NNQ>", $buffer);

    bless($h,$class);
    return $h;
}

=head2 hsize

    my $size = hsize();

Returns 64.  This is the number of bytes the JRobin Header uses.

=cut

sub hsize {
    40 + 8 + 4 + 4 + 8;
}

1;

