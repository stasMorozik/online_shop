package Core::ConfirmationCode::TestEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Core::Common::Errors::Domain;

require_ok( 'Core::ConfirmationCode::Entity' );

my $code = Core::ConfirmationCode::Entity->factory({
  'email' => 'name@gmail.com'
});

ok($code->isa('Core::ConfirmationCode::Entity') eq 1, 'New Code');


$code = Core::ConfirmationCode::Entity->factory({
  'email' => 'name'
});

ok($code->isa('Core::Common::Errors::Domain') eq 1, 'Invalid email');

$code = Core::ConfirmationCode::Entity->factory({
  'email' => 'name@gmail.com'
});

ok($code->validate_code($code->code->value) eq 1, 'Validate code');

my $maybe_true = $code->validate_code(123);

ok($maybe_true->isa('Core::Common::Errors::Domain') eq 1, 'Wrong code');

1;