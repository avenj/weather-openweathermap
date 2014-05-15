package Weather::OpenWeatherMap::Result::Find;

use v5.10;
use Carp;
use strictures 1;

use Types::Standard      -all;
use List::Objects::Types -all;

use Weather::OpenWeatherMap::Result::Current;


use Moo; use MooX::late;
extends 'Weather::OpenWeatherMap::Result';


has message => (
  lazy    => 1,
  is      => 'ro',
  isa     => Str,
  builder => sub { shift->data->{message} // '' },
);
sub search_type { shift->message }


has _list => (
  init_arg => 'list',
  lazy    => 1,
  is      => 'ro',
  isa     => TypedArray[
    InstanceOf['Weather::OpenWeatherMap::Result::Current']
  ],
  coerce  => 1,
  builder => sub {
    my ($self) = @_;
    my @list = @{ $self->data->{list} || [] };
    map {; 
      Weather::OpenWeatherMap::Result::Current->new(
        request => $self->request,
        json    => $_,
      )
    } @list
  },
);

sub count    { shift->_list->count }
sub list     { shift->_list->all }
sub as_array { shift->_list->copy }
sub iter     { shift->_list->natatime(1) }


1;
