use strict;
use warnings;
use lib qw(lib);
use Test::More;
plan tests => 7;
use JRobin;

my $jrobin = JRobin->new('t/data/ifInOctets.jrb');
my $archive = $jrobin->dump_archive;

is($archive->[0]->{value}, '241.096348491538', 'archive 0 value correct?');
is($archive->[0]->{time}, '1430944500', 'archive 0 time correct?');
is(scalar @$archive, 2016, 'is the archive the right size?');
is($archive->[2015]->{value}, '166.300332225914', 'is the last value correct?');
is($archive->[2015]->{time}, '1431549000', 'is the last time correct?');
is($jrobin->dump_archive( { datasource => 13 } ), -1, 'Asking for invalid datasource returns -1');
is($jrobin->dump_archive( archive => 13 ), -1, 'Asking for invalid archive returns -1');

