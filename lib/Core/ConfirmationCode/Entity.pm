package Core::ConfirmationCode::Entity;

use Moo;
use Scalar::Util qw(reftype);
use Core::Common::Errors::Domain;
use Core::ConfirmationCode::ValueObjects::Code;
use Core::Common::ValueObjects::Email;

sub factory {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid argument'});
  }

  my $maybe_email = Core::Common::ValueObjects::Email->factory($args->{email});

  if ($maybe_email->isa('Core::Common::Errors::Domain')) {
    return $maybe_email;
  }

  return Core::ConfirmationCode::Entity->new({
    'email' => $maybe_email,
    'code' => Core::ConfirmationCode::ValueObjects::Code->factory(),
    'created' => time() + 900
  });
}

sub validate_code {
  my ( $self, $args ) = @_;

  return $self->code->validate($args);
}

has email => (
  is => 'ro'
);

has code => (
  is => 'ro'
);

has created => (
  is => 'ro'
);

1;
