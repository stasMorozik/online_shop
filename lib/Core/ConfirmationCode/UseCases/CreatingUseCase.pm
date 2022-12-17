package Core::ConfirmationCode::UseCases::CreatingUseCase;

use Moo;
use Scalar::Util qw(reftype blessed);
use Core::ConfirmationCode::ConfirmationCodeEntity;
use Core::Common::Errors::DomainError;
use Data::Dump;

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

  return Core::ConfirmationCode::UseCases::CreatingUseCase->new({
    'creating_port' => $args->{creating_port},
    'notifying_port' => $args->{notifying_port}
  });
}

sub create {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  my $maybe_code = Core::ConfirmationCode::ConfirmationCodeEntity->factory($args);

  if ($maybe_code->isa('Core::Common::Errors::DomainError')) {
    return $maybe_code;
  }

  my $maybe_true = $self->creating_port->create($maybe_code);

  if ($maybe_true->isa('Core::Common::Errors::InfrastructureError')) {
    return $maybe_true
  }

  $self->notifying_port->notify({
    'email' => $maybe_code->email,
    'message' => "Your code is $maybe_code->{code}->{value}"
  });

  return 1;
}

has creating_port => (
  is => 'ro'
);

has notifying_port => (
  is => 'ro'
);

1;