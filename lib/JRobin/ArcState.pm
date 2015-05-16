package JRobin::ArcState;

use JRobin::Double;

our $AUTOLOAD;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $fh = shift;
    sysread $fh, my $buffer, hsize() or die "Couldn't read file: $!";

    my $packstring = 'a8Q>';

    my $as = {
        accumValue => undef,        # value
        nanSteps => undef,          # unknown_datapoints
    };

    @{$as->{raw}} = unpack($packstring, $buffer);
    $as->{accumValue} = JRobin::Double->new($as->{raw}->[0]);
    $as->{nanSteps} = $as->{raw}->[1];

    bless($as,$class);
    return $as;
}

=head2 hsize

    my $size = hsize();

Returns 16.  This is the number of bytes the JRobin ArcState uses

=cut

sub hsize {
    8 + 8;
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

