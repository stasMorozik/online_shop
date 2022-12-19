package Core::Common::ValueObjects::Id;

use Moo;
use Data::Validate::UUID qw( is_uuid );

use Core::Common::Errors::Domain;

sub factory {
  my ( $self, $arg ) = @_;

  unless ($arg) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid id'});
  }

  unless (is_uuid($arg)) {
    return Core::Common::Errors::Domain->new({'message' => 'Invalid id'});
  }

  return Core::Common::ValueObjects::Id->new({'value' => $arg});
} 

has value => (
  is => 'ro'
);

1;