package Core::User::ValueObjects::Phone;

use Moo;
use Crypt::Password;
use Data::Monad::Either;
use Core::Common::Errors::Domain;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid phone number'})
    );
  }

  unless ($arg =~ /\+79[0-9]{2,2}[0-9]{7,7}+$/g) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid phone number'})
    );
  }

  return right(
    Core::User::ValueObjects::Phone->new({'value' => $arg})
  );
}

has value => (
  is => 'ro'
);

1;