package PostgresAdapters::User::CreatingAdapter;

use Scalar::Util qw(reftype blessed);

use Try::Tiny;
use Data::Dump;
use PostgresAdapters::DB;
use Core::User::UserEntity;
use PostgresAdapters::User::OrmEntities::UserOrmEntity;
use Core::Common::Errors::InfrastructureError;

sub create {
  my ( $self, $args ) = @_;

  unless ($args) {
    return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid argument'});
  }

  unless (reftype($args) eq "HASH") {
    return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid argument'});
  }

  unless (blessed $args) {
    return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid getting port'}); 
  }

  unless ($args->isa('Core::User::UserEntity')) {
    return Core::Common::Errors::InfrastructureError->new({'message' => 'Invalid argument'});
  }

  my $db = PostgresAdapters::DB->new();

  try {
    $db->begin_work;
    
    my $user_orm_entity = PostgresAdapters::User::OrmEntities::UserOrmEntity->new(
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

    return Core::Common::Errors::InfrastructureError->new({'message' => 'User already exists'});
  };
}

1;