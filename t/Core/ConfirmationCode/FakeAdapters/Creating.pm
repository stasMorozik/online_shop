package Core::ConfirmationCode::FakeAdapters::Creating;

use Moo;
use Core::Common::Errors::Infrastructure;
use Core::ConfirmationCode::Entity;

sub create {
  my ( $self, $arg ) = @_;

  unless ($arg->isa('Core::ConfirmationCode::Entity')) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid code'});
  }

  $self->codes->{$arg->email->value} = $arg; 

  return 1;
}

has codes => (
  is => 'ro'
);

1;