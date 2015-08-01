package JRobin::Archive;

use strict;
use warnings;

use JRobin::ArcState;
use JRobin::Robins;
use JRobin::Double;
use JRobin::String;

=head2 new

    my $archive = JRobin::Archive->new($consolFun, $xff, $steps, $rows);

Returns an archive object.

=cut

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

    foreach my $name (keys %$arc) {
        my $sub = sub {
            $_[0]->{$name};
        };

        no strict 'refs';
        no warnings 'redefine';
        *{$name} = $sub;
    }
    bless($arc,$class);
    return $arc;
}

=head2 packstring

    my $packstring = packstring();

Returns the string used to decode the Archive header.

=cut

sub packstring { 'a40a8NN'; }

=head2 dump

    my $valuesref = $archive->dump;

Returns an array reference of the values in the archive.

=cut

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

