package Core::User::TestUserEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Try::Tiny;

require_ok( 'Core::User::UserEntity' );

my $user = Core::User::UserEntity->new({'name' => 'Some', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
ok($user->isa('Core::User::UserEntity') eq 1, 'New User');

try {
  Core::User::UserEntity->new({'nam' => 'Some', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Empty name');
};

try {
  Core::User::UserEntity->new({'name' => 'Som1', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid name');
};

$user = Core::User::UserEntity->new({'name' => 'Николай', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

$user = Core::User::UserEntity->new({'name' => 'Николай-Яркий', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

$user = Core::User::UserEntity->new({'name' => 'Николай-яркий', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

$user = Core::User::UserEntity->new({'name' => 'Николай-яркий', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

$user = Core::User::UserEntity->new({'name' => 'Николай Яркий', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

$user = Core::User::UserEntity->new({'name' => 'Николай яркий', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
ok($user->isa('Core::User::UserEntity') eq 1, 'Russian name');

try {
  Core::User::UserEntity->new({'name' => 'Николай яркий1', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid russian name');
};

try {
  Core::User::UserEntity->new({'name' => 'Николай-яркий1', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid russian name');
};

try {
  Core::User::UserEntity->new({'name' => 'Sqwertyuiopasdfghjklzxcvbnmqasdf', 'email' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Soo long name');
};

try {
  Core::User::UserEntity->new({'name' => 'Some', 'emai' => 'name@gmail.com', 'password' => 'qwe-rty!12$'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Empty email');
};

try {
  Core::User::UserEntity->new({'name' => 'Some', 'email' => 'name@gmail.', 'password' => 'qwe-rty!12$'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid email');
};

try {
  Core::User::UserEntity->new({'name' => 'Some', 'email' => '~@@#$@hevanet.com', 'password' => 'qwe-rty!12$'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid email');
};

$user = Core::User::UserEntity->new({'name' => 'Some', 'email' => 'name@gmail.com', 'password' => '.,!?$@&-*_'});
ok($user->isa('Core::User::UserEntity') eq 1, 'Valid password');

try {
  Core::User::UserEntity->new({'name' => 'Some', 'email' => 'name@gmail.com', 'passwor' => 'qwe-rty!12$'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Empty password');
};

try {
  Core::User::UserEntity->new({'name' => 'Some', 'email' => 'name@gmail.com', 'passwors' => '^[]()'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid password');
};

try {
  Core::User::UserEntity->new({'name' => 'Some', 'email' => 'name@gmail.com', 'passwors' => 'пароль123'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid password');
};

try {
  Core::User::UserEntity->new({'name' => 'Some', 'email' => 'name@gmail.com', 'passwors' => '123456789012345678901234567'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Soo long password');
};

try {
  Core::User::UserEntity->new({'name' => 'Some', 'email' => 'name@gmail.com', 'passwors' => '1234'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Soo short password');
};

done_testing(22);

1;
