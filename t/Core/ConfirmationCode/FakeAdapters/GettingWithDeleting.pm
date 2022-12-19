package Core::ConfirmationCode::FakeAdapters::GettingWithDeleting;

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

  my $code = $self->codes->{$arg->value};

  undef $self->codes->{$arg->value};

  return $code;
}

has codes => (
  is => 'ro'
);

1;