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
use JRobin::Utils qw ( parse_double fix_jrd_string );
use JRobin::Header;
use JRobin::Datasource;
use JRobin::Archive;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $file = shift;
    sysopen my $fh, $file, O_RDONLY or die "Can't open file $file: $!";

    my $self = {
        'header' => JRobin::Header->new($fh),
    };
    bless($self, $class);
    die if ($self->signature) ne $JROBIN_VERSION);
    for (1..$header->{dsCount}) {
        my $ds = JRobin::Datasource->new($fh);
        push(@{$self->{ds}}, $ds);
        for (1..$header->{arcCount}) {
            push(@{$self->{archive}}, JRobin::Archive->new($fh));
        }
    }
    return $self;
}

sub signature {
    fix_jrd_string($_[0]->{header}->{signature});
}

sub get_steps {
    my $self = shift;
    my $archive = shift;
    $self->{header}->{step} * $self->{archive}->[$archive]->{steps};
}

sub get_start_time {
    my $lastUpdateTime = shift;
    my $step = shift;
    my $numrows = shift;

    return ($lastUpdateTime - $lastUpdateTime % $step) - ($numrows - 1) * $step;
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
    my $start = get_start_time($header->{lastUpdateTime},$steps,$archive->{rows});
    my $x=0;
    my $vals = [];
    for(@{$archive->dump()}) {
        my $time = $start + $steps*$x++;
        if (defined($values->{starttime}) && defined($values->{endtime})) {
            if ($time > $values->{starttime} && $time < $values->{endtime}) {
                push(@{$vals}, { $time => parse_double($_) });
            }
        } else {
            push(@{$vals}, { $time => parse_double($_) });
        }
    }
    return $vals;
}

