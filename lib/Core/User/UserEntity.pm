package Core::User::UserEntity;

use strict;
use warnings;

use lib '../lib';

use Moo;
use Core::User::ValueObjects::NameValueObject;
use Core::Common::Errors::DomainError;


around BUILDARGS => sub {
  my ( $orig, $class, $args ) = @_;
 
  my $maybe_name = Core::User::ValueObjects::NameValueObject->new({'value' => $args->{name}});

  die $maybe_name if ($maybe_name->isa('Core::Common::Errors::DomainError'));

  $args->{name} = $maybe_name;

  return $class->$orig($args);
};

has name => (
  is => 'ro'
);

1;



