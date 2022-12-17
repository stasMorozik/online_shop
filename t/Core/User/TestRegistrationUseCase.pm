package Core::User::TestRegistrationUseCase;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Try::Tiny;

use Core::Common::Errors::DomainError;
use Core::Common::Errors::InfrastructureError;
use Core::ConfirmationCode::UseCases::CreatingUseCase;
use Core::User::UseCases::RegistrationUseCase;

use Core::Common::FakeAdapters::NotifyingAdapter;
use Core::ConfirmationCode::FakeAdapters::CreatingAdapter;
use Core::User::FakeAdapters::CreatingAdapter;
use Core::ConfirmationCode::FakeAdapters::GettingAdapter;

my $codes = {};
my $users = {};

my $creating_code_use_case = Core::ConfirmationCode::UseCases::CreatingUseCase->factory({
  'creating_port' => Core::ConfirmationCode::FakeAdapters::CreatingAdapter->new({
    'codes' => $codes
  }),
  'notifying_port' => Core::Common::FakeAdapters::NotifyingAdapter->new()
});

ok($creating_code_use_case->isa('Core::ConfirmationCode::UseCases::CreatingUseCase') eq 1, 'New Creating Code Use Case');

my $maybe_true = $creating_code_use_case->create({
  'email' => 'name@gmail.com'
});

ok($maybe_true eq 1, 'Create new Code');


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

ok($registration_use_case->isa('Core::User::UseCases::RegistrationUseCase') eq 1, 'New Registration Use Case');

my $invalid_registration_use_case = Core::User::UseCases::RegistrationUseCase->factory({});

ok($invalid_registration_use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid ports');

$invalid_registration_use_case = Core::User::UseCases::RegistrationUseCase->factory({
  'creating_port' => {},
  'notifying_port' => {},
  'getting_confirmation_code_port' => {}
});

ok($invalid_registration_use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid ports');

$invalid_registration_use_case = Core::User::UseCases::RegistrationUseCase->factory({
  'creating_port' => 0,
  'notifying_port' => 1,
  'getting_confirmation_code_port' => ''
});

ok($invalid_registration_use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid ports');

$maybe_true = $registration_use_case->registry({
  'email' => 'name@gmail.com',
  'name' => 'Alex',
  'last_name' => 'Bolduin',
  'password' => 'qwerty12345',
  'code' => $codes->{'name@gmail.com'}->code->value,
  'phone' => '+79672356789'
});

ok($maybe_true eq 1, 'Registration User');

$maybe_true = $registration_use_case->registry({
  'email' => 'name@gmail.com',
  'name' => 'Alex',
  'last_name' => 'Bolduin',
  'password' => 'qwerty12345',
  'code' => '1234',
  'phone' => '+79672356789'
});

ok($maybe_true->isa('Core::Common::Errors::InfrastructureError') eq 1, 'Code not found');

$maybe_true = $creating_code_use_case->create({
  'email' => 'name1@gmail.com'
});

$maybe_true = $registration_use_case->registry({
  'email' => 'name1@gmail.com',
  'name' => 'Alex',
  'last_name' => 'Bolduin',
  'password' => 'qwerty12345',
  'code' => 12,
  'phone' => '+79672356789'
});

ok($maybe_true->isa('Core::Common::Errors::DomainError') eq 1, 'Wrong Code');

1;