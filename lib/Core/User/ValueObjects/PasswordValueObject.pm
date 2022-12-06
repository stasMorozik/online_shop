package Core::User::ValueObjects::PasswordValueObject;

use strict;
use warnings;

use Core::Common::Errors::DomainError;

use Moo;
use Crypt::Password;

around BUILDARGS => sub {
  my ( $orig, $class, $args ) = @_;

  die Core::Common::Errors::DomainError->new({'message' => 'Invalid password'}) 
    unless $args->{value};

  die Core::Common::Errors::DomainError->new({'message' => 'Invalid password'}) 
    unless $args->{value} =~ /[A-Za-z0-9\.\,\!\?\$\@\&\-\*\_]{5,15}+$/g;

  $args->{value} = password($args->{value});

  return $class->$orig($args);
};

has value => (
  is => 'ro'
);

1;