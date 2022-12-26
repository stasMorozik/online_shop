package PostgreSQLAdapters::ConfirmationCode::TestConfirming;

use strict;
use warnings;

use lib '../lib';

use Try::Tiny;
use Test::More;
use Data::Dump;

require_ok( 'PostgreSQLAdapters::DBFactory' );
require_ok( 'PostgreSQLAdapters::ConfirmationCode::Creating' );
require_ok( 'PostgreSQLAdapters::ConfirmationCode::Getting' );
require_ok( 'PostgreSQLAdapters::ConfirmationCode::Confirming' );
require_ok( 'Core::ConfirmationCode::Entity' );
require_ok( 'Core::Common::ValueObjects::Email' );

my $email_address = 'name@gmail.com';

my $email = Core::Common::ValueObjects::Email->factory($email_address);
my $confirmation_code = Core::ConfirmationCode::Entity->factory($email->value);

my $creating_code_adapter = PostgreSQLAdapters::ConfirmationCode::Creating->new({
  'dbh' => $PostgreSQLAdapters::DBFactory::dbh
});

my $getting_code_adapter = PostgreSQLAdapters::ConfirmationCode::Getting->new({
  'dbh' => $PostgreSQLAdapters::DBFactory::dbh
});

my $maybe_true = $creating_code_adapter->create($confirmation_code->value);

$confirmation_code = $getting_code_adapter->get($email->value);

$confirmation_code->value->confirm($confirmation_code->value->code);

my $confirming_adapter = PostgreSQLAdapters::ConfirmationCode::Confirming->new({
  'dbh' => $PostgreSQLAdapters::DBFactory::dbh
});

try {
  PostgreSQLAdapters::ConfirmationCode::Confirming->new({
    'dbh' => 1
  });
} catch {
  ok($_->isa('Core::Common::Errors::Infrastructure') eq 1, 'Invalid DB connection');
};

try {
  PostgreSQLAdapters::ConfirmationCode::Confirming->new({
    'dbh' => {}
  });
} catch {
  ok($_->isa('Core::Common::Errors::Infrastructure') eq 1, 'Invalid DB connection');
};

$maybe_true = $confirming_adapter->confirm($confirmation_code->value);

ok($maybe_true->is_right() eq 1, 'Confirmed code');

$PostgreSQLAdapters::DBFactory::dbh->do('DELETE from codes', {AutoCommit => 1});

1;