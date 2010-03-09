package RDF::RDFa::Template::SimpleQuery;

use warnings;
use strict;

=head1 NAME

RDF::RDFa::Template::SimpleQuery - Takes a Document and runs its BGP as a query

=cut

use RDF::RDFa::Template::Unit;
use RDF::RDFa::Template::Document;
use RDF::RDFa::Template::SAXFilter;
use RDF::Trine::Model;
use RDF::Trine::Statement;
use RDF::Trine::Node::Variable;
use RDF::Trine::Pattern;
use RDF::RDFa::Parser;
use RDF::Query::Client;
use XML::LibXML;
use XML::LibXML::SAX::Generator;

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

  my $storage = RDF::Trine::Store::Memory->temporary_store;
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
  $self->{DOC} = RDF::RDFa::Template::Document->new($parser);
  $self->{DOC}->extract;

  my $return = 0;
#  die Dumper($doc->units);
  foreach my $unit ($self->{DOC}->units) {
    my $query = 'SELECT * WHERE { ' . $unit->pattern->as_sparql . ' }';
    my $model = $self->{MODEL};
    my $client;
    if ($unit->endpoint) {
      $client = RDF::Query::Client->new($query);
      $model = $unit->endpoint;
    } elsif ($self->{MODEL} && ($self->{MODEL}->isa('RDF::Query::Model'))) {
      $client = RDF::Query->new($query);
    } else {
      croak "Need either an endpoint or an RDF::Query::Model";
    }
    my $iterator = $client->execute( $model );

    $unit->results($iterator);
    $return++;
  }
  return $return;
}


sub rdfa_xhtml {
  my $self = shift;
 use XML::LibXML::SAX::Builder;
  my $builder = XML::LibXML::SAX::Builder->new();
  my $filter = RDF::RDFa::Template::SAXFilter->new(Handler => $builder, Doc => $self->{DOC});
  my $driver = XML::LibXML::SAX::Generator->new(Handler => $filter);

  # generate SAX events that are captured
  # by a SAX Handler or Filter.
  $driver->generate($self->{DOC}->dom);
  return $builder->result;
}

  


=head1 AUTHOR

Kjetil Kjernsmo, C<< <kjetilk at cpan.org> >>


=head1 COPYRIGHT & LICENSE

Copyright 2009 Kjetil Kjernsmo.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
