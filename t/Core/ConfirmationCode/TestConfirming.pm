package Core::ConfirmationCode::TestConfirming;

use strict;
use warnings;

use lib '../lib';

use Try::Tiny;
use Test::More;
use Data::Dump;

require_ok( 'Core::ConfirmationCode::UseCases::Creating' );
require_ok( 'Core::ConfirmationCode::UseCases::Confirming' );
require_ok( 'Core::ConfirmationCode::Fake::Getting' );
require_ok( 'Core::ConfirmationCode::Fake::Creating' );
require_ok( 'Core::ConfirmationCode::Fake::Notifying' );
require_ok( 'Core::ConfirmationCode::Fake::Confirming' );

our $codes = {};

my $getting_adapter = Core::ConfirmationCode::Fake::Getting->new({'codes' => $codes});
my $creating_adapter = Core::ConfirmationCode::Fake::Creating->new({'codes' => $codes});
my $notifying_adapter = Core::ConfirmationCode::Fake::Notifying->new();
my $confirming_adapter = Core::ConfirmationCode::Fake::Confirming->new({'codes' => $codes});

ok($getting_adapter->isa('Core::ConfirmationCode::Fake::Getting') eq 1, 'New getting confirmation code adapter');
ok($creating_adapter->isa('Core::ConfirmationCode::Fake::Creating') eq 1, 'New creating confirmation code adapter');
ok($notifying_adapter->isa('Core::ConfirmationCode::Fake::Notifying') eq 1, 'New notifying adapter');
ok($confirming_adapter->isa('Core::ConfirmationCode::Fake::Confirming') eq 1, 'New confirming adapter');

my $creating_use_case = Core::ConfirmationCode::UseCases::Creating->new({
  'getting_port' => $getting_adapter,
  'creating_port' => $creating_adapter,
  'notifying_port' => $notifying_adapter,
});

ok($creating_use_case->isa('Core::ConfirmationCode::UseCases::Creating') eq 1, 'New creating confirmation code use case');

my $maybe_true = $creating_use_case->create('name@gmail.com');

ok($maybe_true->is_right() eq 1, 'Created confirmation code');

my $confirming_use_case = Core::ConfirmationCode::UseCases::Confirming->new({
  'getting_port' => $getting_adapter,
  'confirming_port' => $confirming_adapter
});

ok($confirming_use_case->isa('Core::ConfirmationCode::UseCases::Confirming') eq 1, 'New confirming code use case');

try {
  Core::ConfirmationCode::UseCases::Confirming->new({
    'getting_port' => 1,
    'confirming_port' => $confirming_adapter,
  });
} catch {
  ok($_->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');
};

try {
  Core::ConfirmationCode::UseCases::Confirming->new({
    'getting_port' => $getting_adapter,
    'confirming_port' => 1,
  });
} catch {
  ok($_->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');
};

try {
  Core::ConfirmationCode::UseCases::Confirming->new({
    'getting_port' => '',
    'confirming_port' => 1,
  });
} catch {
  ok($_->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');
};

$maybe_true = $confirming_use_case->confirm({
  'email' => 'name@gmail.com',
  'code' => $codes->{'name@gmail.com'}->code
});

ok($maybe_true->is_right() eq 1, 'Confirmed code');

$maybe_true = $confirming_use_case->confirm({
  'email' => 'name@gmail.com',
  'code' => 123
});

ok($maybe_true->is_left() eq 1, 'Wrong code');

$maybe_true = $confirming_use_case->confirm({
  'email' => 'name1@gmail.com',
  'code' => $codes->{'name@gmail.com'}->code
});

ok($maybe_true->is_left() eq 1, 'Code not found');

1;
