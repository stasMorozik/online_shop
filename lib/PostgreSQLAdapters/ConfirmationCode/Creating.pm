package PostgreSQLAdapters::ConfirmationCode::Creating;

use Moo;
use Data::Monad::Either;
use DBD::Pg qw(:pg_types);
use Scalar::Util qw(blessed);
use Core::Common::Errors::Infrastructure;

has dbh => (
  is => 'ro',
  required => 1,
  isa => sub {
    unless (blessed $_[0]) {
      die Core::Common::Errors::Infrastructure->new({'message' => 'Invalid creating adapter'});   
    }

    unless ($_[0]->isa('DBI::db')) {
      die Core::Common::Errors::Infrastructure->new({'message' => 'Invalid creating adapter'});   
    }
  }
);

sub create {
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

  my $sth_del = $self->dbh->prepare("DELETE FROM codes WHERE email = ?");
  
  $sth_del->execute($arg->email->value);

  my $sth_insert = $self->dbh->prepare('INSERT INTO codes VALUES (?, ?, ?, ?)');

  $sth_insert->execute(
    $arg->code,
    $arg->email->value,
    $arg->created,
    $arg->confirmed
  );

  $self->dbh->commit;

  return right(1);
}

1;