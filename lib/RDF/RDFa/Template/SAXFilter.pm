package RDF::RDFa::Template::Document;

use warnings;
use strict;

=head1 NAME

RDF::RDFa::Template::SAXFilter - A SAX Filter that does variable insertions and removes templates

=cut

use RDF::RDFa::Template::Unit;
use base qw(XML::Filter::Base);

use Data::Dumper;
use Carp;

sub new {
    my $class = shift;
    my %options = @_;
    $options{BaseURI} ||= './';	    
    $options{SUBURI} = 'http://www.kjetil.kjernsmo.net/software/rat/substitutions#';
    $options{RATURI} = 'http://www.kjetil.kjernsmo.net/software/rat/xmlns';  
    return bless \%options, $class;
}

sub start_element {
  my ($self, $element) = @_;
  my %attrs = %{$element->{Attributes}};


# sub new {
#   my $class = shift;
#   my $self  = {
# 	       PARSED => shift,
# 	       UNITS  => {},
# 	       SUBURI => 'http://www.kjetil.kjernsmo.net/software/rat/substitutions#',
# 	       RATURI => 'http://www.kjetil.kjernsmo.net/software/rat/xmlns',
# 	      };
#   bless ($self, $class);
#   return $self;
# }


=head1 SYNOPSIS

  my $storage = RDF::Trine::Store::DBI->temporary_store;
  my $parser = RDF::RDFa::Parser->new($storage, $xhtml, {}, 'http://example.com/foo');
  $parser->named_graphs('http://example.org/graph#', 'graph');
  $parser->consume;
  my $doc = RDF::RDFa::Template::Document->($parser);
  $doc->extract;

=head1 METHODS


=head1 AUTHOR

Kjetil Kjernsmo, C<< <kjetilk at cpan.org> >>


=head1 COPYRIGHT & LICENSE

Copyright 2009 Kjetil Kjernsmo.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
