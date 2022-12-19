package PostgresAdapters::User::GettingByEmail;

use Scalar::Util qw(reftype blessed);
use Core::Common::ValueObjects::Email;
use Core::User::ValueObjects::Password;
use Core::User::ValueObjects::Name;
use Core::User::ValueObjects::Phone;
use Core::Common::ValueObjects::Email;
use Core::Common::ValueObjects::Id;
use Core::User::Entity;
use PostgresAdapters::User::OrmEntity;
use Core::Common::Errors::Infrastructure;

sub get {
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

  unless ($args->isa('Core::Common::ValueObjects::Email')) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'Invalid argument'});
  }

  my @users = PostgresAdapters::User::OrmEntity::Manager->get_users(
    query =>
    [
      email =>  { eq => $args->value },
    ],
    limit   => 1
  );

  unless ($users[0][0]) {
    return Core::Common::Errors::Infrastructure->new({'message' => 'User not found'});
  }

  return Core::User::Entity->new({
    'id' => Core::Common::ValueObjects::Id->new({'value' => $users[0][0]->id}),
    'name' => Core::User::ValueObjects::Name->new({'value' => $users[0][0]->name}),
    'last_name' => Core::User::ValueObjects::Name->new({'value' => $users[0][0]->last_name}),
    'email' => Core::Common::ValueObjects::Email->new({'value' => $users[0][0]->email}),
    'phone' => Core::User::ValueObjects::Phone->new({'value' => $users[0][0]->phone}),
    'password' => Core::User::ValueObjects::Password->new({'value' => $users[0][0]->password}),
    'created' => $users[0][0]->created
  });
}

1;