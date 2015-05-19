package JRobin::Robins;

use JRobin::Double;

use strict;
use warnings;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;

    my $r = {
        values => [],          # array of values
        ptr => 0,              # ptr to current value in round-robin db
    };
    ($r->{ptr}, @{$r->{values}}) = @_;
    @{$r->{values}} = map { JRobin::Double->new($_); } @{$r->{values}};

    bless($r,$class);
    return $r;
}

=head2 packstring

    my $packstring = packstring($rows);

Returns the packstring to decode the Robins binary data.  The number of rows
is needed to determine the length of the values.

=cut

sub packstring { 'N' . 'a8' x $_[0]; }

1;

