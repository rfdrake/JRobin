package JRobin::Header;

use JRobin::String;

use strict;
use warnings;

our $AUTOLOAD;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;

    my $h = {
        signature => '',
        lastUpdateTime => '',
        step => '',
        dsCount => '',
        arcCount => '',
    };

    $h->{signature} = JRobin::String->new($_[0]);
    $h->{step} = $_[1];
    $h->{dsCount} = $_[2];
    $h->{arcCount} = $_[3];
    $h->{lastUpdateTime} = $_[4];


    bless($h,$class);
    return $h;
}

=head2 packstring

    my $packstring = packstring();

Returns the string used to decode the Header.

=cut

sub packstring { 'a40Q>NNQ>'; }

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

