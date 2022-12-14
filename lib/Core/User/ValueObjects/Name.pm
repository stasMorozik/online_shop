package Core::User::ValueObjects::Name;

use Moo;
use Data::Monad::Either;
use Core::Common::Errors::Domain;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid name'})
    ); 
  }

  unless (
    $arg =~ /[A-ZА-ЯЁ]{1}[a-zа-яё]{1,10}+(\s[A-ZА-ЯЁ]{1}[a-zа-яё]{1,10})?+(\-[A-ZА-ЯЁ]{1}[a-zа-яё]{1,10})?+$/g
  ) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid name'})
    );
  }

  return right(
    Core::User::ValueObjects::Name->new({'value' => $arg})
  );
}

has value => (
  is => 'ro',
  required => 1
);

1;