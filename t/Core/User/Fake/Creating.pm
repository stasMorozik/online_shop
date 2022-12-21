package Core::User::Fake::Creating;

use Moo;
use Scalar::Util qw(blessed);
use Data::Monad::Either;
use Core::Common::Errors::Infrastructure;
use Core::User::Entity;

sub create {
  my ( $self, $arg ) = @_;

  unless (blessed $arg) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid user'})
    );
  }

  unless ($arg->isa('Core::User::Entity')) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid user'})
    );
  }

  $self->users->{$arg->email->value} = $arg; 

  return right(1);
}

has users => (
  is => 'ro',
  required => 1
);

1;