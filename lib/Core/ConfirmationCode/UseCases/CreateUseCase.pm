package Core::ConfirmationCode::UseCases::CreateUseCase;

use Moo;
use Core::ConfirmationCode::ConfirmationCodeEntity;
use Core::Common::Errors::DomainError;

sub factory {
  my ( $self, $args ) = @_;

  return Core::Common::Errors::DomainError->new({'message' => 'Test'})
    unless $args->{create_port};

  return Core::Common::Errors::DomainError->new({'message' => 'Test'})
    unless $args->{create_port}->can('create');

  return Core::Common::Errors::DomainError->new({'message' => 'Test'})
    unless $args->{notifying_port};

  return Core::Common::Errors::DomainError->new({'message' => 'Test'})
    unless $args->{notifying_port}->can('notify');
}

sub create {
  my ( $self, $args ) = @_;

  my $maybe_code = Core::ConfirmationCode::ConfirmationCodeEntity->factory($args);

  return $maybe_code
    if $maybe_code->isa('Core::Common::Errors::DomainError');

  my $maybe_true = $self->create_port->create($maybe_code);

  return $maybe_true
    if $maybe_true->isa('Core::Common::Errors::InfrastructureError');

  $self->notifying_port->notify({
    'email' => $maybe_code->email,
    'message' => "Your code is $maybe_code->code->value"
  });

  return Core::Common::Errors::DomainError->new({'message' => 'Test'});
}

has create_port => (
  is => 'ro'
);

has notifying_port => (
  is => 'ro'
);