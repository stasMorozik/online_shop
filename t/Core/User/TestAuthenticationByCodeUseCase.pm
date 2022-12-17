package Core::User::TestAuthenticationByCodeUseCase;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use JSON::WebToken;

use Core::Common::Errors::DomainError;
use Core::Common::Errors::InfrastructureError;
use Core::User::UseCases::AuthenticationByCodeUseCase;
use Core::ConfirmationCode::UseCases::CreatingUseCase;
use Core::User::UseCases::RegistrationUseCase;

use Core::Common::FakeAdapters::NotifyingAdapter;
use Core::ConfirmationCode::FakeAdapters::CreatingAdapter;
use Core::User::FakeAdapters::CreatingAdapter;
use Core::ConfirmationCode::FakeAdapters::GettingAdapter;
use Core::ConfirmationCode::FakeAdapters::GettingWithDeletingAdapter;
use Core::User::FakeAdapters::GettingByEmailAdapter;

my $codes = {};
my $users = {};

require_ok( 'Core::User::UseCases::AuthenticationByCodeUseCase' );

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

my $auth_use_case = Core::User::UseCases::AuthenticationByCodeUseCase->factory({
  'getting_user_by_email_port' => Core::User::FakeAdapters::GettingByEmailAdapter->new({
    'users' => $users
  }),
  'getting_confirmation_code_port' => Core::ConfirmationCode::FakeAdapters::GettingWithDeletingAdapter->new({
    'codes' => $codes
  }),
  'secret_key' => $secret
});

ok($auth_use_case->isa('Core::User::UseCases::AuthenticationByCodeUseCase') eq 1, 'New Auth Use Case');

my $invalid_auth_use_case = Core::User::UseCases::AuthenticationByCodeUseCase->factory({});

ok($invalid_auth_use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid ports');

$invalid_auth_use_case = Core::User::UseCases::AuthenticationByCodeUseCase->factory({
  'getting_user_by_email_port' => {},
  'getting_confirmation_code_port' => {},
  'secret_key' => 1
});

ok($invalid_auth_use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid ports');

$invalid_auth_use_case = Core::User::UseCases::AuthenticationByCodeUseCase->factory({
  'getting_user_by_email_port' => 12,
  'getting_confirmation_code_port' => '1',
  'secret_key' => 1
});

ok($invalid_auth_use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid ports');

$maybe_true = $creating_code_use_case->create({
  'email' => 'name@gmail.com'
});

my $maybe_token = $auth_use_case->auth({
  'email' => 'name@gmail.com',
  'code' => $codes->{'name@gmail.com'}->code->value
});

unless (ref($maybe_token) eq "HASH") {
  ok($maybe_token ? 1 : 0 eq 1, 'Authentication User'); 

  my $got = decode_jwt($maybe_token, $secret);
  
  ok(($got->{iss} eq 'name@gmail.com') eq 1, 'Verification JWT'); 
}

$maybe_true = $creating_code_use_case->create({
  'email' => 'name@gmail.com'
});

$maybe_token = $auth_use_case->auth({
  'email' => 'name@gmail.com',
  'code' => 123
});

ok($maybe_token->isa('Core::Common::Errors::DomainError') eq 1, 'Wrong code');

$maybe_token = $auth_use_case->auth({
  'email' => 'name1@gmail.com',
  'code' => 123
});

ok($maybe_token->isa('Core::Common::Errors::InfrastructureError') eq 1, 'Code not found');

$maybe_token = $auth_use_case->auth();

ok($maybe_token->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid data');

1;