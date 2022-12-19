package Core::User::TestAuthorization;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;

use Core::Common::Errors::Domain;
use Core::User::UseCases::AuthenticationByCode;
use Core::ConfirmationCode::UseCases::Creating;
use Core::User::UseCases::Registration;
use Core::Token::Entity;
use Core::User::Entity;

use Core::Common::FakeAdapters::Notifying;
use Core::ConfirmationCode::FakeAdapters::Creating;
use Core::User::FakeAdapters::Creating;
use Core::ConfirmationCode::FakeAdapters::Getting;
use Core::ConfirmationCode::FakeAdapters::GettingWithDeleting;
use Core::User::FakeAdapters::GettingByEmail;

my $codes = {};
my $users = {};

require_ok( 'Core::User::UseCases::Authorization' );

my $creating_code_use_case = Core::ConfirmationCode::UseCases::Creating->factory({
  'creating_port' => Core::ConfirmationCode::FakeAdapters::Creating->new({
    'codes' => $codes
  }),
  'getting_port' => Core::ConfirmationCode::FakeAdapters::Getting->new({
    'codes' => $codes
  }),
  'notifying_port' => Core::Common::FakeAdapters::Notifying->new()
});

my $maybe_true = $creating_code_use_case->create({
  'email' => 'name@gmail.com'
});

my $registration_use_case = Core::User::UseCases::Registration->factory({
  'creating_port' => Core::User::FakeAdapters::Creating->new({
    'users' => $users,
    'codes' => $codes
  }),
  'notifying_port' => Core::Common::FakeAdapters::Notifying->new(),
  'getting_confirmation_code_port' => Core::ConfirmationCode::FakeAdapters::Getting->new({
    'codes' => $codes
  })
});

$maybe_true = $registration_use_case->registry({
  'email' => 'name@gmail.com',
  'name' => 'Alex',
  'last_name' => 'Bolduin',
  'password' => 'qwerty12345',
  'code' => $codes->{'name@gmail.com'}->code->value,
  'phone' => '+79672356789'
});

my $secret = 'some_secret';
my $refresh_secret = 'some_refresh_secret';

my $getting_user_by_email_port = Core::User::FakeAdapters::GettingByEmail->new({'users' => $users});

my $auth_use_case = Core::User::UseCases::AuthenticationByCode->factory({
  'getting_user_by_email_port' => $getting_user_by_email_port,
  'getting_confirmation_code_port' => Core::ConfirmationCode::FakeAdapters::GettingWithDeleting->new({
    'codes' => $codes
  }),
  'secret_key' => $secret,
  'refresh_secret_key' => $refresh_secret
});

my $authorization_use_case = Core::User::UseCases::Authorization->factory({
  'secret_key' => $secret,
  'getting_user_by_email_port' => $getting_user_by_email_port
});

ok($authorization_use_case->isa('Core::User::UseCases::Authorization') eq 1, 'New Authorization Use Case');


my $invalid_authorization_use_case = Core::User::UseCases::Authorization->factory({});

ok($invalid_authorization_use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid argument');

$invalid_authorization_use_case = Core::User::UseCases::Authorization->factory({
  'secret_key' => $secret,
  'getting_user_by_email_port' => {}
});

ok($invalid_authorization_use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');

$maybe_true = $creating_code_use_case->create({
  'email' => 'name@gmail.com'
});

my $maybe_token = $auth_use_case->auth({
  'email' => 'name@gmail.com',
  'code' => $codes->{'name@gmail.com'}->code->value
});

my $user = $authorization_use_case->auth({
  'token' => $maybe_token->token
});

ok($user->isa('Core::User::Entity') eq 1, 'Authorization User');

$user = $authorization_use_case->auth({
  'token' => '123'
});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid token');


$user = $authorization_use_case->auth({});

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid argument');

$user = $authorization_use_case->auth();

ok($user->isa('Core::Common::Errors::Domain') eq 1, 'Invalid argument');

1;