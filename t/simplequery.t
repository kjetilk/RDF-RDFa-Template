use Test::More;

use_ok('RDF::RDFa::Template::SimpleQuery');

TODO: {
  local $TODO = 'Not implemented';
  my $query = RDF::RDFa::Template::SimpleQuery->new($doc);
  isa_ok($query, 'RDF::RDFa::Template::SimpleQuery');
  ok($query->execute, "Query executed successfully");
  my $output = $query->rdfa_xhtml;
  isa_ok($output, 'XML::LibXML::Document');

}

done_testing();
