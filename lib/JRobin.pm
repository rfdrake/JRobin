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

our $AUTOLOAD;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $file = shift;
    sysopen my $fh, $file, O_RDONLY or die "Can't open file $file: $!";

    my $self = {
        'header' => JRobin::Header->new($fh),
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

sub get_steps {
    my $self = shift;
    my $archive = shift;
    $self->{header}->{step} * $self->{archive}->[$archive]->{steps};
}

sub get_start_time {
    my $self = shift;
    my $update = $self->header->lastUpdateTime;
    my $step = shift;
    my $numrows = shift;

    return ($update - $update % $step) - ($numrows - 1) * $step;
}



=head2 dump_archive

    my @reply = $self->dump_archive( { 'starttime' => timestamp, 'endtime' => timestamp, 'archive' => 0 } );

Generates a dump of the archive.  starttime and endtime are optional but can
be used to specify a timeperiod for graphing different intervals.

We should improve error reporting/handling here.

=cut

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
