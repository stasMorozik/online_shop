package Core::User::UserEntity;

use Moo;
use UUID::Generator::PurePerl;

use Core::User::ValueObjects::NameValueObject;
use Core::Common::ValueObjects::EmailValueObject;
use Core::User::ValueObjects::PasswordValueObject;
use Core::User::ValueObjects::PasswordValueObject;
use Core::User::ValueObjects::PhoneNubmerValueObject;
use Core::Common::ValueObjects::IdValueObject;
use Core::Common::Errors::DomainError;

sub factory {
  my ( $self, $args ) = @_;

  my $uid_gen = UUID::Generator::PurePerl->new();

  my $maybe_id = Core::Common::ValueObjects::IdValueObject->factory( $uid_gen->generate_v4() );
  return $maybe_id if $maybe_id->isa('Core::Common::Errors::DomainError');

  my $maybe_name = Core::User::ValueObjects::NameValueObject->factory($args->{name});
  return $maybe_name if $maybe_name->isa('Core::Common::Errors::DomainError');

  my $maybe_last_name = Core::User::ValueObjects::NameValueObject->factory($args->{last_name});
  return $maybe_last_name if $maybe_last_name->isa('Core::Common::Errors::DomainError');

  my $maybe_email = Core::Common::ValueObjects::EmailValueObject->factory($args->{email});
  return $maybe_email if $maybe_email->isa('Core::Common::Errors::DomainError');

  my $maybe_password = Core::User::ValueObjects::PasswordValueObject->factory($args->{password});
  return $maybe_password if $maybe_password->isa('Core::Common::Errors::DomainError');

  my $maybe_phone = Core::User::ValueObjects::PhoneNubmerValueObject->factory($args->{phone});
  return $maybe_phone if $maybe_phone->isa('Core::Common::Errors::DomainError');

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

  return $self->password->validate($args);
}

sub update {
  my ( $self, $args ) = @_;

  if ($args->{name}) {
    $self->{name} = Core::User::ValueObjects::NameValueObject->factory($args->{name});
    return $self->{name} if $self->{name}->isa('Core::Common::Errors::DomainError');
  }

  if ($args->{last_name}) {
    $self->{last_name} = Core::User::ValueObjects::NameValueObject->factory($args->{last_name});
    return $self->{last_name} if $self->{last_name}->isa('Core::Common::Errors::DomainError');
  }

  if ($args->{email}) {
    $self->{email} = Core::Common::ValueObjects::EmailValueObject->factory($args->{email});
    return $self->{email} if $self->{email}->isa('Core::Common::Errors::DomainError');
  }

  if ($args->{phone}) {
    $self->{phone} = Core::User::ValueObjects::PhoneNubmerValueObject->factory($args->{phone});
    return $self->{phone} if $self->{phone}->isa('Core::Common::Errors::DomainError');
  }

  if ($args->{password}) {
    $self->{password} = Core::User::ValueObjects::PasswordValueObject->factory($args->{password});
    return $self->{password} if $self->{password}->isa('Core::Common::Errors::DomainError');
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



