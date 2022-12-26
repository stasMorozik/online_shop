package PostgreSQLAdapters::ConfirmationCode::Confirming;

use Moo;
use Data::Monad::Either;
use DBD::Pg qw(:pg_types);
use Scalar::Util qw(blessed);
use Core::Common::Errors::Infrastructure;
use Core::ConfirmationCode::Entity;

has dbh => (
  is => 'ro',
  required => 1,
  isa => sub {
    unless (blessed $_[0]) {
      die Core::Common::Errors::Infrastructure->new({'message' => 'Invalid getting adapter'});
    }

    unless ($_[0]->isa('DBI::db')) {
      die Core::Common::Errors::Infrastructure->new({'message' => 'Invalid getting adapter'});
    }
  }
);

sub confirm {
  my ( $self, $arg ) = @_;

  unless (blessed $arg) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid confirmation code'})
    );
  }

  unless ($arg->isa('Core::ConfirmationCode::Entity')) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid confirmation code'})
    );
  }

  my $sth_update = $self->dbh->prepare('UPDATE codes SET confirmed=? WHERE email=?');

  $sth_update->execute(
    $arg->confirmed,
    $arg->email->value
  );

  $self->dbh->commit;

  return right(1);
}

1;