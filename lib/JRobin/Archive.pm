package JRobin::Archive;

use strict;
use warnings;

our $AUTOLOAD;

use JRobin::ArcState;
use JRobin::Robins;
use JRobin::Double;
use JRobin::String;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $u = shift;

    my $arc = {
        consolFun => '',    # consolidation function
        xff => '',          # archive X-files factor (between 0 and 1)
        steps => '',        # pdp_per_row in XML.  This * $step = time between rows
        rows => '',
    };

    $arc->{consolFun} = JRobin::String->new($_[0]);
    $arc->{xff} = JRobin::Double->new($_[1]);
    $arc->{steps} = $_[2];
    $arc->{rows} = $_[3];
    $arc->{arcState} = JRobin::ArcState->new($u->unpack(JRobin::ArcState->packstring));
    $arc->{robins} = JRobin::Robins->new($u->unpack(JRobin::Robins::packstring($arc->{rows})));
    bless($arc,$class);
    return $arc;
}

=head2 packstring

    my $packstring = packstring();

Returns the string used to decode the Archive header.

=cut

sub packstring { 'a40a8NN'; }

sub hsize { 40 + 8 + 4 + 4; }

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

