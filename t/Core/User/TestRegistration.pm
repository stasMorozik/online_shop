package Core::User::TestRegistration;

use strict;
use warnings;

use lib '../lib';

use Try::Tiny;
use Test::More;
use Data::Dump;

require_ok( 'Core::ConfirmationCode::UseCases::Confirming' );
require_ok( 'Core::ConfirmationCode::UseCases::Creating' );
require_ok( 'Core::User::UseCases::Registration' );
require_ok( 'Core::ConfirmationCode::Fake::Getting' );
require_ok( 'Core::ConfirmationCode::Fake::Creating' );
require_ok( 'Core::User::Fake::Creating' );
require_ok( 'Core::ConfirmationCode::Fake::Notifying' );
require_ok( 'Core::ConfirmationCode::Fake::Confirming' );

my $codes = {};
my $users = {};

my $getting_code_adapter = Core::ConfirmationCode::Fake::Getting->new({'codes' => $codes});
my $creating_code_adapter = Core::ConfirmationCode::Fake::Creating->new({'codes' => $codes});
my $notifying_adapter = Core::ConfirmationCode::Fake::Notifying->new();
my $confirming_code_adapter = Core::ConfirmationCode::Fake::Confirming->new({'codes' => $codes});
my $creating_user_adapter = Core::User::Fake::Creating->new({'users' => $users});

ok($getting_code_adapter->isa('Core::ConfirmationCode::Fake::Getting') eq 1, 'New getting confirmation code adapter');
ok($creating_code_adapter->isa('Core::ConfirmationCode::Fake::Creating') eq 1, 'New creating confirmation code adapter');
ok($creating_user_adapter->isa('Core::User::Fake::Creating') eq 1, 'New creating user adapter');
ok($notifying_adapter->isa('Core::ConfirmationCode::Fake::Notifying') eq 1, 'New notifying adapter');
ok($confirming_code_adapter->isa('Core::ConfirmationCode::Fake::Confirming') eq 1, 'New confirming adapter');

my $creating_code_use_case = Core::ConfirmationCode::UseCases::Creating->new({
  'getting_port' => $getting_code_adapter,
  'creating_port' => $creating_code_adapter,
  'notifying_port' => $notifying_adapter
});

ok($creating_code_use_case->isa('Core::ConfirmationCode::UseCases::Creating') eq 1, 'New creating confirmation code use case');

my $maybe_true = $creating_code_use_case->create('name@gmail.com');

ok($maybe_true->is_right() eq 1, 'Created confirmation code');

my $confirming_code_use_case = Core::ConfirmationCode::UseCases::Confirming->new({
  'getting_port' => $getting_code_adapter,
  'confirming_port' => $confirming_code_adapter
});

ok($confirming_code_use_case->isa('Core::ConfirmationCode::UseCases::Confirming') eq 1, 'New confirming code use case');

my $registration_use_case = Core::User::UseCases::Registration->new({
  'getting_confirmation_code_port' => $getting_code_adapter,
  'creating_port' => $creating_user_adapter,
  'notifying_port' => $notifying_adapter
});

ok($registration_use_case->isa('Core::User::UseCases::Registration') eq 1, 'New registration use case');

try {
  $registration_use_case = Core::User::UseCases::Registration->new({
    'getting_confirmation_code_port' => 1,
    'creating_port' => $creating_user_adapter,
    'notifying_port' => $notifying_adapter
  });
} catch {
  ok($_->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');
};

try {
  $registration_use_case = Core::User::UseCases::Registration->new({
    'getting_confirmation_code_port' => $getting_code_adapter,
    'creating_port' => 1,
    'notifying_port' => $notifying_adapter
  });
} catch {
  ok($_->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');
};

try {
  $registration_use_case = Core::User::UseCases::Registration->new({
    'getting_confirmation_code_port' => $getting_code_adapter,
    'creating_port' => $creating_user_adapter,
    'notifying_port' => '1'
  });
} catch {
  ok($_->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');
};

$maybe_true = $registration_use_case->registry({
  'name' => 'John', 
  'last_name' => 'Doe', 
  'email' => 'name@gmail.com', 
  'password' => '12345!@', 
  'phone' => '+79683456782'
});

ok($maybe_true->is_left() eq 1, 'Mail not confirmed');

$maybe_true = $confirming_code_use_case->confirm({
  'email' => 'name@gmail.com',
  'code' => $codes->{'name@gmail.com'}->code
});

ok($maybe_true->is_right() eq 1, 'Confirmed code');

$maybe_true = $registration_use_case->registry({
  'name' => 'John', 
  'last_name' => 'Doe', 
  'email' => 'name@gmail.com', 
  'password' => '12345!@', 
  'phone' => '+79683456782'
});

ok($maybe_true->is_right() eq 1, 'User have registraion');

$maybe_true = $registration_use_case->registry({
  'name' => 'John', 
  'last_name' => 'Doe', 
  'email' => 'name1@gmail.com', 
  'password' => '12345!@', 
  'phone' => '+79683456782'
});

ok($maybe_true->is_left() eq 1, 'Code not found');

1;