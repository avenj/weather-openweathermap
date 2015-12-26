package Weather::OpenWeatherMap::Result::Forecast::Block;

use strictures 2;

use Types::Standard       -all;
use Types::DateTime       -all;
use List::Objects::Types  -all;

use Weather::OpenWeatherMap::Units -all;

use Moo; use MooX::late;

use Storable 'freeze';

has dt => (
  is        => 'ro',
  isa       => DateTimeUTC,
  coerce    => 1,
  builder   => sub { 0 },
);

has _weather_list => (
  init_arg  => 'weather',
  is        => 'ro',
  isa       => ArrayObj,
  coerce    => 1,
  builder   => sub { [] },
);

has _first_weather_item => (
  lazy      => 1,
  is        => 'ro',
  isa       => HashRef,
  builder   => sub { shift->_weather_list->[0] || +{} },
);


has conditions_terse => (
  lazy      => 1,
  is        => 'ro',
  isa       => Str,
  builder   => sub { shift->_first_weather_item->{main} // '' },
);

has conditions_verbose => (
  lazy      => 1,
  is        => 'ro',
  isa       => Str,
  builder   => sub { shift->_first_weather_item->{description} // '' },
);

has conditions_code => (
  lazy      => 1,
  is        => 'ro',
  isa       => Int,
  builder   => sub { shift->_first_weather_item->{id} // 0 },
);

has conditions_icon => (
  lazy      => 1,
  is        => 'ro',
  isa       => Maybe[Str],
  builder   => sub { shift->_first_weather_item->{icon} },
);

1;

=pod

=head1 NAME

Weather::OpenWeatherMap::Result::Forecast::Block - Weather report for a block of time

=head1 SYNOPSIS

  # Typically a parent class for objects produced by a
  # Weather::OpenWeatherMap::Result::Forecast, one of:
  #  Weather::OpenWeatherMap::Result::Forecast::Day
  #  Weather::OpenWeatherMap::Result::Forecast::Hour

=head1 DESCRIPTION

A L<Weather::OpenWeatherMap> weather forecast for a block of time; this is the
parent class of L<Weather::OpenWeatherMap::Result::Forecast::Day> &
L<Weather::OpenWeatherMap::Result::Forecast::Hour>.

=head2 ATTRIBUTES

=head3 conditions_terse

The conditions category.

=head3 conditions_verbose

The conditions description string.

=head3 conditions_code

The L<OpenWeatherMap|http://www.openweathermap.org/> conditions code.

=head3 conditions_icon

The L<OpenWeatherMap|http://www.openweathermap.org/> conditions icon.

=head3 dt

  my $date = $result->dt->mdy;

A L<DateTime> object coerced from the timestamp attached to this forecast.

=head1 SEE ALSO

L<Weather::OpenWeatherMap::Result>

L<Weather::OpenWeatherMap::Result::Forecast>

L<Weather::OpenWeatherMap::Result::Forecast::Day>

L<Weather::OpenWeatherMap::Result::Forecast::Hour>

L<Weather::OpenWeatherMap::Result::Current>

L<http://www.openweathermap.org>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
