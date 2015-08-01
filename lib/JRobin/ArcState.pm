package JRobin::ArcState;

use JRobin::Double;
use strict;
use warnings;

=head2 new

    my $as = JRobin::ArcState->new($accumValue, $numSteps);

Makes a new arcState Object.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;

    my $as = {
        accumValue => undef,        # value
        nanSteps => undef,          # unknown_datapoints
    };

    $as->{accumValue} = JRobin::Double->new($_[0]);
    $as->{nanSteps} = $_[1];

    foreach my $name (keys %$as) {
        my $sub = sub {
            $_[0]->{$name};
        };

        no strict 'refs';
        no warnings 'redefine';
        *{$name} = $sub;
    }

    bless($as,$class);
    return $as;
}

=head2 packstring

    my $packstring = packstring();

Returns the string used to decode the ArcState.

=cut

sub packstring { 'a8Q>'; }

1;

