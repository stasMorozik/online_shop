package Core::User::FakeAdapters::GettingByEmailAdapter;

use Moo;

use Core::Common::Errors::InfrastructureError;
use Core::Common::ValueObjects::EmailValueObject;

sub get {
  my ( $self, $arg ) = @_;

  unless ($arg->isa('Core::Common::ValueObjects::EmailValueObject')) {
    return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid email'});
  }

  unless ($self->users->{$arg->value}) {
    return Core::Common::Errors::InfrastructureError->new({'message' => 'User not found'});
  }

  return $self->users->{$arg->value};
}

has users => (
  is => 'ro'
);

1;