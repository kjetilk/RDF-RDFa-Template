use inc::Module::Install;

name     'RDF-RDFa-Template';
all_from 'lib/RDF/RDFa/Template.pm';
author   'Kjetil Kjernsmo <kjetilk@cpan.org>';
license  'perl';

requires 'RDF::RDFa::Parser' => 0.21;
requires 'RDF::Trine' => 0.111;

test_requires 'Test::More';
test_requires 'Test::Exception';

include 'Test::Signature';

sign;

auto_install;



WriteAll;

