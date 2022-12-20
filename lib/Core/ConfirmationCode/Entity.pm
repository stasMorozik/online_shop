package Core::ConfirmationCode::Entity;

use Moo;
use Scalar::Util qw(reftype blessed);
use Crypt::Random qw( makerandom_itv );
use Data::Monad::Either;
use Core::Common::Errors::Domain;
use Core::Common::ValueObjects::Email;

has email => (
  is => 'ro',
  required => 1
);

has code => (
  is => 'ro',
  required => 1
);

has created => (
  is => 'ro',
  required => 1
);

has confirmed => (
  is => 'ro',
  required => 1
);

my $validate_code = sub {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Wrong confirmation code'})
    );
  }

  if ($self->code !=  $arg) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Wrong confirmation code'})
    );
  }

  return right(1);
};

my $validate_lifetime = sub {
  my $self = shift;

  if (time() >= $self->created) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid code expiration time'})
    );
  }

  return right(1);
};

sub factory {
  my ( $self, $email ) = @_;

  unless (blessed $email) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid argument'})
    );
  }

  unless ($email->isa('Core::Common::ValueObjects::Email')) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid argument'})
    );
  }

  return right(Core::ConfirmationCode::Entity->new({
    'email' => $email,
    'code' => makerandom_itv(Size => 10, Strength => 1, Uniform => 1, Lower => 1000, Upper => 9999),
    'created' => time() + 900,
    'confirmed' => 0
  }));
}

sub check_lifetime {
  my ( $self, $args ) = @_;

  my $maybe_true = $validate_lifetime->($self);
  if ($maybe_true->is_right()) {
    return left(Core::Common::Errors::Domain->new({'message' => 'You already have a confirmation code'}));
  }

  return right(1);
}

sub confirm {
  my ( $self, $args ) = @_;

  my $maybe_true = $validate_lifetime->($self);
  if ($maybe_true->is_left()) {
    return $maybe_true;
  }

  $maybe_true = $validate_code->($self, $args);
  if ($maybe_true->is_left()) {
    return $maybe_true;
  }

  return right(1);
}

1;