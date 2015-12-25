package Weather::OpenWeatherMap::Result::Forecast::Hour;

use strictures 2;

use Types::Standard      -all;
use Types::DateTime      -all;
use List::Objects::Types -all;

use Weather::OpenWeatherMap::Units -all;

use Moo; use MooX::late;
extends 'Weather::OpenWeatherMap::Result::Forecast::Block';

use Storable 'freeze';

has _main => (
  init_arg    => 'main',
  required    => 1,
  is          => 'ro',
  isa         => HashObj,
  coerce      => 1,
);

has _wind => (
  init_arg    => 'wind',
  is          => 'ro',
  isa         => HashObj,
  coerce      => 1,
  builder     => sub {
    +{ speed => 0, deg => 0 }
  },
);

has _snow => (
  init_arg    => 'snow',
  is          => 'ro',
  isa         => HashObj,
  coerce      => 1,
  builder     => sub { +{} },
);

has _rain => (
  init_arg    => 'rain',
  is          => 'ro',
  isa         => HashObj,
  coerce      => 1,
  builder     => sub { +{} },
);

has temp => (
  init_arg  => undef,
  is        => 'ro',
  isa       => CoercedInt,
  coerce    => 1,
  builder   => sub { shift->_main->{temp} },
);

# FIXME rain / snow / wind accessors

# FIXME cloud_coverage (HASH?)

# FIXME POD + tests

1;
