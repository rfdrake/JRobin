use inc::Module::Install;

name           'JRobin';
all_from       'lib/JRobin.pm';

requires       'Fcntl'  => '0.0';

test_requires q(Test::Most) => 0.25;
bugtracker q(https://github.com/rfdrake/JRobin/issues);
homepage q(http://search.cpan.org/dist/JRobin);
repository q(git://github.com/rfdrake/JRobin.git);
license 'perl';

auto_install;
WriteAll;

