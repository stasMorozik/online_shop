package Core::User::ValueObjects::PhoneNubmerValueObject;

use Core::Common::Errors::DomainError;

use Moo;
use Crypt::Password;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid phone number'});
  }

  unless ($arg =~ /\+79[0-9]{2,2}[0-9]{7,7}+$/g) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid phone number'});
  }

  return Core::User::ValueObjects::PhoneNubmerValueObject->new({'value' => $arg});
}

has value => (
  is => 'ro'
);

1;