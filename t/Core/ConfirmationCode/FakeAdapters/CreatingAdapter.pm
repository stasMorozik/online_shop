package Core::ConfirmationCode::FakeAdapters::CreatingAdapter;

use Moo;
use Core::Common::Errors::InfrastructureError;
use Core::ConfirmationCode::ConfirmationCodeEntity;

sub create {
  my ( $self, $arg ) = @_;

  return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid user'})
    unless $arg->isa('Core::ConfirmationCode::ConfirmationCodeEntity');

  $self->codes->{$arg->email->value} = $arg; 

  return 1;
}

has codes => (
  is => 'ro'
);

1;