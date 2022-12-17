package Core::Common::ValueObjects::IdValueObject;

use Moo;
use Data::Validate::UUID qw( is_uuid );

use Core::Common::Errors::DomainError;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid id'});
  }

  unless (is_uuid($arg)) {
    return Core::Common::Errors::DomainError->new({'message' => 'Invalid id'});
  }

  return Core::Common::ValueObjects::IdValueObject->new({'value' => $arg});
} 

has value => (
  is => 'ro'
);

1;