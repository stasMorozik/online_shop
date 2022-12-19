package Core::Token::TestEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;

use Core::User::Entity;
use Core::Common::Errors::Domain;
use Core::Common::ValueObjects::Email;

require_ok( 'Core::Token::Entity' );


my $user = Core::User::Entity->factory({
  'name' => 'Some', 
  'last_name' => 'Some', 
  'email' => 'name@gmail.com', 
  'password' => 'qwe-rty!12$', 
  'phone' => '+79683456782'
});

my $token = Core::Token::Entity->factory({
  'user' => $user,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

ok($token->isa('Core::Token::Entity') eq 1, 'New Token');

$token = Core::Token::Entity->factory({
  'user' => {},
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

ok($token->isa('Core::Common::Errors::Domain') eq 1, 'Invalid User');

$token = Core::Token::Entity->factory({
  'user' => $user,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => ''
});

ok($token->isa('Core::Common::Errors::Domain') eq 1, 'Invalid refresh secret key');

$token = Core::Token::Entity->factory({
  'user' => $user,
  'secret_key' => '',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

ok($token->isa('Core::Common::Errors::Domain') eq 1, 'Invalid secret key');

$token = Core::Token::Entity->factory();

ok($token->isa('Core::Common::Errors::Domain') eq 1, 'Invalid argument');

$token = Core::Token::Entity->factory({
  'user' => $user,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

$token = $token->refresh({
  'refresh_token' => $token->refresh_token,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

ok($token->isa('Core::Token::Entity') eq 1, 'Refresh token');

my $invalid_token = $token->refresh({
  'refresh_token' => $token->refresh_token,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some'
});

ok($invalid_token->isa('Core::Common::Errors::Domain') eq 1, 'Invalid refresh token');

$invalid_token = $token->refresh({
  'refresh_token' => '123',
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

ok($invalid_token->isa('Core::Common::Errors::Domain') eq 1, 'Invalid refresh token');

$token = Core::Token::Entity->factory({
  'user' => $user,
  'secret_key' => 'some_secret_key',
  'refresh_secret_key' => 'some_refresh_secret_key'
});

my $email = $token->parse({
  'secret_key' => 'some_secret_key',
  'token' => $token->token
});

ok($email->isa('Core::Common::ValueObjects::Email') eq 1, 'Parse token');

$email = $token->parse({
  'secret_key' => 'some_secret_key',
  'token' => '123'
});

ok($email->isa('Core::Common::Errors::Domain') eq 1, 'Invalid parse token');

1;