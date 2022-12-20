package Core::User::ValueObjects::Password;

use Moo;
use Data::Monad::Either;
use Crypt::Password;
use Core::Common::Errors::Domain;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid password'})
    );
  }

  unless ($arg =~ /[A-Za-z0-9\.\,\!\?\$\@\&\-\*\_]{5,15}+$/g) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid password'})
    );
  }

  return right(
    Core::User::ValueObjects::Password->new({'value' =>  password($arg)})
  );
}

sub validate {
  my ( $self, $args ) = @_;
  
  unless (check_password($self->value, $args)) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Wrong password'})
    );
  }

  return right(1);
}

has value => (
  is => 'ro',
  required => 1
);

1;
