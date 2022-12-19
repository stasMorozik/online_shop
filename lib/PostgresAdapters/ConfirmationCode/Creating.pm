package PostgresAdapters::ConfirmationCode::Creating;

use Scalar::Util qw(reftype blessed);

use Try::Tiny;
use PostgresAdapters::DB;
use Core::ConfirmationCode::Entity;
use PostgresAdapters::ConfirmationCode::OrmEntity;
use Core::Common::Errors::Infrastructure;

sub create {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid argument'});
  }

  unless (blessed $args) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid argument'}); 
  }

  unless ($args->isa('Core::ConfirmationCode::Entity')) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid argument'});
  }

  my $db = PostgresAdapters::DB->new();

  try {
    $db->begin_work;

    PostgresAdapters::ConfirmationCode::OrmEntity::Manager->delete_codes(
      where =>
      [
        email => { eq => $args->email->value },
      ]
    );
    
    my $code_orm_entity = PostgresAdapters::ConfirmationCode::OrmEntity->new(
      'code' => $args->code->value,
      'email' => $args->email->value,
      'created' => $args->created,
    );

    $code_orm_entity->save();

    $db->commit();

    return 1;
  } catch {
    $db->rollback();

    return Core::Common::Errors::Infrastructure->new({'message' => 'Code already exists'});
  };
}