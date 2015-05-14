package JRobin::ArcState;

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

    ($as->{accumValue}, $as->{nanSteps}) = unpack($packstring, $buffer);

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


1;

