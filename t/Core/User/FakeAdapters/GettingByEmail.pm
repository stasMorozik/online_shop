package Core::User::FakeAdapters::GettingByEmail;

use Moo;

use Core::Common::Errors::Infrastructure;
use Core::Common::ValueObjects::Email;

sub get {
  my ( $self, $arg ) = @_;

  unless ($arg->isa('Core::Common::ValueObjects::Email')) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid email'});
  }

  unless ($self->users->{$arg->value}) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'User not found'});
  }

  return $self->users->{$arg->value};
}

has users => (
  is => 'ro'
);

1;