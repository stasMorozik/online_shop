package Core::ConfirmationCode::ConfirmationCodeEntity;

use strict;
use warnings;

use Moo;
use Core::Common::Errors::DomainError;
use Core::ConfirmationCode::ValueObjects::CodeValueObject;
use Core::Common::ValueObjects::EmailValueObject;

around BUILDARGS => sub {
  my ( $orig, $class, $args ) = @_;

  $args->{code} = Core::ConfirmationCode::ValueObjects::CodeValueObject->new();

  $args->{email} = Core::Common::ValueObjects::EmailValueObject->new({'value' => $args->{email}});

  $class->$orig($args);
};

sub validate_code {
  my ( $self, $args ) = @_;

  $self->code->validate($args);
}

has email => (
  is => 'ro'
);

has code => (
  is => 'ro'
);

1;
