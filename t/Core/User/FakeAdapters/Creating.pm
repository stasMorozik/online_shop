package Core::User::FakeAdapters::Creating;

use Moo;

use Core::Common::Errors::Infrastructure;
use Core::User::Entity;

sub create {
  my ( $self, $arg ) = @_;

  unless ($arg->isa('Core::User::Entity')) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid user'});
  }

  if ($self->users->{$arg->email->value}) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'User already exists'});
  }

  $self->users->{$arg->email->value} = $arg;

  undef $self->codes->{$arg->email->value};

  return 1;
}

has users => (
  is => 'ro'
);

has codes => (
  is => 'ro'
);

1;