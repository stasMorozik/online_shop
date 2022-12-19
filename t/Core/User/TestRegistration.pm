package Core::User::TestRegistration;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;

use Core::Common::Errors::Domain;
use Core::Common::Errors::Infrastructure;
use Core::ConfirmationCode::UseCases::Creating;
use Core::User::UseCases::Registration;

use Core::Common::FakeAdapters::Notifying;
use Core::ConfirmationCode::FakeAdapters::Creating;
use Core::ConfirmationCode::FakeAdapters::Getting;
use Core::User::FakeAdapters::Creating;

my $codes = {};
my $users = {};

require_ok( 'Core::User::UseCases::Registration' );

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

ok($maybe_true eq 1, 'Create new Code');

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

ok($registration_use_case->isa('Core::User::UseCases::Registration') eq 1, 'New Registration Use Case');

my $invalid_registration_use_case = Core::User::UseCases::Registration->factory({});

ok($invalid_registration_use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid ports');

$invalid_registration_use_case = Core::User::UseCases::Registration->factory({
  'creating_port' => {},
  'notifying_port' => {},
  'getting_confirmation_code_port' => {}
});

ok($invalid_registration_use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid ports');

$invalid_registration_use_case = Core::User::UseCases::Registration->factory({
  'creating_port' => 0,
  'notifying_port' => 1,
  'getting_confirmation_code_port' => ''
});

ok($invalid_registration_use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid ports');

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

ok($maybe_true->isa('Core::Common::Errors::Infrastructure') eq 1, 'Code not found');

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

ok($maybe_true->isa('Core::Common::Errors::Domain') eq 1, 'Wrong Code');

1;