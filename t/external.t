use strict;
use Test::More;

unless ($ENV{NETWORK_TESTS}) {
  plan skip_all => 'Set $ENV{NETWORK_TESTS} to enable tests against external SPARQL endpoints';
}
else {
  plan => 7;
}

use Test::XML;
use FindBin qw($Bin);
use File::Util;
my($f) = File::Util->new();

my $datadir = $Bin . '/data/';
use_ok('RDF::RDFa::Template::SimpleQuery');

# Get and parse the XHTML
my ($rat) = $f->load_file($datadir . 'dbpedia-mustang-range.input.xhtml');

is_well_formed_xml($rat, "Input RDFa Template document is well-formed");

my ($rdfa) = $f->load_file($datadir . 'dbpedia-mustang-range.expected.xhtml');

is_well_formed_xml($rdfa, "Got the expected RDFa document");

my $query = RDF::RDFa::Template::SimpleQuery->new(rat => $rat);

isa_ok($query, 'RDF::RDFa::Template::SimpleQuery');
ok($query->execute, "Query executed successfully");


my $output = $query->rdfa_xhtml;
isa_ok($output, 'XML::LibXML::Document');

TODO: {
  local $TODO = "External needs to work";
  is_xml($output->toStringEC14N, $rdfa, "The output is the expected RDFa");
}
done_testing();
