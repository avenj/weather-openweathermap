package Weather::OpenWeatherMap::Request::Find;

use Carp;
use URI::Escape 'uri_escape_utf8';
use Types::Standard -all;

use namespace::clean; use Moo;
extends 'Weather::OpenWeatherMap::Request';

has max => (
  lazy      => 1,
  is        => 'ro',
  isa       => Int,
  builder   => sub { 10 },
);


sub _url_bycode {
  my ($self, $code) = @_;
  ## FIXME better error handling here, cannot find on a city code
  carp "Find does not support city codes";
  return ''
}

sub _url_bycoord {
  my $self = shift;
  my ($lat, $long) = map {; uri_escape_utf8($_) } @_;
  "http://api.openweathermap.org/data/2.5/find?lat=$lat&lon=$long"
    . '&units=' . $self->_units
    . '&cnt='   . $self->max
}

sub _url_byname {
  my ($self, @parts) = @_;
  'http://api.openweathermap.org/data/2.5/find?q='
    . join(',', map {; uri_escape_utf8($_) } @parts)
    . '&units=' . $self->_units
    . '&cnt='   . $self->max
}

1;

=head1 NAME

Weather::OpenWeatherMap::Request::Find

=head1 SYNOPSIS

  # Usually created by Weather::OpenWeatherMap
  use Weather::OpenWeatherMap::Request::Find;
  my $request = Weather::OpenWeatherMap::Request::Find->new(
    tag       => 'foo',
    location  => 'Manchester',
    max       => 5,
  );

  my $http_request_obj = $request->http_request;

=head1 DESCRIPTION

A L<Weather::OpenWeatherMap::Request> subclass for building a city search
request.

=head1 ATTRIBUTES

=head3 max

The maximum number of results to ask for.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Licensed under the same terms as Perl.
