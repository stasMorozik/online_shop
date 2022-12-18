package Core::User::TestAuthorizationUseCase;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;

use Core::Common::Errors::DomainError;
use Core::Common::Errors::InfrastructureError;
use Core::User::UseCases::AuthenticationByCodeUseCase;
use Core::ConfirmationCode::UseCases::CreatingUseCase;
use Core::User::UseCases::RegistrationUseCase;
use Core::User::TokenEntity;
use Core::User::UserEntity;

use Core::Common::FakeAdapters::NotifyingAdapter;
use Core::ConfirmationCode::FakeAdapters::CreatingAdapter;
use Core::User::FakeAdapters::CreatingAdapter;
use Core::ConfirmationCode::FakeAdapters::GettingAdapter;
use Core::ConfirmationCode::FakeAdapters::GettingWithDeletingAdapter;
use Core::User::FakeAdapters::GettingByEmailAdapter;

my $codes = {};
my $users = {};

require_ok( 'Core::User::UseCases::AuthorizationUseCase' );

my $creating_code_use_case = Core::ConfirmationCode::UseCases::CreatingUseCase->factory({
  'creating_port' => Core::ConfirmationCode::FakeAdapters::CreatingAdapter->new({
    'codes' => $codes
  }),
  'notifying_port' => Core::Common::FakeAdapters::NotifyingAdapter->new()
});

my $maybe_true = $creating_code_use_case->create({
  'email' => 'name@gmail.com'
});

my $registration_use_case = Core::User::UseCases::RegistrationUseCase->factory({
  'creating_port' => Core::User::FakeAdapters::CreatingAdapter->new({
    'users' => $users,
    'codes' => $codes
  }),
  'notifying_port' => Core::Common::FakeAdapters::NotifyingAdapter->new(),
  'getting_confirmation_code_port' => Core::ConfirmationCode::FakeAdapters::GettingAdapter->new({
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

my $getting_user_by_email_port = Core::User::FakeAdapters::GettingByEmailAdapter->new({'users' => $users});

my $auth_use_case = Core::User::UseCases::AuthenticationByCodeUseCase->factory({
  'getting_user_by_email_port' => $getting_user_by_email_port,
  'getting_confirmation_code_port' => Core::ConfirmationCode::FakeAdapters::GettingWithDeletingAdapter->new({
    'codes' => $codes
  }),
  'secret_key' => $secret,
  'refresh_secret_key' => $refresh_secret
});

my $authorization_use_case = Core::User::UseCases::AuthorizationUseCase->factory({
  'secret_key' => $secret,
  'getting_user_by_email_port' => $getting_user_by_email_port
});

ok($authorization_use_case->isa('Core::User::UseCases::AuthorizationUseCase') eq 1, 'New Authorization Use Case');


my $invalid_authorization_use_case = Core::User::UseCases::AuthorizationUseCase->factory({});

ok($invalid_authorization_use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid argument');

$invalid_authorization_use_case = Core::User::UseCases::AuthorizationUseCase->factory({
  'secret_key' => $secret,
  'getting_user_by_email_port' => {}
});

ok($invalid_authorization_use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid port');

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

ok($user->isa('Core::User::UserEntity') eq 1, 'Authorization User');

$user = $authorization_use_case->auth({
  'token' => '123'
});

ok($user->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid token');


$user = $authorization_use_case->auth({});

ok($user->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid argument');

$user = $authorization_use_case->auth();

ok($user->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid argument');

1;