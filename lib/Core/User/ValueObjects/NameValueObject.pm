package Core::User::ValueObjects::NameValueObject;

use strict;
use warnings;

use Core::Common::Errors::DomainError;

use Moo;

has value => (
  is => 'ro',
  isa => sub {
    die Core::Common::Errors::DomainError->new({'message' => 'Invalid name'}) 
      unless $_[0];
    
    die Core::Common::Errors::DomainError->new({'message' => 'Invalid name'}) 
      unless $_[0] =~ /[A-ZА-ЯЁ]{1}[a-zа-яё]{1,10}+(\s[A-ZА-ЯЁ]{1}[a-zа-яё]{1,10})?+(\-[A-ZА-ЯЁ]{1}[a-zа-яё]{1,10})?+$/g;
  }
);

1;