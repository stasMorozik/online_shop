package Core::ConfirmationCode::UseCases::Confirming;

use Moo;
use Data::Monad::Either;
use Scalar::Util qw(blessed reftype);
use Core::Common::Errors::Domain;
use Core::Common::Errors::Infrastructure;
use Core::ConfirmationCode::Entity;
use Data::Dump;

has getting_port => (
  is => 'ro',
  required => 1,
  isa => sub {
    unless (blessed $_[0]) {
      die Core::Common::Errors::Domain->new({'message' => 'Invalid getting port'});   
    }

    unless ($_[0]->can('get')) {
      return Core::Common::Errors::Domain->new({'message' => 'Invalid getting port'});
    }
  }
);

has confirming_port => (
  is => 'ro',
  required => 1,
  isa => sub {
    unless (blessed $_[0]) {
      die Core::Common::Errors::Domain->new({'message' => 'Invalid confirming port'});   
    }

    unless ($_[0]->can('confirm')) {
      return Core::Common::Errors::Domain->new({'message' => 'Invalid confirming port'});
    }
  }
);

sub confirm {
  my ( $self, $args ) = @_;

  unless ($args) {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid arguments'})
    );
  }

  unless (reftype($args) eq "HASH") {
    return left(
      Core::Common::Errors::Domain->new({'message' => 'Invalid arguments'})
    );
  }

  my $maybe_email = Core::Common::ValueObjects::Email->factory($args->{email});

  if ($maybe_email->is_left()) {
    return $maybe_email;
  }

  my $maybe_code = $self->getting_port->get($maybe_email->value);
  if ($maybe_code->is_left()) {
    return $maybe_code;
  }

  my $maybe_true = $maybe_code->value->confirm($args->{code});
  if ($maybe_true->is_left()) {
    return $maybe_true;
  }

  return $self->confirming_port->confirm($maybe_code->value);
}

1;