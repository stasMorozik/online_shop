package Core::ConfirmationCode::UseCases::Creating;

use Moo;
use Scalar::Util qw(reftype blessed);
use Core::ConfirmationCode::Entity;
use Core::Common::Errors::Domain;
use Core::Common::Errors::Infrastructure;
use Core::Common::ValueObjects::Email;

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

  unless ($args->{getting_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid creating port'});
  }
  
  unless (blessed $args->{getting_port}) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid creating port'}); 
  }

  unless ($args->{getting_port}->can('get')) {
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

  return Core::ConfirmationCode::UseCases::Creating->new({
    'creating_port' => $args->{creating_port},
    'getting_port' => $args->{getting_port},
    'notifying_port' => $args->{notifying_port}
  });
}

sub create {
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

  my $maybe_code = $self->getting_port->get($maybe_email);
  if ($maybe_code->isa('Core::ConfirmationCode::Entity')) {
    if (time() <= $maybe_code->created) {
      return Core::Common::Errors::Domain->new({'message' => 'Code already exists'});
    }
  }

  $maybe_code = Core::ConfirmationCode::Entity->factory($args);

  if ($maybe_code->isa('Core::Common::Errors::Domain')) {
    return $maybe_code;
  }

  my $maybe_true = $self->creating_port->create($maybe_code);

  if ($maybe_true->isa('Core::Common::Errors::Infrastructure')) {
    return $maybe_true;
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

has getting_port => (
  is => 'ro'
);

has notifying_port => (
  is => 'ro'
);

1;