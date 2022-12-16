package Core::User::ValueObjects::NameValueObject;

use Moo;
use Core::Common::Errors::DomainError;

sub factory {
  my ( $self, $arg ) = @_;

  return Core::Common::Errors::DomainError->new({'message' => 'Invalid name'}) 
    unless $arg;

  return Core::Common::Errors::DomainError->new({'message' => 'Invalid name'}) 
    unless $arg =~ /[A-ZА-ЯЁ]{1}[a-zа-яё]{1,10}+(\s[A-ZА-ЯЁ]{1}[a-zа-яё]{1,10})?+(\-[A-ZА-ЯЁ]{1}[a-zа-яё]{1,10})?+$/g;

  return Core::User::ValueObjects::NameValueObject->new({'value' => $arg});
}

has value => (
  is => 'ro'
);

1;