use inc::Module::Install;

name     'RDF-RDFa-Template';
all_from 'lib/RDF/RDFa/Template.pm';
author   'Kjetil Kjernsmo <kjetilk@cpan.org>';
license  'perl';

test_requires 'Test::More';

sign;

auto_install;



WriteAll;

