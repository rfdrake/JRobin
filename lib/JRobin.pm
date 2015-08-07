package JRobin;

use strict;
use warnings;
use JRobin::Constants qw ( :all );
use JRobin::Header;
use JRobin::Datasource;
use JRobin::Archive;
use JRobin::Unpack;

=head1 NAME

JRobin - Access JRD files

=head1 VERSION

0.201502

=cut

our $VERSION = '0.201502';

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

our $AUTOLOAD;

=head2 new

    my $jrobin = JRobin->new('file.jrb');
    my $jrobin = JRobin->new({ 'file' => 'file.jrb' });
    my $jrobin = JRobin->new({ 'fh' => $fh });
    my $jrobin = JRobin->new({ 'buffer' => $string });


Parses a JRobin Database into memory.  Depending on how the database is passed
to us, we store the file/fh/buffer in the new object for reference, but don't
really make use of it again.  This may change if we enable write support.

=cut


sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $input = shift;
    my $buffer;
    my $self = {};
    if (ref($input) eq 'HASH') {
        if (defined($input->{'file'})) {
            my $file = $input->{'file'};
            $self->{file} = $file;
            open my $fh, '<', $file or die "Can't open file $file: $!";
            read $fh, $buffer, -s $fh or die "Couldn't read file: $!";
            close $fh;
        } elsif (defined($input->{'fh'})) {
            my $fh = $input->{'fh'};
            $self->{fh} = $fh;
            read $fh, $buffer, -s $fh or die "Couldn't read file: $!";
        } elsif (defined($input->{'buffer'})) {
            $buffer = $input->{'buffer'};
        } else {
            die "Invalid arguments specified for $class";
        }
    } else {
        my $file = $input;
        $self->{file} = $file;
        open my $fh, '<', $file or die "Can't open file $file: $!";
        read $fh, $buffer, -s $fh or die "Couldn't read file: $!";
        close $fh;
    }
    $self->{buffer}=$buffer;

    bless($self, $class);
    return $self->_load;
}

=head2 _load

    my $robin = $self->_load;

This loads the JRobin file from the buffer in $self->{buffer}.  The buffer is
handed over to Unpack and not used again.  This subroutine is automatically
called by new() and shouldn't be needed unless you do something weird.

=cut

sub _load {
    my $self = shift;
    my $u = JRobin::Unpack->new($self->{buffer});

    $self->{'header'} = JRobin::Header->new($u->unpack(JRobin::Header->packstring));

    die if ($self->{header}->{signature} ne $JROBIN_VERSION);

    for (1..$self->{header}->{dsCount}) {
        my $ds = JRobin::Datasource->new($u->unpack(JRobin::Datasource->packstring));
        push(@{$self->{ds}}, $ds);
        for (1..$self->{header}->{arcCount}) {
            push(@{$ds->{archive}}, JRobin::Archive->new($u, $u->unpack(JRobin::Archive->packstring)));
        }
    }
    $u->finish(1);


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

=head2 get_steps

    my $steps = $jrobin->get_steps(<archive>);

This returns the number of steps for a particular archive, where steps are the
step number in the JRobin::Header multiplied by the steps in the JRobin::Archive.

=cut

sub get_steps {
    my $self = shift;
    my $archive = shift;
    my $datasource = shift;
    $self->{header}->{step} * $self->ds->[$datasource]->{archive}->[$archive]->{steps};
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

    my $reply = $jrobin->dump_archive( { 'starttime' => timestamp, 'endtime' => timestamp, 'archive' => 0, 'datasource' => 0 } );

Returns an arrayref dump of the archive.  All the values are currently optional.
Datasource and archive default to zero, the first archive/datasource in the
file.  If starttime and endtime are unspecified then all the values are
returned in that archive.

=cut

# we should improve error handling/reporting here.

sub dump_archive {
    my $self = shift;
    my $values = shift;
    my $header = $self->{header};
    $values->{datasource} ||= 0;
    $values->{archive} ||= 0;
    return -1 if ($values->{archive} > $header->{arcCount} || $values->{datasource} -> $header->{dsCount});
    my $archive = $self->ds->[$values->{datasource}]->{archive}->[$values->{archive}];

    my $steps = $self->get_steps($values->{archive}, $values->{datasource});
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
