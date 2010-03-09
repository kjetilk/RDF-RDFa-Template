
use strict;
use Test::More;
use Test::XML;
use FindBin qw($Bin);
use File::Util;
my($f) = File::Util->new();

my $datadir = $Bin . '/data/';

use_ok('RDF::RDFa::Template::SimpleQuery');

# Get and parse the XHTML
my ($rat) = $f->load_file($datadir . 'dbpedia-comment.input.xhtml');

is_well_formed_xml($rat, "Input RDFa Template document is well-formed");



my $query = RDF::RDFa::Template::SimpleQuery->new($rat);
isa_ok($query, 'RDF::RDFa::Template::SimpleQuery');
ok($query->execute, "Query executed successfully");

my ($rdfa) = $f->load_file($datadir . 'dbpedia-comment.expected.xhtml');

is_well_formed_xml($rdfa, "Got the expected RDFa document");




TODO: {
  local $TODO = 'Not implemented';

  my $output = $query->rdfa_xhtml;
  isa_ok($output, 'XML::LibXML::Document');
  is_xml($output->toStringEC14N, $rdfa, "The output is the expected RDFa");
}

done_testing();
