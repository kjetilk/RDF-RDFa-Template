package RDF::RDFa::Template::Unit;

use warnings;
use strict;

=head1 NAME

RDF::RDFa::Template::Unit - An individual graph pattern of an RDFa Template

=cut


use RDF::Trine::Pattern;

sub new {
  my ($class, %args) = @_;
  use Data::Dumper;
 # die Dumper(\%args);
  my $self = {
	      PATTERN => RDF::Trine::Pattern->new(@{$args{triples}}),
	      ENDPOINT => $args{endpoint},
	      DOC_GRAPH => $args{doc_graph},
	     };

  bless ($self, $class);
  return $self;
}


=head1 SYNOPSIS

This class holds an individual graph pattern of an RDFa Template. This
has several elements, a Basic Graph Pattern, a query endpoint and a
graph name from the RDFa document.

  $doc = RDF::RDFa::Template::Unit->new(triples => \@triples,
                                        endpoint => 'http://dbpedia.org/sparql',
                                        doc_graph => 'http://example.org/graph'



=head1 METHODS


=cut

sub pattern {
  my $self = shift;
  return $self->{PATTERN};
}

sub endpoint {
  my ($self, $endpoint) = @_;
  if ($endpoint) {
    $self->{ENDPOINT} = $endpoint;
  }
  return $self->{ENDPOINT};
}

=head1 AUTHOR

Kjetil Kjernsmo, C<< <kjetilk at cpan.org> >>


=head1 COPYRIGHT & LICENSE

Copyright 2009 Kjetil Kjernsmo.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
