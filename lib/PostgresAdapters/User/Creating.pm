package PostgresAdapters::User::Creating;

use Scalar::Util qw(reftype blessed);

use Try::Tiny;
use PostgresAdapters::DB;
use Core::User::Entity;
use PostgresAdapters::User::OrmEntity;
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

  unless ($args->isa('Core::User::Entity')) {
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
    
    my $user_orm_entity = PostgresAdapters::User::OrmEntity->new(
      'id' => $args->id->value,
      'name' => $args->name->value,
      'last_name' => $args->last_name->value,
      'email' => $args->email->value,
      'password' => $args->password->value,
      'phone' => $args->phone->value,
      'created' => $args->created,
    );

    $user_orm_entity->save();

    $db->commit();

    return 1;
  } catch {
    $db->rollback();

    return Core::Common::Errors::Infrastructure->new({'message' => 'User already exists'});
  };
}

1;