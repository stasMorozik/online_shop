package Core::User::TestEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;

require_ok( 'Core::User::Entity' );
require_ok( 'Core::ConfirmationCode::Entity' );
require_ok( 'Core::Common::ValueObjects::Email' );

my $email_address = 'name@gmail.com';

my $email = Core::Common::ValueObjects::Email->factory($email_address);

ok($email->is_right() eq 1, 'New email');

my $code = Core::ConfirmationCode::Entity->factory($email->value);

ok($code->is_right() eq 1, 'New code');

my $user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Some', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_right() eq 1, 'New User');

$user = Core::User::Entity->factory({
  'nam' => 'Some',
  'last_name' => 'Some', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Empty name');

$user = Core::User::Entity->factory({
  'name' => 'Som1',
  'last_name' => 'Some', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Invalid name');

$user = Core::User::Entity->factory({
  'name' => 'Николай',
  'last_name' => 'Минин', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_right() eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай-Яркий',
  'last_name' => 'Минин', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_right() eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай-яркий',
  'last_name' => 'Минин', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_right() eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай-яркий',
  'last_name' => 'Минин', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_right() eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай Яркий',
  'last_name' => 'Минин', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_right() eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай яркий',
  'last_name' => 'Минин', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_right() eq 1, 'Russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай яркий1',
  'last_name' => 'Минин', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Invalid russian name');

$user = Core::User::Entity->factory({
  'name' => 'Николай-яркий1',
  'last_name' => 'Минин', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Invalid russian name');

$user = Core::User::Entity->factory({
  'name' => 'Sqwertyuiopasdfghjklzxcvbnmqasdf',
  'last_name' => 'Some', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Soo long name');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'emai' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Empty email');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 'name1', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Invalid email');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => '~@@#$@hevanet.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Invalid email');


$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'code' => $code->value, 
  'password' => '.,!?$@&-*_', 
  'phone' => '+79683456782'
});

ok($user->is_right() eq 1, 'Valid password');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'code' => $code->value, 
  'passwor' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Empty password');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'code' => $code->value, 
  'passwors' => '^[]()', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Invalid password');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'code' => $code->value, 
  'passwors' => 'пароль123', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Invalid password');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'code' => $code->value, 
  'passwors' => '123456789012345678901234567', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Soo long password');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'code' => $code->value, 
  'passwors' => '1234', 
  'phone' => '+79683456782'
});

ok($user->is_left() eq 1, 'Soo short password');

$user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Last',
  'code' => $code->value, 
  'passwors' => '1234', 
  'phone' => '+7968345678'
});

ok($user->is_left() eq 1, 'Invalid phone number');

$user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Last',
  'code' => $code->value, 
  'passwors' => '1234', 
  'phone' => '+796834567826'
});

ok($user->is_left() eq 1, 'Invalid phone number');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'email' => 
  'name@gmail.com', 
  'passwors' => '1234', 
  'phone' => '79683456782'
});

ok($user->is_left() eq 1, 'Invalid phone number');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'code' => $code->value, 
  'passwors' => '1234', 
  'phone' => 79683456782
});

ok($user->is_left() eq 1, 'Invalid phone number');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'code' => $code->value, 
  'passwors' => '1234', 
  'phon' => '+79683456782'
});

ok($user->is_left() eq 1, 'Empty phone number');

$user = Core::User::Entity->factory({
  'name' => 'Some',
  'last_name' => 'Last', 
  'code' => 1, 
  'passwors' => '1234', 
  'phon' => '+79683456782'
});

ok($user->is_left() eq 1, 'Invalid code');


$user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Some', 
  'code' => $code->value, 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

my $maybe_true = $user->value->validate_password('qwe-rty!12$');

ok($maybe_true->is_right() eq 1, 'Validate password');

$maybe_true = $user->value->validate_password('1234567');

ok($maybe_true->is_left() eq 1, 'Wrong password');

$maybe_true = $user->value->update({'name' => 'Some'});

ok($maybe_true->is_right() eq 1, 'Update name');

$maybe_true = $user->value->update({'last_name' => 'Some'});

$maybe_true = $user->value->update({'phone' => '+79683456782'});

ok($maybe_true->is_right() eq 1, 'Update phone');

$maybe_true = $user->value->update_email($code->value);

ok($maybe_true->is_right() eq 1, 'Update email');

$maybe_true = $user->value->update_password({
  'password' => 'qwe-rty!12$',
  'new_password' => 'qwe-rty!12$1'
});

ok($maybe_true->is_right() eq 1, 'Update password');

1;
