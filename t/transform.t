use Test::More;

use_ok('RDF::RDFa::Template::Document');
use_ok('RDF::RDFa::Parser');
use_ok('RDF::Trine');
use_ok('RDF::Trine::Store');


ok(open(INPUT, "< data/dbpedia-comment.input.xhtml"), "open input XHTML");
my @data = <INPUT>;
close INPUT;

my $xhtml = join('', @data);

#die $xhtml;
ok(defined($xhtml), "Got data");


my $storage = RDF::Trine::Store->temporary_store;


my $parser = RDF::RDFa::Parser->new($xhtml, 'http://example.org/dbpedia-comment/', {}, $storage);
isa_ok($parser, 'RDF::RDFa::Parser');

ok($parser->named_graphs('http://example.org/graph#', 'graph'), "Graph named");

ok($parser->consume, "Graph consumed");


my $doc = RDF::RDFa::Template::Document->new($parser);

isa_ok($doc, 'RDF::RDFa::Template::Document');

ok($doc->extract, "RDFa templates extracted");

TODO: {
  local $TODO = 'Not implemented';
  

  my $unit = $doc->unit('http://example.org/dbpedia-comment/query1');

  isa_ok($unit, 'RDF::RDFa::Template::Unit');

  ok($unit->endpoint eq 'http://dbpedia.org/sparql', "Correct endpoint");
  isa_ok($unit->pattern, 'RDF::Trine::Pattern');

}
done_testing();
