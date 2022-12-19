package Core::User::Entity;

use Moo;
use Time::Piece;
use Scalar::Util qw(reftype);
use UUID::Generator::PurePerl;

use Core::User::ValueObjects::Name;
use Core::Common::ValueObjects::Email;
use Core::User::ValueObjects::Password;
use Core::User::ValueObjects::Phone;
use Core::Common::ValueObjects::Id;
use Core::Common::Errors::Domain;

sub factory {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  my $uid_gen = UUID::Generator::PurePerl->new();

  my $maybe_id = Core::Common::ValueObjects::Id->factory( $uid_gen->generate_v4() );
  if ($maybe_id->isa('Core::Common::Errors::Domain')) {
    return $maybe_id;
  }

  my $maybe_name = Core::User::ValueObjects::Name->factory($args->{name});
  if ($maybe_name->isa('Core::Common::Errors::Domain')) {
    return $maybe_name;
  }

  my $maybe_last_name = Core::User::ValueObjects::Name->factory($args->{last_name});
  if ($maybe_last_name->isa('Core::Common::Errors::Domain')) {
    return $maybe_last_name;
  }

  my $maybe_email = Core::Common::ValueObjects::Email->factory($args->{email});
  if ($maybe_email->isa('Core::Common::Errors::Domain')) {
    return $maybe_email;
  }

  my $maybe_password = Core::User::ValueObjects::Password->factory($args->{password});
  if ($maybe_password->isa('Core::Common::Errors::Domain')) {
    return $maybe_password;
  }

  my $maybe_phone = Core::User::ValueObjects::Phone->factory($args->{phone});
  if ($maybe_phone->isa('Core::Common::Errors::Domain')) {
    return $maybe_phone;
  }

  return Core::User::Entity->new({
    'id' => $maybe_id,
    'name' => $maybe_name,
    'last_name' => $maybe_last_name,
    'email' => $maybe_email,
    'password' => $maybe_password,
    'phone' => $maybe_phone,
    'created' => localtime->strftime('%Y-%m-%d')
  });
}

sub validate_password {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::Domain->new({'message' => 'Wrong password'});
  }

  return $self->password->validate($args);
}

sub update {
  my ( $self, $args ) = @_;

  if ($args->{name}) {
    $self->{name} = Core::User::ValueObjects::Name->factory($args->{name});
    if ($self->{name}->isa('Core::Common::Errors::Domain')) {
      return $self->{name};
    }
  }

  if ($args->{last_name}) {
    $self->{last_name} = Core::User::ValueObjects::Name->factory($args->{last_name});
    if ($self->{last_name}->isa('Core::Common::Errors::Domain')) {
      return $self->{last_name};
    }
  }

  if ($args->{email}) {
    $self->{email} = Core::Common::ValueObjects::Email->factory($args->{email});
    if ($self->{email}->isa('Core::Common::Errors::Domain')) {
      return $self->{email};
    }
  }

  if ($args->{phone}) {
    $self->{phone} = Core::User::ValueObjects::Phone->factory($args->{phone});
    if ($self->{phone}->isa('Core::Common::Errors::Domain')) {
      return $self->{phone};
    }
  }

  if ($args->{password}) {
    $self->{password} = Core::User::ValueObjects::Password->factory($args->{password});
    if ($self->{password}->isa('Core::Common::Errors::Domain')) {
      return $self->{password};
    }
  }

  return 1;
}

has id => (
  is => 'ro'
);

has name => (
  is => 'ro'
);

has last_name => (
  is => 'ro'
);

has email => (
  is => 'ro'
);

has phone => (
  is => 'ro'
);

has password => (
  is => 'ro'
);

has created => (
  is => 'ro'
);

1;



