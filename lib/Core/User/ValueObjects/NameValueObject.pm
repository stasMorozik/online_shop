package Core::User::ValueObjects::NameValueObject;

use strict;
use warnings;

use Core::Common::Errors::DomainError;

use Moo;

has value => (
  is => 'ro',
  isa => sub {
    die Core::Common::Errors::DomainError->new({'message' => 'Invalid name'}) unless $_[0];
    die Core::Common::Errors::DomainError->new({'message' => 'Invalid name'}) unless $_[0] =~ /[A-Z]{1}[a-z]{1,29}+$/g;
  }
);

1;