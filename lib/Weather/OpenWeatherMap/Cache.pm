package Weather::OpenWeatherMap::Cache;

use Carp;
use strictures 1;

use Storable ();

use Digest::SHA 'sha1_hex';

use List::Objects::WithUtils;

use Path::Tiny;
use Try::Tiny;

use Types::Standard       -all;
use List::Objects::Types  -all;
use Types::Path::Tiny     -all;


use Moo; use MooX::late;


has dir => (
  lazy      => 1,
  is        => 'ro',
  isa       => AbsDir,
  coerce    => 1,
  builder   => sub {
    my $tempdir = Path::Tiny->tempdir;
    my $path = path( join '/', $tempdir, 'owmcache' );
    $path->mkpath unless $path->exists;
    $path
  },
);

has expiry => (
  is        => 'ro',
  isa       => Int,
  builder   => sub { 1200 },
);

has max_entries => (
  is        => 'ro',
  isa       => Int,
  builder   => sub { 128 },
);


sub make_path {
  my ($self, $obj) = @_;
  confess "Expected a Weather::OpenWeatherMap::Request but got $obj"
    unless is_Object($obj) and $obj->isa('Weather::OpenWeatherMap::Request');
  my $fname = 'W';
  TYPE: {
    if ($obj->isa('Weather::OpenWeatherMap::Request::Current')) {
      $fname .= 'C';
      last TYPE
    }
    if ($obj->isa('Weather::OpenWeatherMap::Request::Forecast')) {
      $fname .= 'F';
      last TYPE
    }
    confess "Fell through; no clue what to do with $obj"
  }
  my $digest = $^O eq 'Win32' ? 
    substr sha1_hex($obj->location), 0, 25 : sha1_hex($obj->location);
  # If you happen to alter the extension, check ->clear() too:
  $fname .= $digest . '.wx';
  path( join '/', $self->dir->absolute, $fname )
}


sub serialize {
  my ($self, $obj) = @_;
  Storable::freeze(
    [ time(), $obj ]
  )
}

sub cache {
  my ($self, $obj) = @_;
  confess "Expected a Weather::OpenWeatherMap::Result but got $obj"
    unless is_Object($obj) and $obj->isa('Weather::OpenWeatherMap::Result');

  my $path   = $self->make_path($obj);
  my $frozen = $self->serialize($obj);
  $path->spew_raw($frozen)
}

sub is_cached {
  my ($self, $obj) = @_;
  my $path = $self->make_path($obj);
  return unless $path->exists;
  return if $self->expire($obj);
  $path
}

sub deserialize {
  my ($self, $data) = @_;
  Storable::thaw($data)
}

sub retrieve {
  my ($self, $obj) = @_;
  my $path = $self->is_cached($obj);
  return unless $path;
  my $data = $path->slurp_raw;
  my $ref = $self->deserialize($data);
  my ($ts, $result) = @$ref;
  hash(
    cached_at => $ts,
    object    => $result
  )->inflate
}

sub expire {
  my ($self, $obj) = @_;
  # FIXME act on either Request or Result objs?
  # FIXME expire cached $obj if old
  #  cannot use retrieve(), is_cached calls an expire()
  # FIXME return true if we expired an object
}

sub clear {
  my ($self) = @_;
  my @removed;
  my @found = $self->dir->children( qr/^W(?:C|F).+\.wx/ );
  POSSIBLE: for my $maybe (@found) {
    try {
      my $data = $maybe->slurp_raw;
      my $ref  = $self->deserialize($data);
      my ($ts, $result) = @$ref;
      die 
        unless is_StrictNum $ts 
        and $result->isa('Weather::OpenWeatherMap::Result')
    } or next POSSIBLE;
    push @removed, "$maybe";
    # Looks like ours; remove() rather than unlink()
    # (we don't care if it exists or not, at this point)
    $maybe->remove
  }
  @removed
}


1;
