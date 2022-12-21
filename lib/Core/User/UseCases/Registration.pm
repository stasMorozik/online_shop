package Core::User::UseCases::Registration;

use Moo;
use Data::Monad::Either;
use Scalar::Util qw(blessed reftype);
use Core::Common::Errors::Domain;
use Core::ConfirmationCode::Entity;
use Core::User::Entity;

has getting_confirmation_code_port => (
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

sub registry {
  my ( $self, $args ) = @_;

  unless (reftype($args) eq "HASH") {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid arguments'})
    );
  }

  my $maybe_email = Core::Common::ValueObjects::Email->factory($args->{email});
  if ($maybe_email->is_left()) {
    return $maybe_email;
  }

  my $maybe_code = $self->getting_confirmation_code_port->get($maybe_email->value);
  if ($maybe_code->is_left()) {
    return $maybe_code;
  }

  my $maybe_true = $maybe_code->value->is_confirmed();
  if ($maybe_true->is_left()) {
    return $maybe_true;
  }

  my $maybe_user = Core::User::Entity->factory({
    'name' => $args->{name}, 
    'last_name' => $args->{last_name}, 
    'code' => $maybe_code->value, 
    'password' => $args->{password}, 
    'phone' => $args->{phone}
  });

  if ($maybe_user->is_left()) {
    return $maybe_user;
  }

  $maybe_true = $self->creating_port->create($maybe_user->value);
  if ($maybe_true->is_left()) {
    return $maybe_true;
  }

  $self->notifying_port->notify({
    'email' => $maybe_email->value,
    'message' => "Hello $args->{name} $args->{last_name}! Welcome and enjoy your shopping!"
  });

  return right(1);
}

1;

