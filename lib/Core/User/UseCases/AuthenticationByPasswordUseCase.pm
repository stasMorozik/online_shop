package Core::User::UseCases::AuthenticationByPasswordUseCase;

use Moo;
use Scalar::Util qw(reftype blessed);
use Core::User::UserEntity;
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

  unless ($args->{refresh_secret_key}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid refresh secret key'})
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

  return Core::User::UseCases::AuthenticationByPasswordUseCase->new({
    'getting_user_by_email_port' => $args->{getting_user_by_email_port},
    'secret_key' => $args->{secret_key},
    'refresh_secret_key' => $args->{refresh_secret_key}
  });
}

sub auth {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  my $maybe_email = Core::Common::ValueObjects::EmailValueObject->factory($args->{email});
  if ($maybe_email->isa('Core::Common::Errors::DomainError')) {
    return $maybe_email;
  }

  my $maybe_user = $self->getting_user_by_email_port->get($maybe_email);
  
  unless (reftype($maybe_user) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid user'}); 
  }

  unless (blessed $maybe_user) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid user'});   
  }

  unless ($maybe_user->isa('Core::User::UserEntity')) {
    return $maybe_user;
  }

  my $maybe_true = $maybe_user->validate_password($args->{password});
  if ($maybe_true->isa('Core::Common::Errors::DomainError')) {
    return $maybe_true; 
  }
  
  return Core::User::TokenEntity->factory({
    'user' => $maybe_user,
    'secret_key' => $self->secret_key,
    'refresh_secret_key' => $self->refresh_secret_key
  });
}

has getting_user_by_email_port => (
  is => 'ro'
);

has secret_key => (
  is => 'ro'
);

has refresh_secret_key => (
  is => 'ro'
);

1;