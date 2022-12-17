use strict;
use warnings;

use lib '../t';

use Test::More;

use Core::User::TestUserEntity;
use Core::ConfirmationCode::TestConfirmationCodeEntity;
use Core::ConfirmationCode::TestCreatingUseCase;
use Core::User::TestRegistrationUseCase;
use Core::User::TestAuthenticationByPasswordUseCase;

done_testing(65);
