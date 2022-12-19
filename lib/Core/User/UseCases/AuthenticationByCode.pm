package Core::User::UseCases::AuthenticationByCode;

use Moo;
use Scalar::Util qw(reftype blessed);
use Core::User::Entity;
use Core::Token::Entity;
use Core::Common::ValueObjects::Email;
use Core::ConfirmationCode::Entity;
use Core::Common::Errors::Domain;

sub factory {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'})
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  unless ($args->{secret_key}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid secret key'})
  }

  unless ($args->{refresh_secret_key}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid refresh secret key'})
  }

  unless ($args->{getting_user_by_email_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid getting user port'});
  }

  unless (blessed $args->{getting_user_by_email_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid getting user port'}); 
  }

  unless ($args->{getting_user_by_email_port}->can('get')) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid getting user port'});
  }

  unless ($args->{getting_confirmation_code_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid getting code port'});
  }

  unless (blessed $args->{getting_confirmation_code_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid getting code port'});   
  }

  unless ($args->{getting_confirmation_code_port}->can('get')) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid getting code port'});
  }

  return Core::User::UseCases::AuthenticationByCode->new({
    'getting_user_by_email_port' => $args->{getting_user_by_email_port},
    'getting_confirmation_code_port' => $args->{getting_confirmation_code_port},
    'secret_key' => $args->{secret_key},
    'refresh_secret_key' => $args->{refresh_secret_key}
  });
}

sub auth {
  my ( $self, $args ) = @_;
  
  unless ($args) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  my $maybe_email = Core::Common::ValueObjects::Email->factory($args->{email});
  if ($maybe_email->isa('Core::Common::Errors::Domain')) {
    return $maybe_email;
  }

  my $maybe_code = $self->getting_confirmation_code_port->get($maybe_email);

  unless (reftype($maybe_code) eq "HASH") {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid code'}); 
  }

  unless (blessed $maybe_code) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid code'});   
  }
  
  unless ($maybe_code->isa('Core::ConfirmationCode::Entity')) {
    return $maybe_code;
  }

  my $maybe_user = $self->getting_user_by_email_port->get($maybe_email);

  unless (reftype($maybe_user) eq "HASH") {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid user'}); 
  }

  unless (blessed $maybe_user) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid user'});   
  }

  unless ($maybe_user->isa('Core::User::Entity')) {
    return $maybe_user;
  }

  my $maybe_true = $maybe_code->validate_code($args->{code});
  if ($maybe_true->isa('Core::Common::Errors::Domain')) {
    return $maybe_true;
  }

  return Core::Token::Entity->factory({
    'user' => $maybe_user,
    'secret_key' => $self->secret_key,
    'refresh_secret_key' => $self->refresh_secret_key
  });
}

has getting_user_by_email_port => (
  is => 'ro'
);

has getting_confirmation_code_port => (
  is => 'ro'
);

has secret_key => (
  is => 'ro'
);

has refresh_secret_key => (
  is => 'ro'
);

1;