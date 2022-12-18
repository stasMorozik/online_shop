package PostgresAdapters::User::TestCreatingAdapter;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Core::Common::Errors::InfrastructureError;
use Core::User::UserEntity;

require_ok( 'PostgresAdapters::User::OrmEntities::UserOrmEntity' );
require_ok( 'PostgresAdapters::User::CreatingAdapter' );

PostgresAdapters::User::OrmEntities::UserOrmEntity::Manager->delete_users('all' => 1);

my $user = Core::User::UserEntity->factory({
  'name' => 'Some', 
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

my $true = PostgresAdapters::User::CreatingAdapter->create($user);

ok($true eq 1, 'Insert New User');

$true = PostgresAdapters::User::CreatingAdapter->create({});

ok($true->isa('Core::Common::Errors::InfrastructureError') eq 1, 'Invalid argument');

$true = PostgresAdapters::User::CreatingAdapter->create();

ok($true->isa('Core::Common::Errors::InfrastructureError') eq 1, 'Invalid argument');

1;