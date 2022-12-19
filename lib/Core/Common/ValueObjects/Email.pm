package Core::Common::ValueObjects::Email;

use Core::Common::Errors::Domain;

use Moo;
use Email::Valid;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid email'});
  }

  unless (Email::Valid->address('-address' => $arg)) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid email'});
  }
  
  return Core::Common::ValueObjects::Email->new({'value' => $arg});
}

has value => (
  is => 'ro'
);

1;