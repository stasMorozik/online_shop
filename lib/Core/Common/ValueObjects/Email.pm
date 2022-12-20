package Core::Common::ValueObjects::Email;

use Moo;
use Email::Valid;
use Data::Monad::Either;
use Core::Common::Errors::Domain;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid email'})
    );
  }
  
  unless (Email::Valid->address('-address' => $arg)) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid email'})
    );
  }
  
  return right(
    Core::Common::ValueObjects::Email->new({'value' => $arg})
  );
}

has value => (
  is => 'ro'
);

1;