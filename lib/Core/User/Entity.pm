package Core::User::Entity;

use Moo;
use Time::Piece;
use Scalar::Util qw(reftype blessed);
use UUID::Tiny ':std';

use Core::ConfirmationCode::Entity;
use Core::User::ValueObjects::Name;
use Core::Common::ValueObjects::Email;
use Core::User::ValueObjects::Password;
use Core::User::ValueObjects::Phone;
use Core::Common::Errors::Domain;
use Data::Monad::Either;
use Data::Dump;

has id => (
  is => 'ro',
  required => 1
);

has name => (
  is => 'ro',
  required => 1
);

has last_name => (
  is => 'ro',
  required => 1
);

has email => (
  is => 'ro',
  required => 1
);

has phone => (
  is => 'ro',
  required => 1
);

has password => (
  is => 'ro',
  required => 1
);

has created => (
  is => 'ro',
  required => 1
);

sub factory {
  my ( $self, $args ) = @_;

  unless (reftype($args) eq "HASH") {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid argument'})
    );
  }

  unless (blessed($args->{code})) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid argument'})
    );
  }

  unless ($args->{code}->isa('Core::ConfirmationCode::Entity')) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid argument'})
    );
  }

  my $maybe_name = Core::User::ValueObjects::Name->factory($args->{name});
  if ($maybe_name->is_left()) {
    return $maybe_name;
  }

  my $maybe_last_name = Core::User::ValueObjects::Name->factory($args->{last_name});
  if ($maybe_last_name->is_left()) {
    return $maybe_last_name;
  }

  my $maybe_password = Core::User::ValueObjects::Password->factory($args->{password});
  if ($maybe_password->is_left()) {
    return $maybe_password;
  }

  my $maybe_phone = Core::User::ValueObjects::Phone->factory($args->{phone});
  if ($maybe_phone->is_left()) {
    return $maybe_phone;
  }

  return right(Core::User::Entity->new({
    'id' => create_uuid_as_string(UUID_V4),
    'email' => $args->{code}->email,
    'name' => $maybe_name->value,
    'last_name' => $maybe_last_name->value,
    'password' => $maybe_password->value,
    'phone' => $maybe_phone->value,
    'created' => localtime->strftime('%Y-%m-%d')
  }));
}

sub validate_password {
  my ( $self, $args ) = @_;

  return $self->password->validate($args);
}

sub update_email {
  my ( $self, $arg ) = @_;

  unless (blessed($arg)) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid argument'})
    );
  }

  unless ($arg->isa('Core::ConfirmationCode::Entity')) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid argument'})
    );
  }

  $self->{email} = $arg->email;

  return right(1);
}

sub update_password {
  my ( $self, $args ) = @_;

  unless (reftype($args) eq "HASH") {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid argument'})
    );
  }

  my $maybe_true = $self->validate_password($args->{password});
  if ($maybe_true->is_left()) {
    return $maybe_true;
  }

  my $maybe_password = Core::User::ValueObjects::Password->factory($args->{new_password});
  if ($maybe_password->is_left()) {
    return $maybe_password;
  }

  $self->{password} = $maybe_password;

  return right(1);
}

sub update {
  my ( $self, $args ) = @_;

  if ($args->{name}) {
    my $maybe_name = Core::User::ValueObjects::Name->factory($args->{name});
    if ($maybe_name->is_left()) {
      return $maybe_name;
    }

    $self->{name} = $maybe_name->value;
  }

  if ($args->{last_name}) {
    my $maybe_last_name = Core::User::ValueObjects::Name->factory($args->{last_name});
    if ($maybe_last_name->is_left()) {
      return $maybe_last_name;
    }

    $self->{last_name} = $maybe_last_name->value;
  }

  if ($args->{phone}) {
    my $maybe_phone = Core::User::ValueObjects::Phone->factory($args->{phone});
    if ($maybe_phone->is_left()) {
      return $maybe_phone;
    }

    $self->{phone} = $maybe_phone->value;
  }

  return right(1);
}

1;



