package Testing::Request;

use Types::Standard -all;
use Test::Roo::Role;

requires 'request_obj', 
         'request_obj_bycoord',
         'request_obj_bycode';


test 'accessors' => sub {
  my ($self) = @_;
  isa_ok $self->request_obj, 'Weather::OpenWeatherMap::Request';
  ok $self->request_obj->api_key,  'api_key';
  ok $self->request_obj->location, 'location';
  ok $self->request_obj->tag,      'tag';
  ok is_StrictNum $self->request_obj->ts, 'ts';
  like $self->request_obj->url,
       qr{^http://api.openweathermap.org/.+},
       'url';
};

test 'http request' => sub {
  my ($self) = @_;
  isa_ok $self->request_obj->http_request, 'HTTP::Request';
  cmp_ok $self->request_obj->http_request->header('x-api-key'),
    'eq', $self->request_obj->api_key,
    'request header';
};


1;
