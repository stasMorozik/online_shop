package Core::User::UseCases::RegistrationUseCase;

use Moo;
use Core::User::UserEntity;
use Core::ConfirmationCode::ConfirmationCodeEntity;
use Core::Common::Errors::DomainError;
use Core::Common::Errors::InfrastructureError;

sub factory {
  my ( $self, $args ) = @_;

  return Core::Common::Errors::DomainError->new({'message' => 'Invalid port'})
    unless $args->{create_port};

  return Core::Common::Errors::DomainError->new({'message' => 'Invalid port'})
    unless $args->{create_port}->can('create');
  
  return Core::Common::Errors::DomainError->new({'message' => 'Invalid port'})
    unless $args->{getting_confirmation_code_port};

  return Core::Common::Errors::DomainError->new({'message' => 'Invalid port'})
    unless $args->{getting_confirmation_code_port}->can('get');

  return Core::Common::Errors::DomainError->new({'message' => 'Invalid port'})
    unless $args->{notifying_port};

  return Core::Common::Errors::DomainError->new({'message' => 'Invalid port'})
    unless $args->{notifying_port}->can('notify');

  return Core::User::UseCases::RegistrationUseCase->new({
    'create_port' => $args->{create_port},
    'getting_confirmation_code_port' => $args->{getting_confirmation_code_port},
    'notifying_port' => $args->{notifying_port}
  });
}

sub registry {
  my ( $self, $args ) = @_;

  return Core::Common::Errors::DomainError->new({'message' => 'Invalid code'})
    unless $args->{code};

  my $maybe_user = Core::User::UserEntity->factory($args);

  return $maybe_user
    if $maybe_user->isa('Core::Common::Errors::DomainError');

  my $maybe_code = $self->getting_confirmation_code_port->get($maybe_user->email);

  return $maybe_code
    if $maybe_code->isa('Core::Common::Errors::InfrastructureError');

  my $maybe_true = $maybe_code->validate_code($args->{code});

  return $maybe_true
    if $maybe_true->isa('Core::Common::Errors::DomainError');

  $maybe_true = $self->create_port->create($maybe_user);

  return $maybe_true
    if $maybe_true->isa('Core::Common::Errors::InfrastructureError');

  $self->notifying_port->notify({
    'email' => $maybe_user->email,
    'message' => "Hello $maybe_user->name->value! Welcome and enjoy your shopping!"
  });
  
  return 1;
}

has create_port => (
  is => 'ro'
);

has getting_confirmation_code_port => (
  is => 'ro'
);

has notifying_port => (
  is => 'ro'
);