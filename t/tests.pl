use strict;
use warnings;

use lib '../t';

use Test::More;

use Core::User::TestEntity;
use Core::ConfirmationCode::TestEntity;

use Core::ConfirmationCode::TestCreating;
use Core::ConfirmationCode::TestConfirming;
use Core::User::TestRegistration;

use PostgreSQLAdapters::ConfirmationCode::TestCreating;
use PostgreSQLAdapters::ConfirmationCode::TestGetting;

done_testing(76);
