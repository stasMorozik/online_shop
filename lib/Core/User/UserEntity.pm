package Core::User::UserEntity;

use Moo;
use Scalar::Util qw(reftype);
use UUID::Generator::PurePerl;

use Core::User::ValueObjects::NameValueObject;
use Core::Common::ValueObjects::EmailValueObject;
use Core::User::ValueObjects::PasswordValueObject;
use Core::User::ValueObjects::PhoneNubmerValueObject;
use Core::Common::ValueObjects::IdValueObject;
use Core::Common::Errors::DomainError;

sub factory {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  my $uid_gen = UUID::Generator::PurePerl->new();

  my $maybe_id = Core::Common::ValueObjects::IdValueObject->factory( $uid_gen->generate_v4() );
  if ($maybe_id->isa('Core::Common::Errors::DomainError')) {
    return $maybe_id;
  }

  my $maybe_name = Core::User::ValueObjects::NameValueObject->factory($args->{name});
  if ($maybe_name->isa('Core::Common::Errors::DomainError')) {
    return $maybe_name;
  }

  my $maybe_last_name = Core::User::ValueObjects::NameValueObject->factory($args->{last_name});
  if ($maybe_last_name->isa('Core::Common::Errors::DomainError')) {
    return $maybe_last_name;
  }

  my $maybe_email = Core::Common::ValueObjects::EmailValueObject->factory($args->{email});
  if ($maybe_email->isa('Core::Common::Errors::DomainError')) {
    return $maybe_email;
  }

  my $maybe_password = Core::User::ValueObjects::PasswordValueObject->factory($args->{password});
  if ($maybe_password->isa('Core::Common::Errors::DomainError')) {
    return $maybe_password;
  }

  my $maybe_phone = Core::User::ValueObjects::PhoneNubmerValueObject->factory($args->{phone});
  if ($maybe_phone->isa('Core::Common::Errors::DomainError')) {
    return $maybe_phone;
  }

  return Core::User::UserEntity->new({
    'id' => $maybe_id,
    'name' => $maybe_name,
    'last_name' => $maybe_last_name,
    'email' => $maybe_email,
    'password' => $maybe_password,
    'phone' => $maybe_phone
  });
}

sub validate_password {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Wrong password'});
  }

  return $self->password->validate($args);
}

sub update {
  my ( $self, $args ) = @_;

  if ($args->{name}) {
    $self->{name} = Core::User::ValueObjects::NameValueObject->factory($args->{name});
    if ($self->{name}->isa('Core::Common::Errors::DomainError')) {
      return $self->{name};
    }
  }

  if ($args->{last_name}) {
    $self->{last_name} = Core::User::ValueObjects::NameValueObject->factory($args->{last_name});
    if ($self->{last_name}->isa('Core::Common::Errors::DomainError')) {
      return $self->{last_name};
    }
  }

  if ($args->{email}) {
    $self->{email} = Core::Common::ValueObjects::EmailValueObject->factory($args->{email});
    if ($self->{email}->isa('Core::Common::Errors::DomainError')) {
      return $self->{email};
    }
  }

  if ($args->{phone}) {
    $self->{phone} = Core::User::ValueObjects::PhoneNubmerValueObject->factory($args->{phone});
    if ($self->{phone}->isa('Core::Common::Errors::DomainError')) {
      return $self->{phone};
    }
  }

  if ($args->{password}) {
    $self->{password} = Core::User::ValueObjects::PasswordValueObject->factory($args->{password});
    if ($self->{password}->isa('Core::Common::Errors::DomainError')) {
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

1;



