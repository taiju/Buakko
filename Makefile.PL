use inc::Module::Install;

name 'Buakko';
author 'taiju';
all_from 'lib/Buakko.pm';

requires 'Parse::RecDescent' => 1.967009;
requires 'Path::Class' => 0.26;

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';

auto_set_repository;

install_script('bin/buakko');

WriteAll;
