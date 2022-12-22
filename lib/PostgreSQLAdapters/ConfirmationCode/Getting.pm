package PostgreSQLAdapters::ConfirmationCode::Getting;

use Moo;
use Data::Monad::Either;
use DBD::Pg qw(:pg_types);
use Scalar::Util qw(blessed);
use Core::Common::Errors::Infrastructure;
use Core::Common::ValueObjects::Email;
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

sub get {
  my ( $self, $arg ) = @_;

  unless (blessed $arg) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid email'})
    );
  }

  unless ($arg->isa('Core::Common::ValueObjects::Email')) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Invalid email'})
    );
  }

  my $sth = $self->dbh->prepare("SELECT * FROM codes WHERE email = ?");

  $sth->execute($arg->value);
  
  my ( @row ) = $sth->fetchrow_array();

  unless (@row) {
    return left(
      Core::Common::Errors::Infrastructure->new({'message' => 'Code not found'})
    );
  }

  my $code_entity = Core::ConfirmationCode::Entity->new({
    'email' => Core::Common::ValueObjects::Email->new({'value' => $row[1] }),
    'code' => $row[0],
    'created' => $row[2],
    'email' => $row[3]
  });

  return right(
    @row
  );
}

1;