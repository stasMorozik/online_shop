package Core::User::TestAuthenticationByCodeUseCase;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;

use Core::Common::Errors::Domain;
use Core::Common::Errors::Infrastructure;
use Core::User::UseCases::AuthenticationByCode;
use Core::ConfirmationCode::UseCases::Creating;
use Core::User::UseCases::Registration;
use Core::User::Entity;

use Core::Common::FakeAdapters::Notifying;
use Core::ConfirmationCode::FakeAdapters::Creating;
use Core::User::FakeAdapters::Creating;
use Core::ConfirmationCode::FakeAdapters::Getting;
use Core::ConfirmationCode::FakeAdapters::GettingWithDeleting;
use Core::User::FakeAdapters::GettingByEmail;

my $codes = {};
my $users = {};

require_ok( 'Core::User::UseCases::AuthenticationByCode' );

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

my $auth_use_case = Core::User::UseCases::AuthenticationByCode->factory({
  'getting_user_by_email_port' => Core::User::FakeAdapters::GettingByEmail->new({
    'users' => $users
  }),
  'getting_confirmation_code_port' => Core::ConfirmationCode::FakeAdapters::GettingWithDeleting->new({
    'codes' => $codes
  }),
  'secret_key' => $secret,
  'refresh_secret_key' => $refresh_secret
});

ok($auth_use_case->isa('Core::User::UseCases::AuthenticationByCode') eq 1, 'New Auth Use Case');

my $invalid_auth_use_case = Core::User::UseCases::AuthenticationByCode->factory({});

ok($invalid_auth_use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid argument');

$invalid_auth_use_case = Core::User::UseCases::AuthenticationByCode->factory({
  'getting_user_by_email_port' => {},
  'getting_confirmation_code_port' => {},
  'secret_key' => $secret,
  'refresh_secret_key' => $refresh_secret
});

ok($invalid_auth_use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid ports');

$invalid_auth_use_case = Core::User::UseCases::AuthenticationByCode->factory({
  'getting_user_by_email_port' => 12,
  'getting_confirmation_code_port' => '1',
  'secret_key' => 0,
  'refresh_secret_key' => 0
});

ok($invalid_auth_use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid argument');

$maybe_true = $creating_code_use_case->create({
  'email' => 'name@gmail.com'
});

my $maybe_token = $auth_use_case->auth({
  'email' => 'name@gmail.com',
  'code' => $codes->{'name@gmail.com'}->code->value
});

ok($maybe_token->isa('Core::Token::Entity') eq 1, 'New token');

$maybe_true = $creating_code_use_case->create({
  'email' => 'name@gmail.com'
});

$maybe_token = $auth_use_case->auth({
  'email' => 'name@gmail.com',
  'code' => 123
});

ok($maybe_token->isa('Core::Common::Errors::Domain') eq 1, 'Wrong code');

$maybe_token = $auth_use_case->auth({
  'email' => 'name1@gmail.com',
  'code' => 123
});

ok($maybe_token->isa('Core::Common::Errors::Infrastructure') eq 1, 'Code not found');

$maybe_token = $auth_use_case->auth();

ok($maybe_token->isa('Core::Common::Errors::Domain') eq 1, 'Invalid data');

1;