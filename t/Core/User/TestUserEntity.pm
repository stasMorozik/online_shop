package Core::User::TestUserEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Try::Tiny;

require_ok( 'Core::User::UserEntity' );

my $user = Core::User::UserEntity->new({'name' => 'Some', 'email' => 'name@gmail.com'});
ok($user->isa('Core::User::UserEntity') eq 1, 'New User');

try {
  Core::User::UserEntity->new({'nam' => 'Some', 'email' => 'name@gmail.com'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Empty name');
};

try {
  Core::User::UserEntity->new({'name' => 'Som1', 'email' => 'name@gmail.com'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid name');
};

try {
  Core::User::UserEntity->new({'name' => 'Sqwertyuiopasdfghjklzxcvbnmqasdf', 'email' => 'name@gmail.com'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Soo long name');
};

try {
  Core::User::UserEntity->new({'name' => 'Some', 'emai' => 'name@gmail.com'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Empty email');
};

try {
  Core::User::UserEntity->new({'name' => 'Some', 'email' => 'name@gmail.'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid email');
};

done_testing(7);

1;
