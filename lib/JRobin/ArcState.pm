package JRobin::ArcState;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $input = shift;

    my $packstring = 'a8Q>A*';

    my $as = {
        accumValue => undef,        # value
        nanSteps => undef,          # unknown_datapoints
    };

    ($as->{accumValue}, $as->{nanSteps}, $as->{leftover}) = unpack($packstring, $input);

    bless($as,$class);
    return $as;
}

1;

