package Core::ConfirmationCode::CreatingUseCaseTest;

use strict;
use warnings;

use lib '../lib';

use Test::More;
use Data::Dump;
use Try::Tiny;

use Core::ConfirmationCode::UseCases::CreatingUseCase;
use Core::Common::FakeAdapters::NotifyingAdapter;
use Core::ConfirmationCode::FakeAdapters::CreatingAdapter;
use Core::Common::Errors::DomainError;

my $use_case = Core::ConfirmationCode::UseCases::CreatingUseCase->factory({
  'creating_port' => Core::ConfirmationCode::FakeAdapters::CreatingAdapter->new({
    'codes' => {}
  }),
  'notifying_port' => Core::Common::FakeAdapters::NotifyingAdapter->new()
});

ok($use_case->isa('Core::ConfirmationCode::UseCases::CreatingUseCase') eq 1, 'New Create Use Case');

my $maybe_true = $use_case->create({
  'email' => 'name@gmail.com'
});

ok($maybe_true eq 1, 'Create new Code');


$use_case = Core::ConfirmationCode::UseCases::CreatingUseCase->factory({
  'creating_port' => {},
  'notifying_port' => {}
});

ok($use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid ports');


$use_case = Core::ConfirmationCode::UseCases::CreatingUseCase->factory();

ok($use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid ports');

$use_case = Core::ConfirmationCode::UseCases::CreatingUseCase->factory({
  'creating_port' => 1,
  'notifying_port' => ''
});

ok($use_case->isa('Core::Common::Errors::DomainError') eq 1, 'Invalid ports');

1;



