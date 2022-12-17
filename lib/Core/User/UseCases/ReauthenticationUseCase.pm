package Core::User::UseCases::ReauthenticationUseCase;

use Moo;
use Scalar::Util qw(reftype blessed);
use JSON::WebToken;
use Core::User::UserEntity;
use Core::Common::ValueObjects::EmailValueObject;
use Core::User::ValueObjects::PasswordValueObject;
use Core::Common::Errors::DomainError;
use Core::Common::Errors::InfrastructureError;

sub reauth {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  
}

has secret_key => (
  is => 'ro'
);

1;