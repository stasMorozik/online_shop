package Core::ConfirmationCode::Fake::Getting;

use Moo;
use Scalar::Util qw(blessed);
use Data::Monad::Either;
use Core::Common::Errors::Infrastructure;
use Core::Common::ValueObjects::Email;

sub get {
  my ( $self, $arg ) = @_;

  unless (blessed $arg) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid email'})
    );
  }

  unless ($arg->isa('Core::Common::ValueObjects::Email')) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid email'})
    );
  }

  unless ($self->codes->{$arg->value}) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Code not found'})
    );
  }

  return right($self->codes->{$arg->value});
}

has codes => (
  is => 'ro',
  required => 1
);

1;