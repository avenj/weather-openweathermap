use Test::Roo;

sub _build_description { "Testing get_weather interface" }

use lib 't/inc';
with 'Testing::OpenWeatherMap';
run_me;

done_testing
