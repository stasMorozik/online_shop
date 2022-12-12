package Core::ConfirmationCode::TestConfirmationCodeEntity;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Try::Tiny;

require_ok( 'Core::ConfirmationCode::ConfirmationCodeEntity' );

my $code = Core::ConfirmationCode::ConfirmationCodeEntity->new({
  'email' => 'name@gmail.com'
});

ok($code->isa('Core::ConfirmationCode::ConfirmationCodeEntity') eq 1, 'New Code');


try {
  Core::ConfirmationCode::ConfirmationCodeEntity->new({
    'email' => 'name@g'
  });
} catch {
  ok($_->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid email');
};

1;