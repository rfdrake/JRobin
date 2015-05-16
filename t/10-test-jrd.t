use lib qw(lib);
use Test::More;
plan tests => 18;
use JRobin;


my $jrobin = new JRobin('t/data/ifInOctets.jrb');

is($jrobin->{header}->signature, 'JRobin, version 0.1', 'Is the JRobin signature correct?');
is($jrobin->{header}->step, '300', 'is step correct?');
is($jrobin->{header}->arcCount, '5', 'is arcCount correct?');
is($jrobin->{header}->lastUpdateTime, '1431549031', 'is lastUpdateTime correct?');
is($jrobin->{ds}->[0]->dsName, 'ifInOctets', 'is dsName correct?');
is($jrobin->{ds}->[0]->dsType, 'COUNTER', 'is dsType correct?');
is($jrobin->{ds}->[0]->heartbeat, '600', 'is heartbeat correct?');
is($jrobin->{ds}->[0]->minValue, nan, 'is minValue correct?');
is($jrobin->{ds}->[0]->lastValue, '108100581', 'is lastValue correct?');
is($jrobin->{archive}->[0]->consolFun, 'AVERAGE', 'is consolFun correct?');
is($jrobin->{archive}->[0]->xff, 0.5, 'is xff correct?');
is($jrobin->{archive}->[0]->steps, 1, 'is steps correct?');
is($jrobin->{archive}->[0]->rows, 2016, 'is rows correct?');
is($jrobin->{archive}->[0]->arcState->accumValue, nan, 'is accumValue correct?');
is($jrobin->{archive}->[0]->arcState->nanSteps, 0, 'is nanSteps correct?');
my $ptr = $jrobin->{archive}->[0]->robins->{ptr};

is($ptr, 1495, 'is ptr correct?');
is($jrobin->{archive}->[0]->robins->{values}->[$ptr], '241.096348491538', 'is first value correct?');
my $steps = $jrobin->get_steps(0);

my $start_time = $jrobin->get_start_time($steps, $jrobin->archive->[0]->rows);
is($start_time, 1430944500, 'is start time correct?');

