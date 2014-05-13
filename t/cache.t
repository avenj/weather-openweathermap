use Test::Roo;

sub _build_description { "Testing Cache" }

use Weather::OpenWeatherMap::Cache;
use Weather::OpenWeatherMap::Request;
use Weather::OpenWeatherMap::Result;

has current_result => ();

has forecast_result => ();

has cache_obj => ();


use lib 't/inc';
with 'Testing::Result::Cachable';

# FIXME
# Need some cleverness:
#  - Need a current_result / forecast_result obj
#  - Testing::Result::Cachable:
#    - internal pkgs consuming Testing::Result::{Current,Forecast}
#    - requires 'current_result', 'forecast_result', 'cache_obj'
#    - Caches and retrieves bare current_result / forecast_result,
#      runs result tests
#    - Runs Testing::Result tests to populate objects,
#      caches and retrieves,
#      runs result tests
#    - Tests other cache functions
#    
#  - Test class:
#    - sets up current_result and forecast_result based on ->get_mock_json
#    - consumes Testing::Result::Cachable 

run_me;
done_testing
