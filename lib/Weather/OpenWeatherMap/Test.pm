package Weather::OpenWeatherMap::Test;

=pod

=for Pod::Coverage .*

=cut

use v5.10;
use strictures 1;
use Carp;

use Path::Tiny;

use File::ShareDir 'dist_dir', 'dist_file';

use parent 'Exporter::Tiny';
our @EXPORT = our @EXPORT_OK = qw/
  get_test_data
  mock_http_ua
/;

our $JSON_Current = path(
    dist_file( 'Weather-OpenWeatherMap', 'current.json' )
  )->slurp_utf8;
our $JSON_Forecast = path(
    dist_file( 'Weather-OpenWeatherMap', '3day.json' )
  )->slurp_utf8;


sub get_test_data {
  my $type = lc (shift || return);
  for ($type) {
    return $JSON_Current
      if $type eq 'current';

    return $JSON_Forecast
      if $type eq '3day'
      or $type eq 'forecast';
  }

  confess "Unknown type $type"
}

{ package
    Weather::OpenWeatherMap::Test::MockUA;
  use strict; use warnings FATAL => 'all';
  require HTTP::Response;
  use parent 'LWP::UserAgent';
  sub requested_count { my ($self) = @_; $self->{'__requested'} }
  sub request {
    my ($self, $http_request) = @_;
    my $url = $http_request->uri;
    $self->{'__requested'} ? 
      ++$self->{'__requested'} : ($self->{'__requested'} = 1);
    return $url =~ /forecast/ ?
      HTTP::Response->new(
        200 => undef => [] => $self->{forecast_json},
      )
      : HTTP::Response->new(
        200 => undef => [] => $self->{current_json},
      )
  }
}

sub mock_http_ua {
  return bless +{
    forecast_json => get_test_data('forecast'),
    current_json  => get_test_data('current'),
  }, 'Weather::OpenWeatherMap::Test::MockUA'
}

1;
