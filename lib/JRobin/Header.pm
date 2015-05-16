package JRobin::Header;

use JRobin::String;

use strict;
use warnings;

our $AUTOLOAD;

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

    my @header = unpack("a40Q>NNQ>", $buffer);
    $h->{signature} = JRobin::String->new($header[0]);
    $h->{step} = $header[1];
    $h->{dsCount} = $header[2];
    $h->{arcCount} = $header[3];
    $h->{lastUpdateTime} = $header[4];


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

sub AUTOLOAD {
    my $self = shift;

    my ($type) = ($AUTOLOAD =~ m/::(\w+)$/);

    if (defined($self->{$type})) {
        return $self->{$type};
    } else {
        die "Bad argument for ". __PACKAGE__ ." --- $AUTOLOAD\n";
    }
}


1;

