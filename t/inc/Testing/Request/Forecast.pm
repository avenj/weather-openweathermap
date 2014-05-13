package Testing::Request::Forecast;


use Test::Roo::Role;
with 'Testing::Request';

has rx_base => (
  is      => 'ro',
  builder => sub { 
    '^http://api\.openweathermap\.org/data/2\.5/forecast/daily\?' 
  },
);

test 'forecast default days' => sub {
  my ($self) = @_;
  cmp_ok $self->request_obj->days, '==', 7, 'default days';
};

test 'forecast request url by name' => sub {
  my ($self) = @_;
  my $re = $self->rx_base .'q=\S+&units=imperial&cnt=7';
  cmp_ok $self->request_obj->url, '=~', $re, 'by name';
};

test 'forecast request url by coord' => sub {
  my ($self) = @_;
  my $re = $self->rx_base .'lat=\d+&lon=\d+&units=imperial&cnt=7';
  cmp_ok $self->request_obj_bycoord->url, '=~', $re, 'by coord';
};

test 'forecast request url by code' => sub {
  my ($self) = @_;
  my $re = $self->rx_base .'id=\d+&units=imperial&cnt=7';
  cmp_ok $self->request_obj_bycode->url, '=~', $re, 'by code';
};

1;


