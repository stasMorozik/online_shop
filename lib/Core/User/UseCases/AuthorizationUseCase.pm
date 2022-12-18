package Core::User::UseCases::AuthorizationUseCase;

use Moo;
use Scalar::Util qw(reftype blessed);
use Core::User::TokenEntity;
use Core::Common::ValueObjects::EmailValueObject;
use Core::Common::Errors::DomainError;

sub factory {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'})
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless ($args->{secret_key}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid secret key'})
  }

  unless ($args->{getting_user_by_email_port}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid getting port'});
  }

  unless (blessed $args->{getting_user_by_email_port}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid getting port'}); 
  }

  unless ($args->{getting_user_by_email_port}->can('get')) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid getting port'});
  }

  return Core::User::UseCases::AuthorizationUseCase->new({
    'getting_user_by_email_port' => $args->{getting_user_by_email_port},
    'secret_key' => $args->{secret_key},
  });
}

sub auth {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'})
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless ($args->{token}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid token'});
  }

  my $maybe_email = Core::User::TokenEntity->parse({
    'secret_key' => $self->secret_key,
    'token' => $args->{token}
  });

  if ($maybe_email->isa('Core::Common::Errors::DomainError')) {
    return $maybe_email;
  }

  return $self->getting_user_by_email_port->get($maybe_email);
}

has getting_user_by_email_port => (
  is => 'ro'
);

has secret_key => (
  is => 'ro'
);

1;