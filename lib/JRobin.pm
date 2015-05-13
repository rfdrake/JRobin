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

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $file = shift;
    open my $fh, '<', $file or die "Can't open file $file: $!";
    read $fh, my $buffer, -s $fh or die "Couldn't read file: $!";

    my $self = {
       buffer => $buffer,
    };
    bless($self, $class);
    my $header = JRobin::Header->new($buffer);
    $self->leftover($header->{leftover});
    die if (fix_jrd_string($header->{signature}) ne $JROBIN_VERSION);
    for (1..$header->{dsCount}) {
        my $ds = JRobin::Datasource->new($self->leftover);
        $self->leftover($ds->{leftover});
        push(@{$self->{ds}}, $ds);
        my $archive;
        for (1..$header->{arcCount}) {
            $archive = JRobin::Archive->new($self->leftover);
            $self->leftover($archive->{leftover});
            push(@{$self->{archive}}, $archive);
        }
    }
    return $self;
}

=head2 leftover

    my $leftover = $self->leftover;

This is a storage area for the "remaining" parts of the buffer each time we
remove some of the data via pack.  I don't really like this method but it's
working.

I'm planning to move to sysread/sysopen/seek rather than reading it all into a
buffer.  I wanted to optimize away the seek calls but the reality is that it's
probably caching the entire file in memory on open and the seeks are happening
there anyway.

=cut

sub leftover {
    my $self = shift;
    my $leftover = shift;
    if (!defined($leftover)) {
        return $self->{leftover};
    } else {
        $self->{leftover} = $leftover;
    }
    return $leftover;
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

