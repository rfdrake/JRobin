package JRobin::String;

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw ( fix_jrd_string );

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;

    my $self = {};
    $self->{string} = fix_jrd_string($_[0]);
    $self->{uncorrected_string} = $_[0];

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

sub value {
    $_[0]->{string};
}


use overload (
    '""'    => sub { $_[0]->{string} },
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

