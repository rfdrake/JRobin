=head1 NAME

JRobin - Access JRD files

=head1 VERSION

0.201501

=cut

our $VERSION = eval '0.201501';

=head1 SYNOPSIS

use JRobin;

=cut

=head1 AUTHOR

Robert Drake, C<< <rdrake at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2015 Robert Drake, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

package JRobin;

use strict;
use warnings;
use JRobin::Constants qw ( :all );
use JRobin::Header;
use JRobin::Datasource;
use JRobin::Archive;
use Fcntl qw( O_RDONLY );

use 5.012;
use feature "state";

our $AUTOLOAD;


=head2 new

    my $jrobin = JRobin->new('file.jrb');

Opens and reads a JRobin database.

=cut


sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $file = shift;
    sysopen my $fh, $file, O_RDONLY or die "Can't open file $file: $!";
    sysread $fh, my $buffer, 64 or die "Couldn't read file: $!";

    my $self = {
        'header' => JRobin::Header->new(_unpack(JRobin::Header->packstring, $buffer)),
    };
    bless($self, $class);

    die if ($self->{header}->{signature} ne $JROBIN_VERSION);
    for (1..$self->{header}->{dsCount}) {
        push(@{$self->{ds}}, JRobin::Datasource->new($fh));
        for (1..$self->{header}->{arcCount}) {
            push(@{$self->{archive}}, JRobin::Archive->new($fh));
        }
    }
    return $self;
}

sub AUTOLOAD {
    my $self = shift;

    my ($type) = ($AUTOLOAD =~ m/::(\w+)$/);

    if (defined($self->{$type})) {
        return $self->{$type};
    } else {
        die "Bad argument for ". __PACKAGE__ ." --- $AUTOLOAD\n";
    }
}


# This handles the unpack command and returns the values to be passed into the
# sub as an array.  This keeps an internal offset
sub _unpack {
    my $string = shift;
    my $buffer = shift;
    state $offset = 0;
    if ($string eq '' && $offset < length $buffer) {
        warn "Parse incomplete.  offset = $offset.  Buffer length = ". length $buffer;
        return;
    }
    my $size = _size($string);
    my $tempstr = "x$offset$string";
    $offset += $size;
    return unpack($tempstr, $buffer);
}

# given a packstring, break it down by types and find the size of each
# element.  For instance, 'N' is a 4 byte long.  'a8' is 8 bytes.
sub _size {
    my $string = shift;
    my $size = 0;

    while (my ($i, $type) = each @$RRD_PACK_TYPES) {
        my $count = () = $string =~ /$type/g;
        $size += $count * $RRD_PRIM_SIZES->[$i];
    }

    return $size;
}



=head2 get_steps

    my $steps = $jrobin->get_steps(<archive>);

This returns the number of steps for a particular archive, where steps are the
step number in the JRobin::Header multiplied by the steps in the JRobin::Archive.

=cut

sub get_steps {
    my $self = shift;
    my $archive = shift;
    $self->{header}->{step} * $self->{archive}->[$archive]->{steps};
}

=head2 get_start_time

    my $start_time = $jrobin->get_start_time($steps, $rows);

This returns the start time for the archive.  Rather than storing each value
as a time/value pair, the JRD database just stores the value and the
lastUpdateTime.  That cuts down on writes size but it means that you can't miss too
many write cycles or bad things happen that you need to correct for.

Anyway, you need to calculate when a value was stored and the way you do that
is you pick the lastUpdateTime and subtract the number of steps to whichever
value you're looking at.  Usually we're interested in the first record so we
want the start time and this is how we get it.

The formula is this:

    (lastUpdateTime - lastUpdateTime % step) - (rows - 1) * step

=cut

sub get_start_time {
    my $self = shift;
    my $update = $self->header->lastUpdateTime;
    my $step = shift;
    my $numrows = shift;

    return ($update - $update % $step) - ($numrows - 1) * $step;
}



=head2 dump_archive

    my @reply = $jrobin->dump_archive( { 'starttime' => timestamp, 'endtime' => timestamp, 'archive' => 0 } );

Generates a dump of the archive.  starttime and endtime are optional but can
be used to specify a timeperiod for graphing different intervals.

=cut

# we should improve error handling/reporting here.

sub dump_archive {
    my $self = shift;
    my $values = shift;
    my $header = $self->{header};
    return -1 if !defined($values->{archive} || $values->{archive} > $header->{arcCount});
    my $archive = $self->{archive}->[$values->{archive}];

    my $steps = $self->get_steps($values->{archive});
    my $start = $self->get_start_time($steps,$archive->rows);
    my $x=0;
    my $vals = [];
    for(@{$archive->dump()}) {
        my $time = $start + $steps*$x++;
        if (defined($values->{starttime}) && defined($values->{endtime})) {
            if ($time > $values->{starttime} && $time < $values->{endtime}) {
                push(@{$vals}, { time => $time, value => $_ });
            }
        } else {
            push(@{$vals}, { time => $time, value =>  $_ });
        }
    }
    return $vals;
}

1;
