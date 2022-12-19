package PostgresAdapters::User::TestGettingByEmail;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Core::Common::Errors::Infrastructure;
use Core::Common::ValueObjects::Email;
use Core::User::Entity;

require_ok( 'PostgresAdapters::User::OrmEntity' );
require_ok( 'PostgresAdapters::User::GettingByEmail' );

PostgresAdapters::User::OrmEntity::Manager->delete_users('all' => 1);

my $user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

my $true = PostgresAdapters::User::Creating->create($user);

my $maybe_user = PostgresAdapters::User::GettingByEmail->get($user->email);

ok($maybe_user->isa('Core::User::Entity') eq 1, 'Got User by email');

$maybe_user = PostgresAdapters::User::GettingByEmail->get({});

ok($maybe_user->isa('Core::Common::Errors::Infrastructure') eq 1, 'Invalid argument');

$maybe_user = PostgresAdapters::User::GettingByEmail->get();

ok($maybe_user->isa('Core::Common::Errors::Infrastructure') eq 1, 'Invalid argument');

$maybe_user = PostgresAdapters::User::GettingByEmail->get(
  Core::Common::ValueObjects::Email->new({'value' => 'name1@gmail.com'})
);

ok($maybe_user->isa('Core::Common::Errors::Infrastructure') eq 1, 'User not found');

1;