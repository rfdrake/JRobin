package JRobin::Datasource;

use JRobin::String;
use JRobin::Double;

our $AUTOLOAD;

use strict;
use warnings;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $fh = shift;
    sysread $fh, my $buffer, hsize() or die "Couldn't read file: $!";

    my $packstring = 'a40a40Q>a8a8a8a8Q>';

    my $ds = {
        raw => [],
        dsName => '',
        dsType => '',
        heartbeat => '',
        minValue => '',
        maxValue => '',
        lastValue => '',
        accumValue => '',
        nanSeconds => '',
    };

    @{$ds->{raw}} = unpack($packstring, $buffer);
    $ds->{dsName} = JRobin::String->new($ds->{raw}->[0]);
    $ds->{dsType} = JRobin::String->new($ds->{raw}->[1]);
    $ds->{heartbeat} = $ds->{raw}->[2];
    $ds->{minValue} = JRobin::Double->new($ds->{raw}->[3]);
    $ds->{maxValue} = JRobin::Double->new($ds->{raw}->[4]);
    $ds->{lastValue} = JRobin::Double->new($ds->{raw}->[5]);
    $ds->{accumValue} = JRobin::Double->new($ds->{raw}->[6]);
    $ds->{nanSeconds} = $ds->{raw}->[7];


    bless($ds,$class);
    return $ds;
}

=head2 hsize

    my $size = hsize();

Returns 128.  This is the number of bytes the JRobin Datasource uses.

=cut

sub hsize {
    40 + 40 + 8 + 8 + 8 + 8 + 8 + 8;
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


=head2 dump

    my $arrayref = $datasource->dump();

Returns an arrayref of all the current values for the Datasource.

=cut

sub dump {
    my $self = shift;
    my $vals = [];

    push(@$vals, "dsName = ". $self->{dsName});
    push(@$vals, "dsType = ". $self->{dsType});
    push(@$vals, "heartbeat = ". $self->{heartbeat});
    push(@$vals, "minValue = ". $self->{minValue});
    push(@$vals, "maxValue = ". $self->{maxValue});
    push(@$vals, "lastValue = ". $self->{lastValue});
    push(@$vals, "accumValue = ". $self->{accumValue});
    push(@$vals, "nanSeconds = ". $self->{nanSeconds});
    return $vals;
}

1;

