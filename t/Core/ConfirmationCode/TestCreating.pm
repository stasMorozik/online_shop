package Core::ConfirmationCode::TestCreating;

use strict;
use warnings;

use lib '../lib';

use Try::Tiny;
use Test::More;
use Data::Dump;

require_ok( 'Core::ConfirmationCode::UseCases::Creating' );
require_ok( 'Core::ConfirmationCode::Fake::Getting' );
require_ok( 'Core::ConfirmationCode::Fake::Creating' );
require_ok( 'Core::ConfirmationCode::Fake::Notifying' );

my $codes = {};

my $getting_adapter = Core::ConfirmationCode::Fake::Getting->new({'codes' => $codes});
my $creating_adapter = Core::ConfirmationCode::Fake::Creating->new({'codes' => $codes});
my $notifying_adapter = Core::ConfirmationCode::Fake::Notifying->new();

ok($getting_adapter->isa('Core::ConfirmationCode::Fake::Getting') eq 1, 'New getting confirmation code adapter');
ok($creating_adapter->isa('Core::ConfirmationCode::Fake::Creating') eq 1, 'New creating confirmation code adapter');
ok($notifying_adapter->isa('Core::ConfirmationCode::Fake::Notifying') eq 1, 'New notifying adapter');

my $use_case = Core::ConfirmationCode::UseCases::Creating->new({
  'getting_port' => $getting_adapter,
  'creating_port' => $creating_adapter,
  'notifying_port' => $notifying_adapter,
});

ok($use_case->isa('Core::ConfirmationCode::UseCases::Creating') eq 1, 'New creating confirmation code use case');

try {
  Core::ConfirmationCode::UseCases::Creating->new({
    'getting_port' => 1,
    'creating_port' => $creating_adapter,
    'notifying_port' => $notifying_adapter,
  });
} catch {
  ok($_->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');
};

try {
  Core::ConfirmationCode::UseCases::Creating->new({
    'getting_port' => $getting_adapter,
    'creating_port' => 1,
    'notifying_port' => $notifying_adapter,
  });
} catch {
  ok($_->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');
};

try {
  Core::ConfirmationCode::UseCases::Creating->new({
    'getting_port' => $getting_adapter,
    'creating_port' => $creating_adapter,
    'notifying_port' => 1,
  });
} catch {
  ok($_->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');
};

try {
  Core::ConfirmationCode::UseCases::Creating->new({
    'getting_port' => 0,
    'creating_port' => '',
    'notifying_port' => 1,
  });
} catch {
  ok($_->isa('Core::Common::Errors::Domain') eq 1, 'Invalid port');
};

my $maybe_true = $use_case->create('name@gmail.com');

ok($maybe_true->is_right() eq 1, 'Created confirmation port');

$maybe_true = $use_case->create('name@gmail.');

ok($maybe_true->is_left() eq 1, 'Invalid email');