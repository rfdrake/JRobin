package JRobin::Header;

use JRobin::String;

use strict;
use warnings;

=head2 new

    my $header = JRobin::Header->new($signature, $lastUpdateTime, $step, $dsCount, $arcCount);

Returns a JRobin::Header object.

=cut

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

    foreach my $name (keys %$h) {
        my $sub = sub {
            $_[0]->{$name};
        };

        no strict 'refs';
        no warnings 'redefine';
        *{$name} = $sub;
    }

    bless($h,$class);
    return $h;
}

=head2 packstring

    my $packstring = packstring();

Returns the string used to decode the Header.

=cut

sub packstring { 'a40Q>NNQ>'; }

1;

