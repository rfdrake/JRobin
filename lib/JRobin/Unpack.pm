package JRobin::Unpack;

# there may be better ways to do this.  I decided on this method because it's
# going to work and I don't think it will be that ugly.

=head1 NAME

JRobin::Unpack - Stream unpacker for the binary buffer

=cut

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw ( );

=head2 new

    my $unpack = JRobin::Unpack->new($buffer);

Returns an unpack object.  Requires a string buffer of packed values.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;

    my $self = {
        offset => 0,
        buffer => shift,
    };

    $self->{length} = length $self->{buffer};

    foreach my $name (keys %$self) {
        my $sub = sub {
            $_[0]->{$name};
        };

        no strict 'refs';
        no warnings 'redefine';
        *{$name} = $sub;
    }

    bless($self,$class);
    return $self;
}


=head2 finish

    my $boolean = $unpack->finish($warn);

Returns 1 if offset >= the buffer length.  If the offset is less than the
buffer length it returns zero.  You can have it emit a warning on failure by
passing a non-zero value.

This should be called after all your parsing routines to see if anything was missed.

=cut

sub finish {
    my $self = shift;
    my $warn = shift;
    if ($self->offset < $self->length) {
        warn "Parse incomplete.  offset = $self->offset.  Buffer length = $self->length" if $warn;
        return 0;
    }
    return 1;
}

=head2 unpack

    my @array = $unpack->unpack($string);

This runs unpack and returns the values as an array.  The size of the
packstring and the offset is calculated and tracked for you.

=cut

sub unpack {
    my $self = shift;
    my $string = shift;
    my $size = size($string);
    my $tempstr = 'x' . $self->offset . $string;
    $self->{offset} += $size;
    return CORE::unpack($tempstr, $self->buffer);
}

=head2 size

    my $size = size($string);

Given a packstring, break it down by types and find the size of each
element.  For instance, 'N' is 4 bytes long.  'a8' is 8 bytes.

=cut

sub size {
    length pack ref($_[0]) eq __PACKAGE__ ? $_[1] : $_[0];
}

1;

