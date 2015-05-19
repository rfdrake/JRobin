package JRobin::ArcState;

use JRobin::Double;

our $AUTOLOAD;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;

    my $as = {
        accumValue => undef,        # value
        nanSteps => undef,          # unknown_datapoints
    };

    $as->{accumValue} = JRobin::Double->new($_[0]);
    $as->{nanSteps} = $_[1];

    bless($as,$class);
    return $as;
}

=head2 packstring

    my $packstring = packstring();

Returns the string used to decode the ArcState.

=cut

sub packstring { 'a8Q>'; }

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

