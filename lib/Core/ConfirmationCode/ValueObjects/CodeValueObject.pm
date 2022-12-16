package Core::ConfirmationCode::ValueObjects::CodeValueObject;

use Moo;
use Core::Common::Errors::DomainError;
use Crypt::Random qw( makerandom_itv );

sub factory {
  return Core::ConfirmationCode::ValueObjects::CodeValueObject->new({
    'value' => makerandom_itv(Size => 10, Strength => 1, Uniform => 1, Lower => 1000, Upper => 9999)
  });
}

sub validate {
  my ( $self, $arg ) = @_;
  
  return Core::Common::Errors::DomainError->new({'message' => 'Wrong confirmation code'})
    if ($self->value !=  $arg);

  return 1;
}

has value => (
  is => 'ro'
);

1;
