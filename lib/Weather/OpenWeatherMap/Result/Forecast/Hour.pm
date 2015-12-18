package Weather::OpenWeatherMap::Result::Forecast::Hour;

use strictures 2;

use Types::Standard      -all;
use Types::DateTime      -all;
use List::Objects::Types -all;

use Weather::OpenWeatherMap::Units -all;

use Moo; use MooX::late;
extends 'Weather::OpenWeatherMap::Result::Forecast::Block';

use Storable 'freeze';

# FIXME cloud_coverage (HASH?)

# FIXME wind_speech_* (see Day) (HASH?)

# FIXME

1;
