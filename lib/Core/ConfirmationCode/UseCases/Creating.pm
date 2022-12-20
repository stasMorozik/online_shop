package Core::ConfirmationCode::UseCases::Creating;

use Moo;
use Data::Monad::Either;
use Scalar::Util qw(blessed);
use Core::Common::Errors::Domain;
use Core::Common::Errors::Infrastructure;
use Core::ConfirmationCode::Entity;

has getting_port => (
  is => 'ro',
  required => 1,
  isa => sub {
    unless (blessed $_[0]) {
      die Core::Common::Errors::Domain->new({'message' => 'Invalid getting port'});   
    }

    unless ($_[0]->can('get')) {
      return Core::Common::Errors::Domain->new({'message' => 'Invalid getting port'});
    }
  }
);

has creating_port => (
  is => 'ro',
  required => 1,
  isa => sub {
    unless (blessed $_[0]) {
      die Core::Common::Errors::Domain->new({'message' => 'Invalid creating port'});   
    }

    unless ($_[0]->can('create')) {
      return Core::Common::Errors::Domain->new({'message' => 'Invalid creating port'});
    }
  }
);

has notifying_port => (
  is => 'ro',
  required => 1,
  isa => sub {
    unless (blessed $_[0]) {
      die Core::Common::Errors::Domain->new({'message' => 'Invalid notifying port'});   
    }

    unless ($_[0]->can('notify')) {
      return Core::Common::Errors::Domain->new({'message' => 'Invalid notifying port'});
    }
  }
);

sub create {
  my ( $self, $arg ) = @_;

  my $maybe_email = Core::Common::ValueObjects::Email->factory($arg);

  if ($maybe_email->is_left()) {
    return $maybe_email;
  }

  my $maybe_code = $self->getting_port->get($maybe_email->value);

  if ($maybe_code->is_right()) {
    my $maybe_true = $maybe_code->value->check_lifetime();

    if ($maybe_true->is_left()) {
      return $maybe_true;
    }
  }

  $maybe_code = Core::ConfirmationCode::Entity->factory($maybe_email->value);
  
  my $maybe_true = $self->creating_port->create($maybe_code->value);

  if ($maybe_true->is_left()) {
    return $maybe_true;
  }

  $self->notifying_port->notify({
    'email' => $maybe_email->value,
    'message' => "Your code is $maybe_code->value->{code}"
  });

  return right(1);
}

1;