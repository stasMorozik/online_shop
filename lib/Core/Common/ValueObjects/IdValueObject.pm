package Core::Common::ValueObjects::IdValueObject;

use Data::Validate::UUID qw( is_uuid );

use strict;
use warnings;

use Core::Common::Errors::DomainError;

use Moo;

has value => (
  is => 'ro',
  isa => sub {
    die Core::Common::Errors::DomainError->new({'message' => 'Invalid id'}) 
      unless $_[0];

    die Core::Common::Errors::DomainError->new({'message' => 'Invalid id'}) 
      unless is_uuid($_[0]);
  }
);

1;