package Core::Common::ValueObjects::EmailValueObject;

use Core::Common::Errors::DomainError;

use Moo;
use Email::Valid;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid email'});
  }

  unless (Email::Valid->address('-address' => $arg)) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid email'});
  }
  
  return Core::Common::ValueObjects::EmailValueObject->new({'value' => $arg});
}

has value => (
  is => 'ro'
);

1;