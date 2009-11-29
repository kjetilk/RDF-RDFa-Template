package RDF::RDFa::Template::SimpleQuery;

use warnings;
use strict;

=head1 NAME

RDF::RDFa::Template::SimpleQuery - Takes a Document and runs its BGP as a query

=cut

use RDF::RDFa::Template::Unit;
use RDF::RDFa::Template::Document;
use RDF::Trine::Model;
use RDF::Trine::Statement;
use RDF::Trine::Node::Variable;
use RDF::Trine::Pattern;
use RDF::RDFa::Parser;
use RDF::Query::Client;
use Data::Dumper;
use Carp;

sub new {
  my $class = shift;
  my $self  = {
	       XHTML => shift,
	      };
  bless ($self, $class);
  return $self;
}


=head1 SYNOPSIS

This module takes a RDF::RDFa::Template::Document and takes the RDF::RDFa::Template::Units it provides and run them against the endpoints.

  my $storage = RDF::Trine::Store::DBI->temporary_store;
  my $parser = RDF::RDFa::Parser->new($storage, $xhtml, {}, 'http://example.com/foo');
  $parser->named_graphs('http://example.org/graph#', 'graph');
  $parser->consume;
  my $doc = RDF::RDFa::Template::Document->new($parser);
  $doc->extract;
  my $query = RDF::RDFa::Template::SimpleQuery->new($doc);
  $query->execute;
  my $output = $query->rdfa_xhtml;

=head1 METHODS

=cut

sub execute {
  my $self = shift;
  my $parser = RDF::RDFa::Parser->new($self->{XHTML}, 'http://example.org/foo/', {use_rtnlx => 1});
  $parser->named_graphs('http://example.org/graph#', 'graph');
  $parser->consume;
  my $doc = RDF::RDFa::Template::Document->new($parser);
  $doc->extract;

  my $return = 0;
#  die Dumper($doc->units);
  foreach my $unit ($doc->units) {
    my $client = RDF::Query::Client->new(
		      'SELECT * WHERE { ' . $unit->pattern->as_sparql . ' }'
				       );
    my $iterator = $client->execute($unit->endpoint);
    $unit->results($iterator);
    $return++;
  }
  return $return;
}



=head1 AUTHOR

Kjetil Kjernsmo, C<< <kjetilk at cpan.org> >>


=head1 COPYRIGHT & LICENSE

Copyright 2009 Kjetil Kjernsmo.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
