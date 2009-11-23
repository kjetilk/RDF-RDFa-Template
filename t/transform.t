use Test::More;

use_ok('RDF::RDFa::Template::Document');
use_ok('RDF::RDFa::Parser::Trine');
use_ok('RDF::Trine');
use_ok('RDF::Trine::Store');


ok(open(INPUT, "< data/dbpedia-comment.input.xhtml"), "open input XHTML");
my @data = <INPUT>;
close INPUT;

my $xhtml = join('', @data);

#die $xhtml;
ok(defined($xhtml), "Got data");


my $storage = RDF::Trine::Store->temporary_store;


my $parser = RDF::RDFa::Parser::Trine->new($storage, $xhtml, 'http://example.org/dbpedia-comment/');
isa_ok($parser, 'RDF::RDFa::Parser::Trine');

ok($parser->named_graphs('http://example.org/graph#', 'graph'), "Graph named");

ok($parser->consume, "Graph consumed");

die "huh";
my $doc = RDF::RDFa::Template::Document->new($parser);

isa_ok($doc, 'RDF::RDFa::Template::Document');


TODO: {
  local $TODO = 'Not implemented';

  ok($doc->extract, "RDFa templates extracted");
  
  isa_ok($doc->dom, 'XML::LibXML::Document');
  my $unit = $doc->unit('http://example.org/dbpedia-comment/query1');

  isa_ok($unit, 'RDF::RDFa::Template::Unit');

  ok($unit->endpoint eq 'http://dbpedia.org/sparql', "Correct endpoint");
  isa_ok($unit->pattern, 'RDF::Trine::Pattern');

}
done_testing();
