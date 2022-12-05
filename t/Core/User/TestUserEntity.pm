package Core::User::TestUserEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Try::Tiny;

require_ok( 'Core::User::UserEntity' );

my $user = Core::User::UserEntity->new({'name' => 'Some'});
ok($user->isa('Core::User::UserEntity') eq 1, 'New User');

try {
  Core::User::UserEntity->new({'nam' => 'Some'});
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid Name');
  ok($_->{message} eq 'Invalid name', 'Invalid Name');
};

done_testing( 3 );

1;
