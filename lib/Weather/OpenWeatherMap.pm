package Weather::OpenWeatherMap;

use strictures 1;
use Carp;

use LWP::UserAgent;

use Types::Standard -all;


use Weather::OpenWeatherMap::Error;
use Weather::OpenWeatherMap::Request;
use Weather::OpenWeatherMap::Result;


use Moo; use MooX::late;

has api_key => (
  lazy      => 1,
  is        => 'ro',
  isa       => Str,
  predicate => 1,
  builder   => sub { '' },
);

has ua => (
  is        => 'ro',
  isa       => InstanceOf['LWP::UserAgent'],
  builder   => sub { LWP::UserAgent->new },
);


sub get_weather {
  my ($self, %args) = @_;

  croak "Missing 'location =>' in query" unless $args{location};

  my $type = $args{forecast} ? 'Forecast' : 'Current';
  my $my_request = Weather::OpenWeatherMap::Request->new_for(
    $type => 
      (
        $self->has_api_key && length $self->api_key ?
          ( api_key => $self->api_key ) : ()
      ),
      %args
  );

  my $http_response = $self->ua->request( $my_request->http_request );

  unless ($http_response->is_success) {
    die Weather::OpenWeatherMap::Error->new(
      request => $my_request,
      source  => 'http',
      status  => $http_response->status_line,
    );
  }

  my $result = Weather::OpenWeatherMap::Result->new_for(
    $type =>
      request => $my_request,
      json    => $http_response->content
  );

  unless ($result->is_success) {
    die Weather::OpenWeatherMap::Error->new(
      request => $my_request,
      source  => 'api',
      status  => $result->error,
    )
  }

  $result
}


1;

# vim: ts=2 sw=2 et sts=2 ft=perl
