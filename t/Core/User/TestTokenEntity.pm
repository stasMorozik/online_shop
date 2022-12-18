package Core::User::TestTokenEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;

use Core::User::UserEntity;
use Core::Common::Errors::DomainError;

require_ok( 'Core::User::TokenEntity' );


my $user = Core::User::UserEntity->factory({
  'name' => 'Some', 
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

my $token = Core::User::TokenEntity->factory({
  'user' => $user,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

ok($token->isa('Core::User::TokenEntity') eq 1, 'New Token');

$token = Core::User::TokenEntity->factory({
  'user' => {},
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

ok($token->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid User');

$token = Core::User::TokenEntity->factory({
  'user' => $user,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => ''
});

ok($token->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid refresh secret key');

$token = Core::User::TokenEntity->factory({
  'user' => $user,
  'secret_key' => '',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

ok($token->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid secret key');

$token = Core::User::TokenEntity->factory();

ok($token->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid argument');

$token = Core::User::TokenEntity->factory({
  'user' => $user,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

$token = $token->refresh({
  'refresh_token' => $token->refresh_token,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

ok($token->isa('Core::User::TokenEntity') eq 1, 'Refresh token');

my $invalid_token = $token->refresh({
  'refresh_token' => $token->refresh_token,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some'
});

ok($invalid_token->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid refresh token');

$invalid_token = $token->refresh({
  'refresh_token' => '123',
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

ok($invalid_token->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid refresh token');

1;