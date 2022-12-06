package Core::User::UserEntity;

use strict;
use warnings;

use lib '../lib';

use Moo;
use Core::User::ValueObjects::NameValueObject;
use Core::User::ValueObjects::EmailValueObject;
use Core::Common::Errors::DomainError;


around BUILDARGS => sub {
  my ( $orig, $class, $args ) = @_;
 
  my $maybe_name = Core::User::ValueObjects::NameValueObject->new({'value' => $args->{name}});

  die $maybe_name if ($maybe_name->isa('Core::Common::Errors::DomainError'));

  $args->{name} = $maybe_name;

  my $maybe_email = Core::User::ValueObjects::EmailValueObject->new({'value' => $args->{email}});

  die $maybe_email if ($maybe_name->isa('Core::Common::Errors::DomainError'));

  $args->{email} = $maybe_email;

  return $class->$orig($args);
};

has name => (
  is => 'ro'
);

has email => (
  is => 'ro'
);

1;



