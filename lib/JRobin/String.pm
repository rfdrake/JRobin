package JRobin::String;

=head1 NAME

JRobin::String - String object for JRD style binary strings

=cut

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw ( fix_jrd_string );

=head2 new

    my $string = JRobin::String->new($string);

Returns a JRobin::String object, given a JRD file raw string.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    # fix_jrd_string will complain about modifying literal string if we pass a
    # literal string to new.  Copy it here to fix this.
    my $string = $_[0];

    my $self = [ fix_jrd_string($string), $string ];

    bless($self,$class);
    return $self;
}

=head2 fix_jrd_string

    my $string = fix_jrd_string ($string);

The JRD file strings have padding between their characters.  Each Letter
has a binary zero preceeding it.  This strips those characters.

=cut

sub fix_jrd_string {
    for(@_) {
        s/.(.)/$1/g;
        s/\s+$//;
    }
    return $_[0];
}

=head2 value

    my $string = $string->value;

Returns the string value directly.  This will usually not be needed because
overloading will take care of most access.

=cut

sub value {
    $_[0]->[0];
}


use overload (
    '""'    => sub { $_[0]->value },
    'eq' => sub {
        my $a = (UNIVERSAL::isa($_[0],__PACKAGE__)) ? $_[0]->value : $_[0];
        my $b = (UNIVERSAL::isa($_[1],__PACKAGE__)) ? $_[1]->value : $_[1];
        $a eq $b;
    },

    'ne' => sub {
        my $a = (UNIVERSAL::isa($_[0],__PACKAGE__)) ? $_[0]->value : $_[0];
        my $b = (UNIVERSAL::isa($_[1],__PACKAGE__)) ? $_[1]->value : $_[1];
        $a ne $b;
    },

);


1;

