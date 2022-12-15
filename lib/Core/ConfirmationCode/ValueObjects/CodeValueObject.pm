package Core::ConfirmationCode::ValueObjects::CodeValueObject;

use strict;
use warnings;

use Moo;
use Core::Common::Errors::DomainError;
use Crypt::Random qw( makerandom_itv );

around BUILDARGS => sub {
  my ( $orig, $class, $args ) = @_;

  $args->{value} = makerandom_itv(Size => 10, Strength => 1, Uniform => 1, Lower => 1000, Upper => 9999);;

  $class->$orig($args);
};

sub validate {
  my ( $self, $args ) = @_;
  
  die Core::Common::Errors::DomainError->new({'message' => 'Wrong confirmation code'})
    if ($self->value !=  $args);

  1;
}

has value => (
  is => 'ro'
);

1;
