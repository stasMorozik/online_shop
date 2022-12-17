package Core::User::FakeAdapters::CreatingAdapter;

use Moo;

use Core::Common::Errors::InfrastructureError;
use Core::User::UserEntity;

sub create {
  my ( $self, $arg ) = @_;

  unless ($arg->isa('Core::User::UserEntity')) {
    return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid user'});
  }

  if ($self->users->{$arg->email->value}) {
    return Core::Common::Errors::InfrastructureError->new({'message' => 'User already exists'});
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