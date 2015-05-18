package JRobin::Robins;

use JRobin::Double;

use strict;
use warnings;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $fh = shift;
    my $rows = shift;

    sysread $fh, my $buffer, size($rows) or die "Couldn't read file: $!";

    my $r = {
        values => [],          # array of values
        rows => $rows,
    };
    ($r->{ptr}, @{$r->{values}}) = unpack(packstring($rows), $buffer);
    @{$r->{values}} = map { JRobin::Double->new($_); } @{$r->{values}};

    bless($r,$class);
    return $r;
}

=head2 packstring

    my $packstring = packstring($rows);

Returns the packstring to decode the Robins binary data.  The number of rows
is needed to determine the length of the values.

=cut

sub packstring {
    'N' . 'a8' x $_[0];
}

=head2 size

    my $size = size($rows);

Returns the size of the binary data in bytes.  The number of rows is required.

=cut

sub size {
   4+8*$_[0];
}

1;

