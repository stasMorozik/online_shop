package Core::Common::FakeAdapters::Notifying;

use Moo;
use Core::Common::Errors::Infrastructure;
use Core::Common::ValueObjects::Email;
use Data::Dump;

sub notify {
  my ( $self, $args ) = @_;

  unless ($args->{email}) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid email'});
  }

  unless ($args->{message}) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid message'});
  }

  unless ($args->{email}->isa('Core::Common::ValueObjects::Email')) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid email'});
  }

  # dd($args->{message});

  return 1;
}

1;