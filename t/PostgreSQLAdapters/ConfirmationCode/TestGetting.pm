package PostgreSQLAdapters::ConfirmationCode::TestGetting;

use strict;
use warnings;

use lib '../lib';

use Try::Tiny;
use Test::More;
use Data::Dump;

require_ok( 'PostgreSQLAdapters::DBFactory' );
require_ok( 'PostgreSQLAdapters::ConfirmationCode::Creating' );
require_ok( 'PostgreSQLAdapters::ConfirmationCode::Getting' );
require_ok( 'Core::ConfirmationCode::Entity' );
require_ok( 'Core::Common::ValueObjects::Email' );

my $dbh = PostgreSQLAdapters::DBFactory->factory();

my $creating_code_adapter = PostgreSQLAdapters::ConfirmationCode::Creating->new({
  'dbh' => $dbh
});

my $email_address = 'name@gmail.com';

my $email = Core::Common::ValueObjects::Email->factory($email_address);
my $code = Core::ConfirmationCode::Entity->factory($email->value);


my $maybe_true = $creating_code_adapter->create($code->value);

my $getting_code_adapter = PostgreSQLAdapters::ConfirmationCode::Getting->new({
  'dbh' => $dbh
});

try {
  PostgreSQLAdapters::ConfirmationCode::Getting->new({
    'dbh' => 1
  });
} catch {
  ok($_->isa('Core::Common::Errors::Infrastructure') eq 1, 'Invalid DB connection');
};

try {
  PostgreSQLAdapters::ConfirmationCode::Getting->new({
    'dbh' => {}
  });
} catch {
  ok($_->isa('Core::Common::Errors::Infrastructure') eq 1, 'Invalid DB connection');
};

$code = $getting_code_adapter->get($email->value);

dd($code);

ok($code->is_right() eq 1, 'Got code');

$dbh->do('DELETE from codes');

$dbh->disconnect;

1;