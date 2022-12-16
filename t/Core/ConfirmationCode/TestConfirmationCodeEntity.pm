package Core::ConfirmationCode::TestConfirmationCodeEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;

require_ok( 'Core::ConfirmationCode::ConfirmationCodeEntity' );

my $code = Core::ConfirmationCode::ConfirmationCodeEntity->factory({
  'email' => 'name@gmail.com'
});

ok($code->isa('Core::ConfirmationCode::ConfirmationCodeEntity') eq 1, 'New Code');


$code = Core::ConfirmationCode::ConfirmationCodeEntity->factory({
  'email' => 'name'
});

ok($code->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid email');

$code = Core::ConfirmationCode::ConfirmationCodeEntity->factory({
  'email' => 'name@gmail.com'
});

ok($code->validate_code($code->code->value) eq 1, 'Validate code');

my $maybe_true = $code->validate_code(123);

ok($maybe_true->isa('Core::Common::Errors::DomainError') eq 1, 'Wrong code');

1;