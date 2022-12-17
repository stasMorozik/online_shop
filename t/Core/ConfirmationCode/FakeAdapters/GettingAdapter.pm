package Core::ConfirmationCode::FakeAdapters::GettingAdapter;

use Moo;
use Core::Common::Errors::InfrastructureError;
use Core::Common::ValueObjects::EmailValueObject;

sub get {
  my ( $self, $arg ) = @_;

  unless ($arg->isa('Core::Common::ValueObjects::EmailValueObject')) {
    return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid email'});
  }

  unless ($self->codes->{$arg->value}) {
    return Core::Common::Errors::InfrastructureError->new({'message' => 'Code not found'});
  }

  return $self->codes->{$arg->value};
}

has codes => (
  is => 'ro'
);

1;