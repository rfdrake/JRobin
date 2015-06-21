use lib qw(lib);
use Test::More;
plan tests => 18;
use JRobin;


my $jrobin = new JRobin('t/data/ifInOctets.jrb');

is($jrobin->{header}->signature, 'JRobin, version 0.1', 'Is the JRobin signature correct?');
cmp_ok($jrobin->{header}->step, '==', 300, 'is step correct?');
cmp_ok($jrobin->{header}->arcCount, '==', 5, 'is arcCount correct?');
is($jrobin->{header}->lastUpdateTime, '1431549031', 'is lastUpdateTime correct?');
is($jrobin->{ds}->[0]->dsName, 'ifInOctets', 'is dsName correct?');
is($jrobin->{ds}->[0]->dsType, 'COUNTER', 'is dsType correct?');
cmp_ok($jrobin->{ds}->[0]->heartbeat, '==', 600, 'is heartbeat correct?');
cmp_ok($jrobin->{ds}->[0]->minValue, '==', nan, 'is minValue correct?');
cmp_ok($jrobin->{ds}->[0]->lastValue, '==', 108100581, 'is lastValue correct?');
my $archive = $jrobin->ds->[0]->archive->[0];
is($archive->consolFun, 'AVERAGE', 'is consolFun correct?');
cmp_ok($archive->xff, '==', 0.5, 'is xff correct?');
cmp_ok($archive->steps, '==', 1, 'is steps correct?');
cmp_ok($archive->rows, '==', 2016, 'is rows correct?');
cmp_ok($archive->arcState->accumValue, '==', nan, 'is accumValue correct?');
cmp_ok($archive->arcState->nanSteps, '==', 0, 'is nanSteps correct?');
my $ptr = $archive->robins->{ptr};

cmp_ok($ptr, '==', 1495, 'is ptr correct?');
cmp_ok($archive->robins->{values}->[$ptr], '==', 241.096348491538, 'is first value correct?');
my $steps = $jrobin->get_steps(0, 0);

my $start_time = $jrobin->get_start_time($steps, $archive->rows);
cmp_ok($start_time, '==', 1430944500, 'is start time correct?');

