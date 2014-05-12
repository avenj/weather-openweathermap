package Testing::Result;

use Test::Roo::Role;

use Weather::OpenWeatherMap::Test;


requires 'request_obj', 'result_obj', 'mock_json';


sub get_mock_json {
  my ($self, $type) = @_;
  get_test_data($type)
}


test 'data hash has keys' => sub {
  my ($self) = @_;
  ok !$self->result_obj->data->is_empty;
};

test 'error is false' => sub {
  my ($self) = @_;
  ok !$self->result_obj->error;
};


1;
