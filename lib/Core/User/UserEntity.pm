package Core::User::UserEntity;

use strict;
use warnings;

use Moo;

use Core::User::ValueObjects::NameValueObject;
use Core::Common::ValueObjects::EmailValueObject;
use Core::User::ValueObjects::PasswordValueObject;
use Core::User::ValueObjects::PasswordValueObject;
use Core::User::ValueObjects::PhoneNubmerValueObject;
use Core::Common::ValueObjects::IdValueObject;
use Core::Common::Errors::DomainError;


around BUILDARGS => sub {
  my ( $orig, $class, $args ) = @_;

  $args->{id} = Core::Common::ValueObjects::IdValueObject->new({'value' => $args->{id}});
 
  $args->{name} = Core::User::ValueObjects::NameValueObject->new({'value' => $args->{name}});

  $args->{last_name} = Core::User::ValueObjects::NameValueObject->new({'value' => $args->{last_name}});

  $args->{email} = Core::Common::ValueObjects::EmailValueObject->new({'value' => $args->{email}});

  $args->{password} = Core::User::ValueObjects::PasswordValueObject->new({'value' => $args->{password}});

  $args->{phone} = Core::User::ValueObjects::PhoneNubmerValueObject->new({'value' => $args->{phone}});

  $class->$orig($args);
};

sub validate_password {
  my ( $self, $args ) = @_;

  $self->password->validate($args);
}

sub update {
  my ( $self, $args ) = @_;

  if ($args->{name}) {
    $self->{name} = Core::User::ValueObjects::NameValueObject->new({'value' => $args->{name}});
  }

  if ($args->{last_name}) {
    $self->{last_name} = Core::User::ValueObjects::NameValueObject->new({'value' => $args->{last_name}});
  }

  if ($args->{email}) {
    $self->{email} = Core::Common::ValueObjects::EmailValueObject->new({'value' => $args->{email}});
  }

  if ($args->{phone}) {
    $self->{phone} = Core::User::ValueObjects::PhoneNubmerValueObject->new({'value' => $args->{phone}});
  }

  if ($args->{password}) {
    $self->{password} = Core::User::ValueObjects::PasswordValueObject->new({'value' => $args->{password}});
  }

  1;
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



