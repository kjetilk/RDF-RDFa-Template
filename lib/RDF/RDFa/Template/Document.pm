package RDF::RDFa::Template::Document;

use warnings;
use strict;

=head1 NAME

RDF::RDFa::Template::Document - A parsed Template document

=cut

use RDF::RDFa::Parser::Trine;
use RDF::Trine::Model;

sub new {
  my $class = shift;
  my $self  = {
	       PARSED => shift,
	       UNITS  => {},
	      };
  bless ($self, $class);
  return $self;
}


=head1 SYNOPSIS

  my $storage = RDF::Trine::Store::DBI->temporary_store;
  my $parser = RDF::RDFa::Parser::Trine->new($storage, $xhtml, 'http://example.com/foo');
  $parser->named_graphs('http://example.org/graph#', 'graph');
  $parser->consume;
  my $doc = RDF::RDFa::Template::Document->($parser);


=head1 METHODS

This module inherits all methods of its superclass, including a constructor which is reimplemented with an identical interface. In addition, it implements the following methods:

=over

=item $doc->unit( $graph_name )

Returns a RDF::RDFa::Template::Unit for the specified graph name.

=cut

sub extract {
  my $self = shift;
  my $dom = $self->{PARSED}->dom;
  my $return = 0;
  while (my ($graph, $model) = each(%{$self->{PARSED}->graphs})) {
    next if ($graph eq '_:RDFaDefaultGraph'); # We don't need the default graph
    my $nodes = $dom->findnodes('//rat:graph'); #[@g:graph = ' . $self->{PARSED}->named_grap );

    die $nodes->shift->toString;
    $return = 1;
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
