package Weather::OpenWeatherMap::Result::Forecast::Hour;

use strictures 2;

use Types::Standard      -all;
use Types::DateTime      -all;
use List::Objects::Types -all;

use Weather::OpenWeatherMap::Units -all;

use Moo; use MooX::late;
extends 'Weather::OpenWeatherMap::Result::Forecast::Block';

has dt_txt => (
  lazy        => 1,
  is          => 'ro',
  isa         => Str,
  builder     => sub { '' }, 
);

has _main => (
  init_arg    => 'main',
  required    => 1,
  is          => 'ro',
  isa         => HashObj,
  coerce      => 1,
);

has temp => (
  lazy      => 1,
  is        => 'ro',
  isa       => CoercedInt,
  coerce    => 1,
  builder   => sub { shift->_main->{temp} },
);

has humidity => (
  lazy      => 1,
  is        => 'ro',
  isa       => CoercedInt,
  coerce    => 1,
  builder   => sub { shift->_main->{humidity} },
);

has pressure => (
  lazy      => 1,
  is        => 'ro',
  isa       => StrictNum,
  coerce    => 1,
  builder   => sub { shift->_main->{pressure} },
);


has _wind => (
  init_arg    => 'wind',
  lazy        => 1,
  is          => 'ro',
  isa         => HashObj,
  coerce      => 1,
  builder     => sub {
    +{ speed => 0, deg => 0 }
  },
);

has wind_speed_mph => (
  lazy        => 1,
  is          => 'ro',
  isa         => CoercedInt,
  coerce      => 1,
  builder     => sub { shift->_wind->{speed} // 0 },
);

has wind_speed_kph => (
  lazy        => 1,
  is          => 'ro',
  isa         => CoercedInt,
  coerce      => 1,
  builder     => sub { mph_to_kph shift->wind_speed_mph },
);

has wind_direction => (
  lazy        => 1,
  is          => 'ro',
  isa         => Str,
  builder     => sub { deg_to_compass shift->wind_direction_degrees },
);

has wind_direction_degrees => (
  lazy        => 1,
  is          => 'ro',
  isa         => CoercedInt,
  coerce      => 1,
  builder     => sub { shift->_wind->{deg} // 0 },
);

has _clouds => (
  init_arg    => 'clouds',
  lazy        => 1,
  is          => 'ro',
  isa         => HashObj,
  coerce      => 1,
  builder     => sub { +{ all => 0 } },
);

sub cloud_coverage { shift->_clouds->{all} // 0 }

has _snow => (
  init_arg    => 'snow',
  lazy        => 1,
  is          => 'ro',
  isa         => HashObj,
  coerce      => 1,
  builder     => sub { +{ '3h' => 0 } },
);

sub snow { shift->_snow->{3h} // 0 }

has _rain => (
  init_arg    => 'rain',
  lazy        => 1,
  is          => 'ro',
  isa         => HashObj,
  coerce      => 1,
  builder     => sub { +{ '3h' => 0 } },
);

sub rain { shift->_rain->{3h} // 0 }

# FIXME POD + tests

1;
