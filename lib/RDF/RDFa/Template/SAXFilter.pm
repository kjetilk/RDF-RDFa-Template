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
    $options{_is_in_graph} = 0;
    $options{_currentgraph} = undef;
    return bless \%options, $class;
}


sub start_element {
  my ($self, $element) = @_;
  # TODO: Qnames shouldn't be required.
  if ($element->{Attributes}->{'rat:doctype-system'}) {
    $self->SUPER::doctype_decl($element->{Attributes}->{'rat:doctype-system'}->{Value});
    delete $element->{Attributes}->{'rat:doctype-system'};
  }
  if ($element->{Attributes}->{'rat:doctype-public'}) {
    $self->SUPER::doctype_decl($element->{Attributes}->{'rat:doctype-public'}->{Value});
    delete $element->{Attributes}->{'rat:doctype-public'};
  }
  if ($element->{Attributes}->{'xmlns:rat'}) {
    delete $element->{Attributes}->{'xmlns:rat'};
  }
  if ($element->{Attributes}->{'xmlns:sub'}) {
    delete $element->{Attributes}->{'xmlns:sub'};
  }
  if ($element->{Attributes}->{'xmlns:g'}) {
    delete $element->{Attributes}->{'xmlns:g'};
  }
  if ($element->{Attributes}->{'datatype'}) {
    $self->{_element_with_datatype} = $element;
  }
  # TODO: RATURI method
  if ($element->{NamespaceURI} eq $self->{Doc}->{RATURI}) {
    if ($element->{LocalName} eq 'graph') {
      # This element should not be sent to the result document,
      # but its contents should be looped and variables substituted
      $self->{_currentgraph} = $element->{Attributes}->{'g:graph'}->{Value}; # TODO: Fix, don't require hardcoding
      if (defined($self->{_currentgraph})) {
	$self->{_is_in_graph} = 1;
      }
      die "couldn't find current graph name" unless $self->{_currentgraph};
      $self->{_results} = $self->{Doc}->unit($self->{Doc}->{PARSED}->uri . $self->{_currentgraph})->results; # TODO: PARSED method
    } elsif ($element->{LocalName} eq 'variable') {
      delete $self->{_element_with_datatype}->{Attributes}->{datatype};
      my ($var) = $element->{Attributes}->{name}->{Value} =~ m/sub:(\w+)/; # TODO: Don't hardcode sub-prefix
      my $binding = $self->{_results}->binding_value_by_name($var);
      my %attrs = %{$self->{_element_with_datatype}->{Attributes}};
      if ($binding->has_language) {
	$attrs{'http://www.w3.org/XML/1998/namespace}lang'} = 
	                   {'LocalName' => 'lang',
			    'Prefix' => 'xml',
			    'Value' => $binding->literal_value_language,
			    'Name' => 'xml:lang',
			    'NamespaceURI' => 'http://www.w3.org/XML/1998/namespace'};
      }
      if ($binding->has_datatype) {
	$attrs{'datatype'} = { 'LocalName' => 'datatype',
                               'Prefix' => '',
                               'Value' => $binding->literal_value_datatype,
                               'Name' => 'datatype',
                               'NamespaceURI' => undef
			     }
      }
      $self->{_element_with_datatype}->{Attributes} = \%attrs;
      $self->SUPER::start_element($self->{_element_with_datatype});
      $self->SUPER::characters({Data => $binding->literal_value});
    }
  } elsif ($self->{_is_in_graph} && $element->{Attributes}->{about} 
	   && ($element->{Attributes}->{about}->{Value} =~ m/sub:(\w+)/)) {
    my $uri = $self->{_results}->binding_value_by_name($1);
    $uri =~ s/^<(.*)>$/$1/;
    $element->{Attributes}->{about}->{Value} = $uri;
    $self->SUPER::start_element($element);
  } elsif ($self->{_element_with_datatype}) {
    unless ($element->{Attributes}->{'datatype'}) {
      $self->{_element_with_datatype} = undef;
    }
  } elsif ($self->{_is_in_graph}) {
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
      # Then, reset everything
      $self->{_currentgraph} = undef;
      $self->{_is_in_graph} = 0;
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
