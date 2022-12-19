package Core::User::TestEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Core::Common::Errors::Domain

require_ok( 'Core::User::Entity' );

my $user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::User::Entity') eq 1, 'New User');

$user = Core::User::Entity->factory({
  'nam' => 'Some',
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Empty name');


$user = Core::User::Entity->factory({
  'name' => 'Som1',
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid name');

$user = Core::User::Entity->factory({
  'name' => 'Николай',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::User::Entity') eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай-Яркий',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::User::Entity') eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай-яркий',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::User::Entity') eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай-яркий',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::User::Entity') eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай Яркий',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::User::Entity') eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай яркий',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::User::Entity') eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай яркий1',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай-яркий1',
  'last_name' => 'Минин', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid russian name');

$user = Core::User::Entity->factory({
  'name' => 'Sqwertyuiopasdfghjklzxcvbnmqasdf',
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Soo long name');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'emai' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Empty email');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name@gmail.', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid email');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => '~@@#$@hevanet.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid email');


$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name@gmail.com', 
  'password' => '.,!?$@&-*_', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::User::Entity') eq 1, 'Valid password');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name@gmail.com', 
  'passwor' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Empty password');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name@gmail.com', 
  'passwors' => '^[]()', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid password');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name@gmail.com', 
  'passwors' => 'пароль123', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid password');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name@gmail.com', 
  'passwors' => '123456789012345678901234567', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Soo long password');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name@gmail.com', 
  'passwors' => '1234', 
  'phone' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Soo short password');

$user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Last',
  'email' => 'name@gmail.com', 
  'passwors' => '1234', 
  'phone' => '+7968345678'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid phone number');

$user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Last',
  'email' => 'name@gmail.com', 
  'passwors' => '1234', 
  'phone' => '+796834567826'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid phone number');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 
  'name@gmail.com', 
  'passwors' => '1234', 
  'phone' => '79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid phone number');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name@gmail.com', 
  'passwors' => '1234', 
  'phone' => 79683456782
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid phone number');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name@gmail.com', 
  'passwors' => '1234', 
  'phon' => '+79683456782'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Empty phone number');


$user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->validate_password('qwe-rty!12$') eq 1, 'Validate password');

my $maybe_true = $user->validate_password('1234567');

ok($maybe_true->isa('Core::Common::Errors::Domain') eq 1, 'Wrong password');


ok($user->update({'name' => 'Some'}) eq 1, 'Update name');

ok($user->update({'last_name' => 'Some'}) eq 1, 'Update last name');

ok($user->update({'email' => 'name@gmail.com'}) eq 1, 'Update last email');

ok($user->update({'password' => 'qwe-rty!12$'}) eq 1, 'Update last password');

ok($user->update({'phone' => '+79683456782'}) eq 1, 'Update last phone');

1;
