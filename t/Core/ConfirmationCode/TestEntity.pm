package Core::ConfirmationCode::TestEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;

require_ok( 'Core::ConfirmationCode::Entity' );
require_ok( 'Core::Common::ValueObjects::Email' );

my $email = Core::Common::ValueObjects::Email->factory('name@gmail.com');

ok($email->is_right() eq 1, 'New email');

my $code = Core::ConfirmationCode::Entity->factory($email->value);

ok($code->is_right() eq 1, 'New code');

$code = Core::ConfirmationCode::Entity->factory({
  email => 'name@gmail.'
});

ok($code->is_left() eq 1, 'Invalid email');

$code = Core::ConfirmationCode::Entity->factory();

ok($code->is_left() eq 1, 'Invalid email');

$code = Core::ConfirmationCode::Entity->factory($email->value);

my $maybe_true = $code->value->check_lifetime();

ok($maybe_true->is_left() eq 1, 'Code already exists');


$maybe_true = $code->value->confirm($code->value->code);

ok($maybe_true->is_right() eq 1, 'Confirm code');

$maybe_true = $code->value->confirm(123);

ok($maybe_true->is_left() eq 1, 'Wrong code');

$maybe_true = $code->value->confirm();

ok($maybe_true->is_left() eq 1, 'Wrong code');