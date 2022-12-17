package Core::User::UseCases::RegistrationUseCase;

use Moo;
use Scalar::Util qw(reftype blessed);
use Core::User::UserEntity;
use Core::ConfirmationCode::ConfirmationCodeEntity;
use Core::Common::Errors::DomainError;
use Core::Common::Errors::InfrastructureError;

sub factory {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'})
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless ($args->{creating_port}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid creating port'});
  }

  unless (blessed $args->{creating_port}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid creating port'}); 
  }

  unless ($args->{creating_port}->can('create')) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid creating port'});
  }

  unless ($args->{notifying_port}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid notifying port'});
  }

  unless (blessed $args->{notifying_port}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid notifying port'});   
  }

  unless ($args->{notifying_port}->can('notify')) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid notifying port'});
  }

  unless ($args->{getting_confirmation_code_port}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid getting port'});
  }

  unless (blessed $args->{getting_confirmation_code_port}) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid getting port'});   
  }

  unless ($args->{getting_confirmation_code_port}->can('get')) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid getting port'});
  }

  return Core::User::UseCases::RegistrationUseCase->new({
    'creating_port' => $args->{creating_port},
    'getting_confirmation_code_port' => $args->{getting_confirmation_code_port},
    'notifying_port' => $args->{notifying_port}
  });
}

sub registry {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  my $maybe_user = Core::User::UserEntity->factory($args);

  if ($maybe_user->isa('Core::Common::Errors::DomainError')) {
    return $maybe_user;
  }

  my $maybe_code = $self->getting_confirmation_code_port->get($maybe_user->email);

  if ($maybe_code->isa('Core::Common::Errors::InfrastructureError')) {
    return $maybe_code;
  }

  my $maybe_true = $maybe_code->validate_code($args->{code});

  if ($maybe_true->isa('Core::Common::Errors::DomainError')) {
    return $maybe_true;
  }

  $maybe_true = $self->creating_port->create($maybe_user);

  if ($maybe_true->isa('Core::Common::Errors::InfrastructureError')) {
    return $maybe_true;
  }

  $self->notifying_port->notify({
    'email' => $maybe_user->email,
    'message' => "Hello $maybe_user->{name}->{value}! Welcome and enjoy your shopping!"
  });
  
  return 1;
}

has creating_port => (
  is => 'ro'
);

has getting_confirmation_code_port => (
  is => 'ro'
);

has notifying_port => (
  is => 'ro'
);

1;