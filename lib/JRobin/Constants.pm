package JRobin::Constants;

# these aren't currently used, but I included them for documentation and
# convienence.
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw (  );

our $JROBIN_VERSION = 'JRobin, version 0.1';
our $RRD_STRING_LENGTH = 20;
our $RRD_INT = 0;
our $RRD_LONG = 1;
our $RRD_DOUBLE = 2;
our $RRD_STRING = 3;
our $RRD_PRIM_SIZES = [ 4, 8, 8, 2 * $RRD_STRING_LENGTH ];  # these are sizes
on disk
our $RRD_PACK_TYPES = [ 'N', 'Q>', 'a8', 'a40' ];


our %EXPORT_TAGS = ( all => [ qw( $JROBIN_VERSION $RRD_STRING_LENGTH $RRD_INT
                                  $RRD_LONG $RRD_DOUBLE $RRD_STRING
$RRD_PRIM_SIZES
                                  $RRD_PACK_TYPES )
                            ]
                   );

1;

