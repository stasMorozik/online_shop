package Core::ConfirmationCode::ConfirmationCodeEntity;

use Moo;
use Scalar::Util qw(reftype);
use Core::Common::Errors::DomainError;
use Core::ConfirmationCode::ValueObjects::CodeValueObject;
use Core::Common::ValueObjects::EmailValueObject;

sub factory {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid argument'});
  }

  my $maybe_email = Core::Common::ValueObjects::EmailValueObject->factory($args->{email});

  if ($maybe_email->isa('Core::Common::Errors::DomainError')) {
    return $maybe_email;
  }

  return Core::ConfirmationCode::ConfirmationCodeEntity->new({
    'email' => $maybe_email,
    'code' => Core::ConfirmationCode::ValueObjects::CodeValueObject->factory()
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

1;
