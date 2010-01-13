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
    $options{_graphstack} = [];
    return bless \%options, $class;
}

sub start_element {
  my ($self, $element) = @_;
  my %attrs = %{$element->{Attributes}};
  # TODO: doctypes, RATURI method
  if ($element->{NamespaceURI} eq $self->{Doc}->{RATURI}) {
    if ($element->{LocalName} eq 'graph') {
      # This element should not be sent to the result document,
      # but its contents should be looped and variables substituted
      $self->{_currentgraph} = $element->{Attributes}->{'g:graph'}->{Value};
      die "couldn't find current graph name" unless $self->{_currentgraph}; # TODO: Fix, don't require hardcoding
      $self->{_results} = $self->{Doc}->unit($self->{Doc}->{PARSED}->uri . $self->{_currentgraph})->results; # TODO: PARSED method
    } elsif ($element->{LocalName} eq 'variable') {
      my ($var) = $element->{Attributes}->{name}->{Value} =~ m/sub:(\w+)/; # TODO: Don't hardcode sub-prefix
      my $binding = $self->{_results}->binding_value_by_name($var);
      $self->SUPER::characters({Data => $binding}); # TODO: I get a literal, not just a simple string;
    }
  } elsif ($element->{Attributes}->{about} 
	   && ($element->{Attributes}->{about}->{Value} eq 'sub:resource')) { # TODO: coded to the test
    my $uri = $self->{_results}->binding_value_by_name('resource');
    $uri =~ s/^<(.*)>$/$1/;
    $element->{Attributes}->{about}->{Value} = $uri;
    $self->SUPER::start_element($element);
  } else {
    $self->SUPER::start_element($element);
  }
#  warn Dumper($element);
}

sub end_element {
  my ($self, $element) = @_;
  if ($element->{NamespaceURI} eq $self->{Doc}->{RATURI}) {
    if ($element->{LocalName} eq 'graph') {
      $self->{_currentgraph} = undef;
      $self->{_results} = undef;
    }
  } else {
    $self->SUPER::end_element($element);
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
