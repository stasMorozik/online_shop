package Core::ConfirmationCode::Fake::Confirming;

use Moo;
use Scalar::Util qw(blessed);
use Data::Monad::Either;
use Core::Common::Errors::Infrastructure;
use Core::ConfirmationCode::Entity;

sub confirm {
  my ( $self, $arg ) = @_;

  unless (blessed $arg) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid code'})
    );
  }

  unless ($arg->isa('Core::ConfirmationCode::Entity')) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid code'})
    );
  }

  $self->codes->{$arg->email->value} = $arg; 

  return right(1);
}

has codes => (
  is => 'ro',
  required => 1
);

1;