package Core::Common::ConfirmationCode::ConfirmationCodeEntity

use strict;
use warnings;

use Moo;
use Core::Common::Errors::DomainError;

has code => (
  is => 'ro'
);