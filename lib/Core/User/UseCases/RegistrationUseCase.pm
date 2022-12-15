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


  die Core::Common::Errors::DomainError->new('Invalid port')
    unless ($args->{notifying_port}->can('notify'));

  $class->$orig($args);
}

sub registry {
  my ( $self, $args ) = @_;

  my $user = Core::User::UserEntity->new($args);

  my $code = $self->getting_confirmation_code_port->get($user->email->value);

  if ($code->validate($args->{code})) {
    if ($self->create_port->create($user)) {
      $self->notifying_port->notify($user);
    }
  }
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