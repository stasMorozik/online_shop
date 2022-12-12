package Core::User::UseCases::RegistrationUseCase;

use strict;
use warnings;

use Moo;
use Core::User::UserEntity;
use Core::Common::Errors::DomainError;

around BUILDARGS => sub {
  my ( $orig, $class, $args ) = @_;

  die Core::Common::Errors::DomainError->new('Invalid port')
    unless ($args->{create_port}->can('create'));

  die Core::Common::Errors::DomainError->new('Invalid port')
    unless ($args->{getting_confirmation_code_port}->can('get'));

  $class->$orig($args);
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