use inc::Module::Install;

name     'RDF-RDFa-Template';
all_from 'lib/RDF/RDFa/Template.pm';
author   'Kjetil Kjernsmo <kjetilk@cpan.org>';
license  'perl';

requires 'RDF::RDFa::Parser' => 0.21;
requires 'RDF::Trine' => 0.112;
requires 'RDF::Query' => 2.0;
requires 'RDF::Query::Client';
requires 'XML::LibXML';
requires 'XML::SAX::Base';

test_requires 'Test::More' => 0.88;
test_requires 'Test::Exception';
test_requires 'File::Util';
test_requires 'Test::XML';

include 'Test::Signature';

sign;

auto_install;



WriteAll;

