package Core::User::ValueObjects::NameValueObject;

use strict;
use warnings;

use lib '../lib';

use Core::Common::Errors::DomainError;

use Moo;

has value => (
  is => 'ro',
  isa => sub {
    die Core::Common::Errors::DomainError->new({'message' => 'Invalid name'}) unless $_[0];
  }
);

1;