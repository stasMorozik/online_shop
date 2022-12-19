package Core::ConfirmationCode::FakeAdapters::Getting;

use Moo;
use Core::Common::Errors::Infrastructure;
use Core::Common::ValueObjects::Email;

sub get {
  my ( $self, $arg ) = @_;

  unless ($arg->isa('Core::Common::ValueObjects::Email')) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid email'});
  }

  unless ($self->codes->{$arg->value}) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Code not found'});
  }

  return $self->codes->{$arg->value};
}

has codes => (
  is => 'ro'
);

1;