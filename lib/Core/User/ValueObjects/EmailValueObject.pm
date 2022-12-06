package Core::User::ValueObjects::EmailValueObject;

use strict;
use warnings;

use Core::Common::Errors::DomainError;

use Moo;
use Email::Valid;

has value => (
  is => 'ro',
  isa => sub {
    die Core::Common::Errors::DomainError->new({'message' => 'Invalid email'}) unless Email::Valid->address($_[0]);
  }
);

1;