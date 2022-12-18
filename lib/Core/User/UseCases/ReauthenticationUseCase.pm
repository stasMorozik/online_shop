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

  unless ($args->{secret_key}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid secret key'})
  }

  return Core::User::UseCases::ReauthenticationUseCase->new({
    'secret_key' => $args->{secret_key}
  });
}

sub reauth {
  my ( $self, $args ) = @_;

  my $got = decode_jwt($maybe_token, $secret);

  unless ($got->{iss}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid JWT'});
  }

  return encode_jwt(
    {
      'iss' => $maybe_user->email->value,
      'exp' => time() + 600
    }, 
    $self->secret_key
  );
}

has secret_key => (
  is => 'ro'
);

1;