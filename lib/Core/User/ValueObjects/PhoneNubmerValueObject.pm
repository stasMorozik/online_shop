package Core::User::ValueObjects::PhoneNubmerValueObject;

use strict;
use warnings;

use Core::Common::Errors::DomainError;

use Moo;
use Crypt::Password;

has value => (
  is => 'ro',
  isa => sub {
    die Core::Common::Errors::DomainError->new({'message' => 'Invalid phone number'}) 
      unless $_[0];

    die Core::Common::Errors::DomainError->new({'message' => 'Invalid phone number'}) 
      unless $_[0] =~ /\+79[0-9]{2,2}[0-9]{7,7}+$/g;
  }
);

1;