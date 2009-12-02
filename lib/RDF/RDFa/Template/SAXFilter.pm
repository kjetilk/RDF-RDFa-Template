package RDF::RDFa::Template::SAXFilter;

use warnings;
use strict;

=head1 NAME

RDF::RDFa::Template::SAXFilter - A SAX Filter that does variable insertions and removes templates

=cut

use RDF::RDFa::Template::Unit;
use base qw(XML::SAX::Base);

use Data::Dumper;
use Carp;

sub new {
    my $class = shift;
    my %options = @_;
    $options{BaseURI} ||= './';	    
    return bless \%options, $class;
}

sub start_element {
  my ($self, $element) = @_;
  my %attrs = %{$element->{Attributes}};
  # TODO: doctype's
  unless ($element->{NamespaceURI} eq $self->{Doc}->{RATURI}) {
    $self->{Handler}->start_element($element);
  }
#  warn Dumper($element);
}

sub end_element {
  my ($self, $element) = @_;
  unless ($element->{NamespaceURI} eq $self->{Doc}->{RATURI}) {
    $self->{Handler}->end_element($element);
  }
}

=head1 SYNOPSIS



=head1 METHODS


=head1 AUTHOR

Kjetil Kjernsmo, C<< <kjetilk at cpan.org> >>


=head1 COPYRIGHT & LICENSE

Copyright 2009 Kjetil Kjernsmo.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
