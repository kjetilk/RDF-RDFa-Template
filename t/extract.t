use Test::More;
use Test::Exception;

use_ok('RDF::RDFa::Template::Document');
use_ok('RDF::RDFa::Template::SimpleQuery');
use_ok('RDF::RDFa::Parser');
use_ok('RDF::Trine');
use_ok('RDF::Trine::Store');


ok(open(INPUT, "< data/dbpedia-comment.input.xhtml"), "open input XHTML");
my @data = <INPUT>;
close INPUT;

my $xhtml = join('', @data);

#die $xhtml;
ok(defined($xhtml), "Got data");


my $parser = RDF::RDFa::Parser->new($xhtml, 'http://example.org/dbpedia-comment/', {use_rtnlx => 1});
isa_ok($parser, 'RDF::RDFa::Parser');

ok($parser->named_graphs('http://example.org/graph#', 'graph'), "Graph named");

ok($parser->consume, "Graph consumed");


my $doc = RDF::RDFa::Template::Document->new($parser);

isa_ok($doc, 'RDF::RDFa::Template::Document');

ok($doc->extract, "RDFa templates extracted");

  
{
  my $unit = $doc->unit('http://example.org/dbpedia-comment/query1');

  isa_ok($unit, 'RDF::RDFa::Template::Unit');

  ok($unit->endpoint eq 'http://dbpedia.org/sparql', "Correct endpoint");
  isa_ok($unit->pattern, 'RDF::Query::Algebra::BasicGraphPattern');

  ok($unit->pattern->as_sparql eq '?resource <http://www.w3.org/2000/01/rdf-schema#label> "Resource Description Framework"@en .
?resource <http://www.w3.org/2000/01/rdf-schema#comment> ?comment .', "SPARQL BGP Matches") || diag $unit->pattern->as_sparql;
  dies_ok{$unit->results('foo')} 'Should croak on string';
  is_deeply($unit->results, {}, "Returns empty hashref");
  
}

foreach my $unit ($doc->units) {
  isa_ok($unit, 'RDF::RDFa::Template::Unit');
}




done_testing();