package Core::Common::FakeAdapters::NotifyingAdapter;

use Moo;
use Core::Common::Errors::InfrastructureError;
use Core::Common::ValueObjects::EmailValueObject;
use Data::Dump;

sub notify {
  my ( $self, $args ) = @_;

  return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid email'})
    unless $args->{email};

  return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid message'})
    unless $args->{message};

  return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid email'})
    unless $args->{email}->isa('Core::Common::ValueObjects::EmailValueObject');

  dd($args->{message});

  1;
}

1;