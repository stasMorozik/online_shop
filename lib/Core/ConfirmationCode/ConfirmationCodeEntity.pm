package Core::ConfirmationCode::ConfirmationCodeEntity;

use strict;
use warnings;

use Moo;
use Core::Common::Errors::DomainError;
use Core::ConfirmationCode::ValueObjects::CodeValueObject;
use Core::Common::ValueObjects::EmailValueObject;

around BUILDARGS => sub {
  my ( $orig, $class, $args ) = @_;

  $args->{code} = Core::ConfirmationCode::ValueObjects::CodeValueObject->new({'value' => $args->{code}});

  $args->{email} = Core::Common::ValueObjects::EmailValueObject->new({'value' => $args->{email}});

  return $class->$orig($args);
};

has email => (
  is => 'ro'
);

has code => (
  is => 'ro'
);