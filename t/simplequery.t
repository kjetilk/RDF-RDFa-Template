use Test::More;

use_ok('RDF::RDFa::Template::SimpleQuery');

ok(open(INPUT, "< data/dbpedia-comment.input.xhtml"), "open input XHTML");
my @data = <INPUT>;
close INPUT;

my $xhtml = join('', @data);

#die $xhtml;
ok(defined($xhtml), "Got data");



  my $query = RDF::RDFa::Template::SimpleQuery->new($xhtml);
  isa_ok($query, 'RDF::RDFa::Template::SimpleQuery');
  ok($query->execute, "Query executed successfully");



TODO: {
  local $TODO = 'Not implemented';

  my $output = $query->rdfa_xhtml;
  isa_ok($output, 'XML::LibXML::Document');

}

done_testing();
