package JRobin::Archive;

use strict;
use warnings;

use JRobin::ArcState;
use JRobin::Robins;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $fh = shift;
    sysread $fh, my $buffer, hsize() or die "Couldn't read file: $!";

    my $packstring = 'a40a8NN';

    my $arc = {
        consolFun => '',    # consolidation function
        xff => '',          # archive X-files factor (between 0 and 1)
        steps => '',        # pdp_per_row in XML.  This * $step = time between rows
        rows => '',
    };


    ($arc->{consolFun},$arc->{xff},$arc->{steps},$arc->{rows}) = unpack($packstring, $buffer);
    $arc->{arcState} = JRobin::ArcState->new($fh);
    $arc->{robins} = JRobin::Robins->new($fh, $arc->{rows});
    bless($arc,$class);
    return $arc;
}

=head2 hsize

    my $size = hsize();

Returns 56.  This is the number of bytes the JRobin Archive uses (without
ArcState and Robins)

=cut

sub hsize {
    40 + 8 + 4 + 4;
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

