use inc::Module::Install;

name     'RDF-RDFa-Template';
all_from 'lib/RDF/RDFa/Template.pm';
author   'Kjetil Kjernsmo <kjetilk@cpan.org>';
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

