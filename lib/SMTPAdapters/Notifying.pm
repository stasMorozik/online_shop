package SMTPAdapters::Notifying;

use Moo;
use Scalar::Util qw(blessed);
use Data::Monad::Either;
use Core::Common::Errors::Infrastructure;
use Core::Common::ValueObjects::Email;
use Data::Dump;

sub notify {
  my ( $self, $args ) = @_;

  unless (blessed $args->{email}) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid email'})
    );
  }

  unless ($args->{message}) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid message'})
    );
  }

  unless ($args->{email}->isa('Core::Common::ValueObjects::Email')) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid email'})
    );
  }

  dd($args->{message});

  return 1;
}

1;