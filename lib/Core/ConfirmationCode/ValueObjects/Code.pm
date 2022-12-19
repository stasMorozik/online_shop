package Core::ConfirmationCode::ValueObjects::Code;

use Moo;
use Core::Common::Errors::Domain;
use Crypt::Random qw( makerandom_itv );

sub factory {
  return Core::ConfirmationCode::ValueObjects::Code->new({
    'value' => makerandom_itv(Size => 10, Strength => 1, Uniform => 1, Lower => 1000, Upper => 9999)
  });
}

sub validate {
  my ( $self, $arg ) = @_;
  
  if ($self->value !=  $arg) {
    return Core::Common::Errors::Domain->new({'message' => 'Wrong confirmation code'});
  }

  return 1;
}

has value => (
  is => 'ro'
);

1;
