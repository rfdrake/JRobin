package JRobin::Datasource;

use strict;
use warnings;
use JRobin::String;
use JRobin::Double;

our $AUTOLOAD;

=head2 new

    my $ds = JRobin::Datasource->new($dsName, $dsType, $heartbeat, $minValue, $maxValue, $lastValue, $accumValue, $nanSeconds);

Returns a Datasource object.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;

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

    $ds->{dsName} = JRobin::String->new($_[0]);
    $ds->{dsType} = JRobin::String->new($_[1]);
    $ds->{heartbeat} = $_[2];
    $ds->{minValue} = JRobin::Double->new($_[3]);
    $ds->{maxValue} = JRobin::Double->new($_[4]);
    $ds->{lastValue} = JRobin::Double->new($_[5]);
    $ds->{accumValue} = JRobin::Double->new($_[6]);
    $ds->{nanSeconds} = $_[7];


    bless($ds,$class);
    return $ds;
}

=head2 packstring

    my $packstring = packstring();

Returns the string used to decode the Datasource.

=cut

sub packstring { 'a40a40Q>a8a8a8a8Q>'; }


# make a generic function to return values so I don't have to boilerplate all
# of them.
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

