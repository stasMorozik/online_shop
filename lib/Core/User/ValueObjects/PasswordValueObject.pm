package Core::User::ValueObjects::PasswordValueObject;

use Core::Common::Errors::DomainError;

use Moo;
use Crypt::Password;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid password'});
  }

  unless ($arg =~ /[A-Za-z0-9\.\,\!\?\$\@\&\-\*\_]{5,15}+$/g) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid password'});
  }

  return Core::User::ValueObjects::PasswordValueObject->new({'value' =>  password($arg)});
}

sub validate {
  my ( $self, $args ) = @_;
  
  unless (check_password($self->value, $args)) {
    return Core::Common::Errors::DomainError->new({'message' => 'Wrong password'});
  }

  return 1;
}

has value => (
  is => 'ro'
);

1;
