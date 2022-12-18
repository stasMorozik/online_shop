package Core::User::UseCases::RefreshTokenUseCase;

use Moo;
use Scalar::Util qw(reftype blessed);
use JSON::WebToken;
use Core::User::TokenEntity;
use Core::Common::ValueObjects::EmailValueObject;
use Core::User::ValueObjects::PasswordValueObject;
use Core::Common::Errors::DomainError;
use Core::Common::Errors::InfrastructureError;

sub factory {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless ($args->{secret_key}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid secret key'})
  }

  unless ($args->{refresh_secret_key}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid refresh secret key'})
  }

  return Core::User::UseCases::RefreshTokenUseCase->new({
    'secret_key' => $args->{secret_key},
    'refresh_secret_key' => $args->{refresh_secret_key}
  });
}

sub refresh {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless ($args->{refresh_token}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid refresh token'})
  }

  return Core::User::TokenEntity->refresh({
    'refresh_token' => $args->{refresh_token},
    'secret_key' => $self->secret_key,
    'refresh_secret_key' => $self->refresh_secret_key
  });
}

has secret_key => (
  is => 'ro'
);

has refresh_secret_key => (
  is => 'ro'
);

1;