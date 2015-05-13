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


sub get_steps {
    my $header = shift;
    my $archive = shift;
    $header->{step} * $archive->{steps};
}

sub get_start_time {
    my $lastUpdateTime = shift;
    my $step = shift;
    my $numrows = shift;

    return ($lastUpdateTime - $lastUpdateTime % $step) - ($numrows - 1) * $step;
}

sub parse {

        my $file = shift;
        open my $fh, '<', $file or die "Can't open file $file: $!";
        read $fh, my $buffer, -s $fh or die "Couldn't read file: $!";

        my $header = JRobin::Header->new($buffer);
        die if (fix_jrd_string($header->{signature}) ne $JROBIN_VERSION);
        for (1..$header->{dsCount}) {
            my $ds = JRobin::Datasource->new($header->{rest});
            my $archive;
            for (1..$header->{arcCount}) {
                my $rest = $archive->{rest};
                $rest ||= $ds->{rest};
                $archive = JRobin::Archive->new($rest);
                my $steps = get_steps($header,$archive);
                my $start = get_start_time($header->{lastUpdateTime},$steps,$archive->{rows});
                my $x=0;
                for(@{$archive->dump()}) {
                    print scalar localtime($start + $steps * $x++). " ".  parse_double($_) . "\n";
                }
            }
        }
}


