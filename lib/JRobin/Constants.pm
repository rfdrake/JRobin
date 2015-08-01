package JRobin::Constants;

use strict;
use warnings;
use Const::Fast;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();

const our $JROBIN_VERSION => 'JRobin, version 0.1';
const our $RRD_STRING_LENGTH => 20;

const our $RRD_INT => 0;
const our $RRD_LONG => 1;
const our $RRD_DOUBLE => 2;
const our $RRD_STRING => 3;
const our $RRD_PRIM_SIZES => [ 4, 8, 8, 2 * $RRD_STRING_LENGTH ];  # these are sizes on disk
const our $RRD_PACK_TYPES => [ 'N', 'Q>', 'a8', 'a40' ];


our %EXPORT_TAGS = ( all => [ qw( $JROBIN_VERSION $RRD_STRING_LENGTH $RRD_INT
                                  $RRD_LONG $RRD_DOUBLE $RRD_STRING $RRD_PRIM_SIZES
                                  $RRD_PACK_TYPES )
                            ]
                   );

our @EXPORT_OK = @{$EXPORT_TAGS{'all'}};

=head1 NAME

JRobin::Constants

=cut

=head2 DESCRIPTION

Some constants for JRobin use.

=cut

1;

