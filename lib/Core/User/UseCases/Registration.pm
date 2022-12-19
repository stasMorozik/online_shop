package Core::User::UseCases::Registration;

use Moo;
use Scalar::Util qw(reftype blessed);
use Core::User::Entity;
use Core::ConfirmationCode::Entity;
use Core::Common::Errors::Domain;
use Core::Common::Errors::Infrastructure;

sub factory {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'})
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  unless ($args->{creating_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid creating port'});
  }

  unless (blessed $args->{creating_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid creating port'}); 
  }

  unless ($args->{creating_port}->can('create')) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid creating port'});
  }

  unless ($args->{notifying_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid notifying port'});
  }

  unless (blessed $args->{notifying_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid notifying port'});   
  }

  unless ($args->{notifying_port}->can('notify')) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid notifying port'});
  }

  unless ($args->{getting_confirmation_code_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid getting port'});
  }

  unless (blessed $args->{getting_confirmation_code_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid getting port'});   
  }

  unless ($args->{getting_confirmation_code_port}->can('get')) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid getting port'});
  }

  return Core::User::UseCases::Registration->new({
    'creating_port' => $args->{creating_port},
    'getting_confirmation_code_port' => $args->{getting_confirmation_code_port},
    'notifying_port' => $args->{notifying_port}
  });
}

sub registry {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  my $maybe_user = Core::User::Entity->factory($args);
  if ($maybe_user->isa('Core::Common::Errors::Domain')) {
    return $maybe_user;
  }

  my $maybe_code = $self->getting_confirmation_code_port->get($maybe_user->email);
  
  unless (reftype($maybe_code) eq "HASH") {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid code'}); 
  }

  unless (blessed $maybe_code) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid code'});   
  }

  unless ($maybe_code->isa('Core::ConfirmationCode::Entity')) {
    return $maybe_code;
  }

  my $maybe_true = $maybe_code->validate_code($args->{code});
  if ($maybe_true->isa('Core::Common::Errors::Domain')) {
    return $maybe_true;
  }

  $maybe_true = $self->creating_port->create($maybe_user);
  if ($maybe_true->isa('Core::Common::Errors::Infrastructure')) {
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