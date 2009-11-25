package RDF::RDFa::Template::Document;

use warnings;
use strict;

=head1 NAME

RDF::RDFa::Template::Document - A parsed Template document

=cut

use RDF::RDFa::Template::Unit;
use RDF::RDFa::Parser;
use RDF::Trine::Model;
use RDF::Trine::Statement;
use RDF::Trine::Node::Variable;
use RDF::Trine::Pattern;
use Data::Dumper;
use Carp;

sub new {
  my $class = shift;
  my $self  = {
	       PARSED => shift,
	       UNITS  => {},
	       SUBURI => 'http://www.kjetil.kjernsmo.net/software/rat/substitutions#',
	       RATURI => 'http://www.kjetil.kjernsmo.net/software/rat/xmlns',
	      };
  bless ($self, $class);
  return $self;
}


=head1 SYNOPSIS

  my $storage = RDF::Trine::Store::DBI->temporary_store;
  my $parser = RDF::RDFa::Parser->new($storage, $xhtml, {}, 'http://example.com/foo');
  $parser->named_graphs('http://example.org/graph#', 'graph');
  $parser->consume;
  my $doc = RDF::RDFa::Template::Document->($parser);
  $doc->extract;

=head1 METHODS

This module inherits all methods of its superclass, including a
constructor which is reimplemented with an identical interface. In
addition, it implements the following methods:

=over

=item $doc->extract

Extracts the Basic Graph Patterns from the parsed document. Returns
the number of patterns extracted.

=item $doc->unit( $graph_name )

Returns a RDF::RDFa::Template::Unit for the specified graph name.

=item $doc->units

Returns an array of RDF::RDFa::Template::Unit objects

=cut

sub extract {
  my $self = shift;
  my $dom = $self->{PARSED}->dom;
  my $return = 0;
  my %units;
  my %graphs = %{$self->{PARSED}->graphs};
  while (my ($graph, $model) = each(%graphs)) {
    next if ($graph eq '_:RDFaDefaultGraph'); # We don't need the default graph

    my $baseuri = $self->{PARSED}->uri;
    my ($local_graph) = $graph =~ m/^$baseuri(.*?)$/;
    # TODO: Don't hardcode the graph node name or the rat prefix
    my $nodes = $dom->findnodes('//rat:graph[@g:graph = ' . "'$local_graph']"  ); 
    my @triples;
    my $iterator = $model->as_stream;
    while (my $statement = $iterator->next) {
      # Go through each statement to look for variables

      # First, lets check the object, which needs to be a XMLLiteral to be a variable
      my $object = $statement->object;
      if ($statement->object->isa('RDF::Trine::Node::Literal::XML')) {
	my $element = $statement->object->xml_element->firstChild; # TODO: Reliable?
	if ($element->isa('XML::LibXML::Node') 
	    && ($element->namespaceURI eq $self->{RATURI})
	    && ($element->localname eq 'variable')) {
	  # Now, we know that we have a variable
	  my $varname = $element->attributes->getNamedItem('name')->getValue();
	  if ($varname =~ m/^(\w*):(\w*)$/) {
	    my $prefix = $1;
	    my $localname = $2;
	    if ($dom->firstChild->lookupNamespaceURI($prefix) eq $self->{SUBURI}) {
	      $object = RDF::Trine::Node::Variable->new($localname);
	    } else {
	      carp "No variable found in the " . $element->nodeName . " field. Have you remember the $self->{SUBURI} namespace?";
	    }
	  }
	}
      }


      my $newstatement = RDF::Trine::Statement->new($self->_check_resource($statement->subject), 
						    $self->_check_resource($statement->predicate),
						    $object);
      push(@triples, $newstatement);
    }
    $return++;
    $units{$graph} = RDF::RDFa::Template::Unit->new(
			      triples => \@triples,
			      endpoint => $nodes->shift->attributes->getNamedItem('endpoint')->getValue,
			      doc_graph	=> $graph);
    $self->{UNITS} = \%units;
  }
  return $return;
}

sub unit {
  my ($self, $graph_name) = @_;
  return $self->{UNITS}->{$graph_name};
}

sub units {
  my $self = shift;
  return values(%{$self->{UNITS}});
}

sub _check_resource {
  my ($self, $resource) = @_;
  my $return = $resource;
  if ($resource->uri_value =~ m/^(\w*):(\w*)$/) {
    my $prefix = $1;
    my $localname = $2;
    if ($self->{PARSED}->dom->firstChild->lookupNamespaceURI( $prefix ) 
	eq $self->{SUBURI}) {
      $return = RDF::Trine::Node::Variable->new($localname);
    }
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
