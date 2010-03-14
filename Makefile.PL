use inc::Module::Install;

name     'RDF-RDFa-Template';
all_from 'lib/RDF/RDFa/Template.pm';
author   'Kjetil Kjernsmo <kjetilk@cpan.org>';
license  'perl';
readme_from 'lib/RDF/RDFa/Template/SimpleQuery.pm';


requires 'RDF::RDFa::Parser' => 0.21;
requires 'RDF::Trine' => 0.114;
requires 'RDF::Trine::Node::Literal::XML';
requires 'RDF::Query' => 2.0;
requires 'RDF::Query::Client';
requires 'XML::LibXML';
requires 'XML::SAX::Base';
requires 'XML::LibXML::SAX::Builder';
requires 'XML::LibXML::SAX::Generator';
requires 'File::Util';


test_requires 'Test::More' => 0.88;
test_requires 'Test::Exception';
test_requires 'Test::XML';

include 'Test::Signature';

auto_set_repository;
auto_set_bugtracker;

homepage 'http://www.kjetil.kjernsmo.net/software/rat/';
write_doap_changes;


sign;

auto_install;



WriteAll;

