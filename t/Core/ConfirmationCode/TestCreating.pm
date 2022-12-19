package Core::ConfirmationCode::TestCreating;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;

use Core::Common::Errors::Domain;

use Core::Common::FakeAdapters::Notifying;
use Core::ConfirmationCode::UseCases::Creating;
use Core::ConfirmationCode::FakeAdapters::Creating;
use Core::ConfirmationCode::FakeAdapters::Getting;

require_ok( 'Core::ConfirmationCode::UseCases::Creating' );

my $codes = {};

my $use_case = Core::ConfirmationCode::UseCases::Creating->factory({
  'creating_port' => Core::ConfirmationCode::FakeAdapters::Creating->new({
    'codes' => $codes
  }),
  'getting_port' => Core::ConfirmationCode::FakeAdapters::Getting->new({
    'codes' => $codes
  }),
  'notifying_port' => Core::Common::FakeAdapters::Notifying->new()
});

ok($use_case->isa('Core::ConfirmationCode::UseCases::Creating') eq 1, 'New Creating Code Use Case');

my $maybe_true = $use_case->create({
  'email' => 'name@gmail.com'
});

ok($maybe_true eq 1, 'Create new Code');


$maybe_true = $use_case->create({
  'email' => 'name@'
});

ok($maybe_true->isa('Core::Common::Errors::Domain') eq 1, 'Invalid email');

$maybe_true = $use_case->create({});

ok($maybe_true->isa('Core::Common::Errors::Domain') eq 1, 'Invalid argument');


$use_case = Core::ConfirmationCode::UseCases::Creating->factory({
  'creating_port' => {},
  'notifying_port' => {},
  'getting_port' => {},
});

ok($use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid ports');


$use_case = Core::ConfirmationCode::UseCases::Creating->factory();

ok($use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid ports');

$use_case = Core::ConfirmationCode::UseCases::Creating->factory({
  'creating_port' => 1,
  'notifying_port' => '',
  'getting_port' => 0,
});

ok($use_case->isa('Core::Common::Errors::Domain') eq 1, 'Invalid ports');

1;



