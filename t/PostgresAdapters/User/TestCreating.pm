package PostgresAdapters::User::TestCreating;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Core::Common::Errors::Infrastructure;
use Core::User::Entity;

require_ok( 'PostgresAdapters::User::OrmEntity' );
require_ok( 'PostgresAdapters::User::Creating' );

PostgresAdapters::User::OrmEntity::Manager->delete_users('all' => 1);

my $user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

my $true = PostgresAdapters::User::Creating->create($user);

ok($true eq 1, 'Insert New User');

$true = PostgresAdapters::User::Creating->create({});

ok($true->isa('Core::Common::Errors::Infrastructure') eq 1, 'Invalid argument');

$true = PostgresAdapters::User::Creating->create();

ok($true->isa('Core::Common::Errors::Infrastructure') eq 1, 'Invalid argument');

1;