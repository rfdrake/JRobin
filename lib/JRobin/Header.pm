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

    my @header = @_;
    $h->{signature} = JRobin::String->new($header[0]);
    $h->{step} = $header[1];
    $h->{dsCount} = $header[2];
    $h->{arcCount} = $header[3];
    $h->{lastUpdateTime} = $header[4];


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

