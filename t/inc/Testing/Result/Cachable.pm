package Testing::Result::Cachable;

use Test::Roo::Role;

requires 'current_result_generator', 
         'forecast_result_generator', 
         'cache_obj';


test 'cache bare result' => sub {
  my ($self) = @_;
  my $cache = $self->cache_obj;

  my $current = $self->current_result_generator->();
  isa_ok $current, 'Weather::OpenWeatherMap::Result::Current';

  my $forecast = $self->forecast_result_generator->();
  isa_ok $forecast, 'Weather::OpenWeatherMap::Result::Forecast';

  $cache->cache($current);
  $cache->cache($forecast);

  my $cached_current  = $cache->retrieve($current->request);
  my $cached_forecast = $cache->retrieve($forecast->request);

  Testing::Result::Cachable::Current->run_tests( +{
      result_obj  => $cached_current->object,
      request_obj => $cached_current->object->request,
      mock_json   => $cached_current->object->json,
  } );
  Testing::Result::Cachable::Forecast->run_tests( +{
      result_obj  => $cached_forecast->object,
      request_obj => $cached_forecast->object->request,
      mock_json   => $cached_forecast->object->json,
  } );
};

test 'cache populated result' => sub {
  my ($self) = @_;
  my $cache = $self->cache_obj;

  my $current = $self->current_result_generator->();
  isa_ok $current, 'Weather::OpenWeatherMap::Result::Current';

  my $forecast = $self->forecast_result_generator->();
  isa_ok $forecast, 'Weather::OpenWeatherMap::Result::Forecast';

    
};

test 'cache expiry' => sub {

};

test 'cache clear' => sub {

};


{ package Testing::Result::Cachable::Current;
  use Test::Roo;
  has [qw/request_obj result_obj mock_json/] => ( is => 'ro' );
  with 'Testing::Result::Current';
}

{ package Testing::Result::Cachable::Forecast;
  use Test::Roo;
  has [qw/request_obj result_obj mock_json/] => ( is => 'ro' );
  with 'Testing::Result::Forecast';
}

1;
