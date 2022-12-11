package Core::User::UseCases::RegistrationUseCase;

use strict;
use warnings;

use Moo;
use Core::User::UserEntity;

around BUILDARGS => sub {
  my ( $orig, $class, $args ) = @_;

  if (!$args->{create_port}->can('create')) {

  }

  if (!$args->{getting_confirmation_code_port}->can('get')) {

  }

  return $class->$orig($args);
}

has create_port => (
  is => 'ro'
);

has getting_confirmation_code_port => (
  is => 'ro'
);

has notifying_port => (
  is => 'ro'
);