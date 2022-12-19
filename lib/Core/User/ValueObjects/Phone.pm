package Core::User::ValueObjects::Phone;

use Core::Common::Errors::Domain;

use Moo;
use Crypt::Password;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid phone number'});
  }

  unless ($arg =~ /\+79[0-9]{2,2}[0-9]{7,7}+$/g) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid phone number'});
  }

  return Core::User::ValueObjects::Phone->new({'value' => $arg});
}

has value => (
  is => 'ro'
);

1;