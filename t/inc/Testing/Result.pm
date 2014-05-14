package Testing::Result;

use Test::Roo::Role;
use Scalar::Util 'blessed';

use Weather::OpenWeatherMap::Test;


requires 'request_obj', 'result_obj', 'mock_json';


sub get_mock_json {
  my ($self, $type) = @_;
  get_test_data($type)
}

test 'missing constructor args' => sub {
  my ($self) = @_;
  my $class = blessed $self->result_obj;

  eval {; 
    $class->new(
      json => $self->mock_json
    )
  };
  ok $@, 'missing request dies';

  eval {;
    $class->new(
      json    => $self->mock_json,
      request => 1,
    )
  };
  ok $@, 'bad request dies';

  eval {;
    $class->new(
      request => $self->request_obj
    )
  };
  ok $@, 'missing json dies';
};

test 'data hash has keys' => sub {
  my ($self) = @_;
  ok !$self->result_obj->data->is_empty
};

test 'error is false' => sub {
  my ($self) = @_;
  ok !$self->result_obj->error
};

test 'is_success is true' => sub {
  my ($self) = @_;
  ok $self->result_obj->is_success
};

test 'json looks correct' => sub {
  my ($self) = @_;
  ok $self->result_obj->json eq $self->mock_json
};

test 'response_code indicates success' => sub {
  my ($self) = @_;
  cmp_ok $self->result_obj->response_code, '==', 200
};

test 'request objects match' => sub {
  my ($self) = @_;
  ok $self->result_obj->request == $self->request_obj
};


1;
